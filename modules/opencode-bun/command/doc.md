---
description: Generate documentation for code
---

Generate documentation for the specified code.

## Behavior

1. **Detect existing style**: Match documentation patterns in codebase
2. **Generate appropriate docs**: Based on what's being documented
3. **Be concise**: Document the non-obvious, skip the trivial

## Documentation Types

**Functions/Methods:**
```typescript
/**
 * Brief description of what it does.
 * 
 * @param name - Description (mention constraints)
 * @returns Description
 * @throws When and why
 * @example
 * doThing("input") // => "output"
 */
```

**Modules/Files:**
- Purpose: Why does this exist?
- Usage: How to use it
- API: Key exports

**Config files:**
- Inline comments for non-obvious choices
- Skip obvious settings

## Rules

- **Document why, not what** - code shows what, comments explain why
- **Skip the obvious** - `// increment i` is noise
- **Keep updated** - outdated docs are worse than no docs
- **Match codebase style** - consistency over preference

$ARGUMENTS
