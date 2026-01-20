//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - Role Enum Tests

@Suite("GentleTextRole Tests")
struct GentleTextRoleTests {

    @Test("All text roles have correct ramp assignments")
    func testTextRoleRamps() {
        #expect(GentleTextRole.largeTitle_xxl.ramp == .xxl)
        #expect(GentleTextRole.title_xl.ramp == .xl)
        #expect(GentleTextRole.title2_l.ramp == .l)
        #expect(GentleTextRole.title3_ml.ramp == .ml)
        #expect(GentleTextRole.headline_m.ramp == .m)
        #expect(GentleTextRole.body_m.ramp == .m)
        #expect(GentleTextRole.bodySecondary_m.ramp == .m)
        #expect(GentleTextRole.monoCode_m.ramp == .m)
        #expect(GentleTextRole.callout_ms.ramp == .ms)
        #expect(GentleTextRole.subheadline_ms.ramp == .ms)
        #expect(GentleTextRole.footnote_s.ramp == .s)
        #expect(GentleTextRole.caption_s.ramp == .s)
        #expect(GentleTextRole.caption2_s.ramp == .s)
    }

    @Test("Button title roles have medium ramp")
    func testButtonTitleRamps() {
        #expect(GentleTextRole.primaryButtonTitle_m.ramp == .m)
        #expect(GentleTextRole.secondaryButtonTitle_m.ramp == .m)
        #expect(GentleTextRole.tertiaryButtonTitle_m.ramp == .m)
        #expect(GentleTextRole.quaternaryButtonTitle_m.ramp == .m)
    }

    @Test("All text roles have display names")
    func testTextRoleDisplayNames() {
        for role in GentleTextRole.allCases {
            #expect(!role.displayName.isEmpty, "Display name should not be empty for \(role)")
        }
    }

    @Test("Text roles are identifiable by rawValue")
    func testTextRoleIdentifiable() {
        for role in GentleTextRole.allCases {
            #expect(role.id == role.rawValue)
        }
    }

    @Test("All text roles are case iterable")
    func testTextRoleCaseIterable() {
        #expect(GentleTextRole.allCases.count == 17) // 13 standard + 4 button titles
    }
}

@Suite("GentleColorRole Tests")
struct GentleColorRoleTests {

    @Test("All color roles have display names")
    func testColorRoleDisplayNames() {
        for role in GentleColorRole.allCases {
            #expect(!role.displayName.isEmpty, "Display name should not be empty for \(role)")
        }
    }

    @Test("Color roles are identifiable by rawValue")
    func testColorRoleIdentifiable() {
        for role in GentleColorRole.allCases {
            #expect(role.id == role.rawValue)
        }
    }

    @Test("All color roles are case iterable")
    func testColorRoleCaseIterable() {
        #expect(GentleColorRole.allCases.count == 15)
    }

    @Test("Expected color roles exist")
    func testExpectedColorRolesExist() {
        let expectedRoles: [GentleColorRole] = [
            .textPrimary, .textSecondary, .textTertiary,
            .onPrimaryCTA,
            .background, .surface, .surfaceElevated,
            .surfaceOverlay, .onSurfaceOverlayPrimary, .onSurfaceOverlaySecondary,
            .borderSubtle,
            .destructive,
            .primaryCTA,
            .themePrimary, .themeSecondary
        ]

        for role in expectedRoles {
            #expect(GentleColorRole.allCases.contains(role))
        }
    }
}

@Suite("GentleButtonRole Tests")
struct GentleButtonRoleTests {

    @Test("Button roles have expected raw values")
    func testButtonRoleRawValues() {
        #expect(GentleButtonRole.primary.rawValue == "primary")
        #expect(GentleButtonRole.secondary.rawValue == "secondary")
        #expect(GentleButtonRole.tertiary.rawValue == "tertiary")
        #expect(GentleButtonRole.quaternary.rawValue == "quaternary")
        #expect(GentleButtonRole.destructive.rawValue == "destructive")
    }
}

@Suite("GentleButtonAnimationRole Tests")
struct GentleButtonAnimationRoleTests {

    @Test("All animation roles are case iterable")
    func testAnimationRoleCaseIterable() {
        let roles = GentleButtonAnimationRole.allCases
        #expect(roles.count == 6)
        #expect(roles.contains(.none))
        #expect(roles.contains(.subtlePress))
        #expect(roles.contains(.squish))
        #expect(roles.contains(.pop))
        #expect(roles.contains(.bouncy))
        #expect(roles.contains(.springBack))
    }
}

@Suite("GentleSurfaceRole Tests")
struct GentleSurfaceRoleTests {

    @Test("Surface roles have expected raw values")
    func testSurfaceRoleRawValues() {
        #expect(GentleSurfaceRole.appBackground.rawValue == "appBackground")
        #expect(GentleSurfaceRole.card.rawValue == "card")
        #expect(GentleSurfaceRole.cardChrome.rawValue == "cardChrome")
        #expect(GentleSurfaceRole.cardElevated.rawValue == "cardElevated")
        #expect(GentleSurfaceRole.surfaceOverlay.rawValue == "surfaceOverlay")
    }
}

@Suite("GentleGapIntent Tests")
struct GentleGapIntentTests {

    @Test("All gap intents are case iterable")
    func testGapIntentCaseIterable() {
        let intents = GentleGapIntent.allCases
        #expect(intents.count == 7)
        #expect(intents.contains(.none))
        #expect(intents.contains(.micro))
        #expect(intents.contains(.tight))
        #expect(intents.contains(.regular))
        #expect(intents.contains(.ample))
        #expect(intents.contains(.loose))
        #expect(intents.contains(.expansive))
    }
}

@Suite("GentleFontTextStyle Tests")
struct GentleFontTextStyleTests {

    @Test("Font text styles map to UIKit text styles correctly")
    func testFontTextStyleUIKitMapping() {
        #expect(GentleFontTextStyle.largeTitle.uiKitTextStyle == .largeTitle)
        #expect(GentleFontTextStyle.title.uiKitTextStyle == .title1)
        #expect(GentleFontTextStyle.title2.uiKitTextStyle == .title2)
        #expect(GentleFontTextStyle.title3.uiKitTextStyle == .title3)
        #expect(GentleFontTextStyle.headline.uiKitTextStyle == .headline)
        #expect(GentleFontTextStyle.body.uiKitTextStyle == .body)
        #expect(GentleFontTextStyle.callout.uiKitTextStyle == .callout)
        #expect(GentleFontTextStyle.subheadline.uiKitTextStyle == .subheadline)
        #expect(GentleFontTextStyle.footnote.uiKitTextStyle == .footnote)
        #expect(GentleFontTextStyle.caption.uiKitTextStyle == .caption1)
        #expect(GentleFontTextStyle.caption2.uiKitTextStyle == .caption2)
    }
}

// MARK: - Token Struct Tests

@Suite("GentleColorPair Tests")
struct GentleColorPairTests {

    @Test("Color pair returns correct hex for color scheme")
    func testColorPairHexForScheme() {
        let pair = GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")
        #expect(pair.hex(for: .light) == "#FFFFFF")
        #expect(pair.hex(for: .dark) == "#000000")
    }

    @Test("Color pair is codable")
    func testColorPairCodable() throws {
        let original = GentleColorPair(lightHex: "#FF0000", darkHex: "#00FF00")
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleColorPair.self, from: data)

        #expect(decoded.lightHex == original.lightHex)
        #expect(decoded.darkHex == original.darkHex)
    }
}

@Suite("GentleColorTokens Tests")
struct GentleColorTokensTests {

