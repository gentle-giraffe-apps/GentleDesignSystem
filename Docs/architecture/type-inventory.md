# Type Inventory

Complete mapping of every public type to its file location, kind, and purpose.

## GentleDesignSystem.swift (~1575 lines)

### Constants

| Type | Kind | Purpose |
|------|------|---------|
| `GentleDesignSystemSpecVersion` | enum | Contains `current` version string ("0.4.0") |

### Role Enums

| Type | Kind | Cases | Purpose |
|------|------|-------|---------|
| `GentleTextRole` | enum | 17 | Typography semantic roles (largeTitle_xxl → caption2_s + 4 button titles) |
| `GentleTextRamp` | enum | 7 | Size progression: xxl, xl, l, ml, m, ms, s |
| `GentleColorRole` | enum | 17 | Color semantic roles (text, surface, action, theme, border) |
| `GentleButtonRole` | enum | 5 | Button style intent: primary, secondary, tertiary, quaternary, destructive |
| `GentleButtonMaterialRole` | enum | 3 | Button fill: solidFillPrimaryCTA, solidFillDestructive, hollow |
| `GentleButtonBorderRole` | enum | 3 | Button border: hidden, accent, subtle |
| `GentleButtonShape` | enum | 2 | Button geometry: rounded, pill |
| `GentleButtonAnimationRole` | enum | 6 | Animation intent: unknown, subtlePress, squish, pop, bouncy, springBack |
| `GentleTextFieldShape` | enum | 2 | Input shape: rounded, pill |
| `GentleTextChrome` | enum | 3 | Input container: standalone, formRow, borderless |
| `GentleGapIntent` | enum | 7 | Spacing intent: unknown, micro, tight, regular, ample, loose, expansive |
| `GentleFontTextStyle` | enum | 11 | Dynamic Type anchors (largeTitle → caption2) |
| `GentleFontDesignToken` | enum | 4 | Font design: default, serif, rounded, monospaced |
| `GentleFontWidthToken` | enum | 4 | Font width: compressed, condensed, standard, expanded |
| `GentleFontWeightToken` | enum | 9 | Font weight: ultraLight → black |
| `GentleSpacingToken` | enum | 6 | Spacing scale: xs, s, m, l, xl, xxl |
| `GentleInsetRole` | enum | 4 | Padding context: screen, card, control, listRow |
| `GentleInsetVariant` | enum | 3 | Padding density: tight, regular, roomy |

### Spec Structs (Token Storage)

| Type | Kind | Key Properties | Purpose |
|------|------|----------------|---------|
| `GentleDesignSystemSpec` | struct | specVersion, colors, typography, layout, visual, buttons, surfaces | Root container, JSON-serializable |
| `GentleColorPair` | struct | lightHex, darkHex | Light/dark color pair |
| `GentleColorTokens` | struct | pairByRole: [String: GentleColorPair] | Color role → pair mapping |
| `GentleTypographyRoleSpec` | struct | pointSize, weight, design, width, relativeTo, lineSpacing, letterSpacing, isUppercased, colorRole | Single typography definition |
| `GentleTypographyTokens` | struct | roles: [String: GentleTypographyRoleSpec] | Typography role mapping |
| `GentleButtonAnimationSpec` | struct | pressedScale, pressedOpacity, duration, springResponse, springDamping, springBlend | Animation tuning |
| `GentleButtonRoleSpec` | struct | shape, materialRole, borderRole, animationRole, pressedScale, pressedOpacity, usesNativeStyle | Button style definition |
| `GentleButtonTokens` | struct | roles, animations | Button roles + animation specs |
| `GentleSpacingScaleTokens` | struct | xs, s, m, l, xl, xxl (all Double) | 6-step spacing scale |
| `GentleAxisInsetTokens` | struct | horizontal, vertical (GentleSpacingToken) | H/V inset pair |
| `GentleInsetTokens` | struct | tokensByRoleVariant: [String: [String: GentleAxisInsetTokens]] | Nested inset storage |
| `GentleLayoutTokens` | struct | scale, gap, grid, touch, inset | All layout tokens |
| `GentleRadiusTokens` | struct | small, medium, large, pill (all Double) | Corner radius values |
| `GentleShadowTokens` | struct | none, small, medium (all Double) | Shadow depth values |
| `GentleVisualTokens` | struct | radii, shadows | Visual appearance tokens |

