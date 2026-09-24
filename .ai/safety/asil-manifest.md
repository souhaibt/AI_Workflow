# ASIL Authorship Manifest

> Default posture: **deny**. Any source/design/test path not explicitly listed under
> "QM — AI-authorable" below is treated as safety-relevant: subagents may read and review
> it but never author or edit it directly (see
> `.claude/skills/safety-governance/SKILL.md`). The `block-unauthorized-asil-edit.sh` hook
> enforces this for source-code paths; treat this file as the single source of truth for
> both the hook and human reviewers.
>
> Owner: `configuration-manager` (SUP.8). Changes to this file require human approval —
> record who approved each change in the log below. No subagent may edit this file itself.

## QM — AI-authorable (safe for AI to author/edit directly)

`<glob or path> — <one-line justification, e.g. "build scripts, no runtime safety impact">`

## ASIL A–D — safety-relevant (human-authored; AI may only read/review)

`<glob or path> — <ASIL> — <owning requirement/component>`

## Manifest change log

`<date> — <what changed> — approved by: <human name>`
