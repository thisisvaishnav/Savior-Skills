---
name: coding-best-practices
description: General software engineering standards for writing clean, maintainable, well-tested code — naming, function design, error handling, version control, and testing. Use when writing or reviewing code in any language.
---

# Coding Best Practices

## Writing Code

- **Naming.** Names should reveal intent: `daysUntilDeadline`, not `d`. Booleans read as predicates (`isActive`, `hasAccess`).
- **Functions.** Do one thing. Keep them short (aim under ~30 lines) and limit parameters to 3–4; pass an object when more are needed.
- **DRY, but not prematurely.** Extract duplication only after it appears 2–3 times with identical meaning.
- **Comments.** Explain *why*, not *what*. If code needs a comment to explain what it does, rewrite the code instead.
- **Errors.** Fail fast and loudly. Never swallow exceptions silently. Validate inputs at boundaries; trust internals.

## Project Conventions

- Always match the existing style, patterns, and libraries of the codebase before introducing anything new.
- Only use libraries already confirmed in the project; propose additions explicitly rather than assuming them.
- Keep changes minimal and focused — one logical change per commit/PR.

## Testing

- Test behavior, not implementation details.
- Cover the happy path, edge cases (empty, zero, huge, unicode), and error paths.
- Arrange–Act–Assert structure; one concept per test; descriptive test names.
- Run the full test suite before declaring work done.

## Version Control

- Small, atomic commits with imperative messages: `Fix off-by-one in date range parser`.
- Never commit secrets, generated artifacts, or unrelated files.
- Rebase/merge cleanly; leave the history readable.

## Review Checklist

- [ ] Does it solve the stated problem without extra scope?
- [ ] Are names, structure, and style consistent with the codebase?
- [ ] Are errors handled explicitly?
- [ ] Are new behaviors tested?
- [ ] Any secrets, debug prints, or TODOs left behind?
