---
description: Analyze error and propose minimal surgical fix
---

Analyze the current error/issue and propose a minimal fix.

## Behavior

1. **Gather context**: Error message, stack trace, LSP diagnostics, or user description
2. **Identify root cause**: Don't fix symptoms, fix the actual problem
3. **Propose minimal fix**: Smallest change that solves the issue
4. **If multiple approaches**: List tradeoffs concisely, recommend one
5. **Execute fix**: Apply the change

## Rules

- **Minimal changes only** - don't refactor, don't "improve", just fix
- **One problem at a time** - if you spot other issues, mention but don't fix
- **Preserve behavior** - fix shouldn't change unrelated functionality
- **No scope creep** - resist urge to clean up surrounding code

## Anti-patterns

- "While I'm here, let me also..." - NO
- Rewriting the function to fix a typo - NO
- Adding features while fixing bugs - NO

$ARGUMENTS
