# Project Agent Instructions

> Stack-agnostic AI Layer template. Replace every `<placeholder>` before use.
> This is the single always-on instructions file — do not add `.github/copilot-instructions.md`.

## Project

- **Stack**: `<e.g. TypeScript/React web, Node/Express API, Postgres>`
- **Entry points**: `<e.g. apps/web, apps/api>`

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

| File              | Contents                                    | Written by                             |
| ----------------- | ------------------------------------------- | -------------------------------------- |
| `repo.md`         | Conventions, tooling decisions, gotchas     | anyone, when durable                   |
| `plan.md`         | Current acceptance criteria + task table    | `planner`; others update status only   |
| `architecture.md` | System design + append-only ADR decisions   | `planner` only                         |
| `log.md`          | One line per session, newest first          | anyone, at end of turn                 |

Read `repo.md` and `plan.md` before starting; `architecture.md` only for structural work.
Update what changed before finishing. Keep entries short — every future agent pays to read
them. Never paste diffs or file contents into memory; summarize and link.

## Agents

| Agent         | Owns                                            | Tier      |
| ------------- | ----------------------------------------------- | --------- |
| `planner`     | design decisions + task breakdown               | reasoning |
| `implementer` | application code + its tests (clone per area)   | standard  |
| `data`        | schema, migrations, access policies             | reasoning |
| `reviewer`    | read-only diff review incl. security            | reasoning |

Talk to them directly — there is no orchestrator layer. Split work by **repo area, not tech
layer**: prefer one vertical slice (schema + logic + UI + tests) over one task per layer.
Every extra owner is another cold context that re-pays discovery cost.

Roster source of truth is `.ai/agents/*.md`. Run `bash scripts/gen-agents.sh` after editing;
it emits `.claude/agents/` and `.github/agents/`, which are **generated — never hand-edit**.

Reusable procedures live in `.claude/skills/*/SKILL.md`, shared by Copilot and Claude Code.

## Conventions

`<Project-specific conventions that differ from common practice. Keep this short — only what
a linter can't already enforce.>`
