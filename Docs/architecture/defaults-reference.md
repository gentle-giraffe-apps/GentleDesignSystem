# Default Values Reference

All `.gentleDefault` values in one place.

---

## Spacing Scale (GentleSpacingScaleTokens.gentleDefault)

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4 | Micro gaps, tight padding |
| `s` | 8 | Tight spacing |
| `m` | 12 | Regular spacing |
| `l` | 16 | Comfortable spacing |
| `xl` | 24 | Loose spacing |
| `xxl` | 32 | Expansive spacing |

---

## Gap Intent Mapping

| Intent | Maps To | Value |
|--------|---------|-------|
| `unknown` | 0 | 0 |
| `micro` | xs | 4 |
| `tight` | s | 8 |
| `regular` | m | 12 |
| `ample` | l | 16 |
| `loose` | xl | 24 |
| `expansive` | xxl | 32 |

---

## Radii (GentleRadiusTokens.gentleDefault)

| Token | Value | Usage |
|-------|-------|-------|
| `small` | 8 | Subtle rounding |
| `medium` | 12 | Standard cards/buttons |
| `large` | 20 | Prominent cards |
| `pill` | 999 | Capsule/pill shapes |

---

## Shadows (GentleShadowTokens.gentleDefault)

| Token | Value | Usage |
|-------|-------|-------|
| `none` | 0 | No shadow |
| `small` | 2 | Subtle elevation |
| `medium` | 6 | Card elevation |

---

## Insets (GentleInsetTokens.gentleDefault)

### Screen Insets
| Variant | Horizontal | Vertical |
|---------|------------|----------|
| `tight` | s (8) | m (12) |
| `regular` | m (12) | l (16) |
| `roomy` | l (16) | xl (24) |

### Card Insets
| Variant | Horizontal | Vertical |
|---------|------------|----------|
| `tight` | s (8) | s (8) |
| `regular` | l (16) | l (16) |
| `roomy` | xl (24) | xl (24) |

### Control Insets
| Variant | Horizontal | Vertical |
|---------|------------|----------|
| `tight` | m (12) | xs (4) |
| `regular` | l (16) | s (8) |

### List Row Insets
| Variant | Horizontal | Vertical |
|---------|------------|----------|
| `tight` | m (12) | xs (4) |
| `regular` | l (16) | s (8) |

---

## Typography (GentleTypographyTokens.gentleDefault)

| Role | Size | Weight | Design | Width | RelativeTo | Line Spacing | Color Role |
|------|------|--------|--------|-------|------------|--------------|------------|
| `largeTitle_xxl` | 34 | bold | rounded | - | largeTitle | 6 | textPrimary |
| `title_xl` | 28 | bold | rounded | - | title | 4 | textPrimary |
| `title2_l` | 22 | semibold | rounded | - | title2 | 3 | textPrimary |
| `title3_ml` | 20 | semibold | rounded | - | title3 | 3 | textPrimary |
| `headline_m` | 17 | semibold | default | - | headline | 0 | textPrimary |
| `body_m` | 17 | regular | default | - | body | 2 | textPrimary |
| `bodySecondary_m` | 17 | regular | default | - | body | 2 | textSecondary |
| `monoCode_m` | 17 | regular | monospaced | condensed | body | 0 | textPrimary |
| `callout_ms` | 16 | regular | default | - | callout | 0 | textSecondary |
| `subheadline_ms` | 15 | regular | default | - | subheadline | 0 | textSecondary |
| `footnote_s` | 13 | regular | default | - | footnote | 0 | textTertiary |
| `caption_s` | 12 | regular | default | - | caption | 0 | textTertiary |
| `caption2_s` | 11 | regular | default | - | caption2 | 0 | textTertiary |
| `primaryButtonTitle_m` | 17 | semibold | default | - | headline | 0 | textPrimary |
| `secondaryButtonTitle_m` | 17 | semibold | default | - | headline | 0 | textPrimary |
| `tertiaryButtonTitle_m` | 17 | semibold | default | - | headline | 0 | textPrimary |
| `quaternaryButtonTitle_m` | 17 | regular | default | - | body | 0 | textPrimary |

---

## Colors (GentleColorTokens.gentleDefault)

