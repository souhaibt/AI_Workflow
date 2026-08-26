#!/usr/bin/env bash
# PostToolUse hook: runs the project's formatter on a file after Edit/Write.
# No-op if AI_LAYER_FORMAT_CMD is unset/placeholder (keeps the template stack-agnostic).
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/../.." && pwd)"
# shellcheck disable=SC1091
source "$project_root/.ai/config/commands.sh" 2>/dev/null || true

if [ -z "${AI_LAYER_FORMAT_CMD:-}" ] || [[ "$AI_LAYER_FORMAT_CMD" == "<"* ]]; then
  exit 0
fi

input="$(cat)"
file_path="$(echo "$input" | jq -r '.tool_input.file_path // empty')"
[ -z "$file_path" ] && exit 0

( cd "$project_root" && eval "$AI_LAYER_FORMAT_CMD" -- "$file_path" ) >/dev/null 2>&1 || true
exit 0