### Runtime Types

| Type | Kind | Key Properties/Methods | Purpose |
|------|------|------------------------|---------|
| `GentleTheme` | struct | defaultSpec, editableSpec, activeSpec | Runtime theme resolver |
| `GentleResolvedTextStyle` | struct | font, design, colorRole, lineSpacing, letterSpacing, isUppercased | Resolved typography output |
| `GentleGapScaleFacade` | struct | xs, s, m, l, xl, xxl + micro, tight, regular, ample, loose, expansive | Ergonomic gap access |
| `GentleLayoutFacade` | struct | gap, stack, list, grid, touch, inset | Ergonomic layout access |

### SwiftUI Integration

| Type | Kind | Purpose |
|------|------|---------|
| `GentleThemeRoot<Content>` | View | Injects theme into SwiftUI environment |
| `GentleButtonStyle` | ButtonStyle | Full button rendering with animations |
| `GentleButtonAnimations` | enum | Static animation resolver (MainActor) |
| `GentleDesignRuntime` | @propertyWrapper | Read-only theme + colorScheme access |
| `GentleDesignRuntime.Resolver` | struct | Provides color(), layout, visual, buttons, surfaces |

### Theme Management

| Type | Kind | Key Methods | Purpose |
|------|------|-------------|---------|
| `GentleThemeManager` | @Observable @MainActor class | load(), save(), reset(), selectPreset(), bindingFor*() | Theme editing and persistence |
| `GentleThemeManagerRuntime` | @propertyWrapper | wrappedValue: GentleThemeManager | Manager environment access |

---

## GentleSurfaceRole.swift (~317 lines)

| Type | Kind | Cases/Properties | Purpose |
|------|------|------------------|---------|
| `GentleSurfaceRole` | enum | 9: appBackground, card, cardElevated, cardSecondary, chrome, overlaySheet, overlayPopover, floatingPanel, floatingWidget | Surface semantic roles |
| `GentleAppleMaterial` | enum | 7: noMaterial, ultraThin, thin, regular, thick, ultraThick, bar | Apple's built-in blur materials |
| `GentleSpecularEffect` | enum | 3: noEffect, indent, highlight | Specular highlight effects for depth cues |
| `GentleSurfaceBackgroundStyle` | enum | 3: solid(colorRole: GentleColorRole), material(material:tintColorRole:tintOpacity:), glass(fallbackMaterial:fallbackColorRole:) | Mutually exclusive background rendering styles |
| `GentleSurfaceRoleSpec` | struct | backgroundStyle, specularEffect, specularStrength, border, cornerRadius, borderWidth, shadow* | Surface style definition |
| `GentleSurfaceTokens` | struct | roles: [String: GentleSurfaceRoleSpec] | Surface role mapping |

---

## GentleDesignMaterial.swift (~255 lines)

| Type | Kind | Cases/Properties | Purpose |
|------|------|------------------|---------|
| `GentleDesignMaterialRole` | enum | 3: appBackground, surface, surfaceOverlay | Material semantic roles |
| `GentleMaterialBaseSpec` | enum | 4: solid(GentleColorPair), appleMaterial(GentleAppleMaterialSpec), blur(GentleBlurSpec), glass(GentleGlassSpec) | Material base type |
| `GentleDesignMaterial` | struct | id, base, tint, specular, innerEdges | Complete material recipe |
| `GentleAppleMaterialSpec` | struct | material (String), opacity | SwiftUI Material config |
| `GentleBlurSpec` | struct | radius, backgroundOnly, opacity | Custom blur parameters |
| `GentleGlassSpec` | struct | tintColor, tintOpacity | iOS 26 liquid glass config |
| `GentleSpecularSpec` | struct | colorPair, opacity, cornerRadius + Corner nested struct | Rim highlight config |
| `GentleInnerEdgeSpec` | struct | colorPair, opacity, width, edges | Inner edge highlight |

---

## GentleDesignModifiers.swift (~370 lines)

