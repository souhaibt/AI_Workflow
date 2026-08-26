#!/usr/bin/env bash
# SessionStart hook: injects curated repo memory as context, so agents don't re-derive
# conventions every session.
#
# Deliberately injects repo.md ONLY. plan.md is volatile — it changes on every task status
# update, which churns the cacheable session prefix for a file that is small and cheap for an
# agent to read on demand. Stable content here; volatile content read as needed.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/../.." && pwd)"

repo_md="$project_root/.ai/memory/repo.md"

if [ ! -f "$repo_md" ]; then
  exit 0
fi

jq -n --arg ctx "$(cat "$repo_md")" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
exit 0
