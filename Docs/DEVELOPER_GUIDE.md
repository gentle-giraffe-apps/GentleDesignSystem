# DEVELOPER_GUIDE.md

**GentleDesignSystem** - A token-driven SwiftUI design system for iOS 18+.

## Quick Context

- Swift Package providing typography, color, spacing, button, and surface tokens
- JSON-serializable specs for theme persistence and remote loading
- Built-in Dark Mode and Dynamic Type support
- Demo app in `Demo/` for visual verification

## Before You Work

| Task | Read First |
|------|------------|
| Find a type/file | [Docs/architecture/type-inventory.md](architecture/type-inventory.md) |
| Use the API | [Docs/architecture/api-quick-ref.md](architecture/api-quick-ref.md) |
| Full API surface | [Docs/architecture/api-map.md](architecture/api-map.md) |
| Check default values | [Docs/architecture/defaults-reference.md](architecture/defaults-reference.md) |
| Add/modify tokens | [Docs/architecture/common-tasks.md](architecture/common-tasks.md) |
| Structural changes | [Docs/architecture/repo-map.md](architecture/repo-map.md) |
| Token/theming work | [Docs/architecture/design-tokens.md](architecture/design-tokens.md) |
| Boundary questions | [Docs/architecture/architecture.md](architecture/architecture.md) |
| Code style | [Docs/architecture/conventions.md](architecture/conventions.md) |
| Build/test commands | [Docs/architecture/workflows.md](architecture/workflows.md) |
| Terminology | [Docs/architecture/glossary.md](architecture/glossary.md) |

## Invariants (Never Violate)

1. **Tokens must be `Codable` and `Sendable`** - JSON serialization is core to the design
2. **Theme flows through `GentleThemeRoot`** - no singletons or static state
3. **Swift 6 strict concurrency** - `@MainActor` where needed, no data races
4. **No external dependencies** - package stays zero-dependency
5. **Spec version bumps** - any token schema change requires `GentleDesignSystemSpecVersion.current` update
6. **Never force unwrap (`!`)** - use `guard let`, `if let`, optional chaining, or nil-coalescing everywhere, including tests
7. **Always build for iOS Simulator** - UIKit is always available; do not use `#if canImport(UIKit)` checks
8. **Never use `case none` in enums** - conflicts with `Optional.none` and triggers static analysis warnings

## Common Commands

```bash
swift build                           # Build package
swift test                            # Run tests
cd Demo && bundle exec fastlane ios build  # Build demo app
```

