---
id: 06
status: done
model: sonnet
depends_on: [02, 03, 04, 05]
max_attempts: 2
files: [skills/auto/SKILL.md, skills/grill/SKILL.md, agents/owner.md]
---
## Goal
End-to-end smoke: `/comb:auto prototype` in a scratch repo completes with zero prompts and produces the artifacts.

## Context
Scratch dir: `S=/tmp/comb-auto-smoke`; `rm -rf $S && mkdir -p $S && cd $S && git init -q`. macOS has no `timeout`; one Bash call caps at 10 minutes; the nested run takes 5–15 minutes. So launch in the background and poll:

```
cd $S && nohup perl -e 'alarm 1200; exec @ARGV' claude -p --permission-mode auto --plugin-dir ~/dev/hive-comb "/comb:auto prototype 'a tiny CLI that prints the current time in three cities'" > $S/smoke.log 2>&1 &
echo $! > $S/pid
```

Then poll in separate Bash calls of ≤8 minutes each (`while kill -0 $(cat $S/pid) 2>/dev/null; do sleep 30; done`) until the process exits or 20 minutes pass. Verified beforehand: a nested `claude -p --plugin-dir ~/dev/hive-comb` from inside a session works and lists comb:auto. The listed files are fix scope only: if a check fails because of prompt wording (owner output not parsed, log not written, report missing), adjust the wording and rerun once. Never edit the checks. Do not fix the generated toy project. Include the tail of smoke.log in the report if anything fails.

## Checks (run in order — cheapest first)
1. `test -f /tmp/comb-auto-smoke/PRODUCT.md && grep -q '^owner: agent' /tmp/comb-auto-smoke/PRODUCT.md`
2. `grep -q '^## Grill log' /tmp/comb-auto-smoke/PRODUCT.md && grep -Eq 'AGREE|DIVERGE|ESCALATE' /tmp/comb-auto-smoke/PRODUCT.md`
3. `ls /tmp/comb-auto-smoke/tickets/*.md >/dev/null && test -f /tmp/comb-auto-smoke/REPORT.md`
4. `grep -Eq 'DIVERGE' /tmp/comb-auto-smoke/REPORT.md`

## Done when
- A cold `/comb:auto prototype` run yields PRODUCT.md with `owner: agent` plus grill log, tickets, and REPORT.md, without any human prompt.

## Not included
- Fixing the toy project; edits to plan / run / status / README.
