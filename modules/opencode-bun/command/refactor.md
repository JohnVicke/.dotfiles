---
description: Refactor code preserving exact behavior
---

Refactor the specified code with strict behavior preservation.

## Behavior

1. **Understand current behavior**: Read and comprehend before changing
2. **Preserve behavior exactly**: No feature changes, no bug fixes
3. **Improve structure**: Naming, organization, type safety, readability
4. **Split if needed**: >100 lines or multiple responsibilities = split
5. **Extract patterns**: Repeated code → shared function/module

## Refactoring Targets

- Poor naming → descriptive names
- Long functions → smaller, focused functions
- Repeated code → extracted utilities
- Complex conditionals → early returns, guard clauses
- Weak types → stronger type constraints
- Deep nesting → flattened structure

## Rules

- **Behavior must be identical** - if tests exist, they should still pass unchanged
- **One refactor type at a time** - don't rename AND restructure in one pass
- **Commit separately** - refactors get their own commit (`refactor: ...`)

## Show

- Brief before/after summary
- What improved and why

$ARGUMENTS
