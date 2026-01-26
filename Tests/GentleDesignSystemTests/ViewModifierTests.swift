//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - SwiftUI ViewModifier Tests

@Suite("GentleTextModifier Tests")
@MainActor
struct GentleTextModifierTests {

    @Test("Text modifier can be created with role")
    func testTextModifierCreation() {
        _ = GentleTextModifier(role: .body_m)
    }

    @Test("Text modifier can be created with override color role")
    func testTextModifierWithColorOverride() {
        _ = GentleTextModifier(role: .headline_m, overrideColorRole: .destructive)
    }

    @Test("View extension gentleText creates modifier")
    func testGentleTextExtension() {
        _ = Text("Hello").gentleText(.body_m)
    }

    @Test("View extension gentleText with color role creates modifier")
    func testGentleTextExtensionWithColor() {
        _ = Text("Hello").gentleText(.headline_m, colorRole: .textSecondary)
    }
}

@Suite("GentleTextFieldModifier Tests")
@MainActor
struct GentleTextFieldModifierTests {

    @Test("TextField modifier can be created with defaults")
    func testTextFieldModifierCreation() {
        _ = GentleTextFieldModifier(role: .body_m)
    }

    @Test("TextField modifier can be created with all parameters")
    func testTextFieldModifierWithAllParams() {
        _ = GentleTextFieldModifier(
            role: .body_m,
            overrideColorRole: .textSecondary,
            chrome: .standalone(shape: .pill)
        )
    }

    @Test("TextField modifier with formRow chrome")
    func testTextFieldModifierFormRow() {
        _ = GentleTextFieldModifier(role: .body_m, chrome: .formRow)
    }

    @Test("TextField modifier with borderless chrome")
    func testTextFieldModifierBorderless() {
        _ = GentleTextFieldModifier(role: .body_m, chrome: .borderless)
    }

    @Test("View extension gentleTextField creates modifier")
    func testGentleTextFieldExtension() {
        _ = TextField("Placeholder", text: .constant("")).gentleTextField(.body_m)
    }
}

@Suite("GentleSurfaceModifier Tests")
@MainActor
struct GentleSurfaceModifierTests {

    @Test("Surface modifier can be created with all roles")
    func testSurfaceModifierCreation() {
        let roles: [GentleSurfaceRole] = [
            .appBackground, .card, .cardElevated, .cardSecondary,
            .chrome, .overlaySheet, .overlayPopover,
            .floatingPanel, .floatingWidget
        ]

        for role in roles {
            _ = GentleSurfaceModifier(role: role)
        }
    }

    @Test("View extension gentleSurface creates modifier")
    func testGentleSurfaceExtension() {
        _ = Text("Hello").gentleSurface(.card)
    }
}

@Suite("GentleBackgroundModifier Tests")
@MainActor
struct GentleBackgroundModifierTests {

    @Test("Background modifier stores role and ignoresSafeArea")
    func testBackgroundModifierProperties() {
        let modifier = GentleBackgroundModifier(role: .background, ignoresSafeArea: true)
        #expect(modifier.role == .background)
        #expect(modifier.ignoresSafeArea == true)
    }

    @Test("View extension gentleBackground creates modifier")
    func testGentleBackgroundExtension() {
        _ = Text("Hello").gentleBackground(.surfaceBase)
    }

    @Test("View extension gentleBackground with ignoresSafeArea")
    func testGentleBackgroundExtensionWithSafeArea() {
        _ = Text("Hello").gentleBackground(.background, ignoresSafeArea: true)
    }
}

@Suite("GentleInsetModifier Tests")
@MainActor
struct GentleInsetModifierTests {

    @Test("Inset modifier can be created with all parameters")
    func testInsetModifierCreation() {
        _ = GentleInsetModifier(edges: .horizontal, role: .screen)
    }

    @Test("View extension gentleInset creates modifier")
    func testGentleInsetExtension() {
        _ = Text("Hello").gentleInset(.card)
    }

    @Test("View extension gentleInset with edges creates modifier")
    func testGentleInsetExtensionWithEdges() {
        _ = Text("Hello").gentleInset(.horizontal, .screen)
    }
}

@Suite("GentleButtonStyle Tests")
@MainActor
struct GentleButtonStyleTests {

    @Test("Button style can be created with minimal parameters")
    func testButtonStyleMinimal() {
        _ = GentleButtonStyle(role: .primary)
    }

    @Test("Button style can be created with all parameters")
    func testButtonStyleAllParams() {
        _ = GentleButtonStyle(
            role: .secondary,
            shape: .pill,
            textRole: .headline_m,
            expandsHorizontally: true,
            contentAlignment: .leading
        )
    }

    @Test("View extension gentleButton with role")
    func testGentleButtonExtension() {
        _ = Button("Tap") {}.gentleButton(.primary)
    }

    @Test("View extension gentleButton with role and shape")
    func testGentleButtonExtensionWithShape() {
        _ = Button("Tap") {}.gentleButton(.secondary, shape: .pill)
    }

    @Test("View extension gentleButton with role and textRole")
    func testGentleButtonExtensionWithTextRole() {
        _ = Button("Tap") {}.gentleButton(.tertiary, textRole: .caption_s)
    }

    @Test("View extension gentleButton with all overrides")
    func testGentleButtonExtensionWithAll() {
        _ = Button("Tap") {}.gentleButton(.destructive, shape: .rounded, textRole: .headline_m)
    }

    @Test("View extension gentleButton with expandsHorizontally")
    func testGentleButtonExtensionExpands() {
        _ = Button("Tap") {}.gentleButton(.primary, expandsHorizontally: true, contentAlignment: .center)
    }
}

