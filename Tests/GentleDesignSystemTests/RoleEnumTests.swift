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
        #expect(GentleColorRole.allCases.count == 16)
    }

    @Test("Expected color roles exist")
    func testExpectedColorRolesExist() {
        let expectedRoles: [GentleColorRole] = [
            .textPrimary, .textSecondary, .textTertiary,
            .onPrimaryCTA,
            .background, .surface,
            .surfaceTint, .surfaceSpecular,
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

    @Test("All color roles have unique raw values")
    func testColorRoleUniqueRawValues() {
        let rawValues = GentleColorRole.allCases.map { $0.rawValue }
        let uniqueValues = Set(rawValues)
        #expect(rawValues.count == uniqueValues.count)
    }

    @Test("Theme color with all roles")
    func testThemeColorWithAllRoles() {
        let theme = GentleTheme.default

        for role in GentleColorRole.allCases {
            let lightColor = theme.color(for: role, scheme: .light)
            let darkColor = theme.color(for: role, scheme: .dark)

            // Should return valid colors (not clear)
            #expect(lightColor != Color.clear)
            #expect(darkColor != Color.clear)
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

    @Test("All button roles have unique raw values")
    func testButtonRoleUniqueRawValues() {
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        let rawValues = roles.map { $0.rawValue }
        let uniqueValues = Set(rawValues)
        #expect(rawValues.count == uniqueValues.count)
    }

    @Test("Button tokens have specs for all roles")
    func testButtonTokensHaveAllRoles() {
        let tokens = GentleButtonTokens.gentleDefault
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]

        for role in roles {
            let spec = tokens.roleSpec(for: role)
            #expect(!spec.materialRole.rawValue.isEmpty)
        }
    }
}

@Suite("GentleButtonAnimationRole Tests")
struct GentleButtonAnimationRoleTests {

    @Test("All animation roles are case iterable")
    func testAnimationRoleCaseIterable() {
        let roles = GentleButtonAnimationRole.allCases
        #expect(roles.count == 6)
        #expect(roles.contains(.unknown))
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
        #expect(GentleSurfaceRole.cardElevated.rawValue == "cardElevated")
        #expect(GentleSurfaceRole.surfaceOverlay.rawValue == "surfaceOverlay")
    }

    @Test("All surface roles have unique raw values")
    func testSurfaceRoleUniqueRawValues() {
        let allRoles: [GentleSurfaceRole] = [.appBackground, .card, .cardElevated, .surfaceOverlay]
        let rawValues = allRoles.map { $0.rawValue }
        let uniqueValues = Set(rawValues)
        #expect(rawValues.count == uniqueValues.count)
    }
}

@Suite("GentleSurfaceRole Identifiable Tests")
struct GentleSurfaceRoleIdentifiableTests {

    @Test("Surface roles are identifiable by rawValue")
    func testSurfaceRoleIdentifiable() {
        let roles: [GentleSurfaceRole] = [.appBackground, .card, .cardElevated, .surfaceOverlay]
        for role in roles {
            #expect(role.id == role.rawValue)
        }
    }
}

@Suite("GentleGapIntent Tests")
struct GentleGapIntentTests {

    @Test("All gap intents are case iterable")
    func testGapIntentCaseIterable() {
        let intents = GentleGapIntent.allCases
        #expect(intents.count == 7)
        #expect(intents.contains(.unknown))
        #expect(intents.contains(.micro))
        #expect(intents.contains(.tight))
        #expect(intents.contains(.regular))
        #expect(intents.contains(.ample))
        #expect(intents.contains(.loose))
        #expect(intents.contains(.expansive))
    }

    @Test("Gap facade intent values match expected scale tokens")
    func testGapFacadeIntentValuesMatchScale() {
        let scale = GentleSpacingScaleTokens.gentleDefault
        let facade = GentleGapScaleFacade(scale: scale)

        #expect(facade.value(.unknown) == 0)
        #expect(facade.value(.micro) == facade.xs)
        #expect(facade.value(.tight) == facade.s)
        #expect(facade.value(.regular) == facade.m)
        #expect(facade.value(.ample) == facade.l)
        #expect(facade.value(.loose) == facade.xl)
        #expect(facade.value(.expansive) == facade.xxl)
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

    @Test("All font text styles have UIKit mappings")
    func testAllFontTextStylesHaveUIKitMappings() {
        let styles: [GentleFontTextStyle] = [
            .largeTitle, .title, .title2, .title3, .headline,
            .body, .callout, .subheadline, .footnote, .caption, .caption2
        ]

        for style in styles {
            // Should not crash and should return valid UIKit style
            let uiKitStyle = style.uiKitTextStyle
            #expect(!uiKitStyle.rawValue.isEmpty)
        }
    }
}

@Suite("GentleButtonShape Tests")
struct GentleButtonShapeTests {

    @Test("Button shapes have expected raw values")
    func testButtonShapeRawValues() {
        #expect(GentleButtonShape.rounded.rawValue == "rounded")
        #expect(GentleButtonShape.pill.rawValue == "pill")
    }
}

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

    @Test("Text chrome formRow case")
    func testTextChromeFormRow() {
        let chrome = GentleTextChrome.formRow

        switch chrome {
        case .formRow:
            // Expected
            break
        default:
            Issue.record("Expected formRow chrome")
        }
    }

    @Test("Text chrome borderless case")
    func testTextChromeBorderless() {
        let chrome = GentleTextChrome.borderless

        switch chrome {
        case .borderless:
            // Expected
            break
        default:
            Issue.record("Expected borderless chrome")
        }
    }
}

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

@Suite("GentleInsetRole Tests")
struct GentleInsetRoleTests {

    @Test("Inset roles have expected raw values")
    func testInsetRoleRawValues() {
        #expect(GentleInsetRole.screen.rawValue == "screen")
        #expect(GentleInsetRole.card.rawValue == "card")
        #expect(GentleInsetRole.control.rawValue == "control")
        #expect(GentleInsetRole.listRow.rawValue == "listRow")
    }

    @Test("All inset roles are unique")
    func testAllInsetRolesUnique() {
        let roles: [GentleInsetRole] = [.screen, .card, .control, .listRow]
        let rawValues = roles.map { $0.rawValue }
        let uniqueValues = Set(rawValues)
        #expect(rawValues.count == uniqueValues.count)
    }
}

@Suite("GentleTextFieldShape Tests")
struct GentleTextFieldShapeTests {

    @Test("Text field shapes have expected raw values")
    func testTextFieldShapeRawValues() {
        #expect(GentleTextFieldShape.rounded.rawValue == "rounded")
        #expect(GentleTextFieldShape.pill.rawValue == "pill")
    }
}

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
