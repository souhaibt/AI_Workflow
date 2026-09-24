---
name: maintain-architecture
description: "Create or update the living architecture document at .ai/memory/architecture.md (SWE.2) and record design decisions as ADR-lite entries. Use when a component/interface needs designing, overall structure changes, or requirements-engineer/project-manager need an architectural decision before proceeding."
---

# Maintain Architecture (SWE.2)

## When to use

- `.ai/memory/architecture.md` doesn't cover the area a request touches.
- A request changes structure: a new component/interface, a changed data/signal flow, a
  new safety mechanism, or a shift in a previous decision.
- `project-manager` or the orchestrator flags that a task needs an architectural decision
  before it can be sequenced.

## Procedure

1. Read `.ai/memory/requirements.md` and the current `.ai/memory/architecture.md`.
2. Check `.ai/safety/asil-manifest.md` for the element you're about to touch (see
   `.claude/skills/safety-governance/SKILL.md`).
   - **QM**: author/edit the relevant section directly.
   - **ASIL A–D**: don't write the final design — draft 2-3 options with trade-offs
     (timing, resource cost, failure modes) and hand them to a human to decide.
3. For a design decision (QM, or a human-made ASIL choice): append one entry to "Key
   Design Decisions" with today's date, the decision, the rationale, and alternatives
   considered. Never rewrite or delete a past entry — supersede it instead.
4. Trace every architecture element back to the requirement(s) driving it in
   `.ai/memory/traceability.md`.
5. Report a short summary — not the full document.

## Anti-patterns

- Don't break a decision into implementation tasks — hand that to `project-manager`.
- Don't record implementation-level detail (variable names, register addresses) here —
  that belongs in code/comments, not the architecture doc.
