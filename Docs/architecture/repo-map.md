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
├── Docs/                         # Documentation (architecture, guides)
└── .github/workflows/            # CI configuration
```

## Source Files

| File | Purpose |
|------|---------|
| `GentleDesignSystem.swift` | Core types, tokens, theme, modifiers |
| `GentleThemeEditor.swift` | Theme editor UI (colors, typography, buttons, surfaces) |
| `GentleDesignSystemSpec+Presets.swift` | Built-in theme presets |
| `GentleSurfaceRole.swift` | Surface roles, background styles, materials |
| `GentleDesignModifiers.swift` | SwiftUI view modifiers |
| `ColorRoleEditor.swift` | Collapsible color editor component |
| `TypographyRoleEditor.swift` | Collapsible typography editor |
| `GentleVisualEffect.swift` | Visual effect/blur/glass background specs |
| `GentleDesignPersistence.swift` | JSON file persistence |
| `GentleDesignStudioView.swift` | Full design studio wrapper |
| `GentleUIKitTheming.swift` | UIKit integration (nav bar) |
| `GentleDesignCustomizeView.swift` | Section-based customization view |
| `GentleDesignShareSheet.swift` | Theme export/share sheet |
| `GentlePDFExporter.swift` | PDF generation for theme specs |
| `String+camelCaseBreakable.swift` | String utility extension |

## What Lives Where

| Need to... | Look in... |
|------------|------------|
| Add/modify token types | `GentleDesignSystem.swift` |
| Change default token values | `GentleDesignSystem.swift` (`.gentleDefault` statics) |
| Add view modifiers | `GentleDesignModifiers.swift` |
| Add surface roles | `GentleSurfaceRole.swift` |
| Add visual effects | `GentleVisualEffect.swift` |
| Add theme presets | `GentleDesignSystemSpec+Presets.swift` |
| Add theme editor sections | `GentleThemeEditor.swift` |
| Add role editors | `ColorRoleEditor.swift`, `TypographyRoleEditor.swift` |
| Modify persistence | `GentleDesignPersistence.swift` |
| UIKit navigation styling | `GentleUIKitTheming.swift` |
| Export theme as PDF | `GentlePDFExporter.swift` |

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
│   ├── ThemeStudioView.swift            # Main view with theme editor
│   ├── ThemePickerView.swift            # Theme preset picker
│   └── ThemePreset.swift                # Preset definitions
├── fastlane/
│   ├── Fastfile                         # `fastlane ios build`
│   └── README.md
└── Gemfile                              # Ruby deps for Fastlane
```
