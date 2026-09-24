---
name: verify-and-test
description: 'Run and report unit (SWE.4), integration (SWE.5), or qualification (SWE.6) testing against the appropriate test basis, with ASIL-scaled coverage. Use after implementation (unit), after integration (component interfaces), or against software requirements (qualification).'
---

# Verify & Test (SWE.4 / SWE.5 / SWE.6)

## Choose the level (given by the task)

| Level | Test basis | Scope |
|---|---|---|
| Unit (SWE.4) | Detailed design | One unit/function in isolation |
| Integration (SWE.5) | Architecture interfaces (`architecture.md`) | Interactions between units/components |
| Qualification (SWE.6) | Software requirements (`requirements.md`) | Whole software, black-box |

## Procedure
1. Read the test basis for the given level.
2. Check the item's ASIL (see `.claude/skills/safety-governance/SKILL.md`):
   - **QM/A/B**: author test cases and run them.
   - **ASIL C/D**: do not author the test case/acceptance criteria — only build/execute
     the harness a human-authored test case specifies, and verify `Author` ≠ `Reviewer`
     on the test record.
3. Run the test command from `.ai/config/commands.sh`, at the coverage the item's ASIL
   requires (ISO 26262-6): QM/A/B — statement; C — branch; D — MC/DC.
4. Update `.ai/memory/traceability.md` with the test ID(s) in the right column for the
   level, and the task's status via `.claude/skills/update-memory/SKILL.md`.
5. Any failure becomes a Problem Report — hand it to `change-and-problem-manager`, don't
   adjust the test to pass.

## Anti-patterns
- Don't report a coverage level below what the item's ASIL requires as sufficient.
- Don't skip a level because a lower one passed — SWE.4/5/6 each verify something the
  others don't.
