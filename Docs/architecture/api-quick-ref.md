# API Quick Reference

All public APIs at a glance, organized by usage pattern.

---

## View Modifiers

### Typography

```swift
// Apply typography role with optional color override
.gentleText(_ role: GentleTextRole, colorRole: GentleColorRole? = nil)

// Examples:
Text("Hello").gentleText(.body_m)
Text("Subtle").gentleText(.caption_s, colorRole: .textTertiary)
```

### Text Fields

```swift
// Style text input with chrome option
.gentleTextField(_ role: GentleTextRole,
                 colorRole: GentleColorRole? = nil,
                 chrome: GentleTextChrome = .standalone())

// Chrome options:
// .standalone(shape: .rounded)  - draws own container
// .standalone(shape: .pill)     - pill-shaped container
// .formRow                      - assumes Form/List provides chrome
// .borderless                   - no container chrome

// Examples:
TextField("Name", text: $name).gentleTextField(.body_m)
TextField("Search", text: $query).gentleTextField(.body_m, chrome: .standalone(shape: .pill))
```

### Surfaces

```swift
// Apply surface styling (background, border, shadow, corner radius)
.gentleSurface(_ role: GentleSurfaceRole)

// Roles: .appBackground, .card, .cardElevated, .surfaceOverlay

// Example:
VStack { content }.gentleSurface(.card)
```

### Buttons

```swift
// Basic button styling
.gentleButton(_ role: GentleButtonRole)

// With shape override
.gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape)

// With text role override
.gentleButton(_ role: GentleButtonRole, textRole: GentleTextRole)

// With both overrides
.gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape, textRole: GentleTextRole)

// Roles: .primary, .secondary, .tertiary, .quaternary, .destructive
// Shapes: .rounded, .pill

// Examples:
Button("Save") { }.gentleButton(.primary)
Button("Cancel") { }.gentleButton(.secondary, shape: .rounded)
```

### Layout

```swift
// Semantic padding based on context
.gentleInset(_ role: GentleInsetRole,
             variant: GentleInsetVariant = .regular,
             edges: Edge.Set = .all)

// Roles: .screen, .card, .control, .listRow
// Variants: .tight, .regular, .roomy

// Examples:
VStack { }.gentleInset(.screen)
HStack { }.gentleInset(.card, variant: .tight)
```

### Background

```swift
// Apply solid background color
.gentleBackground(_ role: GentleColorRole, ignoresSafeArea: Bool = false)

// Example:
VStack { }.gentleBackground(.background, ignoresSafeArea: true)
```

### Font Width (iOS 17+)

```swift
// Apply font width
.gentleFontWidth(_ width: GentleFontWidthToken)

// Widths: .compressed, .condensed, .standard, .expanded
```

---

## Property Wrappers

### @GentleDesignRuntime (Read-Only Access)

```swift
@GentleDesignRuntime private var design

// Color access
design.color(.textPrimary)      // Color for current scheme
design.color(.primaryCTA)       // Color

// Convenience colors
design.surface                  // color(.surface)
design.background               // color(.background)
design.borderSubtle             // color(.borderSubtle)
design.textPrimary              // color(.textPrimary)
design.themePrimary             // color(.themePrimary)

// Layout access
design.layout.stack.regular     // CGFloat (gap for stacks)
design.layout.stack.tight       // CGFloat
design.layout.list.ample        // CGFloat
design.layout.grid.m            // CGFloat (raw value)
design.layout.gap.value(.l)     // CGFloat (by token)

// Visual tokens
design.radii.small              // Double (8)
design.radii.medium             // Double (12)
design.radii.large              // Double (20)
design.radii.pill               // Double (999)
design.shadows.small            // Double (2)
design.shadows.medium           // Double (6)

// Component tokens
design.buttons                  // GentleButtonTokens
design.surfaces                 // GentleSurfaceTokens
```

### @GentleThemeManagerRuntime (Editing Access)

