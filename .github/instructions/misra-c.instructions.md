---
description: "MISRA C:2012 conventions for the OBC embedded codebase. Use when writing or reviewing any C/H source file."
applyTo: "<source glob, e.g. src/**/*.c, src/**/*.h>"
---

# MISRA C:2012 Conventions

`<Fill in: MISRA C:2012 compliance level targeted (mandatory/required/advisory), the
static analysis tool used to check it, and the project's deviation record location.>`

- Every MISRA deviation needs a recorded justification (tool: `<placeholder>`) — an
  unrecorded deviation is a finding in `quality-assurance`'s audit.
- Run the static analysis command from `.ai/config/commands.sh`
  (`AI_LAYER_MISRA_CHECK_CMD`) before any unit is reported as build-passing.
- No undefined/implementation-defined behavior on ASIL-tagged paths — if MISRA flags it,
  it needs a deviation record, not a silent ignore.
