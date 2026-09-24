---
name: safety-governance
description: "Defines the ASIL authorship/review gate this AI Layer enforces for a functional-safety (ISO 26262) project. Use before authoring, editing, or approving any requirement, architecture element, design, code unit, or test, and before marking any work product baselined."
---

# Safety Governance (ISO 26262 / ASPICE)

This project targets **ASIL-D**. This AI Layer is not a qualified tool under ISO 26262-8
clause 11 for authoring safety-relevant work products. It assists with QM (non-safety)
work directly, and with _reviewing_ safety-relevant work — it never authors a
safety-relevant work product itself. This skill is the canonical rule every subagent
follows; don't reinvent it per-role.

## The rule

- Before touching any requirement, architecture element, design, source file, or test,
  check `.ai/safety/asil-manifest.md`.
- **QM (explicitly listed in the manifest's allowlist)**: author/edit normally.
- **ASIL A–D (everything else, by default — fail-safe)**: you may READ, ANALYZE, and
  REVIEW only. Never draft, author, or edit the artifact yourself, regardless of which
  role invoked you — this includes "just a draft": don't write ASIL requirement text,
  design text, code, or test cases even as a starting point. A guardrail hook
  (`block-unauthorized-asil-edit.sh`) backs this up for source-code paths and for
  `.ai/safety/` itself; the instruction-level rule applies everywhere else (requirements
  text, architecture doc, work-product markdown), since row-level gating inside a shared
  markdown table isn't something a hook can enforce.
- If a task requires creating or changing an ASIL-tagged artifact, don't do it. Report
  back to the orchestrator that it needs a human author, with a specific, actionable
  description (e.g. "SW requirement REQ-042 needs an ASIL C acceptance criterion for
  over-current shutoff — needs a human safety engineer").
- Never set or change a `Status: approved`/`baselined` field or an `Approved-by:` field
  yourself, on any work product, safety-relevant or not — that transition is human-only.

## Independence (ISO 26262-6, Table 1)

For ASIL C/D work, the same human must not be recorded as both `Author` and
`Reviewer`/`Approver` on a work product. When you review or verify an ASIL-tagged item,
check that the `Author` and `Reviewer` fields name different people — if they match or
either is empty, raise it as a finding rather than approving.

## What you CAN do on ASIL-tagged items

- Check requirement/design/code/test wording for ambiguity, missing acceptance criteria,
  or inconsistency with `.ai/memory/architecture.md` / `.ai/memory/traceability.md`.
- Run static analysis / MISRA checks and report violations (read-only tool use).
- Flag missing or broken traceability links.
- Recommend approval and name exactly what a human reviewer should check — never mark the
  item reviewed/approved/baselined yourself.

## Updating the manifest

`.ai/safety/asil-manifest.md` is hook-protected against every subagent, unconditionally —
it's the trust root the whole gate depends on. If it needs to change, tell the user
exactly what entry to add/remove and why; a human edits it directly.

## Disclaimer

This gate is a best-effort engineering guardrail, not a certification. Real ASPICE
conformance and ISO 26262 compliance require a qualified functional safety assessor,
organizational process ownership, and (if this tool is ever used beyond review support) a
documented tool confidence level analysis per ISO 26262-8 clause 11.
