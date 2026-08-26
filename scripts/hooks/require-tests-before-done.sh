#!/usr/bin/env bash
# Stop hook: if the working tree has uncommitted changes (code was touched this session),
# require the project's gates to pass before the agent is allowed to stop.
#
# No-op on a clean tree. When the gate can't run at all — no test command configured, or not
# a git repo — say so on stderr rather than exiting silently: a guardrail that is quietly
# inert is worse than no guardrail, because it is trusted.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/../.." && pwd)"
# shellcheck disable=SC1091
source "$project_root/.ai/config/commands.sh" 2>/dev/null || true

cd "$project_root"

if [ -z "${AI_LAYER_TEST_CMD:-}" ] || [[ "$AI_LAYER_TEST_CMD" == "<"* ]]; then
  echo "require-tests-before-done: AI_LAYER_TEST_CMD is unset or still a placeholder in .ai/config/commands.sh — the test gate is DISABLED." >&2
  exit 0
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "require-tests-before-done: not a git repository — cannot detect changes, so the test gate is DISABLED. Run 'git init' to enable it." >&2
  exit 0
fi

dirty="$(git status --porcelain -- . ':(exclude).ai/memory/**' 2>/dev/null || true)"
if [ -z "$dirty" ]; then
  exit 0
fi

if ! output="$(eval "$AI_LAYER_TEST_CMD" 2>&1)"; then
  tail_output="$(printf '%s' "$output" | tail -c 4000)"
  reason="Gates are failing; fix them before finishing (or set the task to 'blocked' in .ai/memory/plan.md with a reason). Output:
$tail_output"
  jq -n --arg reason "$reason" '{decision: "block", reason: $reason}'
  exit 2
fi

exit 0
