---
description: "Kick off a new feature or bug fix. Provide a feature description and acceptance criteria."
agent: agent
argument-hint: "<feature description> — <acceptance criteria>"
---

A new feature or bug-fix request follows this prompt. Drive it from this session — there is no
orchestrator to hand it to.

1. Read `.ai/memory/repo.md` and `.ai/memory/plan.md`. Read `architecture.md` only if the request
   changes structure rather than filling it in.
2. If no active plan covers this request, produce one with the `plan-feature` skill — delegate to
   `planner` if the design decision is genuinely open, otherwise just write the tasks.
3. Split the work by **repo area**, not by tech layer. One vertical slice — schema, logic, UI, and
   its tests — owned end to end beats four layer-shaped tasks handed between four cold contexts.
   Delegating is not free; do it when the work belongs to a different area or a different tier,
   not to feel thorough.
4. Execute each task with the `implement-task` skill. Tests ship in the same diff as the code.
5. Run the gates: `source .ai/config/commands.sh && $AI_LAYER_TEST_CMD`. They are the primary
   quality bar. Run `review-diff` only if the diff touches auth, access policies, tenancy
   boundaries, payments, or untrusted input — otherwise the linters already said it.
6. Don't call it done with a failing gate. Mark the task `blocked` in `plan.md` with the reason.
7. Update `plan.md` and `log.md` before finishing.
