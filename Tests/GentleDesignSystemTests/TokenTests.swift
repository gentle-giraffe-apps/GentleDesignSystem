//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

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

    @Test("All text roles have specs in gentleDefault")
    func testAllTextRolesHaveSpecs() {
        let tokens = GentleTypographyTokens.gentleDefault

        for role in GentleTextRole.allCases {
            let spec = tokens.roleSpec(for: role)
            #expect(spec.pointSize > 0, "Role \(role) should have positive point size")
            #expect(!spec.colorRole.rawValue.isEmpty)
        }
    }

    @Test("Typography tokens with custom roles")
    func testTypographyTokensCustomRoles() {
        let customSpec = GentleTypographyRoleSpec(
            pointSize: 42,
            weight: .black,
            design: .monospaced,
            width: .compressed,
            relativeTo: .headline,
            lineSpacing: 10,
            letterSpacing: 2,
            isUppercased: true,
            colorRole: .destructive
        )

        let tokens = GentleTypographyTokens(roles: [
            GentleTextRole.headline_m.rawValue: customSpec
        ])

        let retrieved = tokens.roleSpec(for: .headline_m)
        #expect(retrieved.pointSize == 42)
        #expect(retrieved.weight == .black)
        #expect(retrieved.design == .monospaced)
        #expect(retrieved.width == .compressed)
        #expect(retrieved.lineSpacing == 10)
        #expect(retrieved.letterSpacing == 2)
        #expect(retrieved.isUppercased == true)
        #expect(retrieved.colorRole == .destructive)
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

    @Test("Spacing scale is codable")
    func testSpacingScaleCodable() throws {
        let original = GentleSpacingScaleTokens(xs: 1, s: 2, m: 3, l: 4, xl: 5, xxl: 6)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSpacingScaleTokens.self, from: data)

        #expect(decoded.xs == 1)
        #expect(decoded.s == 2)
        #expect(decoded.m == 3)
        #expect(decoded.l == 4)
        #expect(decoded.xl == 5)
        #expect(decoded.xxl == 6)
    }

    @Test("All spacing tokens return correct values")
    func testAllSpacingTokensReturnCorrectValues() {
        let scale = GentleSpacingScaleTokens(xs: 1, s: 2, m: 3, l: 4, xl: 5, xxl: 6)

        #expect(scale.value(for: .xs) == 1)
        #expect(scale.value(for: .s) == 2)
        #expect(scale.value(for: .m) == 3)
        #expect(scale.value(for: .l) == 4)
        #expect(scale.value(for: .xl) == 5)
        #expect(scale.value(for: .xxl) == 6)
    }
}

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

    @Test("Axis inset tokens are codable")
    func testAxisInsetTokensCodable() throws {
        let original = GentleAxisInsetTokens(horizontal: .xl, vertical: .s)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleAxisInsetTokens.self, from: data)

        #expect(decoded.horizontal == original.horizontal)
        #expect(decoded.vertical == original.vertical)
    }

    @Test("All spacing token combinations work")
    func testAllSpacingTokenCombinations() {
        for h in GentleSpacingToken.allCases {
            for v in GentleSpacingToken.allCases {
                let tokens = GentleAxisInsetTokens(horizontal: h, vertical: v)
                #expect(tokens.horizontal == h)
                #expect(tokens.vertical == v)
            }
        }
    }
}

@Suite("GentleInsetTokens Tests")
struct GentleInsetTokensTests {

    @Test("Default inset tokens have expected roles")
    func testDefaultInsetTokens() {
        let insets = GentleInsetTokens.gentleDefault

        let screen = insets.axisTokens(for: .screen)
        #expect(screen.horizontal == .m)
        #expect(screen.vertical == .l)

        let card = insets.axisTokens(for: .card)
        #expect(card.horizontal == .l)
        #expect(card.vertical == .l)

        let control = insets.axisTokens(for: .control)
        #expect(control.horizontal == .l)
        #expect(control.vertical == .s)

        let listRow = insets.axisTokens(for: .listRow)
        #expect(listRow.horizontal == .l)
        #expect(listRow.vertical == .s)
    }

