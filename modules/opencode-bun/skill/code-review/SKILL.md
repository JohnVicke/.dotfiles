---
name: code-review
description: Code review checklist and patterns for thorough PR reviews
---

## Review Checklist

### Correctness
- [ ] Logic errors, off-by-one, boundary conditions
- [ ] Null/undefined handling
- [ ] Error handling and edge cases
- [ ] Race conditions in async code

### Type Safety
- [ ] No `any` types
- [ ] No non-null assertions (`!`)
- [ ] No unsafe type assertions (`as Type`)
- [ ] Proper generic constraints

### Security
- [ ] Input validation at boundaries
- [ ] No secrets in code
- [ ] Auth/authz checks present
- [ ] SQL/XSS injection prevention

### Performance
- [ ] N+1 query patterns
- [ ] Unnecessary re-renders (React)
- [ ] Memory leaks (event listeners, subscriptions)
- [ ] Large bundle imports

### Maintainability
- [ ] Clear naming
- [ ] Appropriate abstraction level
- [ ] No code duplication
- [ ] Tests cover new behavior

## Output Format

```
**[severity]** file:line - issue
Why: explanation
Suggest: fix direction
```

Severities: `critical` (blocks merge), `warning` (should fix), `nit` (optional)

## Review Approach

1. Understand intent from PR description and commits
2. Check for breaking changes
3. Verify test coverage
4. Look for convention violations
5. End with: approve / request changes / comment
