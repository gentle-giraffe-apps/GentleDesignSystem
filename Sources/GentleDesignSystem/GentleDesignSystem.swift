//  Jonathan Ritchey

import SwiftUI
import Foundation
import UIKit

// MARK: - Roles

/** Naming guide (conventions, not strict rules):
 - Base role: largeTitle, title, headline, body, callout, caption, etc.
 - Numeric suffixes (2, 3, …) mirror SwiftUI semantics (e.g. title2, title3, caption2).
 - Order suffixes (Secondary, Tertiary) indicate reduced visual emphasis
   (typically via color/opacity/weight) without changing the underlying semantic font.
 - Ramp suffix (_xxl → _s) indicates relative position in the typography scale,
   not a fixed point size.
 */
public enum GentleTextRole: String, Codable, Sendable {
    // Ramp legend:
    // xxl > xl > l > ml > m > ms > s
    case largeTitle_xxl
    case title_xl
    case title2_l
    case title3_ml         // medium → large leaning

    case headline_m
    case body_m
    case bodySecondary_m
    case monoCode_m

    case callout_ms        // medium → small leaning
    case subheadline_ms

    case footnote_s
    case caption_s
    case caption2_s
}

public enum GentleTextRamp: String, Codable, Sendable {
    case xxl, xl, l, ml, m, ms, s
}

public extension GentleTextRole {
    var ramp: GentleTextRamp {
        switch self {
        case .largeTitle_xxl: return .xxl
        case .title_xl: return .xl
        case .title2_l: return .l
        case .title3_ml: return .ml
        case .headline_m, .body_m, .bodySecondary_m, .monoCode_m: return .m
        case .callout_ms, .subheadline_ms: return .ms
        case .footnote_s, .caption_s, .caption2_s: return .s
        }
    }
}

public enum GentleColorRole: String, Codable, Sendable {
    case textPrimary
    case textSecondary
    case textTertiary
    case onPrimaryCTA
    case background
    case surface
    case surfaceElevated
    case surfaceOverlay
    case onSurfaceOverlayPrimary
    case onSurfaceOverlaySecondary
    case borderSubtle
    case destructive
    case primaryCTA
    case themePrimary
    case themeSecondary
}

public enum GentleButtonRole: String, Codable, Sendable {
    case primary
    case secondary
    case tertiary
    case destructive
}

/// Separates geometry from intent.
/// - rounded: standard rounded rectangle (default)
/// - pill: capsule-like button
public enum GentleButtonShape: String, Codable, Sendable {
    case rounded
    case pill
}

/// Shape of a standalone text input container (only applies when chrome is `.standalone`).
public enum GentleTextFieldShape: String, Codable, Sendable {
    case rounded
    case pill
}

/// Controls ownership/strength of input affordances.
/// - standalone: draws its own container chrome (background, border, shape)
/// - formRow: assumes container (Form/List row) provides most chrome
/// - borderless: no container chrome (inline / minimalist)
public enum GentleTextChrome: Sendable {
    case standalone(shape: GentleTextFieldShape = .rounded)
    case formRow
    case borderless
}

public enum GentleSurfaceRole: String, Codable, Sendable {
    case appBackground
    case card
    case cardChrome // no padding
    case cardElevated
    case surfaceOverlay
}

// MARK: - Dynamic Type anchor (Option B)

/// JSON-friendly semantic anchor for Dynamic Type scaling.
public enum GentleFontTextStyle: String, Codable, Sendable {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption
    case caption2
}

public extension GentleFontTextStyle {
    /// UIKit semantic anchor used by UIFontMetrics for Dynamic Type scaling.
    var uiKitTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .body: return .body
        case .callout: return .callout
        case .subheadline: return .subheadline
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        }
    }
}

private extension ContentSizeCategory {
    var uiContentSizeCategory: UIContentSizeCategory {
        switch self {
        case .extraSmall: return .extraSmall
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        case .extraLarge: return .extraLarge
        case .extraExtraLarge: return .extraExtraLarge
        case .extraExtraExtraLarge: return .extraExtraExtraLarge
        case .accessibilityMedium: return .accessibilityMedium
        case .accessibilityLarge: return .accessibilityLarge
        case .accessibilityExtraLarge: return .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge: return .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge: return .accessibilityExtraExtraExtraLarge
        @unknown default: return .large
        }
    }
}

