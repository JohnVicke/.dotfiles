---
description: Create a pull request using gh cli
---

Create a PR for the current branch using gh cli.

## Behavior

1. **Safety check**: If on `main` or `master`, abort with warning - never create PR from these branches
2. **Push if needed**: If branch not pushed, run `git push -u origin HEAD`
3. **Generate title**: From commit(s) using conventional format
4. **Generate body**: Summary from commit messages
5. **Create PR**: `gh pr create --title "..." --body "..."`

## Arguments

- `--base <branch>` - Set base branch (for stacked PRs)
- `--draft` - Create as draft PR

## Title Format

Use conventional commit format for PR title:
```
feat: add new capability
fix: resolve specific bug
refactor: restructure without behavior change
```

If multiple commits with different types, use the primary/most significant one.

## Body Format

```markdown
## Summary
- Brief bullet points of changes

## Commits
- List of commit messages (if multiple)
```

## Rules

- Never add AI attribution to PR title or body
- For stacked PRs, always specify `--base`

$ARGUMENTS
