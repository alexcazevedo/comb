---
name: design
description: Use when a comb product has a user-facing UI (PRODUCT.md `ui:` is lean, crafted or polished) and DESIGN.md is missing or stale, when comb:plan is about to slice tickets that touch screens, or when built UI looks generic, templated or AI-made. Triggers on /comb:design, $comb:design, "make the UI look better", "this looks AI-generated", "production-like UI".
---

# comb:design — DESIGN.md, the UI contract

Generic UI is undecided UI. A comb implementer sees one ticket, so every
visual choice nobody made gets the model's default — and the defaults are the
same on every project. Decide once, on the strongest model, in DESIGN.md;
implementers apply its tokens; a script and one look at the render check it.

## The UI dial (PRODUCT.md `ui:`)

| | lean | crafted | polished |
|---|---|---|---|
| default for mode | prototype | mvp | production |
| DESIGN.md holds | direction, tokens, layout, floor 1–8 | + states, voice, floor 9–12 | + rejected direction, motion, themes, floor 13–19 |
| references looked at | 2 | 3 | 5 |
| every UI ticket | reads DESIGN.md, passes `ui-lint` | same | same |
| looking at the render | last UI ticket, 390px, 1 round | each ticket that adds a screen, 390 + 1440, ≤2 rounds | same, ≤3 rounds |
| review | none | none | one `ui-review` ticket, fresh context, strongest model |
| added cost | one planning step; UI tickets ~30% dearer | more looks per screen (unmeasured) | + a review ticket costing more than a build ticket |

`ui:` is independent of `mode:`. `polished` on a prototype or mvp is the
production-like-UI option: it raises only the UI budget — tests, shortcuts,
attempts and approvals stay at the mode's level. The reverse is valid too
(`production` + `lean` for an internal tool). `ui: none` → this skill does
not run.

## Entry points

- From comb:plan, before slicing: run Steps 1–6, ask nothing.
- `/comb:design` alone: write or refresh DESIGN.md for this repo. `ui:`
  missing from PRODUCT.md → ask once, recommending the mode's default.
- `/comb:design <level>`: set `ui:` in PRODUCT.md, rewrite DESIGN.md's
  sections for that level, tell the user which tickets need re-planning.
- `/comb:design review`: run `## Look` in DESIGN.md over the built UI at the
  product's level and fix what it shows. During a comb run, findings become
  tickets instead.

## Steps

1. **Inherit first.** Look for an existing system: a theme or tokens file,
   Tailwind or component-library config, a DESIGN.md, brand colours or a
   reference the user named. Found → `source: inherited`: record what exists
   in `## Tokens`, skip Steps 3–4, restyle nothing. A new screen inside an
   established product inherits it; it never gets a new identity.
2. **Name the surface.** `operate` (app, dashboard, tool), `persuade`
   (landing, marketing) or `read` (docs, content). Operate and read earn
   quality through precision, density fitted to the Scene and restraint — no
   decorative motion. Only persuade spends on one bold commitment.
3. **Direction** (`source: new` only). Fill the four lines from PRODUCT.md
   and the grill log.
   - World is a point, not a region. "The chalk A-board outside the shop at
     6am" carries a palette, a hand and a layout; "warm, artisanal, modern"
     carries nothing.
   - Derive colour, type and layout from World and Scene. Light or dark
     comes from the Scene's ambient light, never from the category.
   - Colour strategy: tinted neutrals plus one accent, or one colour owning
     whole regions. Never accents scattered evenly.
   - Typeface: name three candidates from World, drop the one you would use
     on any project, keep the one closest to World; record only the choice.
     An operate surface may use a workhorse or system stack; then scale and
     weight carry the hierarchy. Name no font the product cannot load.
   - Run three tests; a failed test means rewrite that line, not explain it:
     **category** — could this look be guessed from the product category
     alone (bakery → cream and serif, dev tool → dark and mono, AI → purple)?
     **hour-later** — what would someone describe an hour later? It must be
     the Signature, and specific. **Job** — in the wireframe, does the Job
     element (or group, for a list) take the most area in the first viewport
     at both widths, with the Signature serving it rather than outranking it?
   - Do not repeat yourself across products: read `~/.comb/design-log.md`
     if it exists and reuse neither the display face nor the ground + accent
     pairing of its last three lines. After Step 5 append one line: date,
     product, display face, ground, accent.
   - polished: write two directions that differ in colour strategy and
     layout concept, keep one, record the other under `Rejected`.
