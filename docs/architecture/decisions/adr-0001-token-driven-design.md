# ADR-0001: Token-Driven Design System

**Status:** Accepted
**Date:** 2024

## Context

Building a SwiftUI design system that needs to:
- Support runtime theme customization
- Persist user preferences
- Potentially load themes from remote sources
- Support Dark Mode and Dynamic Type

## Decision

Use a three-layer architecture:

1. **Token Layer** - Codable structs defining design intent (not implementation)
2. **Runtime Layer** - Theme object resolving tokens per environment (ColorScheme, SizeCategory)
3. **Ergonomics Layer** - SwiftUI modifiers consuming resolved values

All tokens are JSON-serializable with explicit versioning.

## Consequences

**Positive:**
- Themes can be persisted, shared, loaded remotely
- Clear separation between design intent and runtime behavior
- Easy to add new tokens without breaking existing code
- Type-safe with compile-time checking

**Negative:**
- More boilerplate than raw SwiftUI values
- JSON keys tied to enum rawValues (migration concern)
- Single ~1600 line file for core types (could refactor later)

## Alternatives Considered

1. **Singleton theme** - Rejected: violates SwiftUI's environment model
2. **Hardcoded values** - Rejected: no runtime customization
3. **CSS-like string tokens** - Rejected: loses Swift type safety
