---
name: project-planning
description: 'Turn software requirements and architecture into a sequenced, ASPICE-tagged task breakdown and risk register in .ai/memory/plan.md (MAN.3). Use when starting new work that needs sequencing, or when the orchestrator needs tasks broken down before delegating.'
---

# Project Planning (MAN.3)

## Procedure
1. Read `.ai/memory/requirements.md` and `.ai/memory/architecture.md` — don't invent
   scope; if something needed isn't covered there, hand it back to the orchestrator to
   consult `requirements-engineer`/`software-architect` first.
2. Break the work into small, independently verifiable tasks. Each task:
   - Maps to exactly one ASPICE activity (SWE.1–SWE.6) and one owner subagent.
   - Carries the ASIL of what it touches (from `requirements.md`/`architecture.md`) —
     this is what routes it to a human-authored vs. AI-authored path per
     `.claude/skills/safety-governance/SKILL.md`.
   - Is sequenced correctly: SWE.1 before SWE.2 before SWE.3 before SWE.4/5/6 for the
     same scope, since each depends on its predecessor's work product.
3. Add or update Risk Register entries for anything newly identified as a project risk
   (schedule, resource, technical).
4. Write the result to `.ai/memory/plan.md` via `.claude/skills/update-memory/SKILL.md`.
5. Report a one-paragraph summary — not the full table.

## Anti-patterns
- Don't create a single monolithic task — that defeats delegation and traceability.
- Don't assign a task to a subagent whose tools/remit don't cover it (e.g. don't give a
  test-authoring task on an ASIL C item to `test-engineer` — that's human work; give
  `test-engineer` the harness/execution task instead).
