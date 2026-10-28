---
name: plan
description: Use after PRODUCT.md exists to slice the work into agent-ready tickets with executable checks and model routing. Triggers on /forge:plan or $forge:plan.
---

# forge:plan — tickets

Read PRODUCT.md first; its `mode` sets every budget below. Planning always
runs on the strongest available model — plan quality gates everything
downstream. If the current session model is weaker, say so before planning.

## Slicing

- Vertical slices (tracer bullets): every ticket cuts through to observable
  behavior. Never layer-slice ("all models", then "all routes").
- Sized to fit one subagent context comfortably and require ZERO discovery:
  the implementer gets the ticket + PRODUCT.md + listed files, nothing else.
  If it would need to hunt, the ticket is underspecified — fix the ticket.
- One file per ticket: `tickets/NN-slug.md`, from templates/ticket.md.
- If parallel execution is plausible, make `files:` sets disjoint between
  independent tickets — parallel agents colliding on shared files is the #1
  documented multi-agent failure mode.
- Count by mode: prototype 3–6 tickets, mvp 5–10, production as needed.
  More than that is two milestones — split PRODUCT.md instead.
- Shape that works: independent foundations → integration → one final
  verification ticket that runs PRODUCT.md's Success demo as checks and
  depends on everything else (mvp and up) → docs/run instructions last.
- Prefer zero new dependencies per ticket unless PRODUCT.md names them;
  the stdlib or what the repo already uses wins.

## Interface contracts (what makes a ticket self-contained)

The implementer sees only its ticket, PRODUCT.md and the listed files. So
every name two tickets share must be written down in both:

- The producing ticket lists under `## Interface` the exact names it
  creates for others: file paths, exported functions and signatures,
  element ids, env vars, CLI commands and flags, storage keys, ports.
- A dependent ticket restates the names it consumes in its Context ("uses
  `#todo-form`, `#todo-input` from ticket 02") — never "see ticket 02".
- Pick the names at plan time. If you cannot name an interface yet, the
  slice is wrong; split or reorder until you can.
- Context cap by mode: prototype 150 words, mvp 250, production 350. Spend
  them on contracts and constraints, not on motivation.

## Ticket fields

- `max_attempts`: from mode — prototype 2, mvp 3, production 4.
- Checks: executable commands whose exit codes define done, cheapest first
  (lint → build → test → runtime probe). Test checks appear mvp and up only.
  No prose criteria — "should work smoothly" is not a check.
- "Not included": explicit, so the agent doesn't gold-plate.

## Model routing (assign per ticket; user may override)

The values below are portable routing tiers. In Claude Code they map directly
to the named Anthropic model/agent definition. In Codex, map `haiku` to the
fastest economical available model, `sonnet` to the balanced/default model,
and `opus` to the strongest available model. Keep the ticket value stable so
the same plan can resume on either host.

| model | use for |
|---|---|
| haiku | boilerplate, renames, docs, config, glue code, simple CRUD |
| sonnet | default implementation, refactors, tests |
| opus | architecture decisions, gnarly debugging, security-sensitive code |
| local | opt-in lane, haiku-class task types ONLY — see below |

Mixed routing cuts spend 40–60% versus running everything on one big model.

## local lane (strictly opt-in)

Tag `model: local` only when PRODUCT.md says `routing_profile: cloud+local`,
and only on haiku-class tickets. Never silently substitute local for cloud
or cloud for local. Execution mechanics live in forge:run — the plan only
tags.

## Self-check before the summary

Validate the ticket set mechanically before showing it. Fix and recheck,
do not hand the user a broken plan:

- every `depends_on` id exists; no cycles; ids unique
- `files:` disjoint between tickets that are not ordered by `depends_on`
- every ticket has ≥1 executable check; test checks only mvp and up
- `max_attempts` matches the mode; `model` is one of the four tiers
- every shared name appears in a producer's `## Interface` and in each
  consumer's Context
- a `hive` binary on PATH: `hive init tickets/` must load the set (it
  rejects duplicate ids, unknown deps and cycles)

## Output + gate

Print a one-screen summary: tickets in dependency order, model per ticket,
which are independent (parallelizable). Then:

- prototype / mvp: ONE gate — approve PRODUCT.md + tickets together.
  (prototype: approval 1 of 1. mvp: approval 1 of 2.)
- production: approve the plan. (Approval 2 of 3.)

Nothing runs before this approval.

Under `owner: agent`: prototype / mvp dispatch `forge:owner` once with
PRODUCT.md + the ticket summary, asking "APPROVE or list blocking
objections." Parse `ANSWER`/`TAG`: AGREE → proceed; DIVERGE → revise
tickets once, then proceed. production: print the summary, say approval
is pending, stop — approval 2 of 3 stays human.
