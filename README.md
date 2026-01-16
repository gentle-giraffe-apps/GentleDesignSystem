# GentleDesignSystem
[![CI](https://github.com/gentle-giraffe-apps/GentleDesignSystem/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/gentle-giraffe-apps/GentleDesignSystem/actions/workflows/ci.yml)
[![Swift](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
![iOS](https://img.shields.io/badge/iOS-18.0+-blue?logo=apple)
![SwiftUI First](https://img.shields.io/badge/SwiftUI-First-4A6EF5)
![Platform](https://img.shields.io/badge/Platform-iPhone%20%7C%20iPad-lightgrey)
![SPM](https://img.shields.io/badge/SPM-Compatible-success)

A token-driven SwiftUI design system with Dark Mode + Dynamic Type—built to feel *native*, *predictable*, and *composable*, while giving you a centralized way to evolve typography, color, spacing, and surface behavior over time.

**Who is this for?** Apps that want a strong SwiftUI foundation and theme evolution without rewriting view code.

💬 **[Join the discussion. Feedback and questions welcome](https://github.com/gentle-giraffe-apps/GentleDesignSystem/discussions)**

![Demo animation](docs/README_assets/Typography.gif)

**See it in action:** Open `Demo/GentleDesignSystemDemo.xcodeproj` to explore the components. The demo app also supports editing and sharing JSON specs via the system Share Sheet.

<img src="docs/README_assets/Typography1.png" alt="GentleDesignSystem demo – page 1" width="800" />
<img src="docs/README_assets/Typography2.png" alt="GentleDesignSystem demo – page 2" width="800" />
<img src="docs/README_assets/Typography3.png" alt="GentleDesignSystem demo – page 3" width="800" />

---

## Quick Start

### 1. Add the Package

```swift
.package(url: "https://github.com/gentle-giraffe-apps/GentleDesignSystem.git", from: "0.1.3")
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

### System Architecture

```mermaid
flowchart TB
    subgraph Tokens["Token Layer (Design-Time)"]
        Spec[GentleDesignSystemSpec]
        Spec --> Colors[GentleColorTokens]
        Spec --> Typography[GentleTypographyTokens]
        Spec --> Layout[GentleLayoutTokens]
        Spec --> Visual[GentleVisualTokens]
        Spec --> Buttons[GentleButtonTokens]
    end

    subgraph Runtime["Runtime Layer"]
        Theme[GentleTheme]
        Manager[GentleThemeManager]
        Store[GentleFileThemeSpecStore]
        Manager --> Theme
        Store -.->|load/save| Manager
    end

    subgraph SwiftUI["SwiftUI Layer"]
        Root[GentleThemeRoot]
        Env[Environment Values .gentleTheme]
        Modifiers[View Modifiers]
        Root --> Env
        Env --> Modifiers
    end

    Tokens --> Runtime
    Runtime --> SwiftUI
```

### Data Flow

```mermaid
flowchart TB
    JSON[(JSON File)] -->|load| Store[GentleFileThemeSpecStore]
    Store --> Manager[GentleThemeManager]
    Manager --> Theme[GentleTheme]
    Theme --> Resolve{Resolution}

    Resolve -->|ColorScheme| ResolvedColor[Color]
    Resolve -->|ContentSizeCategory| ResolvedFont[Font]

    ResolvedColor --> View[SwiftUI View]
    ResolvedFont --> View

    View -->|.gentleText| Text
    View -->|.gentleButton| Button
    View -->|.gentleSurface| Surface
```

### Data Model

The design system is defined by a single JSON-friendly specification
(`GentleDesignSystemSpec`). The diagram below shows the structure of that
spec and how token groups are organized.

```
GentleDesignSystemSpec
│
├── colors: GentleColorTokens
│       │
│       └── pairByRole: [String: GentleColorPair]
│               │
│               ├── key = GentleColorRole.rawValue
│               └── value = GentleColorPair
│                       ├── lightHex: String
│                       └── darkHex:  String
│
├── typography: GentleTypographyTokens
│       │
│       └── roles: [String: GentleTypographyRoleSpec]
│               │
│               ├── key = GentleTextRole.rawValue
│               └── value = GentleTypographyRoleSpec
│                       ├── pointSize: Double
│                       ├── weight: GentleFontWeightToken
│                       ├── design: GentleFontDesignToken
│                       ├── width:  GentleFontWidthToken?
│                       ├── relativeTo: GentleFontTextStyle
│                       ├── lineSpacing: Double
│                       ├── letterSpacing: Double
│                       ├── isUppercased: Bool
│                       └── colorRole: GentleColorRole
│
├── layout: GentleLayoutTokens
│       │
│       ├── scale: GentleSpacingScaleTokens
│       │       ├── xs / s / m / l / xl / xxl : Double
│       │       └── value(for: GentleSpacingToken) -> Double
│       │
│       ├── gap:   GentleGapTokens
│       ├── grid:  GentleGridSpacingTokens
│       ├── touch: GentleTouchTokens
│       │
│       └── inset: GentleInsetTokens
│               │
│               └── tokensByRole: [String: GentleAxisInsetTokens]
│                       │
│                       ├── key = GentleInsetRole.rawValue
│                       └── value = GentleAxisInsetTokens
│                               ├── horizontal: GentleSpacingToken
│                               └── vertical:   GentleSpacingToken
│
├── visual: GentleVisualTokens
│       │
│       ├── radii: GentleRadiusTokens
│       │       ├── small:  Double
│       │       ├── medium: Double
│       │       ├── large:  Double
│       │       └── pill:   Double
│       │
│       └── shadows: GentleShadowTokens
│               ├── none:   Double
│               ├── small:  Double
│               └── medium: Double
│
└── buttons: GentleButtonTokens
        │
        ├── roles: [String: GentleButtonRoleSpec]
        │       │
        │       ├── key = GentleButtonRole.rawValue
        │       └── value = GentleButtonRoleSpec
        │               ├── shape: GentleButtonShape
        │               ├── textRole: GentleTextRole
        │               ├── backgroundRole: GentleColorRole
        │               ├── labelColorRole: GentleColorRole
        │               ├── borderRole: GentleColorRole?
        │               ├── animationRole: GentleButtonAnimationRole
        │               ├── pressedScale: Double
        │               └── pressedOpacity: Double
        │
        └── animations: [String: GentleButtonAnimationSpec]
                │
                ├── key = GentleButtonAnimationRole.rawValue
                └── value = GentleButtonAnimationSpec
                        ├── pressedScale: Double
                        ├── pressedOpacity: Double
                        ├── duration: Double
                        ├── springResponse: Double
                        ├── springDamping: Double
                        └── springBlend: Double
```

> **Why roles instead of direct values?**  
> Roles provide stable identifiers that allow themes to evolve safely over time.
> Specs can change, presets can swap, and values can be overridden without
> breaking call sites or serialized themes.

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

## 6. Theme Presets

GentleDesignSystem includes 9 built-in theme presets, each designed for different use cases and aesthetics.

### Accessing Presets

```swift
// Get all available presets
let presets = GentleDesignSystemSpec.allPresets

// Each preset provides:
// - name: Display name (e.g., "Gentle Default")
// - summary: Brief tagline
// - description: Detailed explanation
// - purpose: When to use this preset
// - systemImageString: SF Symbol name for UI
// - spec: The actual GentleDesignSystemSpec
```

### Available Presets

| Preset | Summary | Best For |
|--------|---------|----------|
| **Gentle Default** | Calm, balanced foundation | Versatile starting point with clean hierarchy |
| **Classic Tan** | Warm, timeless with earthy tones | Apps benefiting from warmth and heritage |
| **Modern Gray** | Sleek, minimal with neutral foundations | Business apps where clarity is paramount |
| **Soft Green** | Fresh, natural with calming accents | Wellness, productivity, calm focus |
| **Editorial Paper** | Refined, print-inspired reading | Content-heavy apps, long-form reading |
| **Technical Blue** | Precise, trustworthy with blue highlights | Developer tools, dashboards |
| **Bold Orange** | Vibrant, energetic with strong presence | Apps that motivate action |
| **Elegant Purple** | Sophisticated, luxurious with rich tones | Lifestyle, creative, premium apps |
| **Compact Mint** | Dense, efficient with fresh accents | Data-rich interfaces |

### Using Presets

```swift
// Apply a preset to your theme manager
@GentleThemeManagerRuntime private var manager

// Find and apply a preset
if let editorialPreset = GentleDesignSystemSpec.allPresets.first(where: { $0.name == "Editorial Paper" }) {
    manager.theme.editableSpec = editorialPreset.spec
}
```

### Building a Theme Picker

The demo app includes a `ThemePickerView` that displays all presets as interactive cards. Each card previews the preset's typography and colors using the preset's own theme:

```swift
ForEach(presets, id: \.name) { preset in
    let previewTheme = GentleTheme(
        defaultSpec: preset.spec,
        editableSpec: preset.spec
    )

    Button {
        themeManager.theme.editableSpec = preset.spec
    } label: {
        GentleThemeRoot(theme: previewTheme) {
            // Card content renders with the preset's own styling
            ThemePresetCard(preset: preset)
        }
    }
}
```

---

## Available Tokens

### Typography Roles

13 semantic text roles organized by size ramp (xxl > xl > l > ml > m > ms > s):

| Ramp | Roles |
|------|-------|
| XXL | `largeTitle_xxl` |
| XL | `title_xl` |
| L | `title2_l` |
| ML | `title3_ml` |
| M | `headline_m`, `body_m`, `bodySecondary_m`, `monoCode_m` |
| MS | `callout_ms`, `subheadline_ms` |
| S | `footnote_s`, `caption_s`, `caption2_s` |

Each role resolves to a `GentleTypographyRoleSpec` containing: `pointSize`, `weight`, `design`, `width`, `relativeTo`, `lineSpacing`, `letterSpacing`, `isUppercased`, and `colorRole`.

### Button Roles

`primary` · `secondary` · `tertiary` · `quaternary` · `destructive`

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

`appBackground` · `card` · `cardChrome` (no padding) · `cardElevated` · `surfaceOverlay`

### Color Roles

| Category | Roles |
|----------|-------|
| Text | `textPrimary`, `textSecondary`, `textTertiary` |
| Surfaces | `background`, `surface`, `surfaceElevated`, `surfaceOverlay`, `onSurfaceOverlayPrimary`, `onSurfaceOverlaySecondary` |
| Actions | `primaryCTA`, `onPrimaryCTA`, `destructive` |
| Theme | `themePrimary`, `themeSecondary` |
| Structure | `borderSubtle` |

### Spacing Tokens

`xs` (4) · `s` (8) · `m` (12) · `l` (16) · `xl` (24) · `xxl` (32)

### Radius Tokens

`small` (8) · `medium` (12) · `large` (20) · `pill` (999)

---

## Requirements

- iOS 18.0+
- Swift 6.1+

---

## Tooling Note

Portions of drafting and editorial refinement in this repository were accelerated using large language models (including ChatGPT, Claude, and Gemini) under direct human design, validation, and final approval. All technical decisions, code, and architectural conclusions are authored and verified by the repository maintainer.

![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fgentle-giraffe-apps%2FGentleDesignSystem)
