---
name: testing-patterns
description: Testing best practices with dependency injection emphasis
---

## Core Principle

**Dependency Injection over Mocking. Always.**

## Dependency Injection

### Why DI > Mocking

| Mocking | Dependency Injection |
|---------|---------------------|
| Couples tests to implementation | Tests behavior only |
| Brittle, breaks on refactor | Survives refactoring |
| Magic, hard to understand | Explicit, readable |
| Framework-dependent | Pure functions |

### Pattern

```typescript
// BAD: Hidden dependency, requires mocking
function getUser(id: string) {
  return database.query(`SELECT * FROM users WHERE id = ${id}`)
}
// Test requires: jest.mock('./database')

// GOOD: Explicit dependency, inject in tests
function getUser(id: string, db: Database) {
  return db.query(`SELECT * FROM users WHERE id = ${id}`)
}
// Test: getUser("1", { query: () => mockUser })

// BETTER: Function dependency
function getUser(id: string, query: (sql: string) => User) {
  return query(`SELECT * FROM users WHERE id = ${id}`)
}
// Test: getUser("1", () => mockUser)
```

### Real World Example

```typescript
// BAD: Mocking fetch
jest.mock('node-fetch')
async function fetchPrices() {
  const res = await fetch('https://api.prices.com')
  return res.json()
}

// GOOD: Inject fetcher
async function fetchPrices(
  fetcher: (url: string) => Promise<Response> = fetch
) {
  const res = await fetcher('https://api.prices.com')
  return res.json()
}
// Test: fetchPrices(() => Promise.resolve({ json: () => mockPrices }))
```

## Test Structure

### AAA Pattern
```typescript
test('calculates total with discount', () => {
  // Arrange
  const items = [{ price: 100 }, { price: 50 }]
  const discount = 0.1
  
  // Act
  const result = calculateTotal(items, discount)
  
  // Assert
  expect(result).toBe(135)
})
```

### Naming Convention
```
test('[unit] [scenario] [expected result]')
test('calculateTotal with empty array returns zero')
test('validateEmail with invalid format throws ValidationError')
```

## What to Test

### Do Test
- **Happy path**: Basic correct usage (1-2 tests)
- **Edge cases**: Empty, null, undefined, zero, negative, boundary
- **Error cases**: Invalid input, missing required fields
- **Integration points**: Where your code meets external systems

### Don't Test
- **Implementation details**: Private methods, internal state
- **Third-party code**: Trust your dependencies (or don't use them)
- **Trivial code**: Simple getters, obvious one-liners
- **Framework behavior**: React's setState works, don't test it

## Test Isolation

```typescript
// BAD: Tests share state
let counter = 0
test('increments', () => { counter++; expect(counter).toBe(1) })
test('increments again', () => { counter++; expect(counter).toBe(2) }) // Coupled!

// GOOD: Each test is independent
test('increments from zero', () => {
  const counter = createCounter(0)
  counter.increment()
  expect(counter.value).toBe(1)
})
```

## When Mocking is Acceptable

1. **System boundaries you don't control**: File system, network, time
2. **Expensive operations**: Only if DI is truly impractical
3. **Legacy code**: Temporary, while refactoring toward DI

Even then, prefer **fakes** over mocks:
```typescript
// Fake: Simple implementation for tests
const fakeFileSystem = {
  files: new Map<string, string>(),
  read(path: string) { return this.files.get(path) },
  write(path: string, content: string) { this.files.set(path, content) }
}
```

## Property-Based Testing

For pure functions, consider property-based tests:
```typescript
// Instead of specific examples
test('reverse twice equals original', () => {
  fc.assert(fc.property(fc.array(fc.integer()), (arr) => {
    expect(reverse(reverse(arr))).toEqual(arr)
  }))
})
```

## Anti-patterns

- **Testing implementation**: Breaks when you refactor
- **Mocking everything**: Sign of bad architecture
- **One giant test**: Hard to diagnose failures
- **Test file mirrors source**: Tests behavior, not structure
- **Snapshot abuse**: Use for UI, not logic
