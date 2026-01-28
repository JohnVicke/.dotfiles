---
description: Generate tests for code
---

Generate tests for the specified function/module.

## Behavior

1. **Detect test framework**: Find existing tests, match patterns
2. **Analyze code**: Understand inputs, outputs, edge cases, error paths
3. **Generate tests**: Focus on behavior, not implementation
4. **Use dependency injection**: Pass dependencies as parameters

## Test Priority

1. **Happy path** - basic correct usage (1-2 tests)
2. **Edge cases** - empty, null, boundary values, zero, negative
3. **Error cases** - invalid input, missing data, failures
4. **Integration points** - where modules connect

## Rules

- **Dependency injection over mocking** - 99% of the time, pass dependencies as parameters instead of mocking
- **Test behavior, not implementation** - tests shouldn't break when refactoring internals
- **One logical assertion per test** - test name should describe the one thing being tested
- **No testing implementation details** - don't test private methods
- **Match existing patterns** - use same style as other tests in codebase

## DI Example

```typescript
// BAD: mocking
jest.mock('./database')
function getUser(id: string) { return db.query(id) }

// GOOD: dependency injection
function getUser(id: string, query: (id: string) => User) { return query(id) }
// Test: getUser("1", () => mockUser)
```

## Anti-patterns

- Mocking everything
- Testing third-party code
- Testing trivial getters/setters
- Tests coupled to implementation

$ARGUMENTS
