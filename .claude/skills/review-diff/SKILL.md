---
name: review-diff
description: "Structured read-only review of the current diff before a task or feature is marked done. Use on changes touching auth, access policies, tenancy, payments, or untrusted input — routine diffs are covered by the automated gates instead."
---

# Review Diff

## First: should this review run at all?

The automated gates already ran. Lint, typecheck, tests, and policy tests catch mechanical
defects at no token cost and catch more of them than a reading pass will. Spending a reasoning
model on a diff they already cleared buys very little.

Run a full review when the diff touches any of:

- authentication, authorization, or access policies
- a tenancy boundary — anything filtered by an owner/household/org id
- payments, subscriptions, or entitlement checks
- untrusted input, secrets, or personal data
- something `architecture.md` records a decision about

Otherwise: say "gates cover this — no review needed" and stop. That's a correct outcome.

## Procedure

1. `git diff` (or `git diff <base>...HEAD`). **This is your scope.** Read files outside the
   diff only when a specific hunk can't be judged without them.
2. Check, in this order — stop at the first that matters and report it:
   - **Correctness** — does it do what the task said? Off-by-one, null/None, error paths,
     unawaited async, resource leaks.
   - **Access control** — every query filtered by the tenancy key. Test the negative case in
     your head: what does this return for a *different* tenant? For an unauthenticated caller?
   - **Input and data** — validated at the boundary; nothing secret in logs or responses.
   - **Scope** — anything here that the task didn't ask for? Flag it; unrequested changes are
     the ones no one reviews later.
   - **Tests** — does a test actually fail if the behaviour regresses? Assertions that can't
     fail are worse than no test, because they read as coverage.
   - **Conventions** — only what `repo.md` or `architecture.md` records. Style is the linter's
     job, not yours.
3. Cross-check the `plan.md` acceptance criteria for the task. Unmet criterion ⇒ Critical.

## Output

**Critical** / **Warnings** / **Suggestions** — file:line, one line of what's wrong, one line
of fix. Omit empty categories. Lead with "No critical findings" when that's true.

Never sign off with "looks fine". If you couldn't verify something, name it and say why —
an unverified claim reported as verified is worse than a missed bug.
