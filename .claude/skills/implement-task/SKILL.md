---
name: implement-task
description: "Pull the next todo task from .ai/memory/plan.md, implement it per SWE.3, and update its status. Use whenever software-developer works from the active plan."
---

# Implement Task (SWE.3)

## Procedure

1. Read `.ai/memory/plan.md`. Take the task the orchestrator named, or the
   highest-priority `todo` row assigned to `software-developer`. Set it to `in-progress`.
2. Check `.ai/safety/asil-manifest.md` for the file(s) the task touches (see
   `.claude/skills/safety-governance/SKILL.md`):
   - **QM**: implement normally.
   - **ASIL A–D**: stop — don't edit. Review the existing human-authored code instead,
     set the task's status to `blocked` with a one-line reason (e.g. "ASIL C, needs
     human author"), and report back to the orchestrator.
3. Read `.ai/memory/repo.md` for conventions and `.ai/memory/architecture.md` for the
   design this unit implements. Follow `.github/instructions/misra-c.instructions.md`
   and `.github/instructions/safety.instructions.md`.
4. Implement the task. Unit tests are `test-engineer`'s job (SWE.4), not yours — hand off
   once your build passes; don't skip requesting it.
5. Run the build command from `.ai/config/commands.sh`.
   - Pass ⇒ set status to `review`.
   - Fail ⇒ fix it, or set status `blocked` with a one-line reason in `Notes`. **Never
     mark `done` yourself** — that's `quality-assurance`'s call after audit.
6. Update `.ai/memory/plan.md` and append one line to `.ai/memory/log.md` per
   [update-memory](../update-memory/SKILL.md).
7. Report: files touched, one line on the change, build result. Not the diff.

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
