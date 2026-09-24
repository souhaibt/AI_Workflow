#!/usr/bin/env bash
# PreToolUse hook: default-deny edits to safety-relevant paths.
# Any Edit/Write target not explicitly QM-allowlisted in .ai/safety/asil-manifest.md is
# denied — ASIL-tagged artifacts must be authored by a human directly in the editor.
# .ai/safety/** (the manifest itself) is always denied, unconditionally, for every agent.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/../.." && pwd)"
manifest="$project_root/.ai/safety/asil-manifest.md"

input="$(cat)"
# Copilot PreToolUse: tool_input.file_path / .filePath. Claude Code PreToolUse: tool_input.file_path.
file_path="$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.filePath // .tool_input.TargetFile // empty')"

# Not a file-editing tool call (or no file_path field) — nothing for this hook to gate.
[ -z "$file_path" ] && exit 0

rel_path="${file_path#"$project_root"/}"

deny() {
  local reason="$1"
  jq -n --arg reason "$reason" '{
    decision: "block",
    reason: $reason,
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 2
}

# The manifest is the trust root: no agent may edit it, ever, regardless of its own content.
case "$rel_path" in
  .ai/safety/*)
    deny "'$rel_path' is the ASIL authorship manifest (or lives under .ai/safety/) — it can only be edited by a human directly, never by an agent."
    ;;
esac

# Other memory/config work products are governed by instructions (safety-governance skill),
# not this hook — row-level ASIL tags inside a shared markdown file aren't hook-gateable.
case "$rel_path" in
  .ai/memory/*|.ai/config/*|*.md)
    exit 0
    ;;
esac

[ -f "$manifest" ] || exit 0

is_allowlisted() {
  # Only consider lines in the "QM — AI-authorable" section (before the ASIL A-D heading).
  awk '/^## QM/{f=1} /^## ASIL/{f=0} f' "$manifest" | grep -oE '`[^`]+`' | tr -d '`' | while read -r glob; do
    case "$rel_path" in
      $glob) echo match ;;
    esac
  done | grep -q match
}

if is_allowlisted; then
  exit 0
fi

deny "'$rel_path' is not in the QM allowlist in .ai/safety/asil-manifest.md — treated as safety-relevant by default. A human must make this edit directly; ask configuration-manager's human owner to add a QM entry if this path is genuinely non-safety-relevant."
