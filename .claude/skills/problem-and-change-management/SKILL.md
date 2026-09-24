---
name: problem-and-change-management
description: "Log Problem Reports and Change Requests, perform impact analysis against the traceability matrix, and gate approval for changes to baselined work products (SUP.9, SUP.10). Use when a defect is found or a baselined item needs to change."
---

# Problem & Change Management (SUP.9 / SUP.10)

## Problem Reports (SUP.9)

1. Log every defect/anomaly as a row in `.ai/memory/problem-reports.md`, whatever its
   source (test failure, field issue, review finding).
2. Fill `ASIL impact` from the affected item's ASIL in `traceability.md` — never leave it
   blank.
3. Root-cause it before proposing a corrective action; a fix without a stated root cause
   is a guess, not a resolution.
4. If the corrective action changes a baselined work product, open a linked Change
   Request and reference its ID in `Linked CR`.

## Change Requests (SUP.10)

1. Log the CR in `.ai/memory/change-requests.md` with its trigger (a PR ID or a new
   need).
2. Impact analysis: list every requirement/architecture element/unit/test the change
   touches, cross-checked against `.ai/memory/traceability.md` — an incomplete impact
   analysis is the most common source of regressions.
3. If any affected item is ASIL A–D, leave `Approval` empty and name the human who must
   approve it — never approve it yourself.
4. Only after approval is recorded does the change proceed to the owning specialist
   (`requirements-engineer`/`software-architect`/`software-developer`/`test-engineer`).

## Anti-patterns

- Don't skip the CR for a "small" change to a baselined item — size doesn't exempt it.
- Don't merge a PR's root cause and a CR's impact analysis into one vague paragraph —
  they answer different questions (why did it break vs. what does fixing it touch).
