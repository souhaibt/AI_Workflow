---
name: work-product-audit
description: "Audit ASPICE work products for process conformance: traceability completeness, ASIL-authorship compliance, and reviewer independence (SUP.1). Use before any task or baseline is marked done."
---

# Work Product Audit (SUP.1)

Read-only. You report findings; you never edit a work product yourself.

## Checklist

- **Traceability**: every row in `.ai/memory/requirements.md` has a corresponding entry
  in `.ai/memory/traceability.md` with a design element, unit, and the test levels
  appropriate to its ASIL.
- **ASIL authorship**: no ASIL A–D row/element has `Author` set to an AI role, and no
  QM-only content leaked into an ASIL-tagged item.
- **Independence**: for every ASIL C/D row, `Author` and `Reviewer`/`Approver` name
  different people. Flag a match or a blank field.
- **Baseline integrity**: nothing in `.ai/memory/baselines.md` references a work product
  that isn't `approved`/`baselined`.
- **Status hygiene**: no `Status: approved`/`baselined` appears to have been set without a
  named human (a plausible human name, not an agent/role name, in the adjacent approver
  field).

## Output Format

Findings grouped **Critical** (blocks baseline/done) / **Warnings** / **Suggestions**,
each naming the work product, the row/element, and exactly what a human needs to do.
Omit empty categories.
