---
ui: lean            # lean | crafted | polished — copied from PRODUCT.md
surface: operate    # operate (app, dashboard, tool) | persuade (landing, marketing) | read (docs, content)
source: new         # new | inherited (documents the existing system — never restyle it)
---

# DESIGN — <product>

Binding for every ticket that touches UI. Read it before writing markup or
styles. If a ticket and this file disagree on anything visual, this file wins.

## Direction
- Scene: <who uses it, where, on which device, in what light, how often>
- Job: <the one thing the screen must make obvious within two seconds>
- World: <one specific reference from the subject's own world — a point, not adjectives>
- Signature: <the single memorable element; it serves the Job and is never louder than it>
<!-- polished: add `- Rejected: <the other direction, and why it lost>` -->
<!-- source: inherited → replace the four lines with `- Inherited from: <files>` -->

## References
Shipped products looked at before this file was written. They explain the
layout; they are not a style to copy — build from Tokens and Layout.
- <product> — <live URL> — took: <one structural thing> · left: <its look, in three words>
<!-- lean 2 · crafted 3 · polished 5. Nothing reachable → `- none: <reason>`.
     source: inherited → delete this section. -->

## Tokens
The only source of colour, type, space, radius, shadow and motion values.
They live in <tokens file — for a single-file product, that file's `:root` block>;
the first UI ticket creates it, later tickets reference it.

```css
:root {
  /* colour — every token has a role; say where the accent may appear */
  --bg: ;            /* page ground */
  --surface: ;       /* raised or grouped areas; add a second surface token only if World needs it */
  --text: ;          /* primary text, ≥4.5:1 on --bg and --surface */
  --text-quiet: ;    /* secondary text, still ≥4.5:1 */
  --line: ;          /* dividers, input borders */
  --accent: ;        /* the primary action, and nothing decorative */
  --on-accent: ;     /* text on --accent */
  --ok: ; --warn: ; --bad: ;   /* status only; distinct from --accent; paired with a word or icon */
  /* type */
  --font-display: ;  --font-body: ;
  --step--1: ; --step-0: 1rem; --step-1: ; --step-2: ; --step-3: ;   /* ratio ≥1.25 */
  /* space (4px base), radius, depth, motion */
  --s1: .25rem; --s2: .5rem; --s3: .75rem; --s4: 1rem; --s6: 1.5rem; --s8: 2rem; --s12: 3rem;
  --radius: ;        /* one scale; nested child ≤ parent */
  --shadow: ;        /* one recipe: offset + blur, coloured from --text's hue, not neutral grey */
  --ease: cubic-bezier(.2, 1, .3, 1); --fast: 140ms; --base: 220ms;
}
```

## Layout
One sentence per surface, then a wireframe at both widths. Say what moves
below 768px. The Job element (or group, when the Job is a list) takes the
most area and the strongest contrast in the first viewport.

```
wide (≥1024)                          narrow (390)
+----------------------------+        +-----------+
|                            |        |           |
+----------------------------+        +-----------+
```

<!-- crafted+ ------------------------------------------------------------ -->
## States
| view | empty | loading | error | long content |
|---|---|---|---|---|
| <view> | <what it says + the one action> | <skeleton shape> | <what happened + next step> | <truncate / wrap / scroll> |

Each state is reachable for a screenshot: a route, a `?ui=empty|loading|error`
flag, or a fixture. No backend yet → fake the delay and the failure behind
that flag; the state still has to exist.

## Voice
<Two lines: who is speaking to whom, and three real strings from this product
(a button, a heading, an error) that set the tone.>

<!-- polished ------------------------------------------------------------ -->
## Motion and themes
- Authored moment: <the one, tied to Signature — or `none` on operate surfaces>
- Themes: <light | dark | both — chosen from Scene's ambient light, not the category>

## Floor
<!-- Copy verbatim. Keep rules 1–8 and Refuse at every level; 9–12 from
     crafted; 13–19 at polished. Delete the levels above this file's `ui:`.
     Keep the line breaks: this section is read by every implementer. -->

Build
1. Tokens only. Every colour, font, size, space, radius and shadow comes from
   `## Tokens`. Need a new value → add a token with a role, then use it.
2. Hierarchy follows the Job. The Job element is the largest, highest-contrast
   thing in the first viewport. Emphasise with size OR weight OR colour — two
   at most. Squint: if everything is equally loud, raise one thing, lower the rest.
3. Group with space before boxes. Tight inside a group, generous between
   groups, more space above a heading than below it. A card is for an object
   the user acts on or compares; page sections are not cards; no card in a card.