| Role | Light Hex | Dark Hex | Usage |
|------|-----------|----------|-------|
| `textPrimary` | #1F2933 | #F5F7FA | Main text |
| `textSecondary` | #4B5563 | #C7CDD4 | Secondary text |
| `textTertiary` | #6B7280 | #9AA0A6 | Tertiary/hint text |
| `background` | #FFFFFF | #0B0F19 | App background |
| `surface` | #FAFAFE | #111827 | Card/container background |
| `surfaceTint` | #111827CC | #020617CC | Surface tint overlay |
| `surfaceSpecular` | #FFFFFF66 | #FFFFFF33 | Specular highlight |
| `surfaceOverlay` | #111827CC | #020617CC | Modal overlay |
| `onOverlay` | #F9FAFB | #F9FAFB | Primary text on overlay |
| `onOverlaySecondary` | #D1D5DB | #D1D5DB | Secondary text on overlay |
| `borderSubtle` | #E5E7EB | #374151 | Subtle borders |
| `primaryCTA` | #4A6EF5 | #3B82F6 | Primary action color |
| `onPrimaryCTA` | #FFFFFF | #FFFFFF | Text on primary CTA |
| `destructive` | #E35D5B | #F87171 | Destructive actions |
| `onDestructive` | #FFFFFF | #FFFFFF | Text on destructive |
| `themePrimary` | #4A6EF5 | #3B82F6 | Theme accent primary |
| `themeSecondary` | #8FA2FF | #93C5FD | Theme accent secondary |

---

## Buttons (GentleButtonTokens.gentleDefault)

### Button Role Specs

| Role | Shape | Material | Border | Animation | Pressed Scale | Pressed Opacity | Native Style |
|------|-------|----------|--------|-----------|---------------|-----------------|--------------|
| `primary` | pill | solidFillPrimaryCTA | hidden | springBack | 0.9 | 0.86 | false |
| `secondary` | pill | hollow | accent | subtlePress | 0.85 | 0.9 | false |
| `tertiary` | pill | hollow | hidden | subtlePress | 0.85 | 0.9 | true |
| `quaternary` | pill | hollow | hidden | subtlePress | 0.95 | 0.93 | true |
| `destructive` | pill | solidFillDestructive | hidden | squish | 0.9 | 0.86 | false |

### Animation Specs

| Role | Pressed Scale | Pressed Opacity | Duration | Spring Response | Spring Damping | Spring Blend |
|------|---------------|-----------------|----------|-----------------|----------------|--------------|
| `unknown` | 1.0 | 1.0 | 0.0 | 0.0 | 1.0 | 0.0 |
| `subtlePress` | 0.98 | 0.95 | 0.12 | 0.0 | 1.0 | 0.0 |
| `squish` | 0.97 | 0.92 | 0.10 | 0.22 | 0.85 | 0.0 |
| `pop` | 0.975 | 0.93 | 0.10 | 0.18 | 0.78 | 0.0 |
| `bouncy` | 0.97 | 0.94 | 0.10 | 0.28 | 0.70 | 0.0 |
| `springBack` | 0.72 | 0.90 | 0.10 | 0.45 | 0.45 | 0.0 |

---

## Surfaces (GentleSurfaceTokens.gentleDefault)

| Role | Material Role | Border (Light/Dark) | Corner Radius | Border Width | Shadow Radius | Shadow Opacity | Shadow Offset Y |
|------|---------------|---------------------|---------------|--------------|---------------|----------------|-----------------|
| `appBackground` | appBackground | #00000000 / #00000000 | 0 | 0 | 0 | 0 | 0 |
| `card` | surface | #E5E7EB / #374151 | 20 | 1 | 0 | 0 | 0 |
| `cardElevated` | surface | #E5E7EB59 / #37415159 | 20 | 0.5 | 8 | 0.08 | 6 |
| `surfaceOverlay` | surfaceOverlay | #00000000 / #00000000 | 0 | 0 | 0 | 0 | 0 |

---

## Material Roles → Colors

| Material Role | Color Role Used |
|---------------|-----------------|
| `appBackground` | background |
| `surface` | surface |
| `surfaceOverlay` | surfaceOverlay |
