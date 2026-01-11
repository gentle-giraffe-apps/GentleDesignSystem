# CLAUDE.md

**GentleDesignSystem** - A token-driven SwiftUI design system for iOS 18+.

## Quick Context

- Swift Package providing typography, color, spacing, button, and surface tokens
- JSON-serializable specs for theme persistence and remote loading
- Built-in Dark Mode and Dynamic Type support
- Demo app in `Demo/` for visual verification

## Before You Work

| Task | Read First |
|------|------------|
| Structural changes | [docs/architecture/repo-map.md](docs/architecture/repo-map.md) |
| Token/theming work | [docs/architecture/design-tokens.md](docs/architecture/design-tokens.md) |
| Boundary questions | [docs/architecture/architecture.md](docs/architecture/architecture.md) |
| Code style | [docs/architecture/conventions.md](docs/architecture/conventions.md) |
| Build/test commands | [docs/architecture/workflows.md](docs/architecture/workflows.md) |
| Terminology | [docs/architecture/glossary.md](docs/architecture/glossary.md) |

## Invariants (Never Violate)

1. **Tokens must be `Codable` and `Sendable`** - JSON serialization is core to the design
2. **Theme flows through `GentleThemeRoot`** - no singletons or static state
3. **Swift 6 strict concurrency** - `@MainActor` where needed, no data races
4. **No external dependencies** - package stays zero-dependency
5. **Spec version bumps** - any token schema change requires `GentleDesignSystemSpecVersion.current` update

## Common Commands

```bash
swift build                           # Build package
swift test                            # Run tests
cd Demo && bundle exec fastlane ios build  # Build demo app
```

## Current State

