# AI Layer — Reusable Agentic Dev Workflow Template

An ASPICE-aligned, ASIL-D-targeting multi-agent development workflow for this OBC
(On-Board Charger) embedded software project, tuned for **code quality per token spent**.
Works natively with **Claude Code** and **GitHub Copilot (VS Code)**, and stands on its
own for tools that read only `AGENTS.md` (Cursor, Windsurf, etc.).

## What's in here

| Path                                             | Purpose                                                                                                                                         |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `AGENTS.md` / `CLAUDE.md`                        | Always-on project instructions — self-sufficient, so a tool that reads nothing else still gets the non-negotiables                               |
| `.ai/agents/`                                    | **Source of truth** for the subagent roster (one file per agent, tool-neutral)                                                                   |
| `.ai/memory/`                                    | Portable cross-session memory: requirements, architecture, plan, traceability, baselines, problem reports, change requests, repo conventions, log |
| `.ai/safety/asil-manifest.md`                    | The QM-vs-ASIL authorship allowlist — default-deny, hook-protected, human-edited only                                                            |
| `.ai/config/commands.sh`                         | The one place your real build/test/MISRA-check/format commands live; hooks read from it                                                          |
| `.claude/skills/`                                | On-demand multi-step procedures, read by **both** Copilot and Claude Code from this one location                                                 |
| `.claude/agents/` `.github/agents/`              | **Generated** per-tool dialects of `.ai/agents/` — never hand-edit                                                                               |
| `scripts/gen-agents.sh`                          | Emits both dialects from `.ai/agents/`; `--check` fails if they're stale                                                                         |
| `scripts/hooks/*.sh`                             | Shared guardrails: destructive-command blocking, generated-file protection, **ASIL authorship gate**, auto-format, test-before-done, memory injection |
| `.github/prompts/`                               | Slash-command entry points (`/new-feature`, `/new-agent-role`)                                                                                   |
| `.github/instructions/`                          | File-scoped guidance via `applyTo` globs (MISRA C, safety coding, testing)                                                                       |
| `.github/hooks/*.json` / `.claude/settings.json` | Thin per-tool wiring for the same hook scripts, plus Claude's `permissions` block                                                                |

## How it works

1. **The `orchestrator` is the entry point.** Unlike a generic feature-work template, ASPICE
   work has a real dependency chain (SWE.1 → SWE.2 → SWE.3 → SWE.4/5/6) and hard
   independence requirements — a single "whoever's free" session doesn't satisfy that, so
   delegation is centralized rather than ad hoc.
2. The roster mirrors ASPICE process areas, not repo areas:

   | Agent                        | Owns                                          | Tier      |
   | ----------------------------- | ---------------------------------------------- | --------- |
   | `project-manager`              | task sequencing + risk register (MAN.3)        | reasoning |
   | `requirements-engineer`        | software requirements + traceability (SWE.1)   | reasoning |
   | `software-architect`           | architecture + ASIL allocation (SWE.2)         | reasoning |
   | `software-developer`           | unit construction, QM only (SWE.3)             | standard  |
   | `test-engineer`                | unit/integration/qualification test (SWE.4/5/6)| standard  |
   | `quality-assurance`            | read-only process/traceability audit (SUP.1)   | reasoning |
   | `configuration-manager`        | configuration items + baselines (SUP.8)        | standard  |
   | `change-and-problem-manager`   | problem reports + change requests (SUP.9/10)   | standard  |

3. **The ASIL authorship gate is the load-bearing rule.** Anything not explicitly
   allowlisted as `QM` in `.ai/safety/asil-manifest.md` is safety-relevant by default —
   every agent may only read/review it, never author or edit it. A human authors it; AI
   reviews it. See `.claude/skills/safety-governance/SKILL.md`.
4. Agents read and write `.ai/memory/*.md` instead of relying on chat history, so a fresh
   session resumes where the last one stopped.
5. **Deterministic gates carry the quality load.** Build, MISRA static analysis, and test
   commands cost nothing per run and catch more than a reading pass. `quality-assurance`'s
   audit is reserved for what no linter can check — traceability, ASIL-authorship
   compliance, reviewer independence.
6. Hooks enforce what instructions can only request: destructive commands blocked,
   generated files unwritable, non-allowlisted ASIL paths unwritable by any agent, edits
   auto-formatted, work not markable done while gates fail.

## The agent roster is generated

Each agent is authored **once** at `.ai/agents/<name>.md` with tool-neutral frontmatter:

```yaml
---
name: software-developer
description: <keyword-rich, with a "Use when..." clause>
tier: reasoning | standard | fast
tools: read, search, edit, execute, delegate
---
```

`bash scripts/gen-agents.sh` expands that into both tool dialects, which differ only in
frontmatter — Claude wants `tools: Read, Grep, Glob` and a scalar `model:`; Copilot wants
`tools: [read, search]`, an `agents:` field, and an array `model:`. Run `--check` in CI to fail
on stale output. Editing `.claude/agents/` or `.github/agents/` by hand is always a mistake; the
next generator run overwrites it.