    @Test("Inset tokens fallback to screen for missing role")
    func testInsetTokensFallback() {
        let insets = GentleInsetTokens(tokensByRoleVariant: [
            GentleInsetRole.screen.rawValue: [
                GentleInsetVariant.regular.rawValue: .init(horizontal: .xxl, vertical: .xl)
            ]
        ])

        // Request missing role should fallback to screen+regular
        let axis = insets.axisTokens(for: .card)
        #expect(axis.horizontal == .xxl)
        #expect(axis.vertical == .xl)
    }

    @Test("Inset tokens are codable")
    func testInsetTokensCodable() throws {
        let original = GentleInsetTokens.gentleDefault
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleInsetTokens.self, from: data)

        let originalScreen = original.axisTokens(for: .screen)
        let decodedScreen = decoded.axisTokens(for: .screen)

        #expect(originalScreen.horizontal == decodedScreen.horizontal)
        #expect(originalScreen.vertical == decodedScreen.vertical)
    }

    @Test("Inset tokens fallback chain")
    func testInsetTokensFallbackChain() {
        // Only has screen+regular, missing card
        let insets = GentleInsetTokens(tokensByRoleVariant: [
            GentleInsetRole.screen.rawValue: [
                GentleInsetVariant.regular.rawValue: .init(horizontal: .xxl, vertical: .xl)
            ]
        ])

        // Card should fallback to screen+regular
        let cardAxis = insets.axisTokens(for: .card)
        #expect(cardAxis.horizontal == .xxl)
        #expect(cardAxis.vertical == .xl)

        // Control should also fallback to screen+regular
        let controlAxis = insets.axisTokens(for: .control)
        #expect(controlAxis.horizontal == .xxl)
        #expect(controlAxis.vertical == .xl)
    }

    @Test("Inset tokens fallback to hardcoded when completely empty")
    func testInsetTokensHardcodedFallback() {
        let emptyInsets = GentleInsetTokens(tokensByRoleVariant: [:])

        // When both the role and screen are missing, should fallback to hardcoded
        let axis = emptyInsets.axisTokens(for: .card)
        #expect(axis.horizontal == .xl)
        #expect(axis.vertical == .l)
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

    @Test("Layout tokens are codable")
    func testLayoutTokensCodable() throws {
        let original = GentleLayoutTokens.gentleDefault
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleLayoutTokens.self, from: data)

        #expect(decoded.scale.m == original.scale.m)
        #expect(decoded.gap.m == original.gap.m)
        #expect(decoded.grid.m == original.grid.m)
        #expect(decoded.touch.m == original.touch.m)
    }

    @Test("Layout tokens custom initialization")
    func testLayoutTokensCustomInit() {
        let customScale = GentleSpacingScaleTokens(xs: 2, s: 4, m: 6, l: 8, xl: 10, xxl: 12)
        let layout = GentleLayoutTokens(
            scale: customScale,
            gap: customScale,
            grid: customScale,
            touch: customScale,
            inset: .gentleDefault
        )

        #expect(layout.scale.xs == 2)
        #expect(layout.gap.s == 4)
        #expect(layout.grid.m == 6)
        #expect(layout.touch.l == 8)
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

    @Test("Radius tokens are codable")
    func testRadiusTokensCodable() throws {
        let original = GentleRadiusTokens(small: 4, medium: 8, large: 16, pill: 500)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleRadiusTokens.self, from: data)

        #expect(decoded.small == 4)
        #expect(decoded.medium == 8)
        #expect(decoded.large == 16)
        #expect(decoded.pill == 500)
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

    @Test("Shadow tokens are codable")
    func testShadowTokensCodable() throws {
        let original = GentleShadowTokens(none: 0, small: 1, medium: 3)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleShadowTokens.self, from: data)

        #expect(decoded.none == 0)
        #expect(decoded.small == 1)
        #expect(decoded.medium == 3)
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

    @Test("Visual tokens are codable")
    func testVisualTokensCodable() throws {
        let original = GentleVisualTokens(
            radii: GentleRadiusTokens(small: 4, medium: 8, large: 16, pill: 500),
            shadows: GentleShadowTokens(none: 0, small: 1, medium: 3)
        )
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleVisualTokens.self, from: data)

        #expect(decoded.radii.small == 4)
        #expect(decoded.shadows.small == 1)
    }
}
