# Sourced by scripts/hooks/*.sh. Fill these in with your project's real commands.
# Leave a value empty to make the corresponding hook a no-op.
#
# AI_LAYER_TEST_CMD is the full gate: lint + typecheck + tests. It runs on Stop when the tree
# is dirty, and agents run it before marking a task done. Chain everything you want enforced —
# whatever isn't here isn't enforced.
export AI_LAYER_TEST_CMD="<e.g. npm run lint && npx tsc --noEmit && npm test -- --silent>"

# Runs on every Edit/Write, with the changed file path appended.
export AI_LAYER_FORMAT_CMD="<e.g. npx prettier --write>"

# Optional. Extended regex matched against project-relative paths to decide what counts as a
# generated file (blocked from edits by block-generated-file-edit.sh). Leave unset to use the
# built-in default, which already covers *.g.*, *.freezed.*, *.mocks.*, dist/, build/,
# node_modules/, and common lockfiles. Set it to extend or narrow that for your stack.
# export AI_LAYER_GENERATED_RE='\.(g|freezed)\.[a-z]+$|(^|/)build/'