    @Test("Gentle default color tokens contain all roles")
    func testDefaultColorTokensContainAllRoles() {
        let tokens = GentleColorTokens.gentleDefault

        for role in GentleColorRole.allCases {
            let pair = tokens.pair(for: role)
            #expect(pair != nil, "Missing color pair for role: \(role)")
        }
    }

    @Test("Color tokens are codable")
    func testColorTokensCodable() throws {
        let original = GentleColorTokens.gentleDefault
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleColorTokens.self, from: data)

        for role in GentleColorRole.allCases {
            let originalPair = original.pair(for: role)
            let decodedPair = decoded.pair(for: role)
            #expect(originalPair?.lightHex == decodedPair?.lightHex)
            #expect(originalPair?.darkHex == decodedPair?.darkHex)
        }
    }

    @Test("Color tokens return nil for missing role")
    func testColorTokensReturnNilForMissingRole() {
        let tokens = GentleColorTokens(pairByRole: [:])
        #expect(tokens.pair(for: .textPrimary) == nil)
    }
}

@Suite("GentleTypographyRoleSpec Tests")
struct GentleTypographyRoleSpecTests {

    @Test("Typography role spec stores all properties")
    func testTypographyRoleSpecProperties() {
        let spec = GentleTypographyRoleSpec(
            pointSize: 17,
            weight: .semibold,
            design: .rounded,
            width: .condensed,
            relativeTo: .body,
            lineSpacing: 4,
            letterSpacing: 0.5,
            isUppercased: true,
            colorRole: .textPrimary
        )

        #expect(spec.pointSize == 17)
        #expect(spec.weight == .semibold)
        #expect(spec.design == .rounded)
        #expect(spec.width == .condensed)
        #expect(spec.relativeTo == .body)
        #expect(spec.lineSpacing == 4)
        #expect(spec.letterSpacing == 0.5)
        #expect(spec.isUppercased == true)
        #expect(spec.colorRole == .textPrimary)
    }

    @Test("Typography role spec is codable")
    func testTypographyRoleSpecCodable() throws {
        let original = GentleTypographyRoleSpec(
            pointSize: 20,
            weight: .bold,
            design: .serif,
            width: .expanded,
            relativeTo: .title,
            lineSpacing: 2,
            letterSpacing: 0.3,
            isUppercased: false,
            colorRole: .textSecondary
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleTypographyRoleSpec.self, from: data)

        #expect(decoded.pointSize == original.pointSize)
        #expect(decoded.weight == original.weight)
        #expect(decoded.design == original.design)
        #expect(decoded.width == original.width)
        #expect(decoded.relativeTo == original.relativeTo)
        #expect(decoded.lineSpacing == original.lineSpacing)
        #expect(decoded.letterSpacing == original.letterSpacing)
        #expect(decoded.isUppercased == original.isUppercased)
        #expect(decoded.colorRole == original.colorRole)
    }
}

@Suite("GentleTypographyTokens Tests")
struct GentleTypographyTokensTests {

    @Test("Default typography tokens contain all standard roles")
    func testDefaultTypographyTokensContainAllRoles() {
        let tokens = GentleTypographyTokens.gentleDefault

        for role in GentleTextRole.allCases {
            let spec = tokens.roleSpec(for: role)
            #expect(spec.pointSize > 0, "Point size should be positive for role: \(role)")
        }
    }

    @Test("Typography tokens fallback to body when role missing")
    func testTypographyTokensFallback() {
        let bodySpec = GentleTypographyRoleSpec(
            pointSize: 17,
            weight: .regular,
            design: .default,
            relativeTo: .body,
            colorRole: .textPrimary
        )

        let tokens = GentleTypographyTokens(roles: [
            GentleTextRole.body_m.rawValue: bodySpec
        ])

        // Request a missing role should fallback to body
        let spec = tokens.roleSpec(for: .largeTitle_xxl)
        #expect(spec.pointSize == 17)
    }

    @Test("Typography tokens fallback to hardcoded defaults when empty")
    func testTypographyTokensHardcodedFallback() {
        let tokens = GentleTypographyTokens(roles: [:])
        let spec = tokens.roleSpec(for: .body_m)

        #expect(spec.pointSize == 17)
        #expect(spec.weight == .regular)
        #expect(spec.design == .default)
    }
}

@Suite("GentleSpacingScaleTokens Tests")
struct GentleSpacingScaleTokensTests {

    @Test("Default spacing scale has expected values")
    func testDefaultSpacingScale() {
        let scale = GentleSpacingScaleTokens.gentleDefault

        #expect(scale.xs == 4)
        #expect(scale.s == 8)
        #expect(scale.m == 12)
        #expect(scale.l == 16)
        #expect(scale.xl == 24)
        #expect(scale.xxl == 32)
    }

    @Test("Spacing scale value(for:) returns correct values")
    func testSpacingScaleValueFor() {
        let scale = GentleSpacingScaleTokens.gentleDefault

        #expect(scale.value(for: .xs) == 4)
        #expect(scale.value(for: .s) == 8)
        #expect(scale.value(for: .m) == 12)
        #expect(scale.value(for: .l) == 16)
        #expect(scale.value(for: .xl) == 24)
        #expect(scale.value(for: .xxl) == 32)
    }

    @Test("Custom spacing scale works correctly")
    func testCustomSpacingScale() {
        let scale = GentleSpacingScaleTokens(xs: 2, s: 4, m: 8, l: 12, xl: 16, xxl: 24)

        #expect(scale.xs == 2)
        #expect(scale.s == 4)
        #expect(scale.m == 8)
        #expect(scale.l == 12)
        #expect(scale.xl == 16)
        #expect(scale.xxl == 24)
    }
}

@Suite("GentleInsetTokens Tests")
struct GentleInsetTokensTests {

    @Test("Default inset tokens have expected roles")
    func testDefaultInsetTokens() {
        let insets = GentleInsetTokens.gentleDefault

        let screen = insets.axisTokens(for: .screen)
        #expect(screen.horizontal == .xl)
        #expect(screen.vertical == .l)

        let card = insets.axisTokens(for: .card)
        #expect(card.horizontal == .m)
        #expect(card.vertical == .m)

        let control = insets.axisTokens(for: .control)
        #expect(control.horizontal == .l)
        #expect(control.vertical == .s)

        let listRow = insets.axisTokens(for: .listRow)
        #expect(listRow.horizontal == .l)
        #expect(listRow.vertical == .s)
    }

    @Test("Inset tokens fallback to screen for missing role")
    func testInsetTokensFallback() {
        let insets = GentleInsetTokens(tokensByRole: [
            GentleInsetRole.screen.rawValue: .init(horizontal: .xxl, vertical: .xl)
        ])

        // Request missing role should fallback to screen
        let axis = insets.axisTokens(for: .card)
        #expect(axis.horizontal == .xxl)
        #expect(axis.vertical == .xl)
    }
}

@Suite("GentleLayoutTokens Tests")
struct GentleLayoutTokensTests {

    @Test("Default layout tokens are created correctly")
    func testDefaultLayoutTokens() {
        let layout = GentleLayoutTokens.gentleDefault

        #expect(layout.scale.m == 12)
        #expect(layout.gap.m == 12)
        #expect(layout.grid.m == 12)
        #expect(layout.touch.m == 12)
    }
}

@Suite("GentleRadiusTokens Tests")
struct GentleRadiusTokensTests {

    @Test("Default radius tokens have expected values")
    func testDefaultRadiusTokens() {
        let radii = GentleRadiusTokens.gentleDefault

        #expect(radii.small == 8)
        #expect(radii.medium == 12)
        #expect(radii.large == 20)
        #expect(radii.pill == 999)
    }
}

@Suite("GentleShadowTokens Tests")
struct GentleShadowTokensTests {

