---
name: grill
description: Use when the user brings a raw product idea to comb — grills it into a right-sized PRODUCT.md. Triggers on /comb:grill, $comb:grill, a new product idea, or "let's build X" with no spec yet.
---

# comb:grill — grill the raw idea

Turn a raw idea into PRODUCT.md. Nothing else: no tickets, no code, no
architecture debate.

## The dial (question 1, always)

First question, every time: which product class? Recommend one based on what
they said, so "yes" is a valid answer.

| | prototype | mvp | production |
|---|---|---|---|
| grill questions (max) | 4 | 8 | as needed |
| PRODUCT.md body (max) | 250 words | 600 words | 1 page + ADRs if warranted |
| human approvals (whole pipeline) | 1 | 2 | 3 |
| tests | smoke only (build runs, happy path executes) | core logic only | full discipline + reviewer pass |
| loop attempts per ticket | 2 | 3 | 4 |
| permitted shortcuts | hardcode config, TODOs, zero abstractions "for later" | some hardcoding, documented | none |

Question 2: greenfield or existing repo? If the cwd already answers this,
don't ask — confirm in passing.

## The UI dial (only when the product has a screen)

No screen (CLI, API, library, job) → write `ui: none`, ask nothing. Otherwise
one question, counted against the cap: how much UI rigor? Recommend the mode's
default. Any level is valid in any mode — `polished` on a prototype or mvp
means production-like UI on the same shortcut-friendly code.

| ui | default for | buys |
|---|---|---|
| lean | prototype | a decided look: DESIGN.md tokens + craft floor, linted, one look at the render |
| crafted | mvp | + empty/loading/error states, responsive layout, a look per screen |
| polished | production | + two directions weighed, motion, themes, accessibility, a fresh-eyes review ticket |

In the same message, invite a reference: a brand, a site, or a thing from
the product's own world the UI should feel like. Record it in PRODUCT.md
under What / why. Details of each level live in comb:design — never grill
on colours or fonts.

## How to grill

- ONE question per message. Multiple-choice preferred. ALWAYS include your
  recommended answer so the user can just say "yes".
- If the codebase can answer a question, explore instead of asking.
- If a product brief already exists (PRD.md, docs/discovery*.md, or one the
  user points to — e.g. output of /product-manager or /startup-advisor),
  treat it as answered questions. Ask only what it leaves open; the cap still
  applies.
- Count your questions. Stop at the mode's cap — or earlier, the moment you
  can state the idea sharply. The cap is a ceiling, not a quota.
- Grill on: who it's for, the one job it must do, what's explicitly out,
  what "done" looks like. Never grill on implementation detail — that is
  comb:plan's job.

## Owner proxy (owner: agent)

If `owner: agent` (PRODUCT.md frontmatter or the prompt), ask the user
nothing. Dispatch `comb:owner` per question (Agent tool; Codex: inline
`agents/owner.md`'s body) with vision, `~/.comb/owner.md` if present,
PRODUCT.md and grill log so far, the question + your recommendation, and
the mode — never asked of the owner. Parse `ANSWER`/`TAG`/`REASON`; append
a row to `## Grill log`. Caps still apply. ESCALATE: prototype takes
ANSWER's smallest-scope option and logs it; mvp/production stop, write
STATE.md Blockers, tell the user. Gate unchanged: prototype/mvp say
"next: /comb:plan"; production shows PRODUCT.md and waits for the human.

## Output: PRODUCT.md

Write from templates/PRODUCT.md at the repo root. Frontmatter: `mode`,
`routing_profile` (`cloud` unless the user themselves brought up local
models — never enable `cloud+local` silently), `parallel_default`, `ui`. Body:
what/why, primary user story, out-of-scope list, success demo ("done when I
can ___", one sentence). Respect the mode's word cap.

## Gate

- production: show PRODUCT.md, get explicit approval. (Approval 1 of 3.)
- prototype / mvp: NO approval here — say "next: /comb:plan". Spec and
  tickets are approved together there. One interruption, not two.
