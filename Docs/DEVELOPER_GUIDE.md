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
| Structural changes | [docs/architecture/repo-map.md](architecture/repo-map.md) |
| Token/theming work | [docs/architecture/design-tokens.md](architecture/design-tokens.md) |
| Boundary questions | [docs/architecture/architecture.md](architecture/architecture.md) |
| Code style | [docs/architecture/conventions.md](architecture/conventions.md) |
| Build/test commands | [docs/architecture/workflows.md](architecture/workflows.md) |
| Terminology | [docs/architecture/glossary.md](architecture/glossary.md) |

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

## What This Repo Is

A Swift Package providing a token-driven design system for iOS 18+ SwiftUI apps. Zero external dependencies.

## Key Paths

- `Sources/GentleDesignSystem/` - Package source
- `Demo/` - Demo iOS app
- `docs/architecture/` - Detailed context for developers

## Must-Know Rules

1. All token types must be `Codable` and `Sendable`
2. Theme injection uses SwiftUI environment (via `GentleThemeRoot`)
3. No singletons or static mutable state
4. Swift 6 strict concurrency required
5. Zero external dependencies

## Build/Test

```bash
swift build        # Build package
swift test         # Run tests
cd Demo && bundle exec fastlane ios build  # Build demo
```

## Where to Find Details

| Topic | File |
|-------|------|
| File locations | `docs/architecture/repo-map.md` |
| Architecture | `docs/architecture/architecture.md` |
| Token model | `docs/architecture/design-tokens.md` |
| Code style | `docs/architecture/conventions.md` |
| Commands | `docs/architecture/workflows.md` |
| Terminology | `docs/architecture/glossary.md` |
