---
name: git-workflow
description: Git workflow patterns including stacked PRs and common operations
---

## Branch Strategy

- Default branch: `main`
- Feature branches from `main`
- Stacked PRs for dependent changes

## Stacked PR Workflow

```bash
# Create stack
git checkout main
git checkout -b feature-base
# ... make changes, commit, push, open PR

git stack feature-part2      # creates branch stacked on feature-base
# ... make changes, commit, push, open PR with base=feature-base

# Update stack after changes
git update-from-parent       # rebase current on parent branch

# After parent PR merges
git parent-merged            # rebase onto main, update tracking

# View stack
git show-stack
```

## Common Operations

| Task | Command |
|------|---------|
| Fix last commit | `git fu` (amend + force push) |
| Add to last commit | `git oops` (amend no-edit) |
| Quick WIP save | `git wip` (commit + push, skip hooks) |
| Interactive rebase | `git rebase -i HEAD~n` |
| View recent | `git log --oneline -10` |

## Pull Request Flow

1. Push branch: `git push -u origin branch-name`
2. Create PR: `gh pr create --title "type: desc" --body "..."`
3. After review: squash or rebase merge
4. Delete branch: `gh pr merge --delete-branch`

## Rules

- Pull strategy: fast-forward only (`git pull --ff-only`)
- Auto-setup remote on push
- Separate config for work directory (`~/dev/anyfin/`)

## PR Title Format

```
feat: add new capability
fix: resolve specific bug
refactor: restructure without behavior change
docs: update documentation
test: add/fix tests
chore: maintenance tasks
```
