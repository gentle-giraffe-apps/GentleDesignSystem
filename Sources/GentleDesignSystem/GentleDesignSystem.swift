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
    case borderSubtle
    case destructive
    case primaryCTA
}

public enum GentleButtonRole: String, Codable, Sendable {
    case primary
    case secondary
    case ghost
    case destructive
}

public enum GentleSurfaceRole: String, Codable, Sendable {
    case appBackground
    case card
    case cardElevated
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

// Top-level spec you’ll eventually load/save as JSON
public struct GentleDesignSystemSpec: Codable, Sendable {
    public var colors: GentleColorTokens
    public var typography: GentleTypographyTokens
    public var spacing: GentleSpacingTokens
    public var radii: GentleRadiusTokens
    public var shadows: GentleShadowTokens

    public init(colors: GentleColorTokens,
                typography: GentleTypographyTokens,
                spacing: GentleSpacingTokens,
                radii: GentleRadiusTokens,
                shadows: GentleShadowTokens) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.radii = radii
        self.shadows = shadows
    }
}

public extension GentleDesignSystemSpec {
    static let gentleDefault: GentleDesignSystemSpec = .init(
        colors: .gentleDefault,
        typography: .gentleDefault,
        spacing: .gentleDefault,
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

public struct GentleColorTokens: Codable, Sendable {
    public var pairByRole: [GentleColorRole: GentleColorPair]

    public init(pairByRole: [GentleColorRole: GentleColorPair]) {
        self.pairByRole = pairByRole
    }
}

public extension GentleColorTokens {
    /// Defaults chosen to be reasonable, high-contrast, and visually consistent across light/dark.
    /// You can (and should) tune these as GentleDesign evolves.
    static let gentleDefault: GentleColorTokens = .init(
        pairByRole: [
            // Text
            .textPrimary: .init(lightHex: "#111827", darkHex: "#F9FAFB"),
            .textSecondary: .init(lightHex: "#4B5563", darkHex: "#D1D5DB"),
            .textTertiary: .init(lightHex: "#9CA3AF", darkHex: "#9CA3AF"),

            // Surfaces
            .background: .init(lightHex: "#FFFFFF", darkHex: "#0B0F19"),
            .surface: .init(lightHex: "#F4F4F7", darkHex: "#111827"),
            .surfaceElevated: .init(lightHex: "#FFFFFF", darkHex: "#1F2937"),
            .borderSubtle: .init(lightHex: "#E5E7EB", darkHex: "#374151"),

            // Actions / status
            .primaryCTA: .init(lightHex: "#2563EB", darkHex: "#3B82F6"),
            .onPrimaryCTA: .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            .destructive: .init(lightHex: "#DC2626", darkHex: "#F87171")
        ]
    )
}

// MARK: - Typography

public struct GentleTypographyRoleSpec: Codable, Sendable {
    public var pointSize: Double
    public var weight: String
    public var design: String

    /// Dynamic Type anchor (semantic style used for scaling).
    public var relativeTo: GentleFontTextStyle

    public var lineSpacing: Double
    public var letterSpacing: Double
    public var isUppercased: Bool
    public var colorRole: GentleColorRole

    public init(pointSize: Double,
                weight: String,
                design: String,
                relativeTo: GentleFontTextStyle,
                lineSpacing: Double = 0,
                letterSpacing: Double = 0,
                isUppercased: Bool = false,
                colorRole: GentleColorRole) {
        self.pointSize = pointSize
        self.weight = weight
        self.design = design
        self.relativeTo = relativeTo
        self.lineSpacing = lineSpacing
        self.letterSpacing = letterSpacing
        self.isUppercased = isUppercased
        self.colorRole = colorRole
    }

    var fontWeight: Font.Weight {
        switch weight.lowercased() {
        case "ultralight": return .ultraLight
        case "thin": return .thin
        case "light": return .light
        case "medium": return .medium
        case "semibold", "semi-bold", "demi-bold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        case "black": return .black
        default: return .regular
        }
    }

    var fontDesign: Font.Design {
        switch design.lowercased() {
        case "rounded": return .rounded
        case "monospaced", "mono": return .monospaced
        case "serif": return .serif
        default: return .default
        }
    }
}

public struct GentleTypographyTokens: Codable, Sendable {
    public var roles: [GentleTextRole: GentleTypographyRoleSpec]

    public init(roles: [GentleTextRole: GentleTypographyRoleSpec]) {
        self.roles = roles
    }

    public func roleSpec(for role: GentleTextRole) -> GentleTypographyRoleSpec {
        if let spec = roles[role] { return spec }
        if let body = roles[.body_m] { return body }

        return GentleTypographyRoleSpec(
            pointSize: 17,
            weight: "regular",
            design: "default",
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
        var dict: [GentleTextRole: GentleTypographyRoleSpec] = [:]

        dict[.largeTitle_xxl] = .init(
            pointSize: 34, weight: "bold", design: "rounded",
            relativeTo: .largeTitle, lineSpacing: 6, colorRole: .textPrimary
        )
        dict[.title_xl] = .init(
            pointSize: 28, weight: "bold", design: "rounded",
            relativeTo: .title, lineSpacing: 4, colorRole: .textPrimary
        )
        dict[.title2_l] = .init(
            pointSize: 22, weight: "semibold", design: "rounded",
            relativeTo: .title2, lineSpacing: 3, colorRole: .textPrimary
        )
        dict[.title3_ml] = .init(
            pointSize: 20, weight: "semibold", design: "rounded",
            relativeTo: .title3, lineSpacing: 3, colorRole: .textPrimary
        )
        dict[.headline_m] = .init(
            pointSize: 17, weight: "semibold", design: "default",
            relativeTo: .headline, colorRole: .textPrimary
        )

        dict[.body_m] = .init(
            pointSize: 17, weight: "regular", design: "default",
            relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
        )
        dict[.bodySecondary_m] = .init(
            pointSize: 17, weight: "regular", design: "default",
            relativeTo: .body, lineSpacing: 2, colorRole: .textSecondary
        )
        dict[.monoCode_m] = .init(
            pointSize: 17, weight: "regular", design: "monospaced",
            relativeTo: .body, letterSpacing: 0.3, colorRole: .textPrimary
        )

        dict[.callout_ms] = .init(
            pointSize: 16, weight: "regular", design: "default",
            relativeTo: .callout, colorRole: .textSecondary
        )
        dict[.subheadline_ms] = .init(
            pointSize: 15, weight: "regular", design: "default",
            relativeTo: .subheadline, colorRole: .textSecondary
        )

        dict[.footnote_s] = .init(
            pointSize: 13, weight: "regular", design: "default",
            relativeTo: .footnote, colorRole: .textTertiary
        )
        dict[.caption_s] = .init(
            pointSize: 12, weight: "regular", design: "default",
            relativeTo: .caption, colorRole: .textTertiary
        )
        dict[.caption2_s] = .init(
            pointSize: 11, weight: "regular", design: "default",
            relativeTo: .caption2, colorRole: .textTertiary
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
    public var radii: GentleRadiusTokens { spec.radii }
    public var shadows: GentleShadowTokens { spec.shadows }

    /// Resolve a color role for the current color scheme.
    public func color(for role: GentleColorRole, scheme: ColorScheme) -> Color {
        guard let pair = spec.colors.pairByRole[role] else { return Color.primary }
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

        let font = Font.system(
            size: scaledSize,
            weight: roleSpec.fontWeight,
            design: roleSpec.fontDesign
        )

        return GentleResolvedTextStyle(
            font: font,
            colorRole: roleSpec.colorRole,
            lineSpacing: CGFloat(roleSpec.lineSpacing),
            letterSpacing: CGFloat(roleSpec.letterSpacing),
            isUppercased: roleSpec.isUppercased
        )
    }
}

public struct GentleResolvedTextStyle {
    public let font: Font
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

        return content
            .font(style.font)
            .foregroundColor(color)
            .lineSpacing(style.lineSpacing)
            .kerning(style.letterSpacing)
            .textCase(style.isUppercased ? .uppercase : .none)
            .minimumScaleFactor(0.9)
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
        let spacing = theme.spacing
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
        case .card:
            return AnyView(
                content
                    .padding(CGFloat(spacing.m))
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
                    .padding(CGFloat(spacing.m))
                    .background(theme.color(for: .surfaceElevated, scheme: colorScheme))
                    .cornerRadius(CGFloat(radii.large))
                    .shadow(radius: CGFloat(shadows.medium))
            )
        }
    }
}

public struct GentleButtonStyle: ButtonStyle {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleButtonRole

    public init(role: GentleButtonRole) {
        self.role = role
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
            labelColorRole = .textPrimary
            borderRole = .borderSubtle
            textRole = .headline_m

        case .ghost:
            backgroundRole = .background
            labelColorRole = .textPrimary
            borderRole = .borderSubtle
            textRole = .body_m

        case .destructive:
            backgroundRole = .destructive
            labelColorRole = .onPrimaryCTA
            borderRole = nil
            textRole = .headline_m
        }

        let backgroundColor = theme.color(for: backgroundRole, scheme: colorScheme)
        let borderColor = borderRole.map { theme.color(for: $0, scheme: colorScheme) }

        return configuration.label
            .gentleText(textRole, colorRole: labelColorRole)
            .padding(.horizontal, CGFloat(spacing.l))
            .padding(.vertical, CGFloat(spacing.s))
            .background(
                RoundedRectangle(cornerRadius: CGFloat(radii.medium))
                    .fill(backgroundColor)
            )
            .overlay(
                Group {
                    if let borderColor = borderColor {
                        RoundedRectangle(cornerRadius: CGFloat(radii.medium))
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

// MARK: - View extensions (ergonomic API)

public extension View {
    func gentleText(_ role: GentleTextRole,
                    colorRole: GentleColorRole? = nil) -> some View {
        modifier(GentleTextModifier(role: role, overrideColorRole: colorRole))
    }

    func gentleSurface(_ role: GentleSurfaceRole) -> some View {
        modifier(GentleSurfaceModifier(role: role))
    }

    func gentleButton(_ role: GentleButtonRole) -> some View {
        buttonStyle(GentleButtonStyle(role: role))
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
                r = Double((hexNumber & 0xFF0000) >> 16) / 255
                g = Double((hexNumber & 0x00FF00) >> 8) / 255
                b = Double(hexNumber & 0x0000FF) / 255
                a = 1.0
            case 8:
                r = Double((hexNumber & 0xFF000000) >> 24) / 255
                g = Double((hexNumber & 0x00FF0000) >> 16) / 255
                b = Double((hexNumber & 0x0000FF00) >> 8) / 255
                a = Double(hexNumber & 0x000000FF) / 255
            default:
                r = 0; g = 0; b = 0; a = 1
            }
        } else {
            r = 0; g = 0; b = 0; a = 1
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
