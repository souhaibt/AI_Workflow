---
description: "Use when writing or reviewing embedded C code for the OBC. Covers ASIL-relevant coding conventions: defensive programming, resource discipline, and the MISRA deviation process."
---

# Safety Coding Conventions

`<Fill in: MISRA C:2012 deviation process/tooling, static analysis tool (Polyspace/QAC/
Coverity), stack/heap budget, interrupt-safety rules specific to this OBC.>`

- No dynamic memory allocation in ASIL-tagged code paths; prefer static allocation with
  bounds known at compile time.
- Defensive programming: check all function arguments and return values on ASIL-tagged
  paths, even ones that "can't happen" — that assumption is exactly what HARA exists to
  challenge.
- Deterministic timing: no unbounded loops/recursion on ASIL-tagged paths; document
  worst-case execution time for anything on a control-loop deadline.
- A change to authentication of diagnostic/bootloader access, input parsing of
  CAN/charging-protocol frames, or any ASIL-tagged path needs `quality-assurance`'s pass
  before it's marked done — see `.claude/skills/work-product-audit/SKILL.md`.
