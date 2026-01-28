---
description: Commit changes using conventional commits format
---

Analyze all changes and create commit(s) using conventional commit format.

## Behavior

1. **Safety check**: If on `main` or `master`, abort with warning
2. **Analyze all changes**: Look at both staged and unstaged changes
3. **Group logically**: Determine if changes should be one or multiple commits
4. **Stage and commit**: For each logical group, stage relevant files and commit
5. **Prefer single commit**: Only split when genuinely distinct purposes

## When to Split

**Split** when changes are genuinely unrelated:
- Bug fix + unrelated new feature
- Refactoring in module A + new code in module B
- Config change + feature implementation

**Keep together** (single commit):
- Feature + its tests
- Refactor + related cleanup
- Multiple files for same logical change
- Most typical changes

Default to single commit unless there's a clear reason to split.

## Conventional Commit Format

```
type: brief description (max 72 chars)
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

## Rules

- Imperative mood ("add" not "added")
- Max 72 chars
- Focus on "why" not "what"
- Never add AI attribution

$ARGUMENTS
