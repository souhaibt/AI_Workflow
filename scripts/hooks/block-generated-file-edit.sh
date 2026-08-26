#!/usr/bin/env bash
# PreToolUse hook: denies edits to generated files.
#
# Generated code must be regenerated, not hand-edited — an edit is silently reverted by the
# next codegen run, and the diff is unreviewable noise. Contract: reads hook JSON on stdin;
# on a match prints a deny decision and exits 2.
#
# Patterns are deliberately broad and language-agnostic. Narrow or extend AI_LAYER_GENERATED_RE
# in .ai/config/commands.sh for your stack.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/../.." && pwd)"
# shellcheck disable=SC1091
source "$project_root/.ai/config/commands.sh" 2>/dev/null || true

# Default pattern set. Anything matching is machine output, not source.
default_re='\.(g|freezed|mocks|pb|generated)\.[a-z]+$|\.min\.(js|css)$|(^|/)(dist|build|node_modules|\.dart_tool|__generated__|vendor)/|(^|/)(package-lock\.json|yarn\.lock|pnpm-lock\.yaml|pubspec\.lock|Cargo\.lock|poetry\.lock|go\.sum)$'
generated_re="${AI_LAYER_GENERATED_RE:-$default_re}"

input="$(cat)"
file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"
[ -z "$file_path" ] && exit 0

# Compare on a normalized, project-relative, forward-slash path.
rel="${file_path//\\//}"
root_fwd="${project_root//\\//}"
rel="${rel#"$root_fwd"/}"

if printf '%s' "$rel" | grep -qE "$generated_re"; then
  reason="Blocked: '$rel' is a generated file. Edit the source it is generated from and re-run the project's codegen command instead — a hand-edit here is overwritten by the next build. (Override by adjusting AI_LAYER_GENERATED_RE in .ai/config/commands.sh.)"
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
fi

exit 0
