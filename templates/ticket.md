---
id: NN
status: todo            # todo | doing | done | blocked
model: sonnet           # haiku | sonnet | opus | local
depends_on: []
max_attempts: 2         # from mode: prototype 2 | mvp 3 | production 4
files: []               # expected touch set; disjoint across parallel tickets
---
## Goal
One sentence.

## Context
Word cap by mode: prototype 150 | mvp 250 | production 350. Everything the
agent needs that isn't in the files, including the exact names it consumes
from upstream tickets. No links to chat history.

## Interface
Exact names this ticket creates for dependents: file paths, functions and
signatures, element ids, env vars, commands and flags, storage keys, ports.
`none` if nothing downstream consumes it.

## Checks (run in order — cheapest first)
1. `<lint command>`
2. `<build command>`
3. `<test command>`     <!-- mvp and up only -->
4. `<runtime probe, e.g. curl -s localhost:3000/health | grep ok>`

## Done when
- <observable behavior, one or two bullets>

## Not included
- <explicit scope boundary so the agent doesn't gold-plate>

<!-- forge:run appends `## Handoff from NN` sections here as upstream
     tickets finish; leave them in place. -->
