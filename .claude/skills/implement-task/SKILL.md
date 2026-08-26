---
name: implement-task
description: "Pull the next todo task from .ai/memory/plan.md, implement it with its tests, run the project's gates, and update its status. Use whenever an implementing agent works from the active plan."
---

# Implement Task

## Procedure

1. Read `.ai/memory/plan.md`. Take the task the orchestrating session named, or the
   highest-priority `todo` row assigned to your role. Set it to `in-progress`.
2. Read `.ai/memory/repo.md` for conventions. Skip `architecture.md` unless the task is
   structural — it's the planner's document and most tasks don't need it.
3. Implement the task **and the tests that cover it** in the same pass. There is no separate
   test-writing agent; a task without a test that fails on regression is not done.
4. Run the gates: `source .ai/config/commands.sh` then `$AI_LAYER_TEST_CMD`.
   - Pass ⇒ set status to `review` (or `done` where no review step applies).
   - Fail ⇒ fix it, or set status `blocked` with a one-line reason in `Notes`.
     **Never mark `done` with a failing gate.**
5. Append one line to `.ai/memory/log.md` per [update-memory](../update-memory/SKILL.md).
6. Report: files touched, one line on the change, gate result. Not the diff.

## Reading discipline

Context re-acquisition, not writing, is where the tokens go. So:

- **Search, then read.** Grep/glob for the symbol, then read that file. Never read a directory
  to "get oriented" — that's the single most expensive thing you can do.
- **Never read generated or vendored files** — `*.g.dart`, `*.freezed.dart`, `*.mocks.dart`,
  `dist/`, `build/`, `node_modules/`, lockfiles. They're machine output, often thousands of
  lines, and they tell you nothing the source doesn't. Read the source they came from.
- **Never edit generated files.** Change the source and re-run codegen. A hook will block the
  write, but knowing why saves you the round trip.
- Don't re-read a file you already read this session, and don't re-derive a fact `repo.md`
  already records.

## Scope discipline

Implement the assigned task and nothing else. Something else that needs doing goes in the
plan's `Notes` column, not in your diff — unrequested changes ride along unreviewed.
