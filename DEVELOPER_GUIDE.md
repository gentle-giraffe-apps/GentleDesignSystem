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
