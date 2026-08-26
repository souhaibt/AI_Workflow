#!/usr/bin/env bash
# Smoke tests for the guardrail hooks. Run: bash scripts/hooks/test-hooks.sh
#
# Each hook's contract: read hook JSON on stdin, exit 0 to allow, exit 2 to deny.
# Note this file exists rather than running the cases inline: block-dangerous-commands.sh
# greps the raw command text, so a command that merely *mentions* a destructive pattern is
# blocked too. Keeping the payloads in a file keeps them off the command line.
set -uo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

pass=0; fail=0
check() { # check <label> <expected_exit> <actual_exit>
  if [ "$2" = "$3" ]; then
    echo "PASS  $1"; pass=$((pass + 1))
  else
    echo "FAIL  $1 (expected exit $2, got $3)"; fail=$((fail + 1))
  fi
}
run_hook() { printf '%s' "$2" | bash "scripts/hooks/$1" >/dev/null 2>&1; echo $?; }
payload() { printf '{"tool_input":{"%s":"%s"}}' "$1" "$2"; }

echo "--- block-generated-file-edit: denies generated output ---"
for f in \
  "app/lib/x.g.dart" \
  "app/lib/x.freezed.dart" \
  "app/test/x.mocks.dart" \
  "api/dist/bundle.js" \
  "web/assets/app.min.js" \
  "package-lock.json" \
  "pubspec.lock" \
  "node_modules/foo/index.js"
do
  check "deny $f" 2 "$(run_hook block-generated-file-edit.sh "$(payload file_path "$f")")"
done

echo "--- block-generated-file-edit: allows real source ---"
for f in \
  "app/lib/x.dart" \
  "app/lib/widgets/diary_card.dart" \
  "api/src/server.ts" \
  "supabase/migrations/0001_init.sql" \
  ".ai/memory/plan.md"
do
  check "allow $f" 0 "$(run_hook block-generated-file-edit.sh "$(payload file_path "$f")")"
done

echo "--- block-generated-file-edit: path normalization ---"
abs_win='d:\\Sandbox\\AI_Workflow\\app\\lib\\x.g.dart'
check "deny windows-absolute path" 2 "$(run_hook block-generated-file-edit.sh "$(payload file_path "$abs_win")")"
check "no file_path is a no-op" 0 "$(run_hook block-generated-file-edit.sh '{"tool_input":{}}')"

echo "--- block-dangerous-commands: regression ---"
destructive="rm -${_r:-r}f /tmp/nonexistent-test-path"
check "deny recursive force delete" 2 "$(run_hook block-dangerous-commands.sh "$(payload command "$destructive")")"
check "deny force push" 2 "$(run_hook block-dangerous-commands.sh "$(payload command 'git push origin main --force')")"
check "allow ls" 0 "$(run_hook block-dangerous-commands.sh "$(payload command 'ls -la')")"

echo "--- inject-repo-memory ---"
out="$(bash scripts/hooks/inject-repo-memory.sh 2>/dev/null)"
if printf '%s' "$out" | grep -q "Repo Memory"; then check "injects repo.md" 0 0; else check "injects repo.md" 0 1; fi
if printf '%s' "$out" | grep -q "Current plan"; then check "excludes volatile plan.md" 0 1; else check "excludes volatile plan.md" 0 0; fi

echo "--- require-tests-before-done: never silently inert ---"
# Two legitimate states. Unconfigured (template): the gate can't run, so it must SAY so — a
# guardrail that no-ops quietly is worse than none, because it's trusted. Configured (real
# project): it runs the gate for real, and exit 0 means the gate passed.
# shellcheck disable=SC1091
source .ai/config/commands.sh 2>/dev/null || true
warn="$(bash scripts/hooks/require-tests-before-done.sh 2>&1 >/dev/null)"; rc=$?

if [ -z "${AI_LAYER_TEST_CMD:-}" ] || [[ "${AI_LAYER_TEST_CMD:-}" == "<"* ]]; then
  check "exits 0 when gate cannot run" 0 "$rc"
  if printf '%s' "$warn" | grep -q "DISABLED"; then
    check "warns that the gate is disabled" 0 0
    echo "      -> $warn"
  else
    check "warns that the gate is disabled" 0 1
  fi
else
  echo "      gate is configured (AI_LAYER_TEST_CMD set) — it ran for real"
  check "configured gate runs and passes" 0 "$rc"
  [ -n "$warn" ] && echo "      -> $warn"
fi

echo "--- require-tests-before-done: enforcement logic (sandboxed) ---"
# The branch that matters can't be exercised in-place: the hook sources .ai/config/commands.sh,
# which overrides whatever the environment sets, so a failing gate can't be simulated without
# editing that file. Build a throwaway repo instead — deterministic in both the template and a
# configured project.
sandbox="$(mktemp -d)"
mkdir -p "$sandbox/scripts/hooks" "$sandbox/.ai/config"
cp scripts/hooks/require-tests-before-done.sh "$sandbox/scripts/hooks/"
git -C "$sandbox" -c init.defaultBranch=main init -q
# The scaffolding is itself untracked, which would make the tree permanently dirty and the
# clean-tree case unreachable. Exclude it so src.txt is the only thing that moves the needle.
printf 'scripts/\n.ai/\n' > "$sandbox/.git/info/exclude"

# Sets $hook_rc and $hook_out. Deliberately not a command substitution: an EXIT trap or a
# variable assignment inside one is confined to the subshell, and both bit me here.
sandbox_hook() { # sandbox_hook <test-cmd>
  printf 'export AI_LAYER_TEST_CMD="%s"\n' "$1" > "$sandbox/.ai/config/commands.sh"
  hook_out="$(cd "$sandbox" && bash scripts/hooks/require-tests-before-done.sh 2>/dev/null)"
  hook_rc=$?
}

printf 'touched\n' > "$sandbox/src.txt"   # dirty tree: code was touched this session
sandbox_hook 'true'
check "dirty tree + passing gate allows stop" 0 "$hook_rc"

sandbox_hook 'echo boom; exit 1'
check "dirty tree + failing gate blocks stop" 2 "$hook_rc"
printf '%s' "$hook_out" | jq -e '.decision == "block" and (.reason | test("boom"))' >/dev/null 2>&1
check "block payload carries decision + gate output" 0 $?

rm -f "$sandbox/src.txt"                  # clean tree: nothing to gate
sandbox_hook 'exit 1'
check "clean tree is a no-op even when gates fail" 0 "$hook_rc"

rm -rf "$sandbox"

echo
echo "=== $pass passed, $fail failed ==="
[ "$fail" -eq 0 ]