// MARK: - Codable token structs (JSON-friendly)

// Top-level spec: load/save as JSON
public struct GentleDesignSystemSpec: Codable, Sendable {
    public var colors: GentleColorTokens
    public var typography: GentleTypographyTokens
    public var spacing: GentleSpacingTokens
    public var padding: GentlePaddingTokens
    public var radii: GentleRadiusTokens
    public var shadows: GentleShadowTokens

    public init(colors: GentleColorTokens,
                typography: GentleTypographyTokens,
                spacing: GentleSpacingTokens,
                padding: GentlePaddingTokens,
                radii: GentleRadiusTokens,
                shadows: GentleShadowTokens) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.padding = padding
        self.radii = radii
        self.shadows = shadows
    }
}

public extension GentleDesignSystemSpec {
    static let gentleDefault: GentleDesignSystemSpec = .init(
        colors: .gentleDefault,
        typography: .gentleDefault,
        spacing: .gentleDefault,
        padding: .gentleDefault,
        radii: .gentleDefault,
        shadows: .gentleDefault
    )
}

// MARK: - Colors (Light/Dark pairs)

public struct GentleColorPair: Codable, Sendable {
    public var lightHex: String
    public var darkHex: String

    public init(lightHex: String, darkHex: String) {
        self.lightHex = lightHex
        self.darkHex = darkHex
    }

    public func hex(for scheme: ColorScheme) -> String {
        scheme == .dark ? darkHex : lightHex
    }
}

/// JSON-facing storage uses String keys (role.rawValue).
public struct GentleColorTokens: Codable, Sendable {
    public var pairByRole: [String: GentleColorPair]

    public init(pairByRole: [String: GentleColorPair]) {
        self.pairByRole = pairByRole
    }

    // Typed convenience
    public func pair(for role: GentleColorRole) -> GentleColorPair? {
        pairByRole[role.rawValue]
    }
}

