---
name: commit-conventions
description: Git commit message conventions and workflow patterns
---

## Commit Message Format

**Style**: Concise, imperative mood, focus on "why"

```
type: brief description (max 72 chars)

Optional body explaining why, not what.
```

### Types
- `feat` - new feature
- `fix` - bug fix
- `refactor` - code restructure, no behavior change
- `docs` - documentation only
- `test` - adding/fixing tests
- `chore` - maintenance, deps, config

### Examples

```
feat: add dark mode toggle
fix: resolve race condition in queue processor
refactor: extract validation into shared module
```

**Bad**: "Added dark mode toggle" (past tense)
**Bad**: "Add dark mode toggle to settings page component" (too long, describes what not why)

## Git Aliases Available

| Alias | Command | Use |
|-------|---------|-----|
| `git fu` | amend + force push | Fix last commit |
| `git oops` | amend no-edit | Add to last commit |
| `git wip` | commit + push --no-verify | WIP save |

## Stacked PRs

```bash
git stack <branch>        # Create stacked branch
git update-from-parent    # Rebase on parent
git parent-merged         # After parent merges
git show-stack            # View stack
```

## Rules

- Never add AI attribution to commits/PRs
- Never commit secrets (.env, credentials)
- One logical change per commit
- Verify with `just build` before commit (for Nix)
