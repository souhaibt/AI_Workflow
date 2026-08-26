#!/usr/bin/env bash
# Bootstraps the AI Layer workflow template into an existing project.
# Usage: ./init.sh /path/to/target/project
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <target-project-path>" >&2
  exit 1
fi

TARGET_PATH="$1"
if [ ! -d "$TARGET_PATH" ]; then
  echo "Target path '$TARGET_PATH' does not exist." >&2
  exit 1
fi
TARGET_PATH="$(cd "$TARGET_PATH" && pwd)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Paths (relative to source root) that stay in the template and are never copied.
EXCLUDED_PATHS=(".git" "README.md" "scripts/init.ps1" "scripts/init.sh")

is_excluded() {
  local rel="$1"
  for excluded in "${EXCLUDED_PATHS[@]}"; do
    if [ "$rel" = "$excluded" ] || [[ "$rel" == "$excluded/"* ]]; then
      return 0
    fi
  done
  return 1
}

copied=0
skipped=0

while IFS= read -r -d '' file; do
  rel="${file#"$SOURCE_ROOT"/}"
  if is_excluded "$rel"; then
    continue
  fi

  dest="$TARGET_PATH/$rel"
  mkdir -p "$(dirname "$dest")"

  if [ -e "$dest" ]; then
    read -r -p "File exists: $rel - overwrite? (y/N) " answer
    if [ "$answer" != "y" ]; then
      skipped=$((skipped + 1))
      continue
    fi
  fi

  cp "$file" "$dest"
  echo "Copied $rel"
  copied=$((copied + 1))
done < <(find "$SOURCE_ROOT" -type f -print0)

echo ""
echo "AI Layer template installed into $TARGET_PATH ($copied copied, $skipped skipped)"
echo "Next steps:"
echo "  1. git init the target if it isn't a repo — the test gate and reviewer need 'git diff'."
echo "  2. Fill in .ai/config/commands.sh (AI_LAYER_TEST_CMD, AI_LAYER_FORMAT_CMD); placeholders leave the hooks inert."
echo "  3. Fill in placeholders in AGENTS.md (stack, entry points, conventions)."
echo "  4. Set the real model IDs at the top of scripts/gen-agents.sh, then run: bash scripts/gen-agents.sh"
echo "  5. Clone .ai/agents/implementer.md per repo area, fill each ## Scope, and regenerate."
echo "  6. Fill in .ai/memory/architecture.md and .ai/memory/repo.md."
echo "  7. Point the applyTo globs in .github/instructions/* at your real directories."
echo "  8. Make sure bash is on PATH so hooks can run, then verify: bash scripts/hooks/test-hooks.sh"
echo "  9. Trust the workspace so agents/skills/hooks are loaded."
