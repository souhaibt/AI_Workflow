---
name: configuration-management
description: 'Manage configuration items and create baselines once work products are approved, and propose (never make) changes to the ASIL authorship manifest (SUP.8). Use when work is ready to be baselined or a new configuration item appears.'
---

# Configuration Management (SUP.8)

## Procedure
1. Read `.ai/memory/traceability.md` and the `Status` column of each work product a
   baseline would cover.
2. A baseline may only include items that are `approved`/`baselined` in their own work
   product, with a named human approver — if anything isn't, report exactly what's
   blocking it instead of creating the baseline.
3. Update the Configuration Items list in `.ai/memory/baselines.md` as new work
   products/files appear.
4. Record the baseline (ID, date, contents, approver, git tag if applicable) in the
   Baseline History table via `.claude/skills/update-memory/SKILL.md`.

## The manifest is not yours to edit
`.ai/safety/asil-manifest.md` is hook-protected against every subagent, including you. If
a path's QM/ASIL classification looks wrong, tell the user exactly what entry to
add/remove and why — never attempt the edit.

## Anti-patterns
- Don't baseline a partial set "to make progress" — an incomplete baseline is worse than
  none, it implies false readiness.
