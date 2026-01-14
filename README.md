# GentleDesignSystem
[![CI](https://github.com/gentle-giraffe-apps/GentleDesignSystem/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/gentle-giraffe-apps/GentleDesignSystem/actions/workflows/ci.yml)
[![Swift](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
![iOS](https://img.shields.io/badge/iOS-18.0+-blue?logo=apple)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Required-4A6EF5)
![Platform](https://img.shields.io/badge/Platform-iPhone%20%7C%20iPad-lightgrey)
![SPM](https://img.shields.io/badge/SPM-Compatible-success)


A lightweight, token-driven SwiftUI design system with built-in Dark Mode and Dynamic Type support.

💬 **[Join the discussion. Feedback and questions welcome](https://github.com/gentle-giraffe-apps/GentleDesignSystem/discussions)**

GentleDesignSystem is designed to feel *native*, *predictable*, and *composable*, while still giving you a centralized place to evolve typography, color, spacing, and surface behavior over time.

**See it in action:** Open `Demo/GentleDesignSystemDemo.xcodeproj` to explore all components.

<img src="Demo/README_assets/Typography1.png" alt="GentleDesignSystem demo – page 1" width="800" />
<img src="Demo/README_assets/Typography2.png" alt="GentleDesignSystem demo – page 2" width="800" />
<img src="Demo/README_assets/Typography3.png" alt="GentleDesignSystem demo – page 3" width="800" />

![Demo animation](Demo/README_assets/Typography.gif)

---

## Quick Start

### 1. Add the Package

```swift
.package(url: "https://github.com/gentle-giraffe-apps/GentleDesignSystem.git", branch: "main")
```

### 2. Wrap Your App Root

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

#### Typography
```swift
Text("Welcome")
    .gentleText(.title_xl)

Text("Description")
    .gentleText(.body_m, colorRole: .textSecondary)
```

#### Buttons
```swift
Button("Continue") { }
    .gentleButton(.primary)

Button("Cancel") { }
    .gentleButton(.secondary)
```

#### Surfaces
```swift
VStack {
    Text("Card content")
}
.gentleSurface(.card)
```

---

## Architecture Overview

GentleDesignSystem is intentionally structured around **three layers**:

1. **Token Definitions (Codable, JSON-friendly)**
2. **Runtime Resolution (Theme + Environment)**
3. **SwiftUI Ergonomics (Modifiers & Extensions)**

This separation keeps design intent clear, runtime behavior predictable, and future evolution safe.

---

## 1. Token Layer (Design-Time)

The token layer defines *what* your design system means — not how it is rendered.

### Token Categories

| Category | Types |
|----------|-------|
| **Typography** | `GentleTextRole`, `GentleTypographyRoleSpec`, `GentleTypographyTokens` |
| **Colors** | `GentleColorRole`, `GentleColorPair`, `GentleColorTokens` |
| **Layout** | `GentleLayoutTokens`, `GentleSpacingToken`, `GentleGapTokens`, `GentleInsetTokens` |
| **Visual** | `GentleVisualTokens`, `GentleRadiusTokens`, `GentleShadowTokens` |
| **Buttons** | `GentleButtonRole`, `GentleButtonRoleSpec`, `GentleButtonTokens`, `GentleButtonAnimationRole` |
| **Surfaces** | `GentleSurfaceRole` |

All tokens are:
- `Codable`
- `Sendable`
- JSON-friendly

This makes it easy to:
- Persist themes
- Load themes remotely
- Share tokens across platforms later

```swift
public struct GentleDesignSystemSpec: Codable, Sendable {
    public var specVersion: String
    public var colors: GentleColorTokens
    public var typography: GentleTypographyTokens
    public var layout: GentleLayoutTokens
    public var visual: GentleVisualTokens
    public var buttons: GentleButtonTokens
}
```

The default theme (`.default`) is simply one concrete spec.

---

## 2. Runtime Layer (Theme Resolution)

At runtime, tokens are resolved into **actual SwiftUI values**.

### GentleTheme

`GentleTheme`:
- Owns a `GentleDesignSystemSpec`
- Resolves:
  - Colors per `ColorScheme`
  - Fonts per `ContentSizeCategory` (Dynamic Type)

```swift
@Environment(\.gentleTheme) var theme
```

Typography resolution uses `UIFontMetrics` to correctly scale custom font sizes while remaining anchored to Apple's semantic text styles.

This ensures:
- Accessibility scaling works correctly
- Custom point sizes remain proportional
- Future Dynamic Type changes remain safe

### Property Wrappers

For convenient access to the theme in views:

```swift
// Access resolved theme values
@GentleDesignRuntime private var design

// Use in view
design.color(.textPrimary)    // Color for current scheme
design.layout.stack.regular   // CGFloat spacing value
design.buttons                // Button tokens
```

---

## 3. Environment Injection

### Why `GentleThemeRoot` Exists

SwiftUI environments flow **top-down**.

By wrapping your app root with:

```swift
GentleThemeRoot {
    ContentView()
}
```

you ensure that:

- All child views receive the same theme
- Previews behave consistently
- Theme overrides are easy later (per scene, per feature, per preview)

`GentleThemeRoot` is intentionally lightweight — it only injects a single environment value.

This avoids:
- Global singletons
- Static state
- Implicit magic

---

## 4. Modifiers & View Extensions

GentleDesignSystem exposes *ergonomic APIs* while keeping logic centralized.

### Text

```swift
Text("Hello")
    .gentleText(.headline_m)
```

Internally:
- Resolves typography via `GentleTheme`
- Applies font, width, design, spacing, color
- Honors Dynamic Type automatically

### Surfaces

```swift
VStack { ... }
    .gentleSurface(.card)
```

Surfaces apply:
- Background color
- Padding (when appropriate)
- Corner radius
- Borders or shadows

The role-based API avoids "magic numbers" leaking into views.

### Buttons

```swift
Button("Save") { }
    .gentleButton(.primary)
```

Buttons are:
- Styled via `ButtonStyle`
- Fully theme-driven
- Support configurable animations
- Easily extendable for new roles

---

## 5. Theme Management & Persistence

For apps that need runtime theme editing or persistence:

### GentleThemeManager

```swift
@main
struct MyApp: App {
    @State private var manager = GentleThemeManager(theme: .default)

    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: manager.theme) {
                ContentView()
            }
            .environment(\.gentleThemeManager, manager)
        }
    }
}
```

### Using the Manager

```swift
@GentleThemeManagerRuntime private var manager

// Save current theme to disk
try manager.save()

// Load persisted theme
try manager.load()

// Get bindings for editing
manager.typographyBinding(for: .body_m)
manager.colorBinding(for: .primaryCTA)
```

### Persistence

`GentleFileThemeSpecStore` handles JSON persistence to Application Support:

```swift
let store = GentleFileThemeSpecStore(fileName: "my-theme.json")
let manager = GentleThemeManager(theme: .default, store: store)
```

---

## Available Tokens

### Typography Roles

| Role | Ramp |
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

### Button Roles

- `primary`
- `secondary`
- `tertiary`
- `destructive`

### Button Animation Roles

| Animation | Description |
|-----------|-------------|
| `none` | No animation |
| `subtlePress` | Subtle press feedback |
| `squish` | Squish effect on press |
| `pop` | Pop effect |
| `bouncy` | Bouncy spring animation |
| `springBack` | Shrinks on press, springs back past original size before settling |

### Surface Roles

- `appBackground`
- `card`
- `cardChrome` (no padding)
- `cardElevated`
- `surfaceOverlay`

### Color Roles

| Category | Roles |
|----------|-------|
| **Text** | `textPrimary`, `textSecondary`, `textTertiary` |
| **Surfaces** | `background`, `surface`, `surfaceElevated`, `surfaceOverlay`, `onSurfaceOverlayPrimary`, `onSurfaceOverlaySecondary` |
| **Actions** | `primaryCTA`, `onPrimaryCTA`, `destructive` |
| **Theme** | `themePrimary`, `themeSecondary` |
| **Structure** | `borderSubtle` |

### Spacing Tokens

| Token | Value |
|------|-------|
| `xs` | 4 |
| `s` | 8 |
| `m` | 12 |
| `l` | 16 |
| `xl` | 24 |
| `xxl` | 32 |

### Radius Tokens

| Token | Value |
|------|-------|
| `small` | 8 |
| `medium` | 12 |
| `large` | 20 |
| `pill` | 999 |

---

## Requirements

- iOS 18.0+
- Swift 6.1+

---

## Tooling Note

Portions of drafting and editorial refinement in this repository were accelerated using large language models (including ChatGPT, Claude, and Gemini) under direct human design, validation, and final approval. All technical decisions, code, and architectural conclusions are authored and verified by the repository maintainer.
