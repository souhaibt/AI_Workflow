# AI Layer — Reusable Agentic Dev Workflow Template

A stack-agnostic set of files that gives a project a multi-agent, multi-model development
workflow, tuned for **code quality per token spent**. Works natively with **Claude Code** and
**GitHub Copilot (VS Code)**, and stands on its own for tools that read only `AGENTS.md`
(Cursor, Windsurf, etc.).

## What's in here

| Path                                             | Purpose                                                                                                                                         |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `AGENTS.md` / `CLAUDE.md`                        | Always-on project instructions — self-sufficient, so a tool that reads nothing else still gets the non-negotiables                               |
| `.ai/agents/`                                    | **Source of truth** for the subagent roster (one file per agent, tool-neutral)                                                                   |
| `.ai/memory/`                                    | Portable cross-session memory: `architecture.md` (design + ADR log), `repo.md` (conventions, gotchas), `plan.md` (current tasks), `log.md`       |
| `.ai/config/commands.sh`                         | The one place your real lint/typecheck/test/format commands live; hooks read from it                                                             |
| `.claude/skills/`                                | On-demand multi-step procedures, read by **both** Copilot and Claude Code from this one location                                                 |
| `.claude/agents/` `.github/agents/`              | **Generated** per-tool dialects of `.ai/agents/` — never hand-edit                                                                               |
| `scripts/gen-agents.sh`                          | Emits both dialects from `.ai/agents/`; `--check` fails if they're stale                                                                         |
| `scripts/hooks/*.sh`                             | Shared guardrails: destructive-command blocking, generated-file protection, auto-format, test-before-done, memory injection                      |
| `.github/prompts/`                               | Slash-command entry points (`/new-feature`, `/new-agent-role`)                                                                                   |
| `.github/instructions/`                          | File-scoped guidance via `applyTo` globs                                                                                                         |
| `.github/hooks/*.json` / `.claude/settings.json` | Thin per-tool wiring for the same hook scripts, plus Claude's `permissions` block                                                                |

## How it works

1. **You drive the main session directly — there is no orchestrator agent.** A coordinator that
   can't read code is just one more cold context between you and the work.
2. When a task genuinely belongs to someone else, you delegate to one of four roles:

   | Agent         | Owns                                          | Tier      |
   | ------------- | --------------------------------------------- | --------- |
   | `planner`     | design decisions + task breakdown             | reasoning |
   | `implementer` | application code + its tests                  | standard  |
   | `data`        | schema, migrations, access policies           | reasoning |
   | `reviewer`    | read-only diff review, including security     | reasoning |

   `implementer` is meant to be **cloned per repo area** (`app/`, `api/`, …) — that's the
   extension point, and it's why the roster is small.
3. **Split work by repo area, not tech layer.** One vertical slice (schema + logic + UI + tests)
   owned by one agent beats four layer-shaped tasks: every extra owner is a cold context that
   re-pays the cost of discovering the codebase. Context re-acquisition, not generation, is where
   the token budget actually goes.
4. Agents read and write `.ai/memory/*.md` instead of relying on chat history, so a fresh session
   resumes where the last one stopped.
5. **Deterministic gates carry the quality load.** Linters, typecheckers, and tests cost nothing
   per run and catch more than a reading pass. An LLM review pass is reserved for what no linter
   can check — auth, access policies, tenancy boundaries, payments, untrusted input.
6. Hooks enforce what instructions can only request: destructive commands blocked, generated
   files unwritable, edits auto-formatted, work not markable done while gates fail.

## The agent roster is generated

Each agent is authored **once** at `.ai/agents/<name>.md` with tool-neutral frontmatter:

```yaml
---
name: implementer
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

Agent sources carry a `tier:` field (`reasoning` / `standard` / `fast`) which the generator turns
into `# MODEL_TIER:` comments and `model:` placeholders. **Before using this template, replace
every `<REASONING|STANDARD|FAST_MODEL...>` placeholder** with real model identifiers — but edit
them in `scripts/gen-agents.sh`, not in the generated files. Grep for `MODEL_TIER` to find them.

## Skills

| Skill            | When                                                                 |
| ---------------- | -------------------------------------------------------------------- |
| `plan-feature`   | Turning a request into a task plan; recording an architecture decision |
| `implement-task` | Executing one task from the plan through the gates                    |
| `review-diff`    | Reviewing a diff — including whether the review is worth running      |
| `update-memory`  | Writing a durable fact back to `.ai/memory/`                          |

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
2. Fill in `.ai/config/commands.sh` (`AI_LAYER_TEST_CMD`, `AI_LAYER_FORMAT_CMD`). This one file
   un-inerts the format and test hooks; a leftover `<placeholder>` disables them.
3. Fill in the placeholders in `AGENTS.md` (stack, entry points, conventions).
4. Replace the `MODEL_TIER` model placeholders in `scripts/gen-agents.sh`, then run
   `bash scripts/gen-agents.sh`.
5. Clone `.ai/agents/implementer.md` once per repo area, fill in each `## Scope`, and regenerate.
6. Fill in `.ai/memory/architecture.md` and `.ai/memory/repo.md` with your real design and
   conventions — put "never hand-edit these generated files" in `repo.md`'s gotchas.
7. Point the `applyTo` globs in `.github/instructions/*.instructions.md` at your real directories.
8. Make sure `bash` is on `PATH` (Git Bash on Windows) — hooks run via `bash scripts/hooks/*.sh`,
   so no `chmod` is needed.
9. Trust the workspace/folder so Copilot and Claude Code will load the agents and run the hooks.

Verify the guardrails actually fire with `bash scripts/hooks/test-hooks.sh`.

## Adding a new subagent role or skill

Use the `/new-agent-role` prompt, or add one file under `.ai/agents/` and run the generator.
If the role needs a repeatable procedure, add `.claude/skills/<short-verb-phrase>/SKILL.md` —
shared by both tools, never duplicated per tool.

Before adding a role, check that it isn't better served by cloning `implementer` with a
different `## Scope`. Roles are cheap to write and expensive to run.
