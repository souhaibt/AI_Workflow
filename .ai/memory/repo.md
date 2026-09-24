# Repo Memory — Conventions & Process Notes

> Injected into every session. Everything here is paid for on every turn, so keep it short and
> durable: facts an agent would otherwise rediscover by reading code. Link out, never paste.
> Updated by anyone via the `update-memory` skill when a fact proves durable.

## Architecture

See [architecture.md](architecture.md) (SWE.2) for system design and decision history —
owned by `software-architect`. Only note here what doesn't belong there.

## Requirements & Traceability

See [requirements.md](requirements.md) (SWE.1) and [traceability.md](traceability.md).

## Key Conventions

`<Naming, folder structure, error-handling patterns — anything a linter can't enforce.>`

## Coding Standard

`<e.g. MISRA C:2012 + project deviation process — see
.github/instructions/misra-c.instructions.md.>`

## Safety Manual / Standards References

`<Pointer to your organization's safety manual, the ISO 26262:2018 edition in use, the
ASPICE process reference model version (VDA Scope) targeted, and where the real
HARA/FSC/TSC live if produced outside this repo.>`

## Process & Tooling Decisions

`<Dated bullets: tooling/process choices. Architecture-level decisions go in architecture.md's
"Key Design Decisions" instead. Full session history is in .ai/memory/log.md.>`

## Known Gotchas

`<Things that have bitten agents before: flaky tests, non-obvious build steps, surprising
coupling. Record the codegen command here if the project has one, so nobody hand-edits its
output.>`
