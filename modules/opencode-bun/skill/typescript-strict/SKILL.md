---
name: typescript-strict
description: Strict TypeScript patterns - no any, no assertions, type-safe code
---

## Core Rules

### Never Use
```typescript
// BAD: any
function process(data: any) { ... }

// BAD: non-null assertion
const value = obj.prop!;

// BAD: type assertion
const user = data as User;
```

### Instead Use
```typescript
// GOOD: proper typing
function process(data: ProcessInput) { ... }

// GOOD: null check
if (obj.prop !== undefined) {
  const value = obj.prop;
}

// GOOD: type guard or validation
function isUser(data: unknown): data is User {
  return typeof data === 'object' && data !== null && 'id' in data;
}
```

## Make Illegal States Unrepresentable

### Discriminated Unions
```typescript
type Result<T, E> =
  | { ok: true; value: T }
  | { ok: false; error: E };

// Usage forces handling both cases
if (result.ok) {
  console.log(result.value);
} else {
  console.error(result.error);
}
```

### Parse at Boundaries
```typescript
// Validate external input immediately
const parsed = schema.parse(externalData);
// Now `parsed` is typed and validated
```

## Patterns

### Exhaustive Switch
```typescript
function assertNever(x: never): never {
  throw new Error(`Unexpected: ${x}`);
}

switch (action.type) {
  case 'add': return handleAdd(action);
  case 'remove': return handleRemove(action);
  default: return assertNever(action);
}
```

### Branded Types
```typescript
type UserId = string & { readonly __brand: 'UserId' };

function createUserId(id: string): UserId {
  // validation here
  return id as UserId;  // only place assertion allowed
}
```

## Abstraction Guidelines

- Consciously constrained
- Pragmatically parameterized
- Doggedly documented