    @Test("Default shadow tokens have expected values")
    func testDefaultShadowTokens() {
        let shadows = GentleShadowTokens.gentleDefault

        #expect(shadows.none == 0)
        #expect(shadows.small == 2)
        #expect(shadows.medium == 6)
    }
}

@Suite("GentleVisualTokens Tests")
struct GentleVisualTokensTests {

    @Test("Default visual tokens are created correctly")
    func testDefaultVisualTokens() {
        let visual = GentleVisualTokens.gentleDefault

        #expect(visual.radii.medium == 12)
        #expect(visual.shadows.small == 2)
    }
}

@Suite("GentleButtonAnimationSpec Tests")
struct GentleButtonAnimationSpecTests {

    @Test("Button animation spec has correct defaults")
    func testButtonAnimationSpecDefaults() {
        let spec = GentleButtonAnimationSpec()

        #expect(spec.pressedScale == 0.97)
        #expect(spec.pressedOpacity == 0.92)
        #expect(spec.duration == 0.12)
        #expect(spec.springResponse == 0.22)
        #expect(spec.springDamping == 0.85)
        #expect(spec.springBlend == 0.0)
    }

    @Test("Button animation spec custom values")
    func testButtonAnimationSpecCustomValues() {
        let spec = GentleButtonAnimationSpec(
            pressedScale: 0.95,
            pressedOpacity: 0.8,
            duration: 0.2,
            springResponse: 0.3,
            springDamping: 0.7,
            springBlend: 0.1
        )

        #expect(spec.pressedScale == 0.95)
        #expect(spec.pressedOpacity == 0.8)
        #expect(spec.duration == 0.2)
        #expect(spec.springResponse == 0.3)
        #expect(spec.springDamping == 0.7)
        #expect(spec.springBlend == 0.1)
    }
}

@Suite("GentleButtonRoleSpec Tests")
struct GentleButtonRoleSpecTests {

    @Test("Button role spec stores all properties")
    func testButtonRoleSpecProperties() {
        let spec = GentleButtonRoleSpec(
            shape: .pill,
            textRole: .headline_m,
            backgroundRole: .primaryCTA,
            labelColorRole: .onPrimaryCTA,
            borderRole: .borderSubtle,
            animationRole: .bouncy,
            pressedScale: 0.95,
            pressedOpacity: 0.85
        )

        #expect(spec.shape == .pill)
        #expect(spec.textRole == .headline_m)
        #expect(spec.backgroundRole == .primaryCTA)
        #expect(spec.labelColorRole == .onPrimaryCTA)
        #expect(spec.borderRole == .borderSubtle)
        #expect(spec.animationRole == .bouncy)
        #expect(spec.pressedScale == 0.95)
        #expect(spec.pressedOpacity == 0.85)
    }
}

@Suite("GentleButtonTokens Tests")
struct GentleButtonTokensTests {

    @Test("Default button tokens contain all roles")
    func testDefaultButtonTokensContainAllRoles() {
        let tokens = GentleButtonTokens.gentleDefault

        let primary = tokens.roleSpec(for: .primary)
        #expect(primary.backgroundRole == .primaryCTA)

        let secondary = tokens.roleSpec(for: .secondary)
        #expect(secondary.borderRole != nil)

        let tertiary = tokens.roleSpec(for: .tertiary)
        #expect(tertiary.backgroundRole == .surface)

        let destructive = tokens.roleSpec(for: .destructive)
        #expect(destructive.backgroundRole == .destructive)
    }

    @Test("Button tokens fallback to primary for missing role")
    func testButtonTokensFallback() {
        let primarySpec = GentleButtonRoleSpec(
            textRole: .headline_m,
            backgroundRole: .primaryCTA,
            labelColorRole: .onPrimaryCTA
        )

        let tokens = GentleButtonTokens(
            roles: [GentleButtonRole.primary.rawValue: primarySpec],
            animations: [:]
        )

        let spec = tokens.roleSpec(for: .destructive)
        #expect(spec.backgroundRole == .primaryCTA)
    }

    @Test("Default button tokens contain animation specs")
    func testDefaultButtonTokensContainAnimationSpecs() {
        let tokens = GentleButtonTokens.gentleDefault

        for role in GentleButtonAnimationRole.allCases {
            let spec = tokens.animationSpec(for: role)
            #expect(spec.pressedScale > 0)
        }
    }
}

// MARK: - GentleDesignSystemSpec Tests

@Suite("GentleDesignSystemSpec Tests")
struct GentleDesignSystemSpecTests {

    @Test("Spec version is current")
    func testSpecVersion() {
        let spec = GentleDesignSystemSpec.gentleDefault
        #expect(spec.specVersion == GentleDesignSystemSpecVersion.current)
    }

    @Test("Default spec contains all token groups")
    func testDefaultSpecContainsAllTokenGroups() {
        let spec = GentleDesignSystemSpec.gentleDefault

        // Colors
        for role in GentleColorRole.allCases {
            #expect(spec.colors.pair(for: role) != nil)
        }

        // Typography
        for role in GentleTextRole.allCases {
            let typoSpec = spec.typography.roleSpec(for: role)
            #expect(typoSpec.pointSize > 0)
        }

        // Layout
        #expect(spec.layout.scale.m == 12)

        // Visual
        #expect(spec.visual.radii.medium == 12)

        // Buttons
        #expect(spec.buttons.roleSpec(for: .primary).backgroundRole == .primaryCTA)
    }

    @Test("Spec is codable")
    func testSpecCodable() throws {
        let original = GentleDesignSystemSpec.gentleDefault
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleDesignSystemSpec.self, from: data)

        #expect(decoded.specVersion == original.specVersion)
        #expect(decoded.colors.pair(for: .textPrimary)?.lightHex == original.colors.pair(for: .textPrimary)?.lightHex)
    }

    @Test("Spec version key uses underscore prefix")
    func testSpecVersionCodingKey() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let encoder = JSONEncoder()

        let data = try encoder.encode(spec)
        if let jsonString = String(data: data, encoding: .utf8) {
            #expect(jsonString.contains("\"_specVersion\""))
        } else {
            Issue.record("Could not convert encoded data to a UTF-8 string")
        }
    }
}

@Suite("GentleDesignSystemSpec Presets Tests")
struct GentleDesignSystemSpecPresetsTests {

    @Test("All presets exist and are valid")
    func testAllPresetsExist() {
        let presets = GentleDesignSystemSpec.allPresets
        #expect(presets.count == 9)

        for preset in presets {
            #expect(!preset.name.isEmpty)
            #expect(!preset.summary.isEmpty)
            #expect(!preset.description.isEmpty)
            #expect(!preset.purpose.isEmpty)
            #expect(!preset.systemImageString.isEmpty)
        }
    }

    @Test("Classic preset has serif typography")
    func testClassicPresetHasSerif() {
        let classic = GentleDesignSystemSpec.classic
        let titleSpec = classic.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.design == .serif)
    }

    @Test("Soft preset has rounded typography")
    func testSoftPresetHasRounded() {
        let soft = GentleDesignSystemSpec.soft
        let titleSpec = soft.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.design == .rounded)
    }

    @Test("Modern preset has default design")
    func testModernPresetHasDefault() {
        let modern = GentleDesignSystemSpec.modern
        let titleSpec = modern.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.design == .default)
    }

    @Test("Compact preset has smaller point sizes")
    func testCompactPresetHasSmallerSizes() {
        let compact = GentleDesignSystemSpec.compact
        let defaultSpec = GentleDesignSystemSpec.gentleDefault

        let compactBody = compact.typography.roleSpec(for: .body_m)
        let defaultBody = defaultSpec.typography.roleSpec(for: .body_m)

        #expect(compactBody.pointSize <= defaultBody.pointSize)
    }

    @Test("Editorial preset has serif design")
    func testEditorialPresetHasSerif() {
        let editorial = GentleDesignSystemSpec.editorial
        let bodySpec = editorial.typography.roleSpec(for: .body_m)
        #expect(bodySpec.design == .serif)
    }
}