public extension GentleColorTokens {
    /// Defaults chosen to be reasonable, high-contrast, and visually consistent across light/dark.
    /// You can (and should) tune these as GentleDesign evolves.
    static let gentleDefault: GentleColorTokens = .init(
        pairByRole: [
            // Text
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#1F2933", darkHex: "#F5F7FA"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#4B5563", darkHex: "#C7CDD4"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#6B7280", darkHex: "#9AA0A6"),

            // Surfaces
            GentleColorRole.background.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#0B0F19"),
            GentleColorRole.surface.rawValue: .init(lightHex: "#FAFAFE", darkHex: "#111827"),
            GentleColorRole.surfaceOverlay.rawValue: .init(lightHex: "#111827CC", darkHex: "#020617CC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue: .init(lightHex: "#F9FAFB", darkHex: "#F9FAFB"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#D1D5DB", darkHex:  "#D1D5DB"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#1F2937"),
            GentleColorRole.borderSubtle.rawValue: .init(lightHex: "#E5E7EB", darkHex: "#374151"),

            // Actions / status
            GentleColorRole.primaryCTA.rawValue: .init(lightHex: "#4A6EF5", darkHex: "#3B82F6"),
            GentleColorRole.onPrimaryCTA.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.destructive.rawValue: .init(lightHex: "#E35D5B", darkHex: "#F87171"),

            // Theme Colors
            GentleColorRole.themePrimary.rawValue: .init(lightHex: "#4A6EF5", darkHex: "#3B82F6"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#8FA2FF", darkHex:  "#93C5FD")
        ]
    )
}

// MARK: - Typography axis enums (JSON-friendly)

public enum GentleFontDesignToken: String, Codable, Sendable {
    case `default`
    case serif
    case rounded
    case monospaced

    var swiftUIDesign: Font.Design {
        switch self {
        case .default: return .default
        case .serif: return .serif
        case .rounded: return .rounded
        case .monospaced: return .monospaced
        }
    }
}

/// Note: Font.Width is iOS 17+. We still store it in JSON, but only apply when available.
public enum GentleFontWidthToken: String, Codable, Sendable {
    case compressed
    case condensed
    case standard
    case expanded

    @available(iOS 17.0, *)
    var swiftUIWidth: Font.Width {
        switch self {
        case .compressed: return .compressed
        case .condensed: return .condensed
        case .standard: return .standard
        case .expanded: return .expanded
        }
    }
}

public enum GentleFontWeightToken: String, Codable, Sendable {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black

    var swiftUIWeight: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
}

// MARK: - Typography

public struct GentleTypographyRoleSpec: Codable, Sendable {
    public var pointSize: Double
    public var weight: GentleFontWeightToken
    public var design: GentleFontDesignToken

    /// Optional: if nil, we treat as "standard".
    public var width: GentleFontWidthToken?

    /// Dynamic Type anchor (semantic style used for scaling).
    public var relativeTo: GentleFontTextStyle

    public var lineSpacing: Double
    public var letterSpacing: Double
    public var isUppercased: Bool
    public var colorRole: GentleColorRole

    public init(pointSize: Double,
                weight: GentleFontWeightToken,
                design: GentleFontDesignToken,
                width: GentleFontWidthToken? = nil,
                relativeTo: GentleFontTextStyle,
                lineSpacing: Double = 0,
                letterSpacing: Double = 0,
                isUppercased: Bool = false,
                colorRole: GentleColorRole) {
        self.pointSize = pointSize
        self.weight = weight
        self.design = design
        self.width = width
        self.relativeTo = relativeTo
        self.lineSpacing = lineSpacing
        self.letterSpacing = letterSpacing
        self.isUppercased = isUppercased
        self.colorRole = colorRole
    }
}

/// JSON-facing storage uses String keys (role.rawValue).
public struct GentleTypographyTokens: Codable, Sendable {
    public var roles: [String: GentleTypographyRoleSpec]

    public init(roles: [String: GentleTypographyRoleSpec]) {
        self.roles = roles
    }

    // Typed convenience
    public func roleSpec(for role: GentleTextRole) -> GentleTypographyRoleSpec {
        if let spec = roles[role.rawValue] { return spec }
        if let body = roles[GentleTextRole.body_m.rawValue] { return body }

        return GentleTypographyRoleSpec(
            pointSize: 17,
            weight: .regular,
            design: .default,
            width: nil,
            relativeTo: .body,
            lineSpacing: 2,
            letterSpacing: 0,
            isUppercased: false,
            colorRole: .textPrimary
        )
    }
}

public extension GentleTypographyTokens {
    static let gentleDefault: GentleTypographyTokens = {
        var dict: [String: GentleTypographyRoleSpec] = [:]

        dict[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 34,
            weight: .bold,
            design: .rounded,
            width: nil,
            relativeTo: .largeTitle,
            lineSpacing: 6,
            colorRole: .textPrimary
        )
        dict[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 28,
            weight: .bold,
            design: .rounded,
            width: nil,
            relativeTo: .title,
            lineSpacing: 4,
            colorRole: .textPrimary
        )
        dict[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 22,
            weight: .semibold,
            design: .rounded,
            width: nil,
            relativeTo: .title2,
            lineSpacing: 3,
            colorRole: .textPrimary
        )
        dict[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20,
            weight: .semibold,
            design: .rounded,
            width: nil,
            relativeTo: .title3,
            lineSpacing: 3,
            colorRole: .textPrimary
        )
        dict[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17,
            weight: .semibold,
            design: .default,
            width: nil,
            relativeTo: .headline,
            colorRole: .textPrimary
        )

        dict[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17,
            weight: .regular,
            design: .default,
            width: nil,
            relativeTo: .body,
            lineSpacing: 2,
            colorRole: .textPrimary
        )
        dict[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 17,
            weight: .regular,
            design: .default,
            width: nil,
            relativeTo: .body,
            lineSpacing: 2,
            colorRole: .textSecondary
        )
        dict[GentleTextRole.monoCode_m.rawValue] = .init(
            pointSize: 17,
            weight: .regular,
            design: .monospaced,
            width: .condensed,
            relativeTo: .body,
            letterSpacing: 0.3,
            colorRole: .textPrimary
        )

        dict[GentleTextRole.callout_ms.rawValue] = .init(
            pointSize: 16,
            weight: .regular,
            design: .default,
            width: nil,
            relativeTo: .callout,
            colorRole: .textSecondary
        )
        dict[GentleTextRole.subheadline_ms.rawValue] = .init(
            pointSize: 15,
            weight: .regular,
            design: .default,
            width: nil,
            relativeTo: .subheadline,
            colorRole: .textSecondary
        )

        dict[GentleTextRole.footnote_s.rawValue] = .init(
            pointSize: 13,
            weight: .regular,
            design: .default,
            width: nil,
            relativeTo: .footnote,
            colorRole: .textTertiary
        )
        dict[GentleTextRole.caption_s.rawValue] = .init(
            pointSize: 12,
            weight: .regular,
            design: .default,
            width: nil,
            relativeTo: .caption,
            colorRole: .textTertiary
        )
        dict[GentleTextRole.caption2_s.rawValue] = .init(
            pointSize: 11,
            weight: .regular,
            design: .default,
            width: nil,
            relativeTo: .caption2,
            colorRole: .textTertiary
        )

        return GentleTypographyTokens(roles: dict)
    }()
}

// MARK: - Spacing (layout rhythm)

public struct GentleSpacingTokens: Codable, Sendable {
    public var xs: Double
    public var s: Double
    public var m: Double
    public var l: Double
    public var xl: Double
    public var xxl: Double

    public init(xs: Double = 4,
                s: Double = 8,
                m: Double = 12,
                l: Double = 16,
                xl: Double = 24,
                xxl: Double = 32) {
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.xxl = xxl
    }
}

public extension GentleSpacingTokens {
    static let gentleDefault = GentleSpacingTokens()
}

public enum GentleSpacingToken: String, Codable, Sendable, CaseIterable {
    case xs, s, m, l, xl, xxl
}

public extension GentleSpacingTokens {
    func value(for token: GentleSpacingToken) -> Double {
        switch token {
        case .xs: return xs
        case .s: return s
        case .m: return m
        case .l: return l
        case .xl: return xl
        case .xxl: return xxl
        }
    }
}

// MARK: - Padding (semantic container insets)

public enum GentlePaddingRole: String, Codable, Sendable {
    case screen
    case card
    case control
    case listRow
}

/// Token references (not point values) so padding stays theme-configurable.
public struct GentleAxisPaddingTokens: Codable, Sendable, Hashable {
    public var horizontal: GentleSpacingToken
    public var vertical: GentleSpacingToken

    public init(horizontal: GentleSpacingToken, vertical: GentleSpacingToken) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

/// JSON-facing storage uses String keys (role.rawValue).
public struct GentlePaddingTokens: Codable, Sendable {
    public var tokensByRole: [String: GentleAxisPaddingTokens]

    public init(tokensByRole: [String: GentleAxisPaddingTokens]) {
        self.tokensByRole = tokensByRole
    }

    public func axisTokens(for role: GentlePaddingRole) -> GentleAxisPaddingTokens {
        // Safe fallback — screen is a reasonable default.
        tokensByRole[role.rawValue]
        ?? tokensByRole[GentlePaddingRole.screen.rawValue]
        ?? .init(horizontal: .xl, vertical: .l)
    }
}

public extension GentlePaddingTokens {
    static let gentleDefault: GentlePaddingTokens = .init(
        tokensByRole: [
            // Big gutters, editorial feel:
            // Default spacing scale: xs=4, s=8, m=12, l=16, xl=24, xxl=32
            GentlePaddingRole.screen.rawValue:  .init(horizontal: .xl, vertical: .l),

            // Matches your existing card padding (currently spacing.m)
            GentlePaddingRole.card.rawValue:    .init(horizontal: .m,  vertical: .m),

            // Matches your button feel (you already use .horizontal l, .vertical s)
            GentlePaddingRole.control.rawValue: .init(horizontal: .l,  vertical: .s),

            // A common “custom row” inset
            GentlePaddingRole.listRow.rawValue: .init(horizontal: .l,  vertical: .s)
        ]
    )
}

// MARK: - Radii

public struct GentleRadiusTokens: Codable, Sendable {
    public var small: Double
    public var medium: Double
    public var large: Double
    public var pill: Double

    public init(small: Double = 8,
                medium: Double = 12,
                large: Double = 20,
                pill: Double = 999) {
        self.small = small
        self.medium = medium
        self.large = large
        self.pill = pill
    }
}

public extension GentleRadiusTokens {
    static let gentleDefault = GentleRadiusTokens()
}

// MARK: - Shadows

public struct GentleShadowTokens: Codable, Sendable {
    public var none: Double
    public var small: Double
    public var medium: Double

    public init(none: Double = 0,
                small: Double = 2,
                medium: Double = 6) {
        self.none = none
        self.small = small
        self.medium = medium
    }
}

public extension GentleShadowTokens {
    static let gentleDefault = GentleShadowTokens()
}

// MARK: - Runtime theme (built from spec)

public struct GentleTheme: Sendable {
    public let spec: GentleDesignSystemSpec

    public init(spec: GentleDesignSystemSpec = .gentleDefault) {
        self.spec = spec
    }

    public static let `default` = GentleTheme(spec: .gentleDefault)

    public var spacing: GentleSpacingTokens { spec.spacing }
    public var padding: GentlePaddingTokens { spec.padding }
    public var radii: GentleRadiusTokens { spec.radii }
    public var shadows: GentleShadowTokens { spec.shadows }

    /// Resolve a color role for the current color scheme.
    public func color(for role: GentleColorRole, scheme: ColorScheme) -> Color {
        guard let pair = spec.colors.pair(for: role) else { return Color.primary }
        return Color(gentleHex: pair.hex(for: scheme))
    }

    /// Returns a resolved style that respects the current Dynamic Type size category.
    public func textStyle(for role: GentleTextRole,
                          sizeCategory: ContentSizeCategory) -> GentleResolvedTextStyle {
        let roleSpec = spec.typography.roleSpec(for: role)

        // Scale pointSize using UIFontMetrics anchored to a semantic text style.
        let metrics = UIFontMetrics(forTextStyle: roleSpec.relativeTo.uiKitTextStyle)
        let traits = UITraitCollection(preferredContentSizeCategory: sizeCategory.uiContentSizeCategory)
        let scaledSize = metrics.scaledValue(for: CGFloat(roleSpec.pointSize), compatibleWith: traits)

        let baseFont = Font.system(
            size: scaledSize,
            weight: roleSpec.weight.swiftUIWeight,
            design: roleSpec.design.swiftUIDesign
        )

        return GentleResolvedTextStyle(
            font: baseFont,
            design: roleSpec.design,
            width: roleSpec.width,
            colorRole: roleSpec.colorRole,
            lineSpacing: CGFloat(roleSpec.lineSpacing),
            letterSpacing: CGFloat(roleSpec.letterSpacing),
            isUppercased: roleSpec.isUppercased
        )
    }
}

public extension GentleTheme {
    /// Returns resolved (horizontal, vertical) padding values for a semantic role,
    /// applying an Edge.Set filter similar to SwiftUI's `.padding`.
    func paddingValue(_ role: GentlePaddingRole, edges: Edge.Set = .all) -> (horizontal: CGFloat?, vertical: CGFloat?) {
        let axis = spec.padding.axisTokens(for: role)
        let h = CGFloat(spec.spacing.value(for: axis.horizontal))
        let v = CGFloat(spec.spacing.value(for: axis.vertical))

        let horizontal: CGFloat? = (edges == .all || edges.contains(.horizontal) || edges.contains(.leading) || edges.contains(.trailing)) ? h : nil
        let vertical: CGFloat? = (edges == .all || edges.contains(.vertical) || edges.contains(.top) || edges.contains(.bottom)) ? v : nil

        return (horizontal, vertical)
    }
}

public struct GentleResolvedTextStyle {
    public let font: Font

    // Keep these so ViewModifiers can apply them cleanly
    public let design: GentleFontDesignToken
    public let width: GentleFontWidthToken?

    public let colorRole: GentleColorRole
    public let lineSpacing: CGFloat
    public let letterSpacing: CGFloat
    public let isUppercased: Bool
}

// MARK: - Environment + theme root

private struct GentleThemeKey: EnvironmentKey {
    static let defaultValue: GentleTheme = .default
}

public extension EnvironmentValues {
    var gentleTheme: GentleTheme {
        get { self[GentleThemeKey.self] }
        set { self[GentleThemeKey.self] = newValue }
    }
}

public struct GentleThemeRoot<Content: View>: View {
    private let theme: GentleTheme
    private let content: Content

    public init(theme: GentleTheme = .default,
                @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }

    public var body: some View {
        content.environment(\.gentleTheme, theme)
    }
}

// MARK: - Modifiers

public struct GentleTextModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleTextRole
    private let overrideColorRole: GentleColorRole?

    public init(role: GentleTextRole, overrideColorRole: GentleColorRole? = nil) {
        self.role = role
        self.overrideColorRole = overrideColorRole
    }

    public func body(content: Content) -> some View {
        let style = theme.textStyle(for: role, sizeCategory: sizeCategory)
        let resolvedColorRole = overrideColorRole ?? style.colorRole
        let color = theme.color(for: resolvedColorRole, scheme: colorScheme)

        // Apply font + axes
        let view = content
            .font(style.font)
            .gentleFontWidth(style.width)
            .fontDesign(style.design.swiftUIDesign)
            .foregroundColor(color)
            .lineSpacing(style.lineSpacing)
            .kerning(style.letterSpacing)
            .textCase(style.isUppercased ? .uppercase : .none)
            .minimumScaleFactor(0.9)

        return view
    }
}

public struct GentleTextFieldModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleTextRole
    private let overrideColorRole: GentleColorRole?
    private let chrome: GentleTextChrome

    public init(role: GentleTextRole,
                overrideColorRole: GentleColorRole? = nil,
                chrome: GentleTextChrome = .standalone(shape: .rounded)) {
        self.role = role
        self.overrideColorRole = overrideColorRole
        self.chrome = chrome
    }

    public func body(content: Content) -> some View {
        let style = theme.textStyle(for: role, sizeCategory: sizeCategory)
        let resolvedColorRole = overrideColorRole ?? style.colorRole
        let textColor = theme.color(for: resolvedColorRole, scheme: colorScheme)
        let spacing = theme.spacing

        // Standalone chrome colors
        let fill = theme.color(for: .surface, scheme: colorScheme)
        let border = theme.color(for: .borderSubtle, scheme: colorScheme)

        let base = content
            .font(style.font)
            .gentleFontWidth(style.width)
            .fontDesign(style.design.swiftUIDesign)
            .foregroundColor(textColor)
            .tint(theme.color(for: .primaryCTA, scheme: colorScheme))
        // intentionally NOT applying:
        // lineSpacing / kerning / textCase / minimumScaleFactor

        switch chrome {
        case .standalone(let shape):
            // A standalone input needs clear affordance on plain backgrounds.
            // Use a light fill + subtle stroke; shape is meaningful here.
            let horizontal = CGFloat(spacing.l)
            let vertical = CGFloat(spacing.m)

            return AnyView(
                base
                    .padding(.horizontal, horizontal)
                    .padding(.vertical, vertical)
                    .background(
                        Group {
                            switch shape {
                            case .rounded:
                                RoundedRectangle(cornerRadius: CGFloat(theme.radii.medium), style: .continuous)
                                    .fill(fill)
                            case .pill:
                                Capsule()
                                    .fill(fill)
                            }
                        }
                    )
                    .overlay(
                        Group {
                            switch shape {
                            case .rounded:
                                RoundedRectangle(cornerRadius: CGFloat(theme.radii.medium), style: .continuous)
                                    .strokeBorder(border, lineWidth: 1)
                            case .pill:
                                Capsule()
                                    .strokeBorder(border, lineWidth: 1)
                            }
                        }
                    )
            )

        case .formRow:
            // In a Form/List row, the container already provides most chrome.
            // Keep spacing modest to avoid “double framed” inputs.
            return AnyView(
                base
                    .padding(.vertical, CGFloat(spacing.s))
            )

        case .borderless:
            // Inline / minimalist: no container chrome.
            return AnyView(base)
        }
    }
}

public struct GentleSurfaceModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleSurfaceRole

