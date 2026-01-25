# Glossary

## Core Concepts

| Term | Definition |
|------|------------|
| **Token** | A named, semantic design value (not a literal). E.g., `textPrimary` not `#1F2933`. |
| **Role** | A semantic purpose for a token. E.g., `.body_m` is a text role, `.primary` is a button role. |
| **Spec** | `GentleDesignSystemSpec` - the complete, serializable token set. |
| **Theme** | `GentleTheme` - runtime object that resolves tokens to SwiftUI values. |
| **Ramp** | Size progression: xxl > xl > l > ml > m > ms > s |

## Key Types

| Type | Purpose |
|------|---------|
| `GentleDesignSystemSpec` | Top-level container for all tokens. Codable, versioned. |
| `GentleTheme` | Resolves tokens per ColorScheme and SizeCategory. |
| `GentleThemeManager` | Observable wrapper for theme with persistence. |
| `GentleThemeRoot` | View that injects theme into SwiftUI environment. |
| `GentleFileThemeSpecStore` | JSON file persistence to Application Support. |

## Role Types

| Type | What it defines |
|------|-----------------|
| `GentleTextRole` | Typography intent (17 roles) |
| `GentleColorRole` | Color intent (17 roles) |
| `GentleButtonRole` | Button style intent (5 roles) |
| `GentleButtonFillRole` | Button fill strategy (solidFillPrimaryCTA, solidFillDestructive, hollow) |
| `GentleButtonAnimationRole` | Button animation feel (6 roles) |
| `GentleSurfaceRole` | Container/background intent (9 roles: appBackground, card, cardElevated, cardSecondary, chrome, overlaySheet, overlayPopover, floatingPanel, floatingWidget) |
| `GentleSurfaceBackgroundStyle` | Surface background type: .solid(colorRole:), .material(material:tintColorRole:tintOpacity:), .glass(fallbackMaterial:fallbackColorRole:) |
| `GentleAppleMaterial` | Apple's blur materials: noMaterial, ultraThin, thin, regular, thick, ultraThick, bar |
| `GentleSpecularEffect` | Specular highlight types: noEffect, indent, highlight |
| `GentleVisualEffect` | Legacy visual effect type (appBackground, surface, surfaceOverlay) |
| `GentleInsetRole` | Padding intent (4 roles) |
| `GentleGapIntent` | Spacing intent (7 levels) |

## Spec Types (Token Storage)

| Type | Contents |
|------|----------|
| `GentleColorTokens` | Map of role → `GentleColorPair` (light/dark hex) |
| `GentleTypographyTokens` | Map of role → `GentleTypographyRoleSpec` |
| `GentleButtonTokens` | Map of role → `GentleButtonRoleSpec` + animations |
| `GentleSurfaceTokens` | Map of role → `GentleSurfaceRoleSpec` (backgroundStyle, specular, border, shadow) |
| `GentleLayoutTokens` | Spacing scales, gaps, insets |
| `GentleVisualTokens` | Radii, shadows |

## Property Wrappers

| Wrapper | Provides |
|---------|----------|
| `@GentleDesignRuntime` | Resolved theme + colorScheme (read-only access) |
| `@GentleThemeManagerRuntime` | GentleThemeManager (for editing/saving) |

## View Modifiers

| Modifier | Applies |
|----------|---------|
| `.gentleText(_:colorRole:)` | Typography (font, color, spacing) |
| `.gentleTextField(_:colorRole:chrome:)` | Input field styling |
| `.gentleSurface(_:)` | Container background, border, shadow |
| `.gentleButton(_:)` | Button style |
| `.gentleButton(_:shape:)` | Button style with shape override |
| `.gentleInset(_:)` | Semantic padding |
| `.gentleBackground(_:ignoresSafeArea:)` | Background color |

## Persistence

| Term | Definition |
|------|------------|
| `defaultSpec` | Immutable baseline spec (shipped with package) |
| `editableSpec` | User-modified spec (persisted separately) |
| `activeSpec` | Currently rendered spec (returns editableSpec) |
| Application Support | iOS directory for app data; where themes persist |

## Dynamic Type

| Term | Definition |
|------|------------|
| `relativeTo` | Semantic text style anchor for scaling |
| `UIFontMetrics` | Apple API for Dynamic Type scaling |
| `ContentSizeCategory` | User's preferred text size setting |

## UI Components

| Component | Purpose |
|-----------|---------|
| `GentleThemeEditor` | Interactive editor for colors, typography, buttons, surfaces |
| `GentleDesignStudioView` | Full design studio with save/revert/share toolbar |
| `TypographyRoleEditor` | Edits one typography role |
| `ColorRoleEditor` | Edits one color role |
| `GentleNavigationBarStyler` | Applies theme to UINavigationBar |
