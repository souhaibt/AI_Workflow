---
description: "Use when writing or reviewing automated tests. Covers test structure, naming, fixtures, and what must be covered before a task is marked done."
---

# Testing Conventions

`<Fill in: test framework, file naming/location convention, fixture/mock patterns, coverage
expectations.>`

- Every task in `.ai/memory/plan.md` needs at least one test unless explicitly marked
  test-exempt in its `Notes` column.
- Tests must be deterministic — no dependence on real network calls, wall-clock time, or
  execution order.
