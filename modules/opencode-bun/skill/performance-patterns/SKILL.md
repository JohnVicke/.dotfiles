---
name: performance-patterns
description: Performance optimization patterns and profiling
---

## Core Principle

**Measure first. Optimize hot paths. Verify improvement.**

## Profiling First

```typescript
// Don't guess - measure
console.time('operation')
doOperation()
console.timeEnd('operation')

// Node.js
const { performance } = require('perf_hooks')
const start = performance.now()
doOperation()
console.log(`Took ${performance.now() - start}ms`)
```

### Tools

| Language | Tool |
|----------|------|
| Node.js | `--prof`, `clinic.js`, Chrome DevTools |
| Browser | Performance tab, Lighthouse |
| Nix | `nix build --print-build-logs` |
| General | `time command`, `hyperfine` |

## 90/10 Rule

90% of time is spent in 10% of code. Find that 10%.

## Common Wins

### Avoid N+1

```typescript
// BAD: N+1 queries
for (const user of users) {
  const posts = await db.posts.findMany({ where: { userId: user.id } })
}

// GOOD: Single query with join
const usersWithPosts = await db.users.findMany({
  include: { posts: true }
})
```

### Cache Expensive Computations

```typescript
// Memoization
const cache = new Map()
function expensive(input: string) {
  if (cache.has(input)) return cache.get(input)
  const result = actuallyCompute(input)
  cache.set(input, result)
  return result
}

// React: useMemo
const computed = useMemo(() => expensiveCalc(data), [data])
```

### Lazy Load

```typescript
// Code splitting
const HeavyComponent = lazy(() => import('./HeavyComponent'))

// Lazy initialization
let instance: Heavy | null = null
function getInstance() {
  if (!instance) instance = new Heavy()
  return instance
}
```

### Batch Operations

```typescript
// BAD: Many small writes
for (const item of items) {
  await db.insert(item)
}

// GOOD: Single batch
await db.insertMany(items)
```

## Data Structure Choice

| Operation | Array | Set | Map | Object |
|-----------|-------|-----|-----|--------|
| Lookup by value | O(n) | O(1) | - | - |
| Lookup by key | O(n) | - | O(1) | O(1)* |
| Insert | O(1) | O(1) | O(1) | O(1) |
| Delete | O(n) | O(1) | O(1) | O(1) |
| Iteration order | Yes | Yes | Yes | No* |

*Object has quirks with numeric keys and prototype chain

```typescript
// For frequent lookups, use Set/Map
const seen = new Set(items)  // O(1) lookup
if (seen.has(item)) { ... }

// Not array.includes()
if (items.includes(item)) { ... }  // O(n) lookup
```

## TypeScript Specific

```typescript
// Avoid spreading in loops
// BAD
let result = {}
for (const item of items) {
  result = { ...result, [item.key]: item.value }  // O(n²)
}

// GOOD
const result: Record<string, Value> = {}
for (const item of items) {
  result[item.key] = item.value  // O(n)
}

// Use for...of over .forEach in hot paths
// for...of is slightly faster and can break early
```

## React Specific

```tsx
// Avoid inline objects/functions in render
// BAD: New object every render
<Component style={{ color: 'red' }} />

// GOOD: Stable reference
const style = { color: 'red' }
<Component style={style} />

// Virtualize long lists
import { FixedSizeList } from 'react-window'
```

## Nix Specific

```nix
# Use builtins.readDir over import with glob
# BAD: Evaluates all files
let files = import ./.; in ...

# GOOD: Only reads directory
let files = builtins.readDir ./.; in ...

# Avoid repeated imports
# BAD: Imported multiple times
{ a = import ./x.nix; b = import ./x.nix; }

# GOOD: Import once
let x = import ./x.nix; in { a = x; b = x; }
```

## When NOT to Optimize

- **Premature optimization**: Code that runs once
- **Non-bottlenecks**: 1ms vs 2ms doesn't matter if user waits 500ms for network
- **Readable code sacrifice**: Maintainability > micro-optimization
- **Before measuring**: You might optimize the wrong thing

## Checklist

1. Is this actually slow? (Measure)
2. Is this code on the hot path?
3. What's the algorithmic complexity?
4. Can I cache the result?
5. Can I batch operations?
6. Am I using the right data structure?
7. Did the optimization actually help? (Measure again)
