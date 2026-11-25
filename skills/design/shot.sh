#!/usr/bin/env bash
# comb shot — render a page to PNGs on disk so an agent can LOOK at its own UI.
# usage: bash .comb/shot.sh <url-or-html-file> [name] [width...]
#   widths default to 390 1440. FULL=1 captures a tall page instead of one viewport.
# Writes .comb/shots/<name>-<width>.png and .comb/shots/<name>.console.txt.
# Exit 3 = no browser found (report "render unchecked"; never claim a look you did not take).
set -u
T="${1:?usage: shot.sh <url-or-html-file> [name] [width...]}"; N="${2:-page}"; shift; [ $# -gt 0 ] && shift
[ $# -eq 0 ] && set -- 390 1440
case "$T" in http://*|https://*|file://*) URL="$T" ;; *) URL="file://$(cd "$(dirname "$T")" && pwd)/$(basename "$T")" ;; esac

B="${CHROME:-}"
for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
         "/Applications/Chromium.app/Contents/MacOS/Chromium" \
         "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
         "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" \
         google-chrome google-chrome-stable chromium chromium-browser microsoft-edge; do
  [ -n "$B" ] && break
  if [ -x "$c" ]; then B="$c"; elif command -v "$c" >/dev/null 2>&1; then B="$(command -v "$c")"; fi
done
[ -z "$B" ] && { echo "SKIP: no Chrome/Chromium/Edge found (set CHROME=/path/to/browser)"; exit 3; }

OUT=".comb/shots"; mkdir -p "$OUT"; : > "$OUT/$N.console.txt"
for W in "$@"; do
  case "$W" in 3[0-9][0-9]|4[0-9][0-9]) H=844 ;; 7[0-9][0-9]|8[0-9][0-9]) H=1024 ;; *) H=900 ;; esac
  [ "${FULL:-0}" = 1 ] && H=2600
  PNG="$OUT/$N-$W.png"; SRC="$URL"; WIN="$W"
  # Headless Chrome will not open a window narrower than ~500px, so a phone
  # width is rendered inside a centred iframe of that exact width, then the
  # centre is cropped out.
  if [ "$W" -lt 500 ]; then
    WRAP="$OUT/.frame-$N-$W.html"; WIN=500
    printf '<!doctype html><body style="margin:0;background:#808080"><iframe src="%s" style="display:block;margin:0 auto;border:0;width:%spx;height:%spx"></iframe>' "$URL" "$W" "$H" > "$WRAP"
    SRC="file://$(cd "$OUT" && pwd)/.frame-$N-$W.html"
  fi
  # virtual-time-budget lets entrance animations and first paint settle before capture
  "$B" --headless=new --disable-gpu --hide-scrollbars --no-first-run --enable-logging=stderr --v=0 \
       --virtual-time-budget=4000 --window-size="$WIN,$H" --screenshot="$PNG" "$SRC" 2>&1 |
    sed -n 's/.*INFO:CONSOLE[^]]*\] //p' >> "$OUT/$N.console.txt"
  [ -s "$PNG" ] || { echo "FAILED: $W"; exit 1; }
  if [ "$WIN" != "$W" ]; then
    rm -f "$WRAP"
    if command -v sips >/dev/null 2>&1; then sips -c "$H" "$W" "$PNG" >/dev/null 2>&1
    elif command -v magick >/dev/null 2>&1; then magick "$PNG" -gravity center -crop "${W}x${H}+0+0" +repage "$PNG"
    elif command -v convert >/dev/null 2>&1; then convert "$PNG" -gravity center -crop "${W}x${H}+0+0" +repage "$PNG"
    else echo "note: $PNG is 500px wide; the grey strips either side of the ${W}px page are not part of it"; fi
  fi
  echo "$PNG"
done
sort -u "$OUT/$N.console.txt" -o "$OUT/$N.console.txt"
echo "console: $(wc -l < "$OUT/$N.console.txt" | tr -d ' ') line(s) in $OUT/$N.console.txt — read it BEFORE the images"
