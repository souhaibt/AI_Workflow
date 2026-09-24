---
description: "Kick off a new requirement, feature, or bug fix via the orchestrator. Provide a description and acceptance criteria."
agent: orchestrator
argument-hint: "<description> — <acceptance criteria>"
---

A new requirement/feature/bug-fix request follows this prompt. Before doing anything else:

1. Read `.ai/memory/repo.md`, `.ai/memory/architecture.md`, `.ai/memory/requirements.md`,
   and `.ai/memory/plan.md`.
2. If the request needs a requirement not yet in `requirements.md`, delegate to
   `requirements-engineer` first; if it needs a design decision not in `architecture.md`,
   delegate to `software-architect`.
3. If no active plan covers this request, delegate to `project-manager` to sequence it.
4. Delegate each task to the specialist that owns it, and don't declare anything done until
   `quality-assurance` has signed off and — for anything ASIL-tagged — a human has
   authored/approved it. See `.claude/skills/safety-governance/SKILL.md`.