    public init(role: GentleSurfaceRole) {
        self.role = role
    }

    public func body(content: Content) -> some View {
        let radii = theme.radii
        let shadows = theme.shadows

        switch role {
        case .appBackground:
            return AnyView(
                content
                    .background(
                        theme.color(for: .background, scheme: colorScheme)
                            .ignoresSafeArea()
                    )
            )
        case .surfaceOverlay:
            return AnyView(
                content
                    .background(
                        theme.color(for: .surfaceOverlay, scheme: colorScheme)
                    )
            )
        case .card:
            return AnyView(
                content
                    .gentlePadding(.card)
                    .background(theme.color(for: .surface, scheme: colorScheme))
                    .cornerRadius(CGFloat(radii.large))
                    .overlay(
                        RoundedRectangle(cornerRadius: CGFloat(radii.large))
                            .stroke(theme.color(for: .borderSubtle, scheme: colorScheme), lineWidth: 1)
                    )
            )
        case .cardChrome:
            return AnyView(
                content
                    .background(theme.color(for: .surface, scheme: colorScheme))
                    .cornerRadius(CGFloat(radii.large))
                    .overlay(
                        RoundedRectangle(cornerRadius: CGFloat(radii.large))
                            .stroke(theme.color(for: .borderSubtle, scheme: colorScheme), lineWidth: 1)
                    )
            )
        case .cardElevated:
            return AnyView(
                content
                    .gentlePadding(.card)
                    .background(theme.color(for: .surfaceElevated, scheme: colorScheme))
                    .cornerRadius(CGFloat(radii.large))
                    .shadow(radius: CGFloat(shadows.medium))
            )
        }
    }
}

