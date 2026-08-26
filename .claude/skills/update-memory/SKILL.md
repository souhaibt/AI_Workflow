---
name: update-memory
description: "How to read and write this project's cross-session memory under .ai/memory/. Use at the start of a task to load context and before finishing to persist what changed."
---

# Update Memory

`.ai/memory/` is the source of truth across sessions — chat history isn't persisted, this is.

| File              | Contents                                              | Written by                   |
| ----------------- | ----------------------------------------------------- | ---------------------------- |
| `architecture.md` | System design + append-only ADR decisions             | `planner`                    |
| `repo.md`         | Conventions, tooling decisions, gotchas               | anyone, when durable         |
| `plan.md`         | In-flight acceptance criteria + task table            | `planner` writes, others update status |
| `log.md`          | One line per session/decision, newest first           | anyone, at end of turn       |

## Reading

Read `repo.md` and `plan.md` at the start of a task. Read `architecture.md` only for
structural work — it's long and most tasks don't need it. Trust what's recorded; don't
re-derive it.

## Writing

- **`plan.md`** — update only your task's row. Status: `todo`, `in-progress`, `blocked`,
  `review`, `done`. Never `done` with a failing gate or an unmet acceptance criterion.
  When a feature ships, move its content under a `### <feature>` heading in `log.md` and
  reset `plan.md` to the empty template.
- **`repo.md`** — append durable facts (one or two lines) under the right heading. Update in
  place rather than duplicating. Nothing architectural — that belongs in `architecture.md`.
- **`architecture.md`** — `planner` only. Append-only for ADR entries; never rewrite or delete
  a past decision, supersede it. Other agents flag corrections instead of editing.
- **`log.md`** — one line at the top: `<date> — <agent> — <summary>`. Past ~200 lines, move the
  oldest into `log.archive.md` first.

## Discipline

Short and factual — every future agent pays to read this. Bullets over prose. Never paste
diffs, stack traces, or file contents; summarize and link. If a fact is already in the code
or the commit history, don't duplicate it here.
