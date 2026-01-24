//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

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
        #expect(screenInset.horizontal == 12) // m = 12
        #expect(screenInset.vertical == 16) // l = 16
    }

    @Test("Theme inset value with edge subset")
    func testThemeInsetValueEdges() {
        let theme = GentleTheme.default

        let horizontalOnly = theme.insetValue(.screen, edges: .horizontal)
        #expect(horizontalOnly.horizontal == 12)
        #expect(horizontalOnly.vertical == nil)

        let verticalOnly = theme.insetValue(.screen, edges: .vertical)
        #expect(verticalOnly.horizontal == nil)
        #expect(verticalOnly.vertical == 16)
    }
}

@Suite("GentleTheme Extended Tests")
struct GentleThemeExtendedTests {

    @Test("Theme buttons accessor works")
    func testThemeButtonsAccessor() {
        let theme = GentleTheme.default

        let buttons = theme.buttons
        #expect(buttons.roleSpec(for: .primary).materialRole == .solidFillPrimaryCTA)
    }

    @Test("Theme inset accessor works")
    func testThemeInsetAccessor() {
        let theme = GentleTheme.default

        let inset = theme.inset
        let screenInset = inset.axisTokens(for: .screen)
        #expect(screenInset.horizontal == .m)
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
        #expect(leadingInset.horizontal == 12)
        #expect(leadingInset.vertical == nil)
    }

    @Test("Theme inset with trailing edge")
    func testThemeInsetTrailingEdge() {
        let theme = GentleTheme.default

        let trailingInset = theme.insetValue(.screen, edges: .trailing)
        #expect(trailingInset.horizontal == 12)
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

@Suite("GentleTheme ID Tests")
struct GentleThemeIDTests {

    @Test("Theme has default ID of 0")
    func testThemeDefaultID() {
        let theme = GentleTheme.default
        #expect(theme.id == 0)
    }

    @Test("Theme ID can be modified")
    func testThemeIDModification() {
        var theme = GentleTheme.default
        theme.id = 42
        #expect(theme.id == 42)
    }
}

@Suite("Theme Spec Accessors Tests")
struct ThemeSpecAccessorsTests {

    @Test("Theme spec accessor returns activeSpec")
    func testThemeSpecAccessor() {
        let theme = GentleTheme.default
        #expect(theme.spec.specVersion == theme.activeSpec.specVersion)
    }

    @Test("Theme gap accessor works")
    func testThemeGapAccessor() {
        let theme = GentleTheme.default
        #expect(theme.gap.m == 12)
    }

    @Test("Theme grid accessor works")
    func testThemeGridAccessor() {
        let theme = GentleTheme.default
        #expect(theme.grid.m == 12)
    }

    @Test("Theme touch accessor works")
    func testThemeTouchAccessor() {
        let theme = GentleTheme.default
        #expect(theme.touch.m == 12)
    }
}

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

@Suite("GentleDesignRuntime Tests")
struct GentleDesignRuntimeTests {

    @Test("Resolver layout facade works")
    func testResolverLayoutFacade() {
        let theme = GentleTheme.default
        let resolver = GentleDesignRuntime.Resolver(theme: theme, colorScheme: .light)

        #expect(resolver.layout.gap.regular == 12)
    }

    @Test("Resolver visual tokens work")
    func testResolverVisualTokens() {
        let theme = GentleTheme.default
        let resolver = GentleDesignRuntime.Resolver(theme: theme, colorScheme: .light)

        #expect(resolver.visual.radii.medium == 12)
        #expect(resolver.radii.medium == 12)
        #expect(resolver.shadows.small == 2)
    }

    @Test("Resolver buttons accessor works")
    func testResolverButtonsAccessor() {
        let theme = GentleTheme.default
        let resolver = GentleDesignRuntime.Resolver(theme: theme, colorScheme: .light)

        #expect(resolver.buttons.roleSpec(for: .primary).materialRole == .solidFillPrimaryCTA)
    }

    @Test("Resolver color function works")
    func testResolverColorFunction() {
        let theme = GentleTheme.default
        let lightResolver = GentleDesignRuntime.Resolver(theme: theme, colorScheme: .light)
        let darkResolver = GentleDesignRuntime.Resolver(theme: theme, colorScheme: .dark)

        #expect(lightResolver.color(.textPrimary) != Color.clear)
        #expect(darkResolver.color(.textPrimary) != Color.clear)
    }

    @Test("Resolver convenience color properties work")
    func testResolverConvenienceColors() {
        let theme = GentleTheme.default
        let resolver = GentleDesignRuntime.Resolver(theme: theme, colorScheme: .light)

        #expect(resolver.surface != Color.clear)
        #expect(resolver.background != Color.clear)
        #expect(resolver.borderSubtle != Color.clear)
        #expect(resolver.textPrimary != Color.clear)
        #expect(resolver.themePrimary != Color.clear)
    }
}
