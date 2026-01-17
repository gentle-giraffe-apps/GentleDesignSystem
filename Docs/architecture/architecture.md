# Architecture

## Three-Layer Design

```
┌─────────────────────────────────────────────────────┐
│  Layer 3: SwiftUI Ergonomics                        │
│  .gentleText(), .gentleSurface(), .gentleButton()   │
├─────────────────────────────────────────────────────┤
│  Layer 2: Runtime Resolution (GentleTheme)          │
│  Colors per ColorScheme, Fonts per SizeCategory     │
├─────────────────────────────────────────────────────┤
│  Layer 1: Token Layer (Codable, JSON-friendly)      │
│  GentleDesignSystemSpec, all *Tokens structs        │
└─────────────────────────────────────────────────────┘
```

## Design Goals

- **Native feel** - follows Apple HIG, uses system font metrics
- **Predictable** - no magic, explicit environment injection
- **Composable** - modifiers stack cleanly
- **Portable** - JSON specs can be persisted, loaded remotely, shared

## Non-Goals

- Cross-platform (macOS, watchOS, etc.) - iOS only for now
- Custom font loading - uses system fonts only
- Component library - provides primitives, not full components

## Dependency Rules

1. **Package has zero external dependencies**
2. **Demo app depends on package** (local path dependency)
3. **No circular dependencies between source files**

## Data Flow

```
App Launch
    │
    ▼
GentleThemeManager (owns theme, handles persistence)
    │
    ▼
GentleThemeRoot (injects theme into environment)
    │
    ▼
@Environment(\.gentleTheme) (views read theme)
    │
    ▼
View Modifiers resolve tokens → SwiftUI values
```

## Theme Mutation Flow

```
Editor Component
    │
    ▼
manager.bindingForTypographyRole(.body_m)
    │
    ▼
GentleThemeManager updates theme.editableSpec
    │
    ▼
manager.save() → GentleFileThemeSpecStore → JSON file
```

## Module Boundaries

| Boundary | Rule |
|----------|------|
| Package ↔ Demo | Package exposes public API only; Demo is a consumer |
| Token Layer ↔ Runtime | Tokens are data; Theme resolves them |
| SwiftUI ↔ UIKit | `GentleUIKitTheming` bridges via UIAppearance |

## Concurrency Model

- `GentleThemeManager` is `@Observable` and `@MainActor`
- All token types are `Sendable`
- Theme struct is `Sendable` (value type)
- No async token resolution (sync by design)
