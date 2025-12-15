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

### Typography

| Role | Size |
|-----|------|
| `largeTitle_xxl` | XXL |
| `title_xl` | XL |
| `title2_l` | L |
| `title3_ml` | ML |
| `headline_m` | M |
| `body_m` | M |
| `bodySecondary_m` | M |
| `monoCode_m` | M |
| `callout_ms` | MS |
| `subheadline_ms` | MS |
| `footnote_s` | S |
| `caption_s` | S |
| `caption2_s` | S |

### Buttons

| Style |
|-------|
| `primary` |
| `secondary` |
| `tertiary` |
| `destructive` |

### Surfaces

| Role |
|------|
| `appBackground` |
| `card` |
| `cardElevated` |

### Colors

| Role |
|------|
| `textPrimary` |
| `textSecondary` |
| `textTertiary` |
| `background` |
| `surface` |
| `surfaceElevated` |
| `borderSubtle` |
| `primaryCTA` |
| `onPrimaryCTA` |
| `destructive` |

### Spacing

| Token | Value |
|------|-------|
| `xs` | 4 |
| `s` | 8 |
| `m` | 12 |
| `l` | 16 |
| `xl` | 24 |
| `xxl` | 32 |

### Radius

| Token | Value |
|------|-------|
| `small` | 8 |
| `medium` | 12 |
| `large` | 20 |
| `pill` | 999 |

## Requirements

- iOS 17+
- Swift 5.9+

---

## 🤖 Tooling Note

Portions of drafting and editorial refinement in this repository were accelerated using large language models (including ChatGPT, Claude, and Gemini) under direct human design, validation, and final approval. All technical decisions, code, and architectural conclusions are authored and verified by the repository maintainer.
