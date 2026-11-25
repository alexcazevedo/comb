#!/usr/bin/env bash
# comb ui-lint — mechanical floor for UI tickets. Zero model tokens.
# usage: bash .comb/ui-lint.sh [--no-raw-color] <file-or-dir>...
# Exit 1 on any finding. Waive ONE line with a trailing comment containing
# `ui-ok: <reason>` when DESIGN.md earns the exception — never to dodge a fix.
set -u
RAW=1
[ "${1:-}" = "--no-raw-color" ] && { RAW=0; shift; }
[ $# -eq 0 ] && { echo "usage: ui-lint.sh [--no-raw-color] <file-or-dir>..." >&2; exit 2; }

find "$@" -type f \( -name '*.html' -o -name '*.css' -o -name '*.scss' -o -name '*.jsx' \
  -o -name '*.tsx' -o -name '*.vue' -o -name '*.svelte' -o -name '*.astro' \) \
  -not -path '*/node_modules/*' -not -path '*/dist/*' -not -path '*/build/*' \
  -not -path '*/.next/*' -not -path '*/.comb/*' -print0 2>/dev/null |
RAW=$RAW xargs -0 perl -CSD -Mutf8 -e '
  my @rules = (
    ["transition-all", qr/transition:\s*all\b|\btransition-all\b/, "list the properties you animate"],
    ["gradient-text",  qr/background-clip:\s*text|\bbg-clip-text\b/, "emphasis comes from weight or size"],
    ["ai-purple",      qr/\b(?:from|via|to|bg|text|border|ring|shadow|fill|stroke)-(?:purple|violet|indigo|fuchsia)-\d/, "use a DESIGN.md colour token"],
    ["caps-label",     qr/\buppercase\b/, "sentence case; no tracked ALL-CAPS labels"],
    ["emoji-icon",     qr/[\x{1F000}-\x{1FAFF}\x{2600}-\x{27BF}]/, "one icon set, one stroke weight; no emoji or glyph icons"],
    ["buzzword",       qr/\b(?:seamless(?:ly)?|elevate|unleash|empower|supercharge|streamline|cutting-edge|next-gen(?:eration)?|world-class|effortless(?:ly)?|revolutionary)\b/i, "state the fact the word stands in for"],
    ["placeholder",    qr/lorem ipsum|\bJohn Doe\b|\bJane Doe\b|\bAcme\b/i, "write real content for this product"],
  );
  my $raw = qr/#[0-9a-fA-F]{3,8}\b|\b(?:rgb|hsl)a?\(\s*\d/;
  my $n = 0;
  for my $f (@ARGV) {
    open(my $h, "<", $f) or next;
    my @l = <$h>; close $h;
    my $all = join "", @l;
    my $has_focus = $all =~ /focus-visible/;
    for my $i (0..$#l) {
      my $s = $l[$i];
      next if $s =~ /ui-ok/;
      (my $t = $s) =~ s/^\s+|\s+$//g; $t = substr($t, 0, 90);
      for my $r (@rules) {
        if ($s =~ $r->[1]) { printf "%s:%d: [%s] %s\n    %s\n", $f, $i+1, $r->[0], $r->[2], $t; $n++; }
      }
      if (!$has_focus && $s =~ /outline:\s*(?:none|0)\b|\boutline-none\b/) {
        printf "%s:%d: [focus-ring] removed outline with no :focus-visible replacement in this file\n    %s\n", $f, $i+1, $t; $n++;
      }
      # colours live in tokens: a literal is allowed only where a custom property is defined
      if ($ENV{RAW} && $s =~ $raw && $s !~ /--[\w-]+\s*:/ && $s !~ /&#x?[0-9a-fA-F]+;|href=|url\(#|id=|theme-color/) {
        printf "%s:%d: [raw-color] use a DESIGN.md token (var(--…)), not a literal\n    %s\n", $f, $i+1, $t; $n++;
      }
    }
  }
  if ($n) { print "ui-lint: $n finding(s)\n"; exit 1 }
  print "ui-lint: clean\n";
'