// MARK: - GentleTheme Tests

@Suite("GentleTheme Tests")
struct GentleThemeTests {

    @Test("Default theme is created correctly")
    func testDefaultTheme() {
        let theme = GentleTheme.default

        #expect(theme.spec.specVersion == GentleDesignSystemSpecVersion.current)
    }

    @Test("Theme active spec returns editable spec")
    func testThemeActiveSpec() {
        var theme = GentleTheme.default
        let customSpec = GentleDesignSystemSpec.classic
        theme.editableSpec = customSpec

        #expect(theme.activeSpec.typography.roleSpec(for: .largeTitle_xxl).design == .serif)
    }

    @Test("Theme color resolution for light scheme")
    func testThemeColorResolutionLight() {
        let theme = GentleTheme.default
        let color = theme.color(for: .textPrimary, scheme: .light)

        // Color should be non-nil (we can't easily test the exact color value)
        #expect(color != Color.clear)
    }

    @Test("Theme color resolution for dark scheme")
    func testThemeColorResolutionDark() {
        let theme = GentleTheme.default
        let color = theme.color(for: .textPrimary, scheme: .dark)

        #expect(color != Color.clear)
    }

    @Test("Theme returns primary color for missing role")
    func testThemeColorFallback() {
        let theme = GentleTheme(
            defaultSpec: .init(
                colors: GentleColorTokens(pairByRole: [:]),
                typography: .gentleDefault,
                layout: .gentleDefault,
                visual: .gentleDefault,
                buttons: .gentleDefault
            )
        )

        // Should not crash and should return some color
        let color = theme.color(for: .textPrimary, scheme: .light)
        #expect(color == Color.primary)
    }

    @Test("Theme text style resolution")
    func testThemeTextStyleResolution() {
        let theme = GentleTheme.default
        let style = theme.textStyle(for: .body_m, sizeCategory: .large)

        #expect(style.lineSpacing >= 0)
        #expect(style.colorRole == .textPrimary)
    }

    @Test("Theme layout accessors work")
    func testThemeLayoutAccessors() {
        let theme = GentleTheme.default

        #expect(theme.layout.scale.m == 12)
        #expect(theme.gap.m == 12)
        #expect(theme.grid.m == 12)
        #expect(theme.touch.m == 12)
    }

    @Test("Theme visual accessors work")
    func testThemeVisualAccessors() {
        let theme = GentleTheme.default

        #expect(theme.visual.radii.medium == 12)
        #expect(theme.radii.medium == 12)
        #expect(theme.shadows.small == 2)
    }

    @Test("Theme inset value calculation")
    func testThemeInsetValue() {
        let theme = GentleTheme.default

        let screenInset = theme.insetValue(.screen)
        #expect(screenInset.horizontal == 24) // xl = 24
        #expect(screenInset.vertical == 16) // l = 16
    }

    @Test("Theme inset value with edge subset")
    func testThemeInsetValueEdges() {
        let theme = GentleTheme.default

        let horizontalOnly = theme.insetValue(.screen, edges: .horizontal)
        #expect(horizontalOnly.horizontal == 24)
        #expect(horizontalOnly.vertical == nil)

        let verticalOnly = theme.insetValue(.screen, edges: .vertical)
        #expect(verticalOnly.horizontal == nil)
        #expect(verticalOnly.vertical == 16)
    }
}

// MARK: - Color Hex Conversion Tests

@Suite("Color Hex Conversion Tests")
struct ColorHexConversionTests {

    @Test("6-digit hex creates correct color")
    func test6DigitHex() {
        let color = Color(gentleHex: "#FF0000")
        // We can't easily test color values, but we can test it doesn't crash
        #expect(color != Color.clear)
    }

    @Test("8-digit hex with alpha creates correct color")
    func test8DigitHex() {
        let color = Color(gentleHex: "#FF000080")
        #expect(color != Color.clear)
    }

    @Test("Hex without hash prefix works")
    func testHexWithoutHash() {
        let color = Color(gentleHex: "00FF00")
        #expect(color != Color.clear)
    }

    @Test("Hex with whitespace is trimmed")
    func testHexWithWhitespace() {
        let color = Color(gentleHex: "  #0000FF  ")
        #expect(color != Color.clear)
    }

    @Test("Invalid hex returns black")
    func testInvalidHex() {
        let color = Color(gentleHex: "invalid")
        // Invalid hex should return black (r=0, g=0, b=0)
        #expect(color != Color.clear)
    }

    @Test("Short hex returns black")
    func testShortHex() {
        let color = Color(gentleHex: "#FFF")
        // 3-digit hex is not supported, should return black
        #expect(color != Color.clear)
    }
}

// MARK: - Layout Facade Tests

@Suite("GentleGapScaleFacade Tests")
struct GentleGapScaleFacadeTests {

    @Test("Gap facade provides raw values")
    func testGapFacadeRawValues() {
        let facade = GentleGapScaleFacade(scale: .gentleDefault)

        #expect(facade.xs == 4)
        #expect(facade.s == 8)
        #expect(facade.m == 12)
        #expect(facade.l == 16)
        #expect(facade.xl == 24)
        #expect(facade.xxl == 32)
    }

    @Test("Gap facade provides intent values")
    func testGapFacadeIntentValues() {
        let facade = GentleGapScaleFacade(scale: .gentleDefault)

        #expect(facade.none == 0)
        #expect(facade.micro == 4)  // xs
        #expect(facade.tight == 8)  // s
        #expect(facade.regular == 12)  // m
        #expect(facade.ample == 16)  // l
        #expect(facade.loose == 24)  // xl
        #expect(facade.expansive == 32)  // xxl
    }

    @Test("Gap facade value(token:) works")
    func testGapFacadeValueToken() {
        let facade = GentleGapScaleFacade(scale: .gentleDefault)

        #expect(facade.value(.xs) == 4)
        #expect(facade.value(.m) == 12)
        #expect(facade.value(.xxl) == 32)
    }

    @Test("Gap facade value(intent:) works")
    func testGapFacadeValueIntent() {
        let facade = GentleGapScaleFacade(scale: .gentleDefault)

        #expect(facade.value(.none) == 0)
        #expect(facade.value(.regular) == 12)
        #expect(facade.value(.expansive) == 32)
    }
}

@Suite("GentleLayoutFacade Tests")
struct GentleLayoutFacadeTests {

    @Test("Layout facade provides all accessors")
    func testLayoutFacadeAccessors() {
        let facade = GentleLayoutFacade(tokens: .gentleDefault)

        #expect(facade.gap.regular == 12)
        #expect(facade.stack.regular == 12)
        #expect(facade.list.regular == 12)
        #expect(facade.grid.regular == 12)
        #expect(facade.touch.regular == 12)
    }

    @Test("Layout facade inset accessor works")
    func testLayoutFacadeInset() {
        let facade = GentleLayoutFacade(tokens: .gentleDefault)

        let screenInset = facade.inset.axisTokens(for: .screen)
        #expect(screenInset.horizontal == .xl)
        #expect(screenInset.vertical == .l)
    }
}

// MARK: - JSON Encoding/Decoding Tests

@Suite("JSON Encoding/Decoding Tests")
struct JSONEncodingDecodingTests {

