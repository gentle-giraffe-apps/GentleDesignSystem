# GentleDesignSystem

A lightweight, token-driven SwiftUI design system with built-in dark mode and Dynamic Type support.

**See it in action:** Open `Demo/GentleDesignSystemDemo.xcodeproj` to explore all components.

## Quick Start

### 1. Add the Package

```swift
.package(url: "https://github.com/your-repo/GentleDesignSystem.git", branch: "main")
```

### 2. Wrap Your App

```swift
import GentleDesignSystem

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: .default) {
                ContentView()
            }
        }
    }
}
```

### 3. Use the Components

**Typography**
```swift
Text("Welcome")
    .gentleText(.title_xl)

Text("Description")
    .gentleText(.body_m, colorRole: .textSecondary)
```

**Buttons**
```swift
Button("Continue") { }
    .gentleButton(.primary)

Button("Cancel") { }
    .gentleButton(.secondary)
```

**Surfaces**
```swift
VStack {
    Text("Card content")
}
.gentleSurface(.card)
```

## Available Tokens

| Category | Options |
|----------|---------|
| **Text** | `largeTitle_xxl`, `title_xl`, `title2_l`, `title3_ml`, `headline_m`, `body_m`, `bodySecondary_m`, `monoCode_m`, `callout_ms`, `subheadline_ms`, `footnote_s`, `caption_s`, `caption2_s` |
| **Buttons** | `primary`, `secondary`, `tertiary`, `destructive` |
| **Surfaces** | `appBackground`, `card`, `cardElevated` |
| **Colors** | `textPrimary`, `textSecondary`, `textTertiary`, `background`, `surface`, `surfaceElevated`, `borderSubtle`, `primaryCTA`, `onPrimaryCTA`, `destructive` |
| **Spacing** | `xs`(4), `s`(8), `m`(12), `l`(16), `xl`(24), `xxl`(32) |
| **Radius** | `small`(8), `medium`(12), `large`(20), `pill`(999) |

## Requirements

- iOS 17+
- Swift 5.9+
