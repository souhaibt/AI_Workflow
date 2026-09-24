---
name: elicit-requirements
description: 'Elicit or derive software requirements from a system/safety requirement, assign an ASIL, and record them with traceability in .ai/memory/requirements.md (SWE.1). Use when a system requirement needs a corresponding software requirement, or a requirement is ambiguous/untraced.'
---

# Elicit Requirements (SWE.1)

## Procedure
1. Read `.ai/memory/architecture.md` for existing constraints the requirement must fit.
2. Identify the source: which system/safety requirement (SYS-REQ/FSR/TSR) drives this
   software requirement, and its ASIL (from HARA/safety concept, or as already stated).
3. Check the posture for requirements (see `.claude/skills/safety-governance/SKILL.md`):
   - **QM**: write the requirement text and verification criteria directly.
   - **ASIL A–D**: do NOT write the requirement text, not even a draft. Add a row with
     `Status: draft`, the ID, source, and ASIL filled in, `Requirement`/`Verification
     criteria` left for a human, and explain precisely what's needed in your report.
4. Add/update the corresponding row in `.ai/memory/traceability.md`.
5. Update `.ai/memory/requirements.md` via `.claude/skills/update-memory/SKILL.md`.

## Anti-patterns
- Don't invent an ASIL — carry it from the source requirement/HARA; if it's not given,
  say so explicitly rather than guessing.
- Don't leave a requirement untraced "for now" — an untraceable requirement is a finding.