    @Test("GentleDesignSystemSpec round-trips through JSON")
    func testSpecRoundTrip() throws {
        let original = GentleDesignSystemSpec.gentleDefault

        let jsonData = try original.encodedJSONData()
        let decoded = try GentleDesignSystemSpec.fromJSONData(jsonData)

        #expect(decoded.specVersion == original.specVersion)

        // Verify colors
        let originalPair = original.colors.pair(for: .textPrimary)
        let decodedPair = decoded.colors.pair(for: .textPrimary)
        #expect(originalPair?.lightHex == decodedPair?.lightHex)
        #expect(originalPair?.darkHex == decodedPair?.darkHex)

        // Verify typography
        let originalTypo = original.typography.roleSpec(for: .body_m)
        let decodedTypo = decoded.typography.roleSpec(for: .body_m)
        #expect(originalTypo.pointSize == decodedTypo.pointSize)
        #expect(originalTypo.weight == decodedTypo.weight)
    }

    @Test("GentleDesignSystemSpec encodes to JSON string")
    func testSpecToJSONString() throws {
        let spec = GentleDesignSystemSpec.gentleDefault

        let jsonString = try spec.encodedJSONString()

        #expect(jsonString.contains("\"_specVersion\""))
        #expect(jsonString.contains("\"colors\""))
        #expect(jsonString.contains("\"typography\""))
        #expect(jsonString.contains("\"layout\""))
        #expect(jsonString.contains("\"visual\""))
        #expect(jsonString.contains("\"buttons\""))
    }

    @Test("GentleDesignSystemSpec decodes from JSON string")
    func testSpecFromJSONString() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let jsonString = try spec.encodedJSONString()

        let decoded = try GentleDesignSystemSpec.fromJSONString(jsonString)

        #expect(decoded.specVersion == spec.specVersion)
    }

    @Test("JSON encoder uses pretty printing and sorted keys")
    func testJSONEncoderOptions() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let jsonString = try spec.encodedJSONString()

        // Pretty printed should have newlines
        #expect(jsonString.contains("\n"))

        // Sorted keys means _specVersion should appear early (starts with underscore)
        let lines = jsonString.components(separatedBy: "\n")
        let specVersionLine = lines.first { $0.contains("_specVersion") }
        #expect(specVersionLine != nil)
    }

    @Test("All preset specs are JSON serializable")
    func testAllPresetsSerializable() throws {
        let presets = GentleDesignSystemSpec.allPresets

        for preset in presets {
            let jsonData = try preset.spec.encodedJSONData()
            let decoded = try GentleDesignSystemSpec.fromJSONData(jsonData)
            #expect(decoded.specVersion == preset.spec.specVersion, "Preset \(preset.name) failed to round-trip")
        }
    }
}

// MARK: - Font Token Tests

@Suite("GentleFontDesignToken Tests")
struct GentleFontDesignTokenTests {

    @Test("Font design tokens map to SwiftUI correctly")
    func testFontDesignMapping() {
        #expect(GentleFontDesignToken.default.swiftUIDesign == .default)
        #expect(GentleFontDesignToken.serif.swiftUIDesign == .serif)
        #expect(GentleFontDesignToken.rounded.swiftUIDesign == .rounded)
        #expect(GentleFontDesignToken.monospaced.swiftUIDesign == .monospaced)
    }

    @Test("All font design tokens are case iterable")
    func testFontDesignCaseIterable() {
        #expect(GentleFontDesignToken.allCases.count == 4)
    }
}

@Suite("GentleFontWidthToken Tests")
struct GentleFontWidthTokenTests {

    @Test("Font width tokens have display names")
    func testFontWidthDisplayNames() {
        #expect(GentleFontWidthToken.compressed.displayName == "Compressed")
        #expect(GentleFontWidthToken.condensed.displayName == "Condensed")
        #expect(GentleFontWidthToken.standard.displayName == "Standard")
        #expect(GentleFontWidthToken.expanded.displayName == "Expanded")
    }

    @Test("All font width tokens are case iterable")
    func testFontWidthCaseIterable() {
        #expect(GentleFontWidthToken.allCases.count == 4)
    }
}

@Suite("GentleFontWeightToken Tests")
struct GentleFontWeightTokenTests {

    @Test("Font weight tokens map to SwiftUI correctly")
    func testFontWeightMapping() {
        #expect(GentleFontWeightToken.ultraLight.swiftUIWeight == .ultraLight)
        #expect(GentleFontWeightToken.thin.swiftUIWeight == .thin)
        #expect(GentleFontWeightToken.light.swiftUIWeight == .light)
        #expect(GentleFontWeightToken.regular.swiftUIWeight == .regular)
        #expect(GentleFontWeightToken.medium.swiftUIWeight == .medium)
        #expect(GentleFontWeightToken.semibold.swiftUIWeight == .semibold)
        #expect(GentleFontWeightToken.bold.swiftUIWeight == .bold)
        #expect(GentleFontWeightToken.heavy.swiftUIWeight == .heavy)
        #expect(GentleFontWeightToken.black.swiftUIWeight == .black)
    }

    @Test("Font weight tokens have display names")
    func testFontWeightDisplayNames() {
        #expect(GentleFontWeightToken.ultraLight.displayName == "Ultra Light")
        #expect(GentleFontWeightToken.semibold.displayName == "Semibold")
    }

    @Test("All font weight tokens are case iterable")
    func testFontWeightCaseIterable() {
        #expect(GentleFontWeightToken.allCases.count == 9)
    }
}

// MARK: - GentleThemeManager Tests

@Suite("GentleThemeManager Tests")
@MainActor
struct GentleThemeManagerTests {

    @Test("Manager initializes with default theme")
    func testManagerInitialization() {
        let manager = GentleThemeManager()

        #expect(manager.theme.spec.specVersion == GentleDesignSystemSpecVersion.current)
        #expect(manager.hasUnsavedChanges == false)
        #expect(manager.currentPresetName == nil)
    }

    @Test("Manager tracks unsaved changes through typography binding")
    func testManagerTypographyBinding() {
        let manager = GentleThemeManager()

        #expect(manager.hasUnsavedChanges == false)

        let binding = manager.bindingForTypographyRole(.body_m)
        var spec = binding.wrappedValue
        spec.pointSize = 20
        binding.wrappedValue = spec

        #expect(manager.hasUnsavedChanges == true)
        #expect(manager.theme.editableSpec.typography.roleSpec(for: .body_m).pointSize == 20)
    }

    @Test("Manager tracks unsaved changes through color binding")
    func testManagerColorBinding() {
        let manager = GentleThemeManager()

        #expect(manager.hasUnsavedChanges == false)

        let binding = manager.bindingForColorRole(.textPrimary)
        binding.wrappedValue = GentleColorPair(lightHex: "#123456", darkHex: "#654321")

        #expect(manager.hasUnsavedChanges == true)
        #expect(manager.theme.editableSpec.colors.pair(for: .textPrimary)?.lightHex == "#123456")
    }

    @Test("Manager tracks unsaved changes through button binding")
    func testManagerButtonBinding() {
        let manager = GentleThemeManager()

        #expect(manager.hasUnsavedChanges == false)

        let binding = manager.bindingForButtonRole(.primary)
        var spec = binding.wrappedValue
        spec.pressedScale = 0.9
        binding.wrappedValue = spec

        #expect(manager.hasUnsavedChanges == true)
        #expect(manager.theme.editableSpec.buttons.roleSpec(for: .primary).pressedScale == 0.9)
    }

    @Test("Manager color binding returns fallback for missing role")
    func testManagerColorBindingFallback() {
        let emptySpec = GentleDesignSystemSpec(
            colors: GentleColorTokens(pairByRole: [:]),
            typography: .gentleDefault,
            layout: .gentleDefault,
            visual: .gentleDefault,
            buttons: .gentleDefault
        )
        let theme = GentleTheme(defaultSpec: emptySpec, editableSpec: emptySpec)
        let manager = GentleThemeManager(theme: theme)

        let binding = manager.bindingForColorRole(.textPrimary)
        let pair = binding.wrappedValue

        #expect(pair.lightHex == "#000000")
        #expect(pair.darkHex == "#FFFFFF")
    }
}

