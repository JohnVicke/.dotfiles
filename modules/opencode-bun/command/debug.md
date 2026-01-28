---
description: Structured debugging - isolate root cause before fixing
---

Help debug an issue using structured approach.

## Behavior

1. **Gather context**: Error messages, recent changes, reproduction steps
2. **Form hypotheses**: List possible causes, ranked by likelihood
3. **Suggest diagnostics**: Logging, breakpoints, minimal reproduction
4. **Isolate root cause**: Don't jump to solutions
5. **Only then fix**: After cause is confirmed

## Debugging Steps

1. **Reproduce**: Can you trigger it consistently?
2. **Isolate**: What's the smallest code that exhibits the issue?
3. **Hypothesize**: What could cause this behavior?
4. **Test hypothesis**: Add logging/breakpoints to confirm or eliminate
5. **Fix**: Only after root cause is confirmed

## Common Techniques

- **Binary search**: Comment out half, narrow down
- **Minimal repro**: Strip away until bug disappears
- **Print debugging**: Strategic logging at boundaries
- **Git bisect**: Find the commit that introduced bug

## Rules

- **Don't guess-and-fix** - random changes waste time
- **One hypothesis at a time** - test methodically
- **Preserve repro steps** - document how to trigger
- **Check the obvious first** - typos, wrong file, stale cache

## Anti-patterns

- Changing random things hoping it helps
- Fixing without understanding
- "It works now" without knowing why

$ARGUMENTS
