# Design Tokens

## Philosophy

Tokens are the **semantic vocabulary** of the design system. They separate *intent* from *implementation*.

```swift
// Intent (token)
.gentleText(.body_m)

// Implementation (resolved at runtime)
Font.system(size: scaledSize, weight: .regular, design: .default)
```

## Token Hierarchy

```
GentleDesignSystemSpec (top-level, versioned)
├── colors: GentleColorTokens
│   └── pairByRole: [String: GentleColorPair]  # lightHex, darkHex
├── typography: GentleTypographyTokens
│   └── roles: [String: GentleTypographyRoleSpec]
├── layout: GentleLayoutTokens
│   ├── scale: GentleSpacingScaleTokens  # xs, s, m, l, xl, xxl
│   ├── gap: GentleGapTokens
│   ├── grid: GentleGridSpacingTokens
│   ├── touch: GentleTouchTokens
│   └── inset: GentleInsetTokens
├── visual: GentleVisualTokens
│   ├── radii: GentleRadiusTokens
│   └── shadows: GentleShadowTokens
├── buttons: GentleButtonTokens
│   ├── roles: [String: GentleButtonRoleSpec]
│   └── animations: [String: GentleButtonAnimationSpec]
└── surfaces: GentleSurfaceTokens
    └── roles: [String: GentleSurfaceRoleSpec]
```

## JSON Schema Notes

- All role enums use `rawValue` as JSON keys
- Colors stored as hex strings: `#RRGGBB` or `#RRGGBBAA`
- Spec has `_specVersion` key for migration compatibility
- All numeric values are `Double` for JSON compatibility

## Role Enums

### GentleTextRole (17 roles)
```
largeTitle_xxl, title_xl, title2_l, title3_ml,
headline_m, body_m, bodySecondary_m, monoCode_m,
primaryButtonTitle_m, secondaryButtonTitle_m, tertiaryButtonTitle_m, quaternaryButtonTitle_m,
callout_ms, subheadline_ms,
footnote_s, caption_s, caption2_s
```

Naming: `{semantic}_{ramp}` where ramp = xxl > xl > l > ml > m > ms > s

### GentleColorRole (17 roles)
```
Text:     textPrimary, textSecondary, textTertiary, onPrimaryCTA
Surface:  background, surface, surfaceTint, surfaceSpecular
          surfaceOverlay, onSurfaceOverlayPrimary, onSurfaceOverlaySecondary
Action:   primaryCTA, destructive
Theme:    themePrimary, themeSecondary
Border:   borderSubtle
```

### GentleButtonRole (5 roles)
```
primary, secondary, tertiary, quaternary, destructive
```

### GentleButtonAnimationRole (6 roles)
```
unknown, subtlePress, squish, pop, bouncy, springBack
```

### GentleSurfaceRole (4 roles)
```
appBackground, card, cardElevated, surfaceOverlay
```

## Adding a New Token

### New Color Role
1. Add case to `GentleColorRole`
2. Add `displayName` in switch
3. Add default in `GentleColorTokens.gentleDefault.pairByRole`

### New Typography Role
1. Add case to `GentleTextRole`
2. Add `ramp` in switch
3. Add `displayName` in switch
4. Add default in `GentleTypographyTokens.gentleDefault`

### New Button Role
1. Add case to `GentleButtonRole`
2. Add spec in `GentleButtonTokens.gentleDefault.roles`

### New Animation Role
1. Add case to `GentleButtonAnimationRole`
2. Add spec in `GentleButtonTokens.gentleDefault.animations`
3. Handle in `GentleButtonAnimations.resolve()`

## Dynamic Type Integration

Typography tokens use `relativeTo` to anchor to semantic text styles:

```swift
public enum GentleFontTextStyle: String, Codable {
    case largeTitle, title, title2, title3, headline,
         body, callout, subheadline, footnote, caption, caption2
}
```

Resolution uses `UIFontMetrics`:
```swift
let metrics = UIFontMetrics(forTextStyle: roleSpec.relativeTo.uiKitTextStyle)
let scaledSize = metrics.scaledValue(for: pointSize, compatibleWith: traits)
```

## Versioning

Current version: `0.4.0` (in `GentleDesignSystemSpecVersion.current`)

Bump version when:
- Adding new token types
- Changing token structure
- Removing tokens (breaking)

Version is stored in JSON as `_specVersion` for migration detection.