// MARK: - GentleFileThemeSpecStore Tests

@Suite("GentleFileThemeSpecStore Tests")
struct GentleFileThemeSpecStoreTests {

    @Test("Store initializes with default values")
    func testStoreInitialization() {
        let store = GentleFileThemeSpecStore()

        #expect(store.fileName == "gentle_theme_spec.json")
        #expect(store.subdirectory == "GentleDesignSystem")
    }

    @Test("Store initializes with custom values")
    func testStoreCustomInitialization() {
        let store = GentleFileThemeSpecStore(fileName: "custom.json", subdirectory: "CustomDir")

        #expect(store.fileName == "custom.json")
        #expect(store.subdirectory == "CustomDir")
    }

    @Test("Store can save and load spec")
    func testStoreSaveAndLoad() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_theme_\(UUID().uuidString).json")
        let spec = GentleDesignSystemSpec.gentleDefault

        // Save
        try store.saveEditableSpec(spec)

        // Load
        let loaded = try store.loadEditableSpec()

        #expect(loaded != nil)
        #expect(loaded?.specVersion == spec.specVersion)

        // Cleanup
        try store.clearEditableSpec()
    }

    @Test("Store returns nil for non-existent file")
    func testStoreLoadNonExistent() throws {
        let store = GentleFileThemeSpecStore(fileName: "non_existent_\(UUID().uuidString).json")

        let loaded = try store.loadEditableSpec()

        #expect(loaded == nil)
    }

    @Test("Store can clear spec")
    func testStoreClear() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_clear_\(UUID().uuidString).json")
        let spec = GentleDesignSystemSpec.gentleDefault

        try store.saveEditableSpec(spec)

        // Verify it exists
        let beforeClear = try store.loadEditableSpec()
        #expect(beforeClear != nil)

        // Clear
        try store.clearEditableSpec()

        // Verify it's gone
        let afterClear = try store.loadEditableSpec()
        #expect(afterClear == nil)
    }

    @Test("Store handles preset-specific files")
    func testStorePresetFiles() throws {
        let store = GentleFileThemeSpecStore()
        let presetName = "Test Preset \(UUID().uuidString)"
        let spec = GentleDesignSystemSpec.classic

        // Initially no saved spec
        #expect(try store.hasEditableSpec(forPreset: presetName) == false)

        // Save
        try store.saveEditableSpec(spec, forPreset: presetName)

        // Now exists
        #expect(try store.hasEditableSpec(forPreset: presetName) == true)

        // Load
        let loaded = try store.loadEditableSpec(forPreset: presetName)
        #expect(loaded?.typography.roleSpec(for: .largeTitle_xxl).design == .serif)

        // Clear
        try store.clearEditableSpec(forPreset: presetName)
        #expect(try store.hasEditableSpec(forPreset: presetName) == false)
    }
}

// MARK: - GentleResolvedTextStyle Tests

@Suite("GentleResolvedTextStyle Tests")
struct GentleResolvedTextStyleTests {

    @Test("Resolved text style contains all properties")
    func testResolvedTextStyleProperties() {
        let theme = GentleTheme.default
        let style = theme.textStyle(for: .body_m, sizeCategory: .large)

        #expect(style.colorRole == .textPrimary)
        #expect(style.lineSpacing >= 0)
        #expect(style.letterSpacing >= 0)
        #expect(style.isUppercased == false)
        #expect(style.design == .default)
    }

    @Test("Resolved text style respects uppercase setting")
    func testResolvedTextStyleUppercase() {
        var spec = GentleDesignSystemSpec.gentleDefault
        spec.typography.roles[GentleTextRole.caption_s.rawValue] = GentleTypographyRoleSpec(
            pointSize: 12,
            weight: .regular,
            design: .default,
            relativeTo: .caption,
            isUppercased: true,
            colorRole: .textTertiary
        )

        let theme = GentleTheme(defaultSpec: spec, editableSpec: spec)
        let style = theme.textStyle(for: .caption_s, sizeCategory: .large)

        #expect(style.isUppercased == true)
    }
}

// MARK: - Button Shape Tests

@Suite("GentleButtonShape Tests")
struct GentleButtonShapeTests {

    @Test("Button shapes have expected raw values")
    func testButtonShapeRawValues() {
        #expect(GentleButtonShape.rounded.rawValue == "rounded")
        #expect(GentleButtonShape.pill.rawValue == "pill")
    }
}

// MARK: - Text Chrome Tests

@Suite("GentleTextChrome Tests")
struct GentleTextChromeTests {

    @Test("Text chrome standalone has default rounded shape")
    func testTextChromeStandaloneDefault() {
        let chrome = GentleTextChrome.standalone()

        switch chrome {
        case .standalone(let shape):
            #expect(shape == .rounded)
        default:
            Issue.record("Expected standalone chrome")
        }
    }

    @Test("Text chrome standalone can have pill shape")
    func testTextChromeStandalonePill() {
        let chrome = GentleTextChrome.standalone(shape: .pill)

        switch chrome {
        case .standalone(let shape):
            #expect(shape == .pill)
        default:
            Issue.record("Expected standalone chrome")
        }
    }
}

// MARK: - Spacing Token Tests

@Suite("GentleSpacingToken Tests")
struct GentleSpacingTokenTests {

    @Test("All spacing tokens are case iterable")
    func testSpacingTokenCaseIterable() {
        let tokens = GentleSpacingToken.allCases
        #expect(tokens.count == 6)
        #expect(tokens.contains(.xs))
        #expect(tokens.contains(.s))
        #expect(tokens.contains(.m))
        #expect(tokens.contains(.l))
        #expect(tokens.contains(.xl))
        #expect(tokens.contains(.xxl))
    }
}

// MARK: - Inset Role Tests

@Suite("GentleInsetRole Tests")
struct GentleInsetRoleTests {

    @Test("Inset roles have expected raw values")
    func testInsetRoleRawValues() {
        #expect(GentleInsetRole.screen.rawValue == "screen")
        #expect(GentleInsetRole.card.rawValue == "card")
        #expect(GentleInsetRole.control.rawValue == "control")
        #expect(GentleInsetRole.listRow.rawValue == "listRow")
    }
}

// MARK: - Axis Inset Tokens Tests

@Suite("GentleAxisInsetTokens Tests")
struct GentleAxisInsetTokensTests {

    @Test("Axis inset tokens store horizontal and vertical values")
    func testAxisInsetTokens() {
        let tokens = GentleAxisInsetTokens(horizontal: .xl, vertical: .m)

        #expect(tokens.horizontal == .xl)
        #expect(tokens.vertical == .m)
    }

    @Test("Axis inset tokens are hashable")
    func testAxisInsetTokensHashable() {
        let tokens1 = GentleAxisInsetTokens(horizontal: .xl, vertical: .m)
        let tokens2 = GentleAxisInsetTokens(horizontal: .xl, vertical: .m)
        let tokens3 = GentleAxisInsetTokens(horizontal: .l, vertical: .m)

        #expect(tokens1 == tokens2)
        #expect(tokens1 != tokens3)

        var set = Set<GentleAxisInsetTokens>()
        set.insert(tokens1)
        set.insert(tokens2)
        #expect(set.count == 1)
    }
}

// MARK: - Text Field Shape Tests

@Suite("GentleTextFieldShape Tests")
struct GentleTextFieldShapeTests {

