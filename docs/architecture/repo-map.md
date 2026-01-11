# Repo Map

## Directory Structure

```
GentleDesignSystem/
├── Package.swift                 # SPM manifest (iOS 18+, Swift 6.1)
├── Sources/GentleDesignSystem/   # Package source (THE source of truth)
├── Tests/GentleDesignSystemTests/# Swift Testing tests
├── Demo/                         # Demo iOS app (consumes package)
│   ├── GentleDesignSystemDemo.xcodeproj
│   ├── GentleDesignSystemDemo/   # App source
│   └── fastlane/                 # Build automation
├── docs/ai/                      # AI/agent context (this folder)
└── .github/workflows/            # CI configuration
```

## Source Files

| File | Purpose | Lines |
|------|---------|-------|
| `GentleDesignSystem.swift` | Core types, tokens, theme, modifiers | ~1600 |
| `GentleDesignFoundationView.swift` | Demo views showing all tokens | ~230 |
| `GentleDesignSettingsView.swift` | Live theme editing UI | ~42 |
| `ColorRoleEditor.swift` | Collapsible color editor component | ~175 |
| `TypographyRoleEditor.swift` | Collapsible typography editor | ~160 |
| `GentleUIKitTheming.swift` | UIKit integration (nav bar) | ~150 |

## What Lives Where

| Need to... | Look in... |
|------------|------------|
| Add/modify token types | `GentleDesignSystem.swift` |
| Change default token values | `GentleDesignSystem.swift` (`.gentleDefault` statics) |
| Add view modifiers | `GentleDesignSystem.swift` (bottom half) |
| Add demo sections | `GentleDesignFoundationView.swift` |
| Add settings editors | `GentleDesignSettingsView.swift` + editor components |
| UIKit navigation styling | `GentleUIKitTheming.swift` |

## Files That Should Not Be Edited Casually

- `GentleDesignSystem.swift` - Core file; changes cascade everywhere
- `Package.swift` - Platform/version changes affect all consumers
- `.github/workflows/ci.yml` - CI stability

## Demo App Structure

```
Demo/
├── GentleDesignSystemDemo.xcodeproj  # Xcode project
├── GentleDesignSystemDemo/
│   ├── GentleDesignSystemDemoApp.swift  # @main, creates GentleThemeManager
│   └── ContentView.swift                # NavigationStack + settings sheet
├── fastlane/
│   ├── Fastfile                         # `fastlane ios build`
│   └── README.md
├── Gemfile                              # Ruby deps for Fastlane
└── README_assets/                       # Screenshots
```
