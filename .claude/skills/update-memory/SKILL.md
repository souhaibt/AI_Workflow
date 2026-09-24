---
name: update-memory
description: "How to read and write this project's cross-session memory under .ai/memory/, including the ASPICE work products (requirements, architecture, traceability, plan, baselines, problem reports, change requests). Use at the start of a task to load context and before finishing to persist what changed."
---

# Update Memory

`.ai/memory/` is the source of truth across sessions — chat history isn't persisted, this is.

| File                 | Contents                                                 | Written by                                                        |
| -------------------- | -------------------------------------------------------- | ----------------------------------------------------------------- |
| `requirements.md`    | Software requirements (SWE.1), ASIL-tagged               | `requirements-engineer` (ASIL rows: gap only, human fills text)   |
| `architecture.md`    | System design (SWE.2) + append-only ADR decisions        | `software-architect` (ASIL elements: human decides)               |
| `plan.md`            | Task breakdown (MAN.3) + risk register                   | `project-manager` writes; task owner updates its own row's status |
| `traceability.md`    | Req → design → unit → test trace matrix                  | shared — each role updates the columns it owns                    |
| `baselines.md`       | Configuration items + baseline history (SUP.8)           | `configuration-manager`                                           |
| `problem-reports.md` | Defect/anomaly log (SUP.9)                               | `change-and-problem-manager`                                      |
| `change-requests.md` | Change request log + impact analysis (SUP.10)            | `change-and-problem-manager`                                      |
| `repo.md`            | Conventions, coding standard, tooling decisions, gotchas | anyone, when durable                                              |
| `log.md`             | One line per session/decision, newest first              | anyone, at end of turn                                            |

## Reading

Read `repo.md` and `plan.md` at the start of a task. Read `requirements.md`,
`architecture.md`, and `traceability.md` for anything requirement- or design-adjacent —
most tasks need at least one. Trust what's recorded; don't re-derive it.

## Writing

- **ASIL-tagged rows/elements, in any file** — never author or finalize the content
  yourself, and never set `Status` to `approved`/`baselined` — see
  `.claude/skills/safety-governance/SKILL.md`. This applies across the whole table, not
  just `architecture.md`.
- **`plan.md`** — update only your task's row. Status: `todo`, `in-progress`, `blocked`,
  `review`, `done`. Never `done` with a failing gate, an unmet acceptance criterion, or
  (for ASIL items) without a recorded human approval.
- **`architecture.md`** — `software-architect` only. Append-only for ADR entries; never
  rewrite or delete a past decision, supersede it instead.
- **`traceability.md`** — never delete a row; retire it with a note instead.
- **`repo.md`** — append durable facts (one or two lines) under the right heading. Update in
  place rather than duplicating. Nothing architectural — that belongs in `architecture.md`.
- **`log.md`** — one line at the top: `<date> — <agent> — <summary>`. Past ~200 lines, move the
  oldest into `log.archive.md` first.

## Discipline

Short and factual — every future agent pays to read this. Bullets over prose. Never paste
diffs, stack traces, or file contents; summarize and link. If a fact is already in the code
or the commit history, don't duplicate it here.