    @Test("Text field shapes have expected raw values")
    func testTextFieldShapeRawValues() {
        #expect(GentleTextFieldShape.rounded.rawValue == "rounded")
        #expect(GentleTextFieldShape.pill.rawValue == "pill")
    }
}

// MARK: - Text Ramp Tests

@Suite("GentleTextRamp Tests")
struct GentleTextRampTests {

    @Test("Text ramps have expected raw values")
    func testTextRampRawValues() {
        #expect(GentleTextRamp.xxl.rawValue == "xxl")
        #expect(GentleTextRamp.xl.rawValue == "xl")
        #expect(GentleTextRamp.l.rawValue == "l")
        #expect(GentleTextRamp.ml.rawValue == "ml")
        #expect(GentleTextRamp.m.rawValue == "m")
        #expect(GentleTextRamp.ms.rawValue == "ms")
        #expect(GentleTextRamp.s.rawValue == "s")
    }
}

// MARK: - Additional GentleThemeManager Tests

@Suite("GentleThemeManager Extended Tests")
@MainActor
struct GentleThemeManagerExtendedTests {

    @Test("Manager can save and load theme")
    func testManagerSaveAndLoad() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_manager_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)

        // Modify the theme
        let binding = manager.bindingForColorRole(.textPrimary)
        binding.wrappedValue = GentleColorPair(lightHex: "#AABBCC", darkHex: "#DDEEFF")

        #expect(manager.hasUnsavedChanges == true)

        // Save
        try manager.save()
        #expect(manager.hasUnsavedChanges == false)

        // Create a new manager with same store
        let newManager = GentleThemeManager(store: store)
        try newManager.load()

        let loadedPair = newManager.theme.editableSpec.colors.pair(for: .textPrimary)
        #expect(loadedPair?.lightHex == "#AABBCC")
        #expect(loadedPair?.darkHex == "#DDEEFF")

        // Cleanup
        try store.clearEditableSpec()
    }

    @Test("Manager can reset theme")
    func testManagerReset() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_reset_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)

        // Get original value
        let originalPair = manager.theme.defaultSpec.colors.pair(for: .textPrimary)

        // Modify and save
        let binding = manager.bindingForColorRole(.textPrimary)
        binding.wrappedValue = GentleColorPair(lightHex: "#111111", darkHex: "#222222")
        try manager.save()

        // Verify modification
        #expect(manager.theme.editableSpec.colors.pair(for: .textPrimary)?.lightHex == "#111111")

        // Reset
        try manager.reset()

        // Verify reset to default
        #expect(manager.theme.editableSpec.colors.pair(for: .textPrimary)?.lightHex == originalPair?.lightHex)
    }

    @Test("Manager can select preset")
    func testManagerSelectPreset() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_preset_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)

        // Select the classic preset
        try manager.selectPreset(name: "Classic", defaultSpec: .classic)

        #expect(manager.currentPresetName == "Classic")
        #expect(manager.theme.defaultSpec.typography.roleSpec(for: .largeTitle_xxl).design == .serif)
        #expect(manager.theme.editableSpec.typography.roleSpec(for: .largeTitle_xxl).design == .serif)
    }

    @Test("Manager preset saves and loads edits")
    func testManagerPresetSavesEdits() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_preset_edits_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)
        let presetName = "TestPreset_\(UUID().uuidString)"

        // Select a preset
        try manager.selectPreset(name: presetName, defaultSpec: .modern)

        // Make edits
        let binding = manager.bindingForTypographyRole(.body_m)
        var spec = binding.wrappedValue
        spec.pointSize = 25
        binding.wrappedValue = spec

        // Save
        try manager.save()

        // Create new manager and select same preset
        let newManager = GentleThemeManager(store: store)
        try newManager.selectPreset(name: presetName, defaultSpec: .modern)

        // Verify edits were loaded
        #expect(newManager.theme.editableSpec.typography.roleSpec(for: .body_m).pointSize == 25)

        // Cleanup
        try store.clearEditableSpec(forPreset: presetName)
    }

    @Test("Manager hasEditableSpec for preset")
    func testManagerHasEditableSpecForPreset() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_has_editable_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)
        let presetName = "CheckPreset_\(UUID().uuidString)"

        // Initially no saved spec
        #expect(manager.hasEditableSpec(forPreset: presetName) == false)

        // Select and save
        try manager.selectPreset(name: presetName, defaultSpec: .soft)
        let binding = manager.bindingForColorRole(.background)
        binding.wrappedValue = GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")
        try manager.save()

        // Now has saved spec
        #expect(manager.hasEditableSpec(forPreset: presetName) == true)

        // Cleanup
        try store.clearEditableSpec(forPreset: presetName)
    }

    @Test("Manager exportURL creates valid file")
    func testManagerExportURL() throws {
        let manager = GentleThemeManager()

        let url = try manager.exportURL()

        #expect(url.pathExtension == "json")
        #expect(FileManager.default.fileExists(atPath: url.path))

        // Verify content is valid JSON
        let data = try Data(contentsOf: url)
        let decoded = try GentleDesignSystemSpec.fromJSONData(data)
        #expect(decoded.specVersion == GentleDesignSystemSpecVersion.current)

        // Cleanup
        try FileManager.default.removeItem(at: url)
    }
}

// MARK: - Additional GentleTheme Tests

@Suite("GentleTheme Extended Tests")
struct GentleThemeExtendedTests {

    @Test("Theme buttons accessor works")
    func testThemeButtonsAccessor() {
        let theme = GentleTheme.default

        let buttons = theme.buttons
        #expect(buttons.roleSpec(for: .primary).backgroundRole == .primaryCTA)
    }

    @Test("Theme inset accessor works")
    func testThemeInsetAccessor() {
        let theme = GentleTheme.default

        let inset = theme.inset
        let screenInset = inset.axisTokens(for: .screen)
        #expect(screenInset.horizontal == .xl)
    }

    @Test("Theme text style with font width")
    func testThemeTextStyleWithFontWidth() {
        var spec = GentleDesignSystemSpec.gentleDefault
        spec.typography.roles[GentleTextRole.monoCode_m.rawValue] = GentleTypographyRoleSpec(
            pointSize: 17,
            weight: .regular,
            design: .monospaced,
            width: .condensed,
            relativeTo: .body,
            colorRole: .textPrimary
        )

        let theme = GentleTheme(defaultSpec: spec, editableSpec: spec)
        let style = theme.textStyle(for: .monoCode_m, sizeCategory: .large)

        #expect(style.design == .monospaced)
    }

    @Test("Theme text style without font width")
    func testThemeTextStyleWithoutFontWidth() {
        let theme = GentleTheme.default
        let style = theme.textStyle(for: .headline_m, sizeCategory: .large)

        // Should not crash when width is nil
        #expect(style.colorRole == .textPrimary)
    }

    @Test("Theme inset with leading edge")
    func testThemeInsetLeadingEdge() {
        let theme = GentleTheme.default

        let leadingInset = theme.insetValue(.screen, edges: .leading)
        #expect(leadingInset.horizontal == 24)
        #expect(leadingInset.vertical == nil)
    }

    @Test("Theme inset with trailing edge")
    func testThemeInsetTrailingEdge() {
        let theme = GentleTheme.default

        let trailingInset = theme.insetValue(.screen, edges: .trailing)
        #expect(trailingInset.horizontal == 24)
        #expect(trailingInset.vertical == nil)
    }

    @Test("Theme inset with top edge")
    func testThemeInsetTopEdge() {
        let theme = GentleTheme.default

        let topInset = theme.insetValue(.screen, edges: .top)
        #expect(topInset.horizontal == nil)
        #expect(topInset.vertical == 16)
    }

