---
description: "Scaffold a new subagent role: one source file under .ai/agents/, plus a skill stub if the role needs a repeatable procedure."
agent: agent
argument-hint: "<role-name> — <one-line responsibility> — <model tier: reasoning|standard|fast>"
---

Given a role name, one-line responsibility, and model tier, scaffold a new subagent.

**First, push back if the role isn't warranted.** The roster is deliberately consolidated —
SWE.4/5/6 share `test-engineer` and SUP.9/10 share `change-and-problem-manager` — because the
actual ISO 26262 independence requirement is about the accountable *human*, not which AI
persona ran a command. Before creating a new role, check whether the work is better served by:

- a task delegated to an existing role (most ASPICE process areas already have an owner), or
- adding a skill that an existing role invokes.

Say so if either fits, and stop there unless the user confirms they want a distinct role.

If a new role really is right:

1. Pick the **minimal** capability set from `read, search, edit, execute, delegate`. Review-style
   roles get `read, search, execute` — no `edit`. A role that can't write can't cause a
   regression, which is most of why read-only roles are worth having.
2. Create `.ai/agents/<role-name>.md`. This is the only file you author — `.claude/agents/` and
   `.github/agents/` are generated. Frontmatter:

   ```yaml
   ---
   name: <role-name>
   description: <keyword-rich summary with an explicit "Use when..." clause>
   tier: reasoning | standard | fast
   tools: <comma-separated capabilities>
   ---
   ```

   Follow the existing sources for body shape: a short role statement, `## Constraints` as hard
   rules rather than advice, and `## Approach` pointing at a skill instead of restating it.
   Keep it under ~40 lines — it is loaded in full every time the role is invoked.
3. Run `bash scripts/gen-agents.sh` and confirm it reports the new count.
4. If the role needs a repeatable multi-step procedure, add
   `.claude/skills/<short-verb-phrase>/SKILL.md` — shared by both tools, never duplicated per tool.
5. Add a row to the Agents table in `AGENTS.md`. Tools that read nothing else need to know the
   role exists.
6. Report exactly which files were created or changed.