## Model routing

Agent sources carry a `tier:` field (`reasoning` / `standard`; `fast` is unused on this
project — nothing in an ASIL-D workflow is low-stakes enough to warrant a cheap tier) which
the generator turns into `# MODEL_TIER:` comments and `model:` placeholders. **Before using
this template, replace every `<REASONING|STANDARD_MODEL...>` placeholder** with real model
identifiers — but edit them in `scripts/gen-agents.sh`, not in the generated files. Grep for
`MODEL_TIER` to find them.

## Skills

| Skill                            | When                                                                              |
| --------------------------------- | ------------------------------------------------------------------------------------ |
| `safety-governance`               | Before authoring/editing/approving anything — the ASIL authorship gate, read by all |
| `project-planning`                | Sequencing requirements/architecture into a tagged task breakdown (MAN.3)            |
| `elicit-requirements`             | Deriving a software requirement from a system/safety requirement (SWE.1)             |
| `maintain-architecture`           | Authoring/updating the architecture doc and ADR-lite decisions (SWE.2)               |
| `implement-task`                  | Executing one QM task from the plan (SWE.3)                                          |
| `verify-and-test`                 | Unit/integration/qualification testing with ASIL-scaled coverage (SWE.4/5/6)         |
| `work-product-audit`              | Traceability + ASIL-authorship + independence audit (SUP.1)                          |
| `configuration-management`        | Baselining once work products are approved (SUP.8)                                   |
| `problem-and-change-management`   | Logging/impact-analyzing Problem Reports and Change Requests (SUP.9/SUP.10)          |
| `update-memory`                   | Writing a durable fact back to `.ai/memory/`                                         |

## Bootstrapping into a new project

```powershell
# From this template's root
./scripts/init.ps1 -TargetPath C:\path\to\your\project
```

```bash
# macOS/Linux
./scripts/init.sh /path/to/your/project
```

The script copies everything except `.git`, `README.md`, and itself, and asks before overwriting
existing files. After copying:

1. **`git init` the target if it isn't a repo yet.** The test gate and the reviewer both work
   from `git diff` — without a repo they degrade to no-ops (loudly, but still no-ops).
2. Fill in `.ai/config/commands.sh` (`AI_LAYER_TEST_CMD`, `AI_LAYER_FORMAT_CMD`,
   `AI_LAYER_MISRA_CHECK_CMD`). This one file un-inerts the format/test/MISRA hooks; a
   leftover `<placeholder>` disables them.
3. Fill in the placeholders in `AGENTS.md` (stack, entry points, conventions).
4. Fill in `.ai/safety/asil-manifest.md`: list every QM (non-safety) path explicitly. Leave
   everything else out — it defaults to safety-relevant (AI review-only) by design.
5. Replace the `MODEL_TIER` model placeholders in `scripts/gen-agents.sh`, then run
   `bash scripts/gen-agents.sh`.
6. **Delete the leftover generic-template files this repo shipped with before the ASPICE
   roster existed** — I can't delete files this session, so do it manually:
   `.ai/agents/{data,implementer,planner,reviewer}.md` (the generator would otherwise
   regenerate agents for them alongside the real roster) and
   `.claude/skills/{plan-feature,review-diff}/` (superseded by `project-planning`,
   `elicit-requirements`, `work-product-audit`, etc.). Re-run the generator afterward.
7. Fill in `.ai/memory/architecture.md`, `requirements.md`, and `repo.md` with your real
   design, requirements, and conventions — put "never hand-edit generated files" and
   "never hand-edit the ASIL manifest" in `repo.md`'s gotchas.
8. Point the `applyTo` globs in `.github/instructions/*.instructions.md` at your real directories.
9. Make sure `bash` is on `PATH` (Git Bash on Windows) — hooks run via `bash scripts/hooks/*.sh`,
   so no `chmod` is needed.
10. Trust the workspace/folder so Copilot and Claude Code will load the agents and run the hooks.

Verify the guardrails actually fire with `bash scripts/hooks/test-hooks.sh`.

## Adding a new subagent role or skill

Use the `/new-agent-role` prompt, or add one file under `.ai/agents/` and run the generator.
If the role needs a repeatable procedure, add `.claude/skills/<short-verb-phrase>/SKILL.md` —
shared by both tools, never duplicated per tool.

Before adding a role, check it against the existing ASPICE process-area mapping — this
roster was deliberately consolidated (SWE.4/5/6 and SUP.9/10 each share one role) to avoid
one agent per process area costing tokens without adding real independence, since the
actual ISO 26262 independence requirement is about the accountable human, not which AI
persona ran a command. Split a role further only if it needs genuinely different tools or
trust boundaries — not just a different process-area label.
