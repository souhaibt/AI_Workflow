---
description: "Use when handling authentication, authorization, tenancy boundaries, user input, secrets, or payments. Covers OWASP-relevant conventions for this project."
---

# Security Conventions

`<Fill in: auth mechanism, secret storage/retrieval, input validation library/pattern,
dependency review process.>`

- Never log secrets, tokens, or full request bodies containing user credentials.
- Validate and sanitize all external input at the boundary (API handlers, form submissions,
  file uploads).
- A change to auth, access control, tenancy boundaries, or data exposure needs a `reviewer`
  pass before it's marked done — these are exactly what linters can't catch.
- Where the risk is expressible as a test, write the test instead of relying on the review.
  An access-policy change ships with a test proving one tenant cannot read another's rows.