4. Type. Body ≥16px, measure 45–75ch, line-height ~1.5 body and 1.1–1.25
   headings, `text-wrap: balance` on headings, `tabular-nums` on numbers that
   align or change. Sentence case.
5. One of each: one accent, one radius scale, one shadow recipe, one icon set
   at one stroke weight, one button ladder (filled → outlined → text).
6. Use the width. Build `## Layout` at both sizes: no phone-width column
   centred on a desktop screen, no horizontal scroll at 390px, tap targets
   ≥44px on touch. Labels never break mid-phrase or clip: `min-width: 0` on
   flex children, `white-space: nowrap` or truncation on short labels.
7. Real controls. `<button>` acts, `<a>` navigates, every input has a
   `<label>`, a visible `:focus-visible` ring, contrast ≥4.5:1 for text and
   ≥3:1 for large text and control edges. Status is never colour alone.
8. Words. Buttons say verb + object (e.g. "Save changes", never "Submit"). Headings name the
   thing. Errors say what happened and what to do next. An empty list says
   what belongs there and offers the action. Sample data is written for this
   product; invent no testimonials, customers or statistics.

Refuse — these appear on every generated page; use one only where Direction
(its World or Signature) names it
- purple or indigo gradients, cyan glow on dark, gradient text, glass blur as decoration
- cream ground + serif display + terracotta accent; near-black + one neon accent
- tracked ALL-CAPS eyebrow labels; 01 / 02 / 03 markers on things that are not a
  sequence; `A · B · C` dot chains; pill badges on everything
- rows of identical icon + heading + text cards; a coloured stripe down one side
  of a rounded box; hairline border plus wide soft shadow on every box
- the hero-metric block (big number, small label, three stats); a centred hero under a pill chip
- emoji or unicode glyphs as icons; monospace worn to look technical
- fade-and-rise on every section, hover-lift on every card, pulsing dots, bounce
  easing, `transition: all`
- seamless, elevate, unleash, empower, streamline; "Not X. Y." cadence; "Trusted by …"

<!-- crafted+ -->
9. States. Build every row of `## States`. Controls have hover, active (press
   feedback), focus-visible and disabled. A submit button stays enabled until
   the request starts, then shows progress.
10. Responsive is structural: the layout changes shape below 768px as
    `## Layout` says, not just shrinks. `dvh`, not `vh`.
11. Motion answers a user action or shows what changed — nothing else.
    Feedback 100–160ms, state change under 300ms, exit faster than entrance,
    `var(--ease)`, transform and opacity only, none on actions repeated all
    day. `prefers-reduced-motion` keeps colour and opacity feedback.
12. Look before done (see `## Look`). Never report UI finished unseen.

<!-- polished -->
13. Theme the browser's own surfaces from tokens: `::selection`, `caret-color`,
    focus ring, scrollbar, `color-scheme`, `theme-color`, underline offset.
14. Depth and optics: two-layer shadows (tight + soft), concentric nested
    radii, borders and shadows tinted toward the surface hue, icons optically
    aligned to their text.
15. At most the one authored moment from `## Motion and themes`; stagger
    30–80ms, under 300ms total; content is visible with JavaScript off.
16. Themes as declared; tokens remapped per theme; contrast checked in each.
17. Accessibility AA: heading order, alt text, `aria-label` on icon buttons,
    `aria-live` for async results, a keyboard path through the primary flow,
    never block zoom or paste.
18. Typographic detail: real ellipsis and quotes, non-breaking spaces in units,
    `Intl` formatting for dates and numbers.
19. URLs carry state (filter, tab, page). Destructive actions offer undo or
    ask first.

## Look
<!-- every level. Rounds: lean 1 at 390 only · crafted 2 · polished 3 -->
```bash
bash .comb/ui-lint.sh <ui paths>            # mechanical floor; exit 1 on any finding
bash .comb/shot.sh <url|file> <name> 390 1440   # PNGs + console log in .comb/shots/
```
1. Read `.comb/shots/<name>.console.txt` first — text is cheap. Fix errors.
2. Open the PNG with the Read tool: the width most likely to be broken first.
3. Judge in this order and write down everything seen before fixing anything:
   broken (overflow, overlap, clipped or mid-phrase wrapped text, dead space)
   → Job not dominant → missing state → drift from Tokens → polish.
4. Fix as one batch, shoot again. Stop after <rounds for this level>; report
   what is left.
5. `shot.sh` exit 3 means no browser: say "render unchecked" in the report.