@Suite("GentleThemeRoot Tests")
@MainActor
struct GentleThemeRootTests {

    @Test("Theme root can be created with default theme")
    func testThemeRootDefault() {
        _ = GentleThemeRoot {
            Text("Hello")
        }
    }

    @Test("Theme root can be created with custom theme")
    func testThemeRootCustom() {
        let customTheme = GentleTheme(defaultSpec: .classic)
        _ = GentleThemeRoot(theme: customTheme) {
            Text("Hello")
        }
    }
}

@Suite("View FontWidth Extension Tests")
@MainActor
struct ViewFontWidthExtensionTests {

    @Test("gentleFontWidth with nil returns self")
    func testGentleFontWidthNil() {
        _ = Text("Hello").gentleFontWidth(nil)
    }

    @Test("gentleFontWidth with compressed")
    func testGentleFontWidthCompressed() {
        _ = Text("Hello").gentleFontWidth(.compressed)
    }

    @Test("gentleFontWidth with condensed")
    func testGentleFontWidthCondensed() {
        _ = Text("Hello").gentleFontWidth(.condensed)
    }

    @Test("gentleFontWidth with standard")
    func testGentleFontWidthStandard() {
        _ = Text("Hello").gentleFontWidth(.standard)
    }

    @Test("gentleFontWidth with expanded")
    func testGentleFontWidthExpanded() {
        _ = Text("Hello").gentleFontWidth(.expanded)
    }
}

@Suite("GentleNavigationBarStyler Tests")
@MainActor
struct GentleNavigationBarStylerTests {

    @Test("GentleNavigationBarStyler can be created")
    func testNavigationBarStyler() {
        _ = GentleNavigationBarStyler()
    }
}

@Suite("GentleUIKitTheming Tests")
@MainActor
struct GentleUIKitThemingTests {

    @Test("Apply navigation bar title style does not crash")
    func testApplyNavigationBarTitleStyle() {
        let theme = GentleTheme.default

        // Should not throw or crash
        GentleUIKitTheming.applyNavigationBarTitleStyle(
            theme: theme,
            textRole: .largeTitle_xxl,
            colorRole: .textPrimary
        )
    }

    @Test("Apply navigation bar with different text roles")
    func testApplyNavigationBarWithDifferentRoles() {
        let theme = GentleTheme.default

        // Test with various roles
        GentleUIKitTheming.applyNavigationBarTitleStyle(
            theme: theme,
            textRole: .title_xl,
            colorRole: .textSecondary
        )

        GentleUIKitTheming.applyNavigationBarTitleStyle(
            theme: theme,
            textRole: .headline_m,
            colorRole: .themePrimary
        )
    }

    @Test("Apply navigation bar with theme containing font width")
    func testApplyNavigationBarWithFontWidth() {
        var spec = GentleDesignSystemSpec.gentleDefault
        spec.typography.roles[GentleTextRole.largeTitle_xxl.rawValue] = GentleTypographyRoleSpec(
            pointSize: 34,
            weight: .bold,
            design: .default,
            width: .expanded,
            relativeTo: .largeTitle,
            colorRole: .textPrimary
        )

        let theme = GentleTheme(defaultSpec: spec, editableSpec: spec)

        GentleUIKitTheming.applyNavigationBarTitleStyle(
            theme: theme,
            textRole: .largeTitle_xxl,
            colorRole: .textPrimary
        )
    }

    @Test("Apply navigation bar with missing color role returns early")
    func testApplyNavigationBarWithMissingColorRole() {
        let emptyColors = GentleColorTokens(pairByRole: [:])
        let spec = GentleDesignSystemSpec(
            colors: emptyColors,
            typography: .gentleDefault,
            layout: .gentleDefault,
            visual: .gentleDefault,
            buttons: .gentleDefault
        )
        let theme = GentleTheme(defaultSpec: spec, editableSpec: spec)

        // Should return early without crashing
        GentleUIKitTheming.applyNavigationBarTitleStyle(
            theme: theme,
            textRole: .largeTitle_xxl,
            colorRole: .textPrimary
        )
    }

    @Test("Apply navigation bar with all font designs")
    func testApplyNavigationBarWithAllFontDesigns() {
        _ = GentleTheme.default
        let designs: [GentleFontDesignToken] = [.default, .serif, .rounded, .monospaced]

        for design in designs {
            var spec = GentleDesignSystemSpec.gentleDefault
            spec.typography.roles[GentleTextRole.largeTitle_xxl.rawValue] = GentleTypographyRoleSpec(
                pointSize: 34,
                weight: .bold,
                design: design,
                relativeTo: .largeTitle,
                colorRole: .textPrimary
            )

            let themeWithDesign = GentleTheme(defaultSpec: spec, editableSpec: spec)
            GentleUIKitTheming.applyNavigationBarTitleStyle(
                theme: themeWithDesign,
                textRole: .largeTitle_xxl,
                colorRole: .textPrimary
            )
        }
    }

    @Test("Apply navigation bar with all font weights")
    func testApplyNavigationBarWithAllFontWeights() {
        for weight in GentleFontWeightToken.allCases {
            var spec = GentleDesignSystemSpec.gentleDefault
            spec.typography.roles[GentleTextRole.largeTitle_xxl.rawValue] = GentleTypographyRoleSpec(
                pointSize: 34,
                weight: weight,
                design: .default,
                relativeTo: .largeTitle,
                colorRole: .textPrimary
            )

            let theme = GentleTheme(defaultSpec: spec, editableSpec: spec)
            GentleUIKitTheming.applyNavigationBarTitleStyle(
                theme: theme,
                textRole: .largeTitle_xxl,
                colorRole: .textPrimary
            )
        }
    }
}