public struct GentleBackgroundModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    let role: GentleColorRole
    let ignoresSafeArea: Bool

    public func body(content: Content) -> some View {
        let c = theme.color(for: role, scheme: colorScheme)
        return content.background(
            Group {
                if ignoresSafeArea {
                    c.ignoresSafeArea()
                } else {
                    c
                }
            }
        )
    }
}

public struct GentleButtonStyle: ButtonStyle {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleButtonRole
    private let shape: GentleButtonShape

    public init(role: GentleButtonRole, shape: GentleButtonShape = .rounded) {
        self.role = role
        self.shape = shape
    }

    public func makeBody(configuration: Configuration) -> some View {
        let spacing = theme.spacing
        let radii = theme.radii

        let backgroundRole: GentleColorRole
        let labelColorRole: GentleColorRole
        let borderRole: GentleColorRole?
        let textRole: GentleTextRole

        switch role {
        case .primary:
            backgroundRole = .primaryCTA
            labelColorRole = .onPrimaryCTA
            borderRole = nil
            textRole = .headline_m

        case .secondary:
            backgroundRole = .surface
            labelColorRole = .primaryCTA
            borderRole = .primaryCTA
            textRole = .headline_m

        case .tertiary:
            backgroundRole = .background
            labelColorRole = .primaryCTA
            borderRole = nil
            textRole = .body_m

        case .destructive:
            backgroundRole = .destructive
            labelColorRole = .onPrimaryCTA
            borderRole = nil
            textRole = .headline_m
        }

        let backgroundColor = theme.color(for: backgroundRole, scheme: colorScheme)
        let borderColor = borderRole.map { theme.color(for: $0, scheme: colorScheme) }

        let cornerRadius: CGFloat = {
            switch shape {
            case .rounded:
                return CGFloat(radii.medium)
            case .pill:
                return CGFloat(radii.pill) // 999
            }
        }()

        return configuration.label
            .gentleText(textRole, colorRole: labelColorRole)
            .padding(.horizontal, CGFloat(spacing.xxl))
            .padding(.vertical, CGFloat(spacing.l)) //spacing.s))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .overlay(
                Group {
                    if let borderColor = borderColor {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: 1)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.9),
                       value: configuration.isPressed)
    }
}