```swift
@GentleThemeManagerRuntime private var manager

// Persistence
try manager.save()              // Save to disk
try manager.load()              // Load from disk
try manager.reset()             // Reset to defaults

// Preset management
try manager.selectPreset(name: "Classic Tan", defaultSpec: preset.spec)
manager.hasEditableSpec(forPreset: "Classic Tan")  // Bool
manager.currentPresetName       // String?
manager.hasUnsavedChanges       // Bool

// Export
let url = try manager.exportURL()  // Temp JSON file URL

// Bindings for editing
manager.bindingForTypographyRole(.body_m)   // Binding<GentleTypographyRoleSpec>
manager.bindingForButtonRole(.primary)       // Binding<GentleButtonRoleSpec>
manager.bindingForSurfaceRole(.card)         // Binding<GentleSurfaceRoleSpec>
manager.bindingForColorRole(.primaryCTA)     // Binding<GentleColorPair>
```

---

## Theme Setup

### Basic Setup

```swift
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

### With Theme Manager (for editing/persistence)

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

### With Custom Store

```swift
let store = GentleFileThemeSpecStore(fileName: "my-theme.json")
let manager = GentleThemeManager(theme: .default, store: store)
```

---

## Direct Theme Access

```swift
@Environment(\.gentleTheme) var theme
@Environment(\.colorScheme) var colorScheme

// Color resolution
theme.color(for: .textPrimary, scheme: colorScheme)

// Typography resolution
theme.textStyle(for: .body_m, sizeCategory: sizeCategory)

// Material resolution
theme.material(for: .surface)

// Token access
theme.layout          // GentleLayoutTokens
theme.visual          // GentleVisualTokens
theme.buttons         // GentleButtonTokens
theme.surfaces        // GentleSurfaceTokens
theme.radii           // GentleRadiusTokens
theme.shadows         // GentleShadowTokens
theme.gap             // GentleGapTokens
theme.inset           // GentleInsetTokens

// Inset resolution
theme.insetValue(.card, variant: .regular, edges: .all)  // (horizontal: CGFloat?, vertical: CGFloat?)
```

---

## JSON Encoding/Decoding

```swift
// Encoding
let jsonData = try spec.encodedJSONData()
let jsonString = try spec.encodedJSONString()

// Decoding
let spec = try GentleDesignSystemSpec(jsonData: data)
let spec = try GentleDesignSystemSpec(jsonString: string)
```

---

## Presets

```swift
// Get all presets
let presets = GentleDesignSystemSpec.allPresets  // [GentleThemePreset]

// Each preset has:
preset.name              // "Gentle Default"
preset.summary           // Brief tagline
preset.description       // Detailed explanation
preset.purpose           // When to use
preset.systemImageString // SF Symbol name
preset.spec              // GentleDesignSystemSpec
```

---

## Role Enums Quick Reference

### GentleTextRole (17)
```
largeTitle_xxl, title_xl, title2_l, title3_ml,
headline_m, body_m, bodySecondary_m, monoCode_m,
primaryButtonTitle_m, secondaryButtonTitle_m, tertiaryButtonTitle_m, quaternaryButtonTitle_m,
callout_ms, subheadline_ms,
footnote_s, caption_s, caption2_s
```

### GentleColorRole (17)
```
textPrimary, textSecondary, textTertiary,
textOnPrimaryCTA, textOnDestructive, textOnOverlay, textOnOverlaySecondary,
background, surfaceBase, surfaceOverlay, surfaceTint, surfaceSpecular, borderSubtle,
primaryCTA, destructive,
themePrimary, themeSecondary
```

**Semantic Groupings:**
- `.textRoles` (7) - text/foreground colors
- `.surfaceRoles` (6) - container/background/border colors
- `.actionRoles` (2) - interactive element colors
- `.themeRoles` (2) - brand/accent colors

**Membership checks:** `role.isTextRole`, `.isSurfaceRole`, `.isActionRole`, `.isThemeRole`

### GentleButtonRole (5)
```
primary, secondary, tertiary, quaternary, destructive
```

### GentleSurfaceRole (9)
```
appBackground, card, cardElevated, cardSecondary,
chrome, overlaySheet, overlayPopover,
floatingPanel, floatingWidget
```

### GentleSpacingToken (6)
```
xs (4), s (8), m (12), l (16), xl (24), xxl (32)
```

### GentleGapIntent (7)
```
unknown (0), micro (xs), tight (s), regular (m), ample (l), loose (xl), expansive (xxl)
```
