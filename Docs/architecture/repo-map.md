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

| File | Purpose | Lines |
|------|---------|-------|
| `GentleDesignSystem.swift` | Core types, tokens, theme, modifiers | ~1560 |
| `GentleThemeEditor.swift` | Theme editor UI (colors, typography, buttons, surfaces) | ~1120 |
| `GentleDesignSystemSpec+Presets.swift` | Built-in theme presets | ~665 |
| `ColorRoleEditor.swift` | Collapsible color editor component | ~460 |
| `TypographyRoleEditor.swift` | Collapsible typography editor | ~450 |
| `GentleDesignModifiers.swift` | SwiftUI view modifiers | ~370 |
| `GentleDesignMaterial.swift` | Material/blur/glass background specs | ~255 |
| `GentleDesignPersistence.swift` | JSON file persistence | ~155 |
| `GentleUIKitTheming.swift` | UIKit integration (nav bar) | ~155 |
| `GentleDesignCustomizeView.swift` | Section-based customization view | ~150 |
| `GentleDesignStudioView.swift` | Full design studio wrapper | ~140 |
| `GentleSurfaceRole.swift` | Surface role specs | ~130 |
| `GentleDesignShareSheet.swift` | Theme export/share sheet | ~25 |
| `String+camelCaseBreakable.swift` | String utility extension | ~15 |

## What Lives Where

| Need to... | Look in... |
|------------|------------|
| Add/modify token types | `GentleDesignSystem.swift` |
| Change default token values | `GentleDesignSystem.swift` (`.gentleDefault` statics) |
| Add view modifiers | `GentleDesignModifiers.swift` |
| Add surface roles | `GentleSurfaceRole.swift` |
| Add material types | `GentleDesignMaterial.swift` |
| Add theme presets | `GentleDesignSystemSpec+Presets.swift` |
| Add theme editor sections | `GentleThemeEditor.swift` |
| Add role editors | `ColorRoleEditor.swift`, `TypographyRoleEditor.swift` |
| Modify persistence | `GentleDesignPersistence.swift` |
| UIKit navigation styling | `GentleUIKitTheming.swift` |

## Related Documentation

| Document | Purpose |
|----------|---------|
| [type-inventory.md](type-inventory.md) | Complete list of all types by file |
| [api-quick-ref.md](api-quick-ref.md) | All public API signatures |
| [defaults-reference.md](defaults-reference.md) | All default token values |
| [common-tasks.md](common-tasks.md) | Step-by-step how-to guides |

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
