# Software Architecture (SWE.2)

> Owner: `software-architect`. Living design document for the OBC software. ASIL-tagged
> elements (safety mechanisms, partitioning) are human-authored — AI may only propose or
> review them, never finalize. See `.claude/skills/safety-governance/SKILL.md`.
> `.ai/memory/repo.md` only links here; don't duplicate content between the two.

## System Overview

`<One paragraph: what the OBC software is, its major runtime pieces (AUTOSAR SWCs/BSW
modules), and how a charging session flows through them end to end.>`

## Static Architecture (Components & Interfaces)

`<Component/SWC — responsibility — ASIL — interfaces (AUTOSAR ports, signals).>`

## Dynamic Behavior

`<Task/runnable scheduling, key sequences (mermaid sequenceDiagram optional), timing
constraints.>`

## Resource Consumption Objectives

`<CPU load budget, RAM/ROM budget, stack usage targets — per SWE.2 base practice
BP5.>`

## Safety Mechanisms & ASIL Allocation

`<Redundancy, monitoring/diagnostics, ASIL decomposition per ISO 26262-9, and the
freedom-from-interference argument between ASIL D and QM/lower-ASIL partitions. This
section is safety-relevant by default — AI reviews, a human authors.>`

## Data Flow

`<How data/signals move between components. A diagram is optional:>`

```mermaid
flowchart LR
    Client --> API
    API --> DB[(Database)]
```

`<Replace with the OBC's real signal/data flow (e.g. CAN/charging-protocol frames, ADC
sampling, control-loop signals).>`

## Key Design Decisions (ADR-lite)

> Reverse-chronological. Never edit or delete a past entry — if a decision changes, add a
> new entry that supersedes it and say what it replaces.

- `<YYYY-MM-DD>` — `<decision>` — why: `<rationale>`; alternatives considered: `<...>`

## Open Questions

`<Architecture-level questions not yet resolved.>`