public struct GentlePaddingModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme

    private let edges: Edge.Set
    private let role: GentlePaddingRole

    public init(edges: Edge.Set = .all, role: GentlePaddingRole) {
        self.edges = edges
        self.role = role
    }

    public func body(content: Content) -> some View {
        let resolved = theme.paddingValue(role, edges: edges)

        return content
            .padding(.horizontal, resolved.horizontal ?? 0)
            .padding(.vertical, resolved.vertical ?? 0)
    }
}

// MARK: - View extensions (ergonomic API)

public extension View {
    func gentleText(_ role: GentleTextRole,
                    colorRole: GentleColorRole? = nil) -> some View {
        modifier(GentleTextModifier(role: role, overrideColorRole: colorRole))
    }

    func gentleTextField(_ role: GentleTextRole,
                         colorRole: GentleColorRole? = nil,
                         chrome: GentleTextChrome = .standalone(shape: .rounded)) -> some View {
        modifier(GentleTextFieldModifier(role: role, overrideColorRole: colorRole, chrome: chrome))
    }

    func gentleSurface(_ role: GentleSurfaceRole) -> some View {
        modifier(GentleSurfaceModifier(role: role))
    }

    func gentleButton(_ role: GentleButtonRole) -> some View {
        buttonStyle(GentleButtonStyle(role: role, shape: .rounded))
    }