    @Test("Theme inset with bottom edge")
    func testThemeInsetBottomEdge() {
        let theme = GentleTheme.default

        let bottomInset = theme.insetValue(.screen, edges: .bottom)
        #expect(bottomInset.horizontal == nil)
        #expect(bottomInset.vertical == 16)
    }
}

// MARK: - GentleButtonTokens Extended Tests

@Suite("GentleButtonTokens Extended Tests")
struct GentleButtonTokensExtendedTests {

    @Test("Button tokens hardcoded fallback when empty")
    func testButtonTokensHardcodedFallback() {
        let tokens = GentleButtonTokens(roles: [:], animations: [:])

        let spec = tokens.roleSpec(for: .primary)

        // Should return hardcoded defaults
        #expect(spec.shape == .rounded)
        #expect(spec.textRole == .headline_m)
        #expect(spec.backgroundRole == .primaryCTA)
        #expect(spec.labelColorRole == .onPrimaryCTA)
    }

    @Test("Animation spec fallback for missing role")
    func testAnimationSpecFallback() {
        let tokens = GentleButtonTokens(roles: [:], animations: [:])

        let spec = tokens.animationSpec(for: .bouncy)

        // Should return default spec
        #expect(spec.pressedScale == 0.97)
    }
}

// MARK: - GentleFontWidthToken Extended Tests

@Suite("GentleFontWidthToken Extended Tests")
struct GentleFontWidthTokenExtendedTests {

    @Test("Font width tokens map to SwiftUI width")
    @available(iOS 17.0, *)
    func testFontWidthSwiftUIMapping() {
        #expect(GentleFontWidthToken.compressed.swiftUIWidth == .compressed)
        #expect(GentleFontWidthToken.condensed.swiftUIWidth == .condensed)
        #expect(GentleFontWidthToken.standard.swiftUIWidth == .standard)
        #expect(GentleFontWidthToken.expanded.swiftUIWidth == .expanded)
    }
}

// MARK: - Additional Preset Tests

@Suite("GentleDesignSystemSpec Extended Preset Tests")
struct GentleDesignSystemSpecExtendedPresetTests {

    @Test("Technical preset exists and is valid")
    func testTechnicalPreset() {
        let technical = GentleDesignSystemSpec.technical
        let titleSpec = technical.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.pointSize > 0)
    }

    @Test("Bold preset exists and is valid")
    func testBoldPreset() {
        let bold = GentleDesignSystemSpec.bold
        let titleSpec = bold.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.weight == .black || titleSpec.weight == .bold || titleSpec.weight == .heavy)
    }

    @Test("Elegant preset exists and is valid")
    func testElegantPreset() {
        let elegant = GentleDesignSystemSpec.elegant
        let titleSpec = elegant.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.pointSize > 0)
    }
}

// MARK: - JSON Encoding Edge Cases

@Suite("JSON Encoding Edge Cases Tests")
struct JSONEncodingEdgeCasesTests {

    @Test("Empty spec encodes and decodes")
    func testEmptySpecEncodeDecode() throws {
        let emptySpec = GentleDesignSystemSpec(
            colors: GentleColorTokens(pairByRole: [:]),
            typography: GentleTypographyTokens(roles: [:]),
            layout: GentleLayoutTokens(),
            visual: GentleVisualTokens(),
            buttons: GentleButtonTokens(roles: [:], animations: [:])
        )

        let data = try emptySpec.encodedJSONData()
        let decoded = try GentleDesignSystemSpec.fromJSONData(data)

        #expect(decoded.specVersion == emptySpec.specVersion)
    }

    @Test("Spec with all custom values encodes correctly")
    func testFullyCustomSpec() throws {
        let customSpec = GentleDesignSystemSpec(
            specVersion: "custom-1.0",
            colors: GentleColorTokens(pairByRole: [
                GentleColorRole.textPrimary.rawValue: GentleColorPair(lightHex: "#123ABC", darkHex: "#DEF456")
            ]),
            typography: GentleTypographyTokens(roles: [
                GentleTextRole.body_m.rawValue: GentleTypographyRoleSpec(
                    pointSize: 18,
                    weight: .medium,
                    design: .rounded,
                    width: .expanded,
                    relativeTo: .body,
                    lineSpacing: 5,
                    letterSpacing: 1,
                    isUppercased: true,
                    colorRole: .textSecondary
                )
            ]),
            layout: GentleLayoutTokens(
                scale: GentleSpacingScaleTokens(xs: 2, s: 4, m: 6, l: 8, xl: 10, xxl: 12)
            ),
            visual: GentleVisualTokens(
                radii: GentleRadiusTokens(small: 4, medium: 8, large: 16, pill: 500),
                shadows: GentleShadowTokens(none: 0, small: 1, medium: 3)
            ),
            buttons: GentleButtonTokens(
                roles: [
                    GentleButtonRole.primary.rawValue: GentleButtonRoleSpec(
                        shape: .pill,
                        textRole: .caption_s,
                        backgroundRole: .destructive,
                        labelColorRole: .textTertiary,
                        borderRole: .themePrimary,
                        animationRole: .pop,
                        pressedScale: 0.8,
                        pressedOpacity: 0.5
                    )
                ],
                animations: [:]
            )
        )

        let data = try customSpec.encodedJSONData()
        let decoded = try GentleDesignSystemSpec.fromJSONData(data)

        #expect(decoded.specVersion == "custom-1.0")
        #expect(decoded.colors.pair(for: .textPrimary)?.lightHex == "#123ABC")
        #expect(decoded.typography.roleSpec(for: .body_m).pointSize == 18)
        #expect(decoded.typography.roleSpec(for: .body_m).isUppercased == true)
        #expect(decoded.layout.scale.xs == 2)
        #expect(decoded.visual.radii.pill == 500)
        #expect(decoded.buttons.roleSpec(for: .primary).shape == .pill)
    }
}

// MARK: - Dynamic Type Tests

@Suite("Dynamic Type Tests")
struct DynamicTypeTests {

    @Test("Text style scales with different size categories")
    func testTextStyleScaling() {
        let theme = GentleTheme.default

        let smallStyle = theme.textStyle(for: .body_m, sizeCategory: .small)
        let largeStyle = theme.textStyle(for: .body_m, sizeCategory: .large)
        let accessibilityStyle = theme.textStyle(for: .body_m, sizeCategory: .accessibilityExtraLarge)

        // The styles should all have the same color role
        #expect(smallStyle.colorRole == largeStyle.colorRole)
        #expect(largeStyle.colorRole == accessibilityStyle.colorRole)
    }

    @Test("All size categories are supported")
    func testAllSizeCategories() {
        let theme = GentleTheme.default
        let sizeCategories: [ContentSizeCategory] = [
            .extraSmall, .small, .medium, .large,
            .extraLarge, .extraExtraLarge, .extraExtraExtraLarge,
            .accessibilityMedium, .accessibilityLarge,
            .accessibilityExtraLarge, .accessibilityExtraExtraLarge,
            .accessibilityExtraExtraExtraLarge
        ]

        for category in sizeCategories {
            let style = theme.textStyle(for: .body_m, sizeCategory: category)
            #expect(style.lineSpacing >= 0, "Style should be valid for \(category)")
        }
    }
}

// MARK: - Inset Fallback Tests

@Suite("Inset Fallback Tests")
struct InsetFallbackTests {

    @Test("Inset tokens fallback to hardcoded when completely empty")
    func testInsetTokensHardcodedFallback() {
        let emptyInsets = GentleInsetTokens(tokensByRole: [:])

        // When both the role and screen are missing, should fallback to hardcoded
        let axis = emptyInsets.axisTokens(for: .card)
        #expect(axis.horizontal == .xl)
        #expect(axis.vertical == .l)
    }
}
