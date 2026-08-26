---
name: plan-feature
description: "Turn a feature request or bug report into a recorded design decision (when one is needed) plus an ordered, ownable task table in .ai/memory/plan.md. Use when starting new feature work or whenever work needs breaking down before implementation."
---

# Plan Feature

Design and sequencing are one pass. Deciding *what to build* and *in what order* in separate
agent runs means paying for the same context twice.

## Procedure

1. Read `.ai/memory/architecture.md` and `.ai/memory/repo.md`. Don't re-derive facts already
   recorded there.
2. **If the request needs a structural decision** not yet covered — a new component or service,
   a changed data flow, a major dependency, a tenancy or sync model — decide it now and append
   an ADR entry to `architecture.md` before writing any tasks:

   `<YYYY-MM-DD> — <decision> — why: <rationale>; alternatives: <what you rejected and why>`

   Append only. If a decision changes, add a new entry naming the one it supersedes.
3. Settle acceptance criteria. If a genuine ambiguity would change the task breakdown, ask one
   question. Otherwise pick the reasonable reading, proceed, and record the assumption in
   `plan.md` so it's visible rather than silent.
4. Break the work into tasks that are each:
   - owned by **exactly one** agent that has the tools and the scope for it,
   - independently verifiable — no task that needs another to be "mostly done" first; sequence
     them instead,
   - small enough that its diff can be reviewed on its own.

   Prefer a **vertical slice** (schema + logic + UI + tests for one behaviour) over horizontal
   layer tasks. Each extra owner is another cold context that re-pays discovery cost, so a task
   split that looks tidy on paper can double the price of the feature.
5. Write the result to `.ai/memory/plan.md` per [update-memory](../update-memory/SKILL.md),
   all tasks at status `todo`.
6. Report one paragraph: the shape of the plan, the task count, any ADR you recorded, any
   assumption you made. The table is already in `plan.md` — don't repeat it.

## Anti-patterns

- A single "implement the feature" task — that defeats the point.
- One task per tech layer when one vertical slice would do.
- Assigning a task to an agent whose scope doesn't cover those paths.
- Deciding architecture implicitly inside a task description instead of recording it as an ADR.