    func gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape) -> some View {
        buttonStyle(GentleButtonStyle(role: role, shape: shape))
    }

    @ViewBuilder
    func gentleFontWidth(_ width: GentleFontWidthToken?) -> some View {
        if let width {
            if #available(iOS 17.0, *) {
                self.fontWidth(width.swiftUIWidth)
            } else {
                self
            }
        } else {
            self
        }
    }

    func gentleBackground(_ role: GentleColorRole, ignoresSafeArea: Bool = false) -> some View {
        modifier(GentleBackgroundModifier(role: role, ignoresSafeArea: ignoresSafeArea))
    }

    func gentlePadding(_ role: GentlePaddingRole) -> some View {
        modifier(GentlePaddingModifier(edges: .all, role: role))
    }

    func gentlePadding(_ edges: Edge.Set, _ role: GentlePaddingRole) -> some View {
        modifier(GentlePaddingModifier(edges: edges, role: role))
    }
}

// MARK: - Color helper (hex → Color)

public extension Color {
    init(gentleHex hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hexString)

        let r, g, b, a: Double

        if scanner.scanHexInt64(&hexNumber) {
            switch hexString.count {
            case 6:
                r = Double((hexNumber & 0xFF0000) >> 16) / 255.0
                g = Double((hexNumber & 0x00FF00) >> 8) / 255.0
                b = Double(hexNumber & 0x0000FF) / 255.0
                a = 1.0
            case 8:
                r = Double((hexNumber & 0xFF000000) >> 24) / 255.0
                g = Double((hexNumber & 0x00FF0000) >> 16) / 255.0
                b = Double((hexNumber & 0x0000FF00) >> 8) / 255.0
                a = Double(hexNumber & 0x000000FF) / 255.0
            default:
                r = 0; g = 0; b = 0; a = 1
            }
        } else {
            r = 0; g = 0; b = 0; a = 1
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

// MARK: - Property Wrapper (Runtime)

@propertyWrapper
public struct GentleDesignRuntime: DynamicProperty {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    public init() {}

    public var wrappedValue: Resolver {
        Resolver(theme: theme, colorScheme: colorScheme)
    }

    public struct Resolver {
        public let theme: GentleTheme
        let colorScheme: ColorScheme

        public var spacing: GentleSpacingTokens { theme.spacing }
        public var padding: GentlePaddingTokens { theme.padding }
        public var radii: GentleRadiusTokens { theme.radii }
        public var shadows: GentleShadowTokens { theme.shadows }

        public func color(_ role: GentleColorRole) -> Color {
            theme.color(for: role, scheme: colorScheme)
        }

        public var surface: Color { color(.surface) }
        public var background: Color { color(.background) }
        public var borderSubtle: Color { color(.borderSubtle) }
        public var textPrimary: Color { color(.textPrimary) }
        public var themePrimary: Color { color(.themePrimary) }
    }
}

// MARK: - UI Kit Theming

public enum GentleUIKitTheming {
    @MainActor
    public static func applyNavigationBarTitleColor(theme: GentleTheme, role: GentleColorRole) {
        guard let pair = theme.spec.colors.pair(for: role) else { return }
        let dark = UIColor(Color(gentleHex: pair.hex(for: .dark)))
        let light = UIColor(Color(gentleHex: pair.hex(for: .light)))
        let dynamicTitleColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        appearance.largeTitleTextAttributes = [
            .foregroundColor: dynamicTitleColor
        ]

        appearance.titleTextAttributes = [
            .foregroundColor: dynamicTitleColor
        ]

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
    }
}
