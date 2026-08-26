#!/usr/bin/env bash
# PreToolUse hook: denies obviously destructive shell commands.
# Contract: reads hook JSON on stdin; on a match, prints a deny decision and exits 2.
set -euo pipefail

input="$(cat)"
command="$(echo "$input" | jq -r '.tool_input.command // empty')"

if [ -z "$command" ]; then
  exit 0
fi

if echo "$command" | grep -qiE '\brm\s+-rf\b|\bgit\s+push\b.*--force\b|\bgit\s+reset\s+--hard\b'; then
  reason="Destructive command blocked by guardrail hook: $command"
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
