# Project Agent Instructions

> Stack-agnostic AI Layer template. Replace every `<placeholder>` before use.
> This is the single always-on instructions file — do not add `.github/copilot-instructions.md`.

## Project

- **Stack**: OBC (On-Board Charger) embedded software, AUTOSAR Classic Platform (C, OSEK/ECC OS). Targets ASIL-D under ISO 26262; ASPICE scope SWE.1–SWE.6, SUP.1/8/9/10, MAN.3.
- **Entry points**: `<e.g. src/app, src/bsw, src/rte>`

## Commands

Real commands live in [.ai/config/commands.sh](.ai/config/commands.sh) — the single source
the hooks read. Keep them accurate; a placeholder there silently disables the hook.

- Install: `<command>`
- Build: `<command>`
- Gates (lint + typecheck + tests): `source .ai/config/commands.sh && $AI_LAYER_TEST_CMD`

---

## Rules

These are the non-negotiables. They apply to every agent and every tool, including ones that
read nothing but this file.

### Never touch generated or vendored files

Never **read** them for context and never **edit** them: `*.g.*`, `*.freezed.*`, `*.mocks.*`,
`dist/`, `build/`, `node_modules/`, `.dart_tool/`, lockfiles, snapshots.

They're machine output — often thousands of lines that tell you nothing the source doesn't,
and reading a handful can cost more than the rest of the task combined. To change one, change
its source and re-run codegen. A hook blocks the write; this explains why.

### Search before you read

Grep or glob for the specific symbol, then read that file. Never read a directory to "get
oriented" — context re-acquisition, not writing, is where the budget goes. Don't re-read a
file you've already read this session, and don't re-derive a fact `.ai/memory/repo.md`
already records.

### Tests ship with the code

Same task, same diff. A test that can't fail when the behaviour regresses is worse than no
test — it reads as coverage. Never mark work done with a failing gate; mark it `blocked` with
a reason instead.

### Stay in scope

Implement what was asked. Anything else you notice goes in the plan's `Notes` column, not in
your diff — changes that ride along are the ones nobody reviews.

### Quality is enforced by tooling first

Lint, typecheck, and tests are the primary gate: they cost nothing per run and catch more than
a reading pass. A human-style review pass is for what no linter can check — auth, access
policies, tenancy boundaries, payments, untrusted input. Don't spend one elsewhere.

---

## Memory

Cross-session context is portable markdown in `.ai/memory/`, not chat history.

| File                 | Contents                                                | Written by |
| -------------------- | ---------------------------------------------------------| ---------- |
| `requirements.md`    | Software requirements (SWE.1), ASIL-tagged                | `requirements-engineer` |
| `architecture.md`    | System design (SWE.2) + append-only ADR decisions          | `software-architect` only |
| `plan.md`            | Task breakdown (MAN.3) + risk register                     | `project-manager` writes; task owner updates status |
| `traceability.md`    | Req → design → unit → test trace matrix                    | shared, per-column |
| `baselines.md`       | Configuration items + baseline history (SUP.8)              | `configuration-manager` |
| `problem-reports.md` | Defect log (SUP.9)                                           | `change-and-problem-manager` |
| `change-requests.md` | Change request log + impact analysis (SUP.10)                | `change-and-problem-manager` |
| `repo.md`            | Conventions, coding standard, tooling decisions, gotchas    | anyone, when durable |
| `log.md`             | One line per session, newest first                           | anyone, at end of turn |

Read `repo.md`, `requirements.md`, and `plan.md` before starting; `architecture.md` and
`traceability.md` for anything requirement- or design-adjacent. Update what changed before
finishing. Never author or finalize an ASIL-tagged row/element yourself — see
`.claude/skills/safety-governance/SKILL.md`. Never paste diffs or file contents into
memory; summarize and link.

## Agents

| Agent                        | Owns                                                    | Tier      |
| ---------------------------- | -------------------------------------------------------- | --------- |
| `orchestrator`                | delegates dynamically; enforces the ASIL gate            | reasoning |
| `project-manager`              | task sequencing + risk register (MAN.3)                  | reasoning |
| `requirements-engineer`        | software requirements + traceability (SWE.1)             | reasoning |
| `software-architect`           | architecture + ASIL allocation (SWE.2)                    | reasoning |
| `software-developer`           | unit construction, QM only (SWE.3)                        | standard  |
| `test-engineer`                | unit/integration/qualification test (SWE.4/5/6)           | standard  |
| `quality-assurance`            | read-only process/traceability audit (SUP.1)              | reasoning |
| `configuration-manager`        | configuration items + baselines (SUP.8)                   | standard  |
| `change-and-problem-manager`   | problem reports + change requests (SUP.9/SUP.10)          | standard  |

This project targets **ASIL-D** under ASPICE. The non-negotiable on top of everything
else in this file: any requirement, architecture element, unit, or test not explicitly
allowlisted as `QM` in `.ai/safety/asil-manifest.md` is safety-relevant by default — every
agent may only read/review it, never author or edit it. See
`.claude/skills/safety-governance/SKILL.md`. This is enforced by instructions everywhere,
and by a hard-deny hook (`block-unauthorized-asil-edit.sh`) for source-code paths and for
the manifest itself.

Roster source of truth is `.ai/agents/*.md`. Run `bash scripts/gen-agents.sh` after editing;
it emits `.claude/agents/` and `.github/agents/`, which are **generated — never hand-edit**.

Reusable procedures live in `.claude/skills/*/SKILL.md`, shared by Copilot and Claude Code.

## Conventions

`<Project-specific conventions that differ from common practice. Keep this short — only what
a linter can't already enforce.>`
