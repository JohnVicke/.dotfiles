---
description: Analyze dependencies - updates, security, unused
---

Analyze project dependencies.

## Behavior

1. **Detect package manager**: npm, pnpm, yarn, Nix flake
2. **Check for updates**: Major/minor/patch available
3. **Security scan**: Known vulnerabilities
4. **Find unused**: Dependencies not imported anywhere
5. **Suggest alternatives**: Lighter options for heavy deps

## Checks

| Check | Command |
|-------|---------|
| npm outdated | `npm outdated` |
| npm audit | `npm audit` |
| pnpm outdated | `pnpm outdated` |
| Nix flake | `nix flake update --dry-run` |

## Output Format

```
## Updates Available
- package@1.0.0 → 2.0.0 (MAJOR - breaking changes)
- package@1.0.0 → 1.1.0 (minor)

## Security Issues
- package@1.0.0 - HIGH: description

## Potentially Unused
- package (not imported in src/)

## Heavy Dependencies
- package (1.2MB) - consider: lighter-alternative
```

## Rules

- **Major updates need review** - check changelog for breaking changes
- **Security issues are urgent** - fix or document why not
- **Unused deps add bloat** - remove unless needed for types/dev

$ARGUMENTS
