---
description: "Use when writing or running unit (SWE.4), integration (SWE.5), or qualification (SWE.6) tests. Covers ASIL-scaled coverage targets and what must be true before a task is marked done."
---

# Testing Conventions (SWE.4 / SWE.5 / SWE.6)

`<Fill in: test framework/harness (e.g. Ceedling+Unity, VectorCAST, GoogleTest for
host-based tests), file naming/location convention, mocking approach for AUTOSAR RTE/BSW.>`

- Coverage target by ASIL (ISO 26262-6): QM/A/B — statement coverage; C — branch
  coverage; D — MC/DC. `test-engineer` must report the level achieved against the level
  required for the item under test, not just "tests pass".
- For ASIL C/D items, the test case/acceptance criteria are human-authored — `test-engineer`
  builds and executes the harness, it doesn't invent the test case (see
  `.claude/skills/safety-governance/SKILL.md`).
- Tests must be deterministic — no dependence on real hardware timing, wall-clock time, or
  execution order, unless the test is explicitly a timing/HIL test.
- A test failure is a Problem Report (SUP.9) — never adjust the test to make it pass
  without a recorded root cause.
