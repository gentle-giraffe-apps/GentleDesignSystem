# Code Conventions

## Swift Style

- **Swift 6.1** with strict concurrency
- **iOS 18.0** minimum deployment target
- Use `@MainActor` for UI-bound classes
- All public types need `public` access modifier

## Strict Rules (Never Violate)

| Rule | Rationale |
|------|-----------|
| **Never force unwrap (`!`)** | No force unwrapping anywhere in the codebase, including tests. Use `guard let`, `if let`, optional chaining, or nil-coalescing instead. |
| **Always build for iOS Simulator** | This project uses UIKit. Do not use `#if canImport(UIKit)` or platform availability checks for UIKit—it is always available. |
| **Never use `case none` in enums** | Causes static analysis warnings due to conflict with `Optional.none`. Use alternative names like `noEffect`, `hidden`, `unknown`, or `unspecified`. |

## Naming

| Pattern | Example |
|---------|---------|
| Role enums | `Gentle{Category}Role` |
| Token structs | `Gentle{Category}Tokens` |
| Spec structs | `Gentle{Category}RoleSpec` |
| View modifiers | `.gentle{Action}()` |
| Property wrappers | `@Gentle{Name}Runtime` |
| Default values | `.gentleDefault` static property |

## File Organization

Within `GentleDesignSystem.swift`:
```
1. Version constant
2. Role enums
3. Token structs (with defaults)
4. GentleTheme (runtime)
5. Environment keys
6. View modifiers
7. View extensions
8. Property wrappers
9. JSON encoding/decoding
10. Persistence (store, manager)
```

## Type Requirements

| Requirement | Why |
|-------------|-----|
| `Codable` | JSON serialization for persistence |
| `Sendable` | Swift 6 concurrency safety |
| `CaseIterable` | For editor UIs (when applicable) |
| `Identifiable` | For SwiftUI lists (roles) |

## View Modifier Pattern

```swift
public struct GentleXxxModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    // other env as needed

    private let param: Type

    public init(param: Type) {
        self.param = param
    }

    public func body(content: Content) -> some View {
        // resolve tokens → SwiftUI values
        // apply to content
    }
}

public extension View {
    func gentleXxx(_ param: Type) -> some View {
        modifier(GentleXxxModifier(param: param))
    }
}
```

## Default Values Pattern

```swift
public extension SomeTokenStruct {
    static let gentleDefault: SomeTokenStruct = .init(
        // explicit values, not magic
    )
}
```

## Comments

- Brief doc comments on public types
- No inline comments unless logic is non-obvious
- Author attribution: `//  Jonathan Ritchey` at file top

## Error Handling

- Persistence errors: `throw` from store methods
- Missing tokens: fallback to sensible defaults (never crash)
- Invalid hex: return black/primary color

## Concurrency

```swift
// Observable manager must be MainActor
@Observable
@MainActor
public final class GentleThemeManager { ... }

// Token types are value types, automatically Sendable
public struct GentleColorPair: Codable, Sendable { ... }
```
