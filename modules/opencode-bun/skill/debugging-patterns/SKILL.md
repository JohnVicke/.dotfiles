---
name: debugging-patterns
description: Systematic debugging techniques and common pitfalls
---

## Core Principle

**Don't guess. Isolate, hypothesize, verify.**

## Techniques

### Binary Search Debugging
1. Comment out half the code
2. Does issue persist?
3. If yes: bug is in remaining half
4. If no: bug is in commented half
5. Repeat until isolated

### Minimal Reproduction
1. Start with failing case
2. Remove code until bug disappears
3. Add back last removed piece
4. That's your culprit

### Git Bisect
```bash
git bisect start
git bisect bad HEAD
git bisect good <known-good-commit>
# Git checks out middle commit
# Test, then: git bisect good/bad
# Repeat until found
```

## Common Culprits

| Symptom | Likely Cause |
|---------|--------------|
| Works sometimes | Race condition, timing |
| Works locally not CI | Env vars, paths, permissions |
| Undefined is not a function | Null/undefined propagation |
| Stale data | Caching, closures capturing old values |
| Off by one | Array bounds, loop conditions |
| Memory leak | Event listeners, subscriptions not cleaned |

## Debug Logging

```typescript
// Strategic placement
console.log('[boundary] input:', JSON.stringify(input))
console.log('[boundary] output:', JSON.stringify(output))

// Timestamps for timing issues
console.log(`[${Date.now()}] event occurred`)
```

## Language-Specific

### TypeScript/JavaScript
- `console.table()` for arrays/objects
- `debugger` statement for breakpoints
- `JSON.stringify(x, null, 2)` for readable output
- Check `typeof` and `instanceof`

### Lua/Neovim
- `:messages` - view error messages
- `print(vim.inspect(x))` - inspect tables
- `:checkhealth` - plugin diagnostics
- `pcall(fn)` - catch errors safely

### Nix
- `nix repl` - explore expressions interactively
- `builtins.trace x x` - print during evaluation
- `nix build --print-build-logs` - verbose output
- `nix why-depends A B` - dependency chains

### Shell
- `set -x` - trace execution
- `bash -n script.sh` - syntax check without running
- `shellcheck script.sh` - static analysis

## Anti-patterns

- **Shotgun debugging**: Random changes hoping something works
- **Debugging in production**: Add proper logging first
- **Ignoring the obvious**: Check typos, wrong file, cache
- **"It works now"**: If you don't know why, it'll break again