| Type | Kind | Parameters | Purpose |
|------|------|------------|---------|
| `GentleTextModifier` | ViewModifier | role, colorRoleOverride | Typography application |
| `GentleTextFieldModifier` | ViewModifier | textRole, colorRole, chrome | Text input styling |
| `GentleSurfaceModifier` | ViewModifier | role | Surface rendering (material, border, shadow) |
| `GentleBackgroundModifier` | ViewModifier | colorRole, ignoresSafeArea | Background color application |
| `GentleInsetModifier` | ViewModifier | role, variant, edges | Semantic padding |
| `GentleMaterialView` | View | material, scheme | Material background rendering |

### View Extensions

| Extension | Signature |
|-----------|-----------|
| `.gentleText()` | `(_ role: GentleTextRole, colorRole: GentleColorRole? = nil)` |
| `.gentleTextField()` | `(_ role: GentleTextRole, colorRole: GentleColorRole? = nil, chrome: GentleTextChrome = .standalone())` |
| `.gentleSurface()` | `(_ role: GentleSurfaceRole)` |
| `.gentleButton()` | `(_ role: GentleButtonRole)` |
| `.gentleButton()` | `(_ role: GentleButtonRole, shape: GentleButtonShape)` |
| `.gentleButton()` | `(_ role: GentleButtonRole, textRole: GentleTextRole)` |
| `.gentleButton()` | `(_ role: GentleButtonRole, shape: GentleButtonShape, textRole: GentleTextRole)` |
| `.gentleInset()` | `(_ role: GentleInsetRole, variant: GentleInsetVariant = .regular, edges: Edge.Set = .all)` |
| `.gentleBackground()` | `(_ role: GentleColorRole, ignoresSafeArea: Bool = false)` |
| `.gentleFontWidth()` | `(_ width: GentleFontWidthToken)` (iOS 17+) |

---

## GentleDesignPersistence.swift (~155 lines)

| Type | Kind | Key Methods | Purpose |
|------|------|-------------|---------|
| `GentleJSONEncodable` | protocol | encodedJSONData(), encodedJSONString() | Pretty JSON encoding |
| `GentleJSONDecodable` | protocol | init(jsonData:), init(jsonString:) | JSON decoding with fallback |
| `GentleThemeSpecStore` | protocol | loadEditableSpec(), saveEditableSpec(), clearEditableSpec(), hasEditableSpec(forPreset:) | Theme storage interface |
| `GentleFileThemeSpecStore` | struct | fileName, baseURL | File-based JSON storage to Application Support |

---

## GentleDesignSystemSpec+Presets.swift (~665 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `GentleThemePreset` | struct | name, summary, description, purpose, systemImageString, spec |
| `GentleDesignSystemSpec.allPresets` | static [GentleThemePreset] | 9 built-in presets |

### Available Presets
- Gentle Default
- Classic Tan
- Modern Gray
- Soft Green
- Editorial Paper
- Technical Blue
- Bold Orange
- Elegant Purple
- Compact Mint

---

## GentleUIKitTheming.swift (~155 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `GentleNavigationBarStyler` | View | Applies theme to UINavigationBar via UIAppearance |

---

## GentleThemeEditor.swift (~1120 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `GentleThemeEditor` | View | Full theme editor UI (colors, typography, buttons, surfaces) |

---

## ColorRoleEditor.swift (~460 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `ColorRoleEditor` | View | Collapsible color role editor with hex input and color picker |

---

## TypographyRoleEditor.swift (~450 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `TypographyRoleEditor` | View | Collapsible typography role editor |

---

## GentleDesignStudioView.swift (~140 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `GentleDesignStudioView` | View | Full design studio with save/revert/share toolbar |

---

## GentleDesignCustomizeView.swift (~150 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `GentleDesignCustomizeView` | View | Section-based customization view |

---

## GentleDesignShareSheet.swift (~25 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `GentleDesignShareSheet` | View | UIActivityViewController wrapper for theme export |

---

## String+camelCaseBreakable.swift (~15 lines)

| Type | Kind | Purpose |
|------|------|---------|
| `String.camelCaseBreakable` | computed property | Inserts zero-width breaks for text wrapping at camelCase boundaries |