4. **References** (`source: new` only). Direction is a claim; check it
   against shipped work before writing it down. Read `references.md` in
   this skill's directory and follow it: search the five galleries (Mobbin,
   Refero, Awwwards, Godly/Recent, Land-book) for the category and for the
   Job's pattern, open each product's live page with `shot.sh`, and look.
   - Count from the dial; stop there. No web tool or no browser → record
     `none` with the reason and go on.
   - Take structure and the level of finish into `## Layout` and
     `## States`. Never take palette, type or copy — those stay with World.
   - What the references share is the category look: re-run the category
     test against it and rewrite any Direction line that now fails.
   - Record each in `## References`: product, URL, the one thing taken, the
     one thing left. Cite nothing you did not open.
5. **Write DESIGN.md** at the repo root from templates/DESIGN.md. Keep the
   sections and Floor rules for this level (`## Look` stays at every
   level), delete the rest, and copy the kept Floor verbatim with its line
   breaks — an implementer knows only what this file says. Expect about 120
   lines at lean, 155 at crafted, 200 at polished; never compress formatting
   to save lines.
6. **Install the checks.** Copy `ui-lint.sh` and `shot.sh` from this skill's
   directory into `.comb/` (run them with `bash`) and, in a git repo, add
   `.comb/shots/` to `.gitignore`. Use
   `ui-lint.sh --no-raw-color` in tickets when an inherited codebase already
   has colour literals everywhere.

## Ticket rules (what comb:plan writes)

- The first UI ticket creates the tokens file from `## Tokens` and lists it
  under `## Interface`. Every later UI ticket consumes it by name.
- Every UI ticket's Context starts: "Read DESIGN.md first; it binds every
  visual choice." Its Checks include `bash .comb/ui-lint.sh <ui paths>`
  after build.
- Tickets that look (see the dial) add the check
  `bash .comb/shot.sh <url|file> <name> <widths> || [ $? -eq 3 ]` and a Done
  line "render looked at; findings fixed". polished drops the
  `|| [ $? -eq 3 ]` — a browser is required there.
- Look rounds are separate from `max_attempts`, which still comes from the
  mode and still counts failed check cycles only.
- Route UI tickets to sonnet or above. haiku fills gaps with defaults.
- polished adds a last UI ticket, `NN-ui-review`, model opus, depending on
  every UI ticket, `files:` = the UI touch set. Context to paste:

  > Fresh eyes: you did not build this. Shoot every screen and every state
  > in DESIGN.md `## States` at 390 and 1440. Follow `## Look`. Then answer
  > in the report: is the Job obvious in two seconds? Could the look be
  > guessed from the category? What is the one thing remembered? Fix what
  > fails, in at most 3 rounds, without leaving DESIGN.md's tokens.

- At a human plan gate, print the Direction lines in the summary. The owner
  approves the look with the plan; there is no separate design gate.

## Common mistakes

| mistake | instead |
|---|---|
| Floor summarised or reworded in DESIGN.md | copy it verbatim; the summary drops the rule that mattered |
| Direction written in adjectives | one concrete reference from the subject's world |
| a reference's palette or typeface copied into Tokens | references give structure and the bar; colour and type come from World |
| references listed from memory, never opened | shoot the live page and look, or record `none` |
| treating Refuse as the direction | avoiding a list yields its own generic look; World comes first |
| new palette for a product that already has one | `source: inherited`, document, extend |
| landing-page ambition on a dashboard | surface `operate`: precision and hierarchy, not decoration |
| `ui-ok` waivers added to get a green check | waive only what Direction names; otherwise fix the line |
| claiming UI done without a look when `shot.sh` worked | open the PNG; if exit 3, report "render unchecked" |
