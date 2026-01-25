//  Jonathan Ritchey
import SwiftUI
import Foundation
import Observation
import UIKit

public enum GentleDesignSystemSpecVersion {
    public static let current = "0.5.0" // color roles: onOverlay, onOverlaySecondary, onDestructive
}

// MARK: - Roles

/** Naming guide (conventions, not strict rules):
 - Base role: largeTitle, title, headline, body, callout, caption, etc.
 - Numeric suffixes (2, 3, …) mirror SwiftUI semantics (e.g. title2, title3, caption2).
 - Order suffixes (Secondary, Tertiary) indicate reduced visual emphasis
   (typically via color/opacity/weight) without changing the underlying semantic font.
 - Ramp suffix (_xxl → _s) indicates relative position in the typography scale,
   not a fixed point size.
 */
public enum GentleTextRole: String, Identifiable, Codable, Sendable, CaseIterable {
    public var id: String { rawValue }

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

    // Button titles – semantic roles for button text
    case primaryButtonTitle_m
    case secondaryButtonTitle_m
    case tertiaryButtonTitle_m
    case quaternaryButtonTitle_m
}

public enum GentleTextRamp: String, Codable, Sendable { case xxl, xl, l, ml, m, ms, s }

public extension GentleTextRole {
    var ramp: GentleTextRamp {
        switch self {
        case .largeTitle_xxl: return .xxl
        case .title_xl: return .xl
        case .title2_l: return .l
        case .title3_ml: return .ml
        case .headline_m, .body_m, .bodySecondary_m, .monoCode_m,
             .primaryButtonTitle_m, .secondaryButtonTitle_m, .tertiaryButtonTitle_m, .quaternaryButtonTitle_m: return .m
        case .callout_ms, .subheadline_ms: return .ms
        case .footnote_s, .caption_s, .caption2_s: return .s
        }
    }

    /// Human-friendly label for settings UIs.
    var displayName: String {
        switch self {
        case .largeTitle_xxl: return "Large Title"
        case .title_xl: return "Title"
        case .title2_l: return "Title 2"
        case .title3_ml: return "Title 3"
        case .headline_m: return "Headline"
        case .body_m: return "Body"
        case .bodySecondary_m: return "Body (Secondary)"
        case .monoCode_m: return "Monospace (Code)"
        case .callout_ms: return "Callout"
        case .subheadline_ms: return "Subheadline"
        case .footnote_s: return "Footnote"
        case .caption_s: return "Caption"
        case .caption2_s: return "Caption 2"
        case .primaryButtonTitle_m: return "Primary Button Title"
        case .secondaryButtonTitle_m: return "Secondary Button Title"
        case .tertiaryButtonTitle_m: return "Tertiary Button Title"
        case .quaternaryButtonTitle_m: return "Quaternary Button Title"
        }
    }
}

public enum GentleColorRole: String, Codable, Sendable, CaseIterable, Identifiable {
    public var id: String { rawValue }

    case textPrimary, textSecondary, textTertiary
    case onPrimaryCTA, onDestructive
    case background, surface
    case surfaceTint, surfaceSpecular
    case surfaceOverlay, onOverlay, onOverlaySecondary
    case borderSubtle
    case destructive
    case primaryCTA
    case themePrimary, themeSecondary

    public var displayName: String {
        switch self {
        case .textPrimary: return "Text Primary"
        case .textSecondary: return "Text Secondary"
        case .textTertiary: return "Text Tertiary"
        case .onPrimaryCTA: return "On Primary CTA"
        case .onDestructive: return "On Destructive"
        case .background: return "Background"
        case .surface: return "Surface"
        case .surfaceTint: return "Surface Tint"
        case .surfaceSpecular: return "Surface Specular"
        case .surfaceOverlay: return "Surface Overlay"
        case .onOverlay: return "On Overlay"
        case .onOverlaySecondary: return "On Overlay Secondary"
        case .borderSubtle: return "Border Subtle"
        case .destructive: return "Destructive"
        case .primaryCTA: return "Primary CTA"
        case .themePrimary: return "Theme Primary"
        case .themeSecondary: return "Theme Secondary"
        }
    }
}

public enum GentleButtonRole: String, Codable, Sendable, Identifiable {
    case primary, secondary, tertiary, quaternary, destructive
    public var id: String { rawValue }
}

public extension GentleButtonRole {
    /// The default typography role for this button role.
    var defaultTextRole: GentleTextRole {
        switch self {
        case .primary: return .primaryButtonTitle_m
        case .secondary: return .secondaryButtonTitle_m
        case .tertiary: return .tertiaryButtonTitle_m
        case .quaternary: return .quaternaryButtonTitle_m
        case .destructive: return .primaryButtonTitle_m
        }
    }
}

/// Defines the visual surface treatment of a button.
/// Determines both the background appearance and the appropriate label color.
public enum GentleButtonFillRole: String, Codable, Sendable, CaseIterable, Identifiable {
    public var id: String { rawValue }

    /// Solid fill using primaryCTA color, with onPrimaryCTA text.
    case solidFillPrimaryCTA

    /// Solid fill using destructive color, with onPrimaryCTA text.
    case solidFillDestructive

    /// No background fill, with primaryCTA text.
    case hollow

    // Future: ultraThinMaterial, glass, etc.

    public var displayName: String {
        switch self {
        case .solidFillPrimaryCTA: return "Solid (Primary)"
        case .solidFillDestructive: return "Solid (Destructive)"
        case .hollow: return "Hollow"
        }
    }
}

/// Defines the border treatment of a button.
public enum GentleButtonBorderRole: String, Codable, Sendable, CaseIterable, Identifiable {
    public var id: String { rawValue }

    /// No border.
    case hidden

    /// Accent border using primaryCTA color.
    case accent

    /// Subtle border using borderSubtle color.
    case subtle

    public var displayName: String {
        switch self {
        case .hidden: return "None"
        case .accent: return "Accent"
        case .subtle: return "Subtle"
        }
    }
}

/// Separates geometry from intent.
/// - rounded: standard rounded rectangle (default)
/// - pill: capsule-like button
public enum GentleButtonShape: String, Codable, Sendable { case rounded, pill }

// MARK: - Button animation roles

/// High-level intent for button press feedback.
/// Keep this JSON-friendly and map it to SwiftUI/UIKit behavior in code (not in JSON).
public enum GentleButtonAnimationRole: String, Codable, Sendable, CaseIterable {
    case unknown
    case subtlePress
    case squish
    case pop
    case bouncy
    /// Shrinks on press, then springs back past original size before settling.
    case springBack
}

/// JSON-friendly animation tuning knobs per role.
/// These parameters are intentionally minimal to keep themes maintainable.
public struct GentleButtonAnimationSpec: Codable, Sendable {
    /// Used by styles that implement pressed-state transforms (e.g. scale/opacity).
    public var pressedScale: Double
    public var pressedOpacity: Double

    /// Used for ease-based animations.
    public var duration: Double

    /// Used for spring-based animations.
    public var springResponse: Double
    public var springDamping: Double
    public var springBlend: Double

    public init(
        pressedScale: Double = 0.97,
        pressedOpacity: Double = 0.92,
        duration: Double = 0.12,
        springResponse: Double = 0.22,
        springDamping: Double = 0.85,
        springBlend: Double = 0.0
    ) {
        self.pressedScale = pressedScale
        self.pressedOpacity = pressedOpacity
        self.duration = duration
        self.springResponse = springResponse
        self.springDamping = springDamping
        self.springBlend = springBlend
    }
}

/// Shape of a standalone text input container (only applies when chrome is `.standalone`).
public enum GentleTextFieldShape: String, Codable, Sendable { case rounded, pill }

/// Controls ownership/strength of input affordances.
/// - standalone: draws its own container chrome (background, border, shape)
/// - formRow: assumes container (Form/List row) provides most chrome
/// - borderless: no container chrome (inline / minimalist)
public enum GentleTextChrome: Sendable {
    case standalone(shape: GentleTextFieldShape = .rounded)
    case formRow
    case borderless
}

// MARK: - Gap intents

/// High-level intent for spacing between siblings (stacks, lists, grids).
public enum GentleGapIntent: String, Codable, Sendable, CaseIterable {
    case unknown
    case micro
    case tight
    case regular
    case ample
    case loose
    case expansive
}

// MARK: - Dynamic Type anchor

/// JSON-friendly semantic anchor for Dynamic Type scaling.
public enum GentleFontTextStyle: String, Codable, Sendable {
    case largeTitle, title, title2, title3, headline, body, callout, subheadline, footnote, caption, caption2
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
    public var specVersion: String
    public var colors: GentleColorTokens
    public var typography: GentleTypographyTokens

    /// Layout-affecting tokens: gaps, insets, grids, touch targets, etc.
    public var layout: GentleLayoutTokens

    /// Visual/appearance tokens: radii, shadows, strokes (future), etc.
    public var visual: GentleVisualTokens

    /// Component style tokens (buttons, etc.)
    public var buttons: GentleButtonTokens

    /// Surface style tokens
    public var surfaces: GentleSurfaceTokens

    enum CodingKeys: String, CodingKey {
        case specVersion = "_specVersion"
        case colors, typography, layout, visual, buttons, surfaces
    }

    public init(
        specVersion: String = GentleDesignSystemSpecVersion.current,
        colors: GentleColorTokens,
        typography: GentleTypographyTokens,
        layout: GentleLayoutTokens,
        visual: GentleVisualTokens,
        buttons: GentleButtonTokens,
        surfaces: GentleSurfaceTokens = .gentleDefault
    ) {
        self.specVersion = specVersion
        self.colors = colors
        self.typography = typography
        self.layout = layout
        self.visual = visual
        self.buttons = buttons
        self.surfaces = surfaces
    }
}

public extension GentleDesignSystemSpec {
    static let gentleDefault: GentleDesignSystemSpec = .init(
        colors: .gentleDefault,
        typography: .gentleDefault,
        layout: .gentleDefault,
        visual: .gentleDefault,
        buttons: .gentleDefault,
        surfaces: .gentleDefault
    )
}

extension GentleDesignSystemSpec: GentleJSONEncodable {}
extension GentleDesignSystemSpec: GentleJSONDecodable {}

// MARK: - Colors (Light/Dark pairs)

public struct GentleColorPair: Codable, Sendable, Equatable {
    public var lightHex: String
    public var darkHex: String

    public init(lightHex: String, darkHex: String) {
        self.lightHex = lightHex
        self.darkHex = darkHex
    }

    public func hex(for scheme: ColorScheme) -> String { scheme == .dark ? darkHex : lightHex }
}

/// JSON-facing storage uses String keys (role.rawValue).
public struct GentleColorTokens: Codable, Sendable {
    public var pairByRole: [String: GentleColorPair]

    public init(pairByRole: [String: GentleColorPair]) {
        self.pairByRole = pairByRole
    }

    public func pair(for role: GentleColorRole) -> GentleColorPair? { pairByRole[role.rawValue] }
}

public extension GentleColorTokens {
    static let gentleDefault: GentleColorTokens = .init(
        pairByRole: [
            // Text
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#1F2933", darkHex: "#F5F7FA"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#4B5563", darkHex: "#C7CDD4"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#6B7280", darkHex: "#9AA0A6"),

            // Surfaces
            GentleColorRole.background.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#0B0F19"),
            GentleColorRole.surface.rawValue: .init(lightHex: "#FAFAFE", darkHex: "#111827"),
            GentleColorRole.surfaceTint.rawValue: .init(lightHex: "#111827CC", darkHex: "#020617CC"),
            GentleColorRole.surfaceSpecular.rawValue: .init(lightHex: "#FFFFFF66", darkHex: "#FFFFFF33"),
            GentleColorRole.surfaceOverlay.rawValue: .init(lightHex: "#111827CC", darkHex: "#020617CC"),
            GentleColorRole.onOverlay.rawValue: .init(lightHex: "#F9FAFB", darkHex: "#F9FAFB"),
            GentleColorRole.onOverlaySecondary.rawValue: .init(lightHex: "#D1D5DB", darkHex:  "#D1D5DB"),
            GentleColorRole.borderSubtle.rawValue: .init(lightHex: "#E5E7EB", darkHex: "#374151"),

            // Actions / status
            GentleColorRole.primaryCTA.rawValue: .init(lightHex: "#4A6EF5", darkHex: "#3B82F6"),
            GentleColorRole.onPrimaryCTA.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.destructive.rawValue: .init(lightHex: "#E35D5B", darkHex: "#F87171"),
            GentleColorRole.onDestructive.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),

            // Theme Colors
            GentleColorRole.themePrimary.rawValue: .init(lightHex: "#4A6EF5", darkHex: "#3B82F6"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#8FA2FF", darkHex:  "#93C5FD")
        ]
    )
}

// MARK: - Button tokens (NEW)

/// JSON-friendly definition of a button "role" style.
/// Typography is derived from the button role; colors are derived from the material role.
public struct GentleButtonRoleSpec: Codable, Sendable {
    public var shape: GentleButtonShape

    /// The visual surface treatment (determines background and label colors).
    public var fillRole: GentleButtonFillRole

    /// The border treatment.
    public var borderRole: GentleButtonBorderRole

    /// Which "feel" to use for press feedback (animation curve + tuning).
    public var animationRole: GentleButtonAnimationRole

    /// Interaction affordances (kept JSON-friendly and tweakable).
    public var pressedScale: Double
    public var pressedOpacity: Double

    /// When true, skip custom background/foreground styling and use SwiftUI's native button behavior.
    /// Useful for tertiary/quaternary buttons that should blend with system UI.
    public var usesNativeStyle: Bool

    public init(
        shape: GentleButtonShape = .rounded,
        fillRole: GentleButtonFillRole,
        borderRole: GentleButtonBorderRole = .hidden,
        animationRole: GentleButtonAnimationRole = .squish,
        pressedScale: Double = 0.97,
        pressedOpacity: Double = 0.9,
        usesNativeStyle: Bool = false
    ) {
        self.shape = shape
        self.fillRole = fillRole
        self.borderRole = borderRole
        self.animationRole = animationRole
        self.pressedScale = pressedScale
        self.pressedOpacity = pressedOpacity
        self.usesNativeStyle = usesNativeStyle
    }
}

public struct GentleButtonTokens: Codable, Sendable {
    /// Stored using String keys for JSON stability (role.rawValue).
    public var roles: [String: GentleButtonRoleSpec]

    /// Shared animation tuning per animation role.
    public var animations: [String: GentleButtonAnimationSpec]

    public init(roles: [String: GentleButtonRoleSpec],
                animations: [String: GentleButtonAnimationSpec]) {
        self.roles = roles
        self.animations = animations
    }

    public func roleSpec(for role: GentleButtonRole) -> GentleButtonRoleSpec {
        if let spec = roles[role.rawValue] { return spec }
        // Fallback to primary if missing.
        if let primary = roles[GentleButtonRole.primary.rawValue] { return primary }
        // Last-resort defaults (should never happen with gentleDefault).
        return .init(
            shape: .rounded,
            fillRole: .solidFillPrimaryCTA,
            borderRole: .hidden,
            animationRole: .squish,
            pressedScale: 0.97,
            pressedOpacity: 0.9
        )
    }

    public func animationSpec(for role: GentleButtonAnimationRole) -> GentleButtonAnimationSpec {
        if let spec = animations[role.rawValue] { return spec }
        if let fallback = animations[GentleButtonAnimationRole.squish.rawValue] { return fallback }
        return GentleButtonAnimationSpec()
    }
}

public extension GentleButtonTokens {
    static let gentleDefault: GentleButtonTokens = .init(
        roles: [
            GentleButtonRole.primary.rawValue: .init(
                shape: .pill,
                fillRole: .solidFillPrimaryCTA,
                borderRole: .hidden,
                animationRole: .springBack,
                pressedScale: 0.9,
                pressedOpacity: 0.86
            ),
            GentleButtonRole.secondary.rawValue: .init(
                shape: .pill,
                fillRole: .hollow,
                borderRole: .accent,
                animationRole: .subtlePress,
                pressedScale: 0.85,
                pressedOpacity: 0.9
            ),
            GentleButtonRole.tertiary.rawValue: .init(
                shape: .pill,
                fillRole: .hollow,
                borderRole: .hidden,
                animationRole: .subtlePress,
                pressedScale: 0.85,
                pressedOpacity: 0.9,
                usesNativeStyle: true
            ),
            GentleButtonRole.quaternary.rawValue: .init(
                shape: .pill,
                fillRole: .hollow,
                borderRole: .hidden,
                animationRole: .subtlePress,
                pressedScale: 0.95,
                pressedOpacity: 0.93,
                usesNativeStyle: true
            ),
            GentleButtonRole.destructive.rawValue: .init(
                shape: .pill,
                fillRole: .solidFillDestructive,
                borderRole: .hidden,
                animationRole: .squish,
                pressedScale: 0.9,
                pressedOpacity: 0.86
            )
        ],
        animations: [
            GentleButtonAnimationRole.unknown.rawValue: .init(
                pressedScale: 1.0, pressedOpacity: 1.0,
                duration: 0.0,
                springResponse: 0.0, springDamping: 1.0, springBlend: 0.0
            ),
            GentleButtonAnimationRole.subtlePress.rawValue: .init(
                pressedScale: 0.98, pressedOpacity: 0.95,
                duration: 0.12,
                springResponse: 0.0, springDamping: 1.0, springBlend: 0.0
            ),
            GentleButtonAnimationRole.squish.rawValue: .init(
                pressedScale: 0.97, pressedOpacity: 0.92,
                duration: 0.10,
                springResponse: 0.22, springDamping: 0.85, springBlend: 0.0
            ),
            GentleButtonAnimationRole.pop.rawValue: .init(
                pressedScale: 0.975, pressedOpacity: 0.93,
                duration: 0.10,
                springResponse: 0.18, springDamping: 0.78, springBlend: 0.0
            ),
            GentleButtonAnimationRole.bouncy.rawValue: .init(
                pressedScale: 0.97, pressedOpacity: 0.94,
                duration: 0.10,
                springResponse: 0.28, springDamping: 0.70, springBlend: 0.0
            ),
            GentleButtonAnimationRole.springBack.rawValue: .init(
                pressedScale: 0.72, pressedOpacity: 0.90,
                duration: 0.10,
                springResponse: 0.45, springDamping: 0.45, springBlend: 0.0
            )
        ]
    )
}

// MARK: - Typography axis enums (JSON-friendly)

public enum GentleFontDesignToken: String, Codable, Sendable, CaseIterable {
    case `default`, serif, rounded, monospaced
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
public enum GentleFontWidthToken: String, Codable, Sendable, CaseIterable {
    case compressed, condensed, standard, expanded
    @available(iOS 17.0, *)
    var swiftUIWidth: Font.Width {
        switch self {
        case .compressed: return .compressed
        case .condensed: return .condensed
        case .standard: return .standard
        case .expanded: return .expanded
        }
    }

    var displayName: String { rawValue.capitalized }
}

public enum GentleFontWeightToken: String, Codable, Sendable, CaseIterable {
    case ultraLight, thin, light, regular, medium, semibold, bold, heavy, black
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

    var displayName: String {
        switch self {
        case .ultraLight: return "Ultra Light"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        }
    }
}

// MARK: - Typography

public struct GentleTypographyRoleSpec: Codable, Sendable {
    public var pointSize: Double
    public var weight: GentleFontWeightToken
    public var design: GentleFontDesignToken
    public var width: GentleFontWidthToken?
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

public struct GentleTypographyTokens: Codable, Sendable {
    public var roles: [String: GentleTypographyRoleSpec]

    public init(roles: [String: GentleTypographyRoleSpec]) {
        self.roles = roles
    }

    public func roleSpec(for role: GentleTextRole) -> GentleTypographyRoleSpec {
        if let spec = roles[role.rawValue] { return spec }
        if let body = roles[GentleTextRole.body_m.rawValue] { return body }
        return GentleTypographyRoleSpec(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 2, letterSpacing: 0,
            isUppercased: false, colorRole: .textPrimary
        )
    }
}

public extension GentleTypographyTokens {
    static let gentleDefault: GentleTypographyTokens = {
        var dict: [String: GentleTypographyRoleSpec] = [:]

        dict[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 34, weight: .bold, design: .rounded, width: nil,
            relativeTo: .largeTitle, lineSpacing: 6, colorRole: .textPrimary
        )
        dict[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 28, weight: .bold, design: .rounded, width: nil,
            relativeTo: .title, lineSpacing: 4, colorRole: .textPrimary
        )
        dict[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 22, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .title2, lineSpacing: 3, colorRole: .textPrimary
        )
        dict[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .title3, lineSpacing: 3, colorRole: .textPrimary
        )
        dict[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )

        dict[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
        )
        dict[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textSecondary
        )
        dict[GentleTextRole.monoCode_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .monospaced, width: .condensed,
            relativeTo: .body, letterSpacing: 0.3, colorRole: .textPrimary
        )

        dict[GentleTextRole.callout_ms.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .default, width: nil,
            relativeTo: .callout, colorRole: .textSecondary
        )
        dict[GentleTextRole.subheadline_ms.rawValue] = .init(
            pointSize: 15, weight: .regular, design: .default, width: nil,
            relativeTo: .subheadline, colorRole: .textSecondary
        )

        dict[GentleTextRole.footnote_s.rawValue] = .init(
            pointSize: 13, weight: .regular, design: .default, width: nil,
            relativeTo: .footnote, colorRole: .textTertiary
        )
        dict[GentleTextRole.caption_s.rawValue] = .init(
            pointSize: 12, weight: .regular, design: .default, width: nil,
            relativeTo: .caption, colorRole: .textTertiary
        )
        dict[GentleTextRole.caption2_s.rawValue] = .init(
            pointSize: 11, weight: .regular, design: .default, width: nil,
            relativeTo: .caption2, colorRole: .textTertiary
        )

        // Button titles – default to same size as headline, semibold weight, default design (not serif)
        dict[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        dict[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        dict[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        dict[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )

        return GentleTypographyTokens(roles: dict)
    }()
}

// MARK: - Layout tokens

public struct GentleSpacingScaleTokens: Codable, Sendable {
    public var xs: Double
    public var s: Double
    public var m: Double
    public var l: Double
    public var xl: Double
    public var xxl: Double

    public init(xs: Double = 4, s: Double = 8, m: Double = 12, l: Double = 16, xl: Double = 24, xxl: Double = 32) {
        self.xs = xs; self.s = s; self.m = m; self.l = l; self.xl = xl; self.xxl = xxl
    }
}

public extension GentleSpacingScaleTokens { static let gentleDefault = GentleSpacingScaleTokens() }

public enum GentleSpacingToken: String, Codable, Sendable, CaseIterable { case xs, s, m, l, xl, xxl }

public extension GentleSpacingScaleTokens {
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

public typealias GentleGapTokens = GentleSpacingScaleTokens
public typealias GentleGridSpacingTokens = GentleSpacingScaleTokens
public typealias GentleTouchTokens = GentleSpacingScaleTokens

// MARK: - Insets (semantic container insets)

public enum GentleInsetRole: String, Codable, Sendable { case screen, card, control, listRow }

public enum GentleInsetVariant: String, Codable, Sendable, CaseIterable {
    case tight
    case regular
    case roomy
}

public struct GentleAxisInsetTokens: Codable, Sendable, Hashable {
    public var horizontal: GentleSpacingToken
    public var vertical: GentleSpacingToken
    public init(horizontal: GentleSpacingToken, vertical: GentleSpacingToken) { self.horizontal = horizontal; self.vertical = vertical }
}

public struct GentleInsetTokens: Codable, Sendable {
    /// Nested dictionary: [role.rawValue: [variant.rawValue: tokens]]
    public var tokensByRoleVariant: [String: [String: GentleAxisInsetTokens]]

    public init(tokensByRoleVariant: [String: [String: GentleAxisInsetTokens]]) {
        self.tokensByRoleVariant = tokensByRoleVariant
    }

    /// Resolve axis tokens with fallback order:
    /// role+variant → role+regular → screen+regular → hardcoded default
    public func axisTokens(for role: GentleInsetRole, variant: GentleInsetVariant = .regular) -> GentleAxisInsetTokens {
        let roleKey = role.rawValue
        let variantKey = variant.rawValue
        let regularKey = GentleInsetVariant.regular.rawValue
        let screenKey = GentleInsetRole.screen.rawValue

        // Try role+variant
        if let variantsForRole = tokensByRoleVariant[roleKey],
           let tokens = variantsForRole[variantKey] {
            return tokens
        }
        // Fallback: role+regular
        if let variantsForRole = tokensByRoleVariant[roleKey],
           let tokens = variantsForRole[regularKey] {
            return tokens
        }
        // Fallback: screen+regular
        if let variantsForScreen = tokensByRoleVariant[screenKey],
           let tokens = variantsForScreen[regularKey] {
            return tokens
        }
        // Hardcoded default
        return .init(horizontal: .xl, vertical: .l)
    }

    // MARK: - Backwards-compatible Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // Try new format first: [String: [String: GentleAxisInsetTokens]]
        if let nested = try? container.decode([String: [String: GentleAxisInsetTokens]].self) {
            self.tokensByRoleVariant = nested
            return
        }

        // Fallback: old format [String: GentleAxisInsetTokens] → migrate to regular variant
        if let flat = try? container.decode([String: GentleAxisInsetTokens].self) {
            var migrated: [String: [String: GentleAxisInsetTokens]] = [:]
            for (roleKey, tokens) in flat {
                migrated[roleKey] = [GentleInsetVariant.regular.rawValue: tokens]
            }
            self.tokensByRoleVariant = migrated
            return
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "GentleInsetTokens: expected nested or flat dictionary"
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(tokensByRoleVariant)
    }
}

public extension GentleInsetTokens {
    static let gentleDefault: GentleInsetTokens = .init(
        tokensByRoleVariant: [
            GentleInsetRole.screen.rawValue: [
                GentleInsetVariant.tight.rawValue:   .init(horizontal: .s, vertical: .m),
                GentleInsetVariant.regular.rawValue: .init(horizontal: .m, vertical: .l),
                GentleInsetVariant.roomy.rawValue:   .init(horizontal: .l, vertical: .xl)
            ],
            GentleInsetRole.card.rawValue: [
                GentleInsetVariant.tight.rawValue:   .init(horizontal: .s, vertical: .s),
                GentleInsetVariant.regular.rawValue: .init(horizontal: .l,  vertical: .l),
                GentleInsetVariant.roomy.rawValue:   .init(horizontal: .xl, vertical: .xl)
            ],
            GentleInsetRole.control.rawValue: [
                GentleInsetVariant.tight.rawValue:   .init(horizontal: .m, vertical: .xs),
                GentleInsetVariant.regular.rawValue: .init(horizontal: .l, vertical: .s)
            ],
            GentleInsetRole.listRow.rawValue: [
                GentleInsetVariant.tight.rawValue:   .init(horizontal: .m, vertical: .xs),
                GentleInsetVariant.regular.rawValue: .init(horizontal: .l, vertical: .s)
            ]
        ]
    )
}

public struct GentleLayoutTokens: Codable, Sendable {
    /// Canonical scale used by inset roles (and handy for occasional one-offs).
    public var scale: GentleSpacingScaleTokens

    public var gap: GentleGapTokens
    public var grid: GentleGridSpacingTokens
    public var touch: GentleTouchTokens
    public var inset: GentleInsetTokens

    public init(scale: GentleSpacingScaleTokens = .gentleDefault,
                gap: GentleGapTokens = .gentleDefault,
                grid: GentleGridSpacingTokens = .gentleDefault,
                touch: GentleTouchTokens = .gentleDefault,
                inset: GentleInsetTokens = .gentleDefault) {
        self.scale = scale
        self.gap = gap
        self.grid = grid
        self.touch = touch
        self.inset = inset
    }
}

public extension GentleLayoutTokens { static let gentleDefault = GentleLayoutTokens() }

// MARK: - Visual tokens

public struct GentleRadiusTokens: Codable, Sendable {
    public var small: Double
    public var medium: Double
    public var large: Double
    public var pill: Double

    public init(small: Double = 8, medium: Double = 12, large: Double = 20, pill: Double = 999) {
        self.small = small; self.medium = medium; self.large = large; self.pill = pill
    }
}
public extension GentleRadiusTokens { static let gentleDefault = GentleRadiusTokens() }

public struct GentleShadowTokens: Codable, Sendable {
    public var none: Double
    public var small: Double
    public var medium: Double

    public init(none: Double = 0, small: Double = 2, medium: Double = 6) {
        self.none = none; self.small = small; self.medium = medium
    }
}
public extension GentleShadowTokens { static let gentleDefault = GentleShadowTokens() }

public struct GentleVisualTokens: Codable, Sendable {
    public var radii: GentleRadiusTokens
    public var shadows: GentleShadowTokens
    public init(radii: GentleRadiusTokens = .gentleDefault, shadows: GentleShadowTokens = .gentleDefault) {
        self.radii = radii; self.shadows = shadows
    }
}
public extension GentleVisualTokens { static let gentleDefault = GentleVisualTokens() }

// MARK: - Runtime theme (built from spec)

public struct GentleTheme: Sendable {
    public var id = 0

    /// The baseline spec for the current preset.
    public var defaultSpec: GentleDesignSystemSpec

    /// The live, user-editable spec (always present).
    public var editableSpec: GentleDesignSystemSpec

    /// The spec that actually drives rendering.
    public var activeSpec: GentleDesignSystemSpec { editableSpec }

    /// Convenience: legacy alias for existing call sites (points to the active spec).
    public var spec: GentleDesignSystemSpec { activeSpec }

    public init(defaultSpec: GentleDesignSystemSpec = .gentleDefault,
                editableSpec: GentleDesignSystemSpec? = nil) {
        self.defaultSpec = defaultSpec
        self.editableSpec = editableSpec ?? defaultSpec
    }

    public static let `default` = GentleTheme(defaultSpec: .gentleDefault, editableSpec: nil)

    public var layout: GentleLayoutTokens { activeSpec.layout }
    public var visual: GentleVisualTokens { activeSpec.visual }
    public var buttons: GentleButtonTokens { activeSpec.buttons }
    public var surfaces: GentleSurfaceTokens { activeSpec.surfaces }

    public var gap: GentleGapTokens { activeSpec.layout.gap }
    public var grid: GentleGridSpacingTokens { activeSpec.layout.grid }
    public var touch: GentleTouchTokens { activeSpec.layout.touch }
    public var inset: GentleInsetTokens { activeSpec.layout.inset }

    public var radii: GentleRadiusTokens { activeSpec.visual.radii }
    public var shadows: GentleShadowTokens { activeSpec.visual.shadows }

    public func color(for role: GentleColorRole, scheme: ColorScheme) -> Color {
        guard let pair = activeSpec.colors.pair(for: role) else { return Color.primary }
        return Color(gentleHex: pair.hex(for: scheme))
    }

    public func visualEffectRecipe(for effect: GentleVisualEffect) -> GentleVisualEffectRecipe {
        let colors = activeSpec.colors

        func pair(_ role: GentleColorRole, fallback: GentleColorPair) -> GentleColorPair {
            colors.pair(for: role) ?? fallback
        }

        switch effect {
        case .appBackground:
            return GentleVisualEffectRecipe(
                id: effect.rawValue,
                base: .solid(pair(.background, fallback: .init(lightHex: "#F3F4F6", darkHex: "#030712")))
            )
        case .surface:
            return GentleVisualEffectRecipe(
                id: effect.rawValue,
                base: .solid(pair(.surface, fallback: .init(lightHex: "#FAFAFE", darkHex: "#111827")))
            )
        case .surfaceOverlay:
            return GentleVisualEffectRecipe(
                id: effect.rawValue,
                base: .solid(pair(.surfaceOverlay, fallback: .init(lightHex: "#111827CC", darkHex: "#020617CC")))
            )
        }
    }

    public func textStyle(for role: GentleTextRole, sizeCategory: ContentSizeCategory) -> GentleResolvedTextStyle {
        let roleSpec = activeSpec.typography.roleSpec(for: role)

        let metrics = UIFontMetrics(forTextStyle: roleSpec.relativeTo.uiKitTextStyle)
        let traits = UITraitCollection(preferredContentSizeCategory: sizeCategory.uiContentSizeCategory)
        let scaledSize = metrics.scaledValue(for: CGFloat(roleSpec.pointSize), compatibleWith: traits)

        var baseFont = Font.system(size: scaledSize,
                                   weight: roleSpec.weight.swiftUIWeight,
                                   design: roleSpec.design.swiftUIDesign)

        if let width = roleSpec.width {
            if roleSpec.design == .default {
                baseFont = baseFont.width(width.swiftUIWidth)
            }
        }

        return GentleResolvedTextStyle(
            font: baseFont,
            design: roleSpec.design,
            colorRole: roleSpec.colorRole,
            lineSpacing: CGFloat(roleSpec.lineSpacing),
            letterSpacing: CGFloat(roleSpec.letterSpacing),
            isUppercased: roleSpec.isUppercased
        )
    }
}

public extension GentleTheme {
    func insetValue(_ role: GentleInsetRole, variant: GentleInsetVariant = .regular, edges: Edge.Set = .all) -> (horizontal: CGFloat?, vertical: CGFloat?) {
        let axis = activeSpec.layout.inset.axisTokens(for: role, variant: variant)
        let h = CGFloat(activeSpec.layout.scale.value(for: axis.horizontal))
        let v = CGFloat(activeSpec.layout.scale.value(for: axis.vertical))

        let horizontal: CGFloat? = (edges == .all || edges.contains(.horizontal) || edges.contains(.leading) || edges.contains(.trailing)) ? h : nil
        let vertical: CGFloat? = (edges == .all || edges.contains(.vertical) || edges.contains(.top) || edges.contains(.bottom)) ? v : nil
        return (horizontal, vertical)
    }
}

public struct GentleResolvedTextStyle {
    public let font: Font
    public let design: GentleFontDesignToken
    public let colorRole: GentleColorRole
    public let lineSpacing: CGFloat
    public let letterSpacing: CGFloat
    public let isUppercased: Bool
}

// MARK: - Intent facades (ergonomics for contractors)

/// Exposes both raw scale values (xs/s/m/...) and intent-based values (none/micro/tight/regular/loose).
public struct GentleGapScaleFacade: Sendable {
    private let scale: GentleSpacingScaleTokens

    public init(scale: GentleSpacingScaleTokens) { self.scale = scale }

    // Raw values (handy for rare fine-tuning)
    public var xs: CGFloat { CGFloat(scale.xs) }
    public var s: CGFloat { CGFloat(scale.s) }
    public var m: CGFloat { CGFloat(scale.m) }
    public var l: CGFloat { CGFloat(scale.l) }
    public var xl: CGFloat { CGFloat(scale.xl) }
    public var xxl: CGFloat { CGFloat(scale.xxl) }

    public func value(_ token: GentleSpacingToken) -> CGFloat { CGFloat(scale.value(for: token)) }

    // Intent values (preferred for most call sites)
    public func value(_ intent: GentleGapIntent) -> CGFloat {
        switch intent {
        case .unknown: return 0
        case .micro: return xs
        case .tight: return s
        case .regular: return m
        case .ample: return l
        case .loose: return xl
        case .expansive: return xxl
        }
    }

    public var none: CGFloat { value(.unknown) }
    public var micro: CGFloat { value(.micro) }
    public var tight: CGFloat { value(.tight) }
    public var regular: CGFloat { value(.regular) }
    public var ample: CGFloat { value(.ample) }
    public var loose: CGFloat { value(.loose) }
    public var expansive: CGFloat { value(.expansive) }
}

/// Layout facade designed for call-site clarity.
public struct GentleLayoutFacade: Sendable {
    private let tokens: GentleLayoutTokens

    public init(tokens: GentleLayoutTokens) { self.tokens = tokens }

    /// Raw generic gap scale (mostly for advanced use).
    public var gap: GentleGapScaleFacade { .init(scale: tokens.gap) }

    /// Stack spacing intent (preferred).
    public var stack: GentleGapScaleFacade { .init(scale: tokens.gap) }

    /// List spacing intent (preferred).
    public var list: GentleGapScaleFacade { .init(scale: tokens.gap) }

    /// Grid spacing (raw + intent).
    public var grid: GentleGapScaleFacade { .init(scale: tokens.grid) }

    /// Touch spacing (raw + intent).
    public var touch: GentleGapScaleFacade { .init(scale: tokens.touch) }

    /// Insets are semantic + axis-aware, and are resolved via `GentleTheme.insetValue(...)`.
    public var inset: GentleInsetTokens { tokens.inset }
}

// MARK: - Environment + theme root

private struct GentleThemeKey: EnvironmentKey { static let defaultValue: GentleTheme = .default }

public extension EnvironmentValues {
    var gentleTheme: GentleTheme {
        get { self[GentleThemeKey.self] }
        set { self[GentleThemeKey.self] = newValue }
    }
}

public struct GentleThemeRoot<Content: View>: View {
    private let theme: GentleTheme
    private let content: Content

    public init(theme: GentleTheme = .default, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }

    public var body: some View { content.environment(\.gentleTheme, theme) }
}

// MARK: - Animation resolver

@MainActor
public enum GentleButtonAnimations {
    public static func resolve(
        reduceMotion: Bool,
        role: GentleButtonAnimationRole,
        spec: GentleButtonAnimationSpec
    ) -> Animation? {
        if reduceMotion { return nil }

        switch role {
        case .unknown:
            return nil
        case .subtlePress:
            // "Feels" crisp; avoids bounce.
            return .easeOut(duration: spec.duration)
        case .squish:
            return .spring(response: spec.springResponse,
                           dampingFraction: spec.springDamping,
                           blendDuration: spec.springBlend)
        case .pop:
            return .spring(response: spec.springResponse,
                           dampingFraction: spec.springDamping,
                           blendDuration: spec.springBlend)
        case .bouncy:
            return .spring(response: spec.springResponse,
                           dampingFraction: spec.springDamping,
                           blendDuration: spec.springBlend)
        case .springBack:
            // Underdamped spring that overshoots 1.0 before settling
            return .spring(response: spec.springResponse,
                           dampingFraction: spec.springDamping,
                           blendDuration: spec.springBlend)
        }
    }
}

public struct GentleButtonStyle: ButtonStyle {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    private let role: GentleButtonRole
    private let shapeOverride: GentleButtonShape?
    private let textRoleOverride: GentleTextRole?

    // ✅ NEW: allow styles to expand the label to full width (so background/border fill)
    private let expandsHorizontally: Bool
    private let contentAlignment: Alignment

    /// If `shapeOverride` is nil, the per-role `shape` from the spec is used.
    /// If `textRoleOverride` is nil, the per-role `textRole` from the spec is used.
    public init(
        role: GentleButtonRole,
        shape: GentleButtonShape? = nil,
        textRole: GentleTextRole? = nil,
        expandsHorizontally: Bool = false,
        contentAlignment: Alignment = .center
    ) {
        self.role = role
        self.shapeOverride = shape
        self.textRoleOverride = textRole
        self.expandsHorizontally = expandsHorizontally
        self.contentAlignment = contentAlignment
    }

    public func makeBody(configuration: Configuration) -> some View {
        let spec = theme.buttons.roleSpec(for: role)

        // Derive text role from button role (or use override)
        let textRoleToUse = textRoleOverride ?? role.defaultTextRole

        // Derive colors from material role
        let (backgroundColor, labelColorRole): (Color, GentleColorRole) = {
            switch spec.fillRole {
            case .solidFillPrimaryCTA:
                return (theme.color(for: .primaryCTA, scheme: colorScheme), .onPrimaryCTA)
            case .solidFillDestructive:
                return (theme.color(for: .destructive, scheme: colorScheme), .onPrimaryCTA)
            case .hollow:
                return (Color.clear, .primaryCTA)
            }
        }()
        let labelColor = theme.color(for: labelColorRole, scheme: colorScheme)

        // When usesNativeStyle is true, apply text styling and press animations but skip background/border/padding.
        if spec.usesNativeStyle {
            let animSpec = theme.buttons.animationSpec(for: spec.animationRole)
            let animation = GentleButtonAnimations.resolve(
                reduceMotion: reduceMotion,
                role: spec.animationRole,
                spec: animSpec
            )
            return AnyView(
                configuration.label
                    .gentleText(textRoleToUse, colorRole: labelColorRole)
                    .frame(maxWidth: expandsHorizontally ? .infinity : nil, alignment: contentAlignment)
                    .scaleEffect(configuration.isPressed ? spec.pressedScale : 1.0)
                    .opacity(configuration.isPressed ? spec.pressedOpacity : 1.0)
                    .animation(animation, value: configuration.isPressed)
            )
        }

        let gap = theme.gap
        let radii = theme.radii

        let animSpec = theme.buttons.animationSpec(for: spec.animationRole)
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: reduceMotion,
            role: spec.animationRole,
            spec: animSpec
        )

        let shapeToUse = shapeOverride ?? spec.shape
        let cornerRadius: CGFloat = (shapeToUse == .pill) ? CGFloat(radii.pill) : CGFloat(radii.medium)

        let secondaryOpticalTrim: CGFloat = (role == .secondary) ? 1.0 : 0.0
        let verticalPadding: CGFloat = max(0, CGFloat(gap.s) - secondaryOpticalTrim)

        // Resolve border color from border role
        let borderColor: Color? = {
            switch spec.borderRole {
            case .hidden: return nil
            case .accent: return theme.color(for: .primaryCTA, scheme: colorScheme)
            case .subtle: return theme.color(for: .borderSubtle, scheme: colorScheme)
            }
        }()

        // Disabled state: solid fills dim opacity, hollow buttons desaturate
        let saturation: Double
        let disabledOpacity: Double
        if isEnabled {
            saturation = 1.0
            disabledOpacity = 1.0
        } else {
            switch spec.fillRole {
            case .solidFillPrimaryCTA, .solidFillDestructive:
                saturation = 1.0
                disabledOpacity = 0.4
            case .hollow:
                saturation = 0.3
                disabledOpacity = 0.6
            }
        }

        // Expand the label *inside* the style, before background/overlay.
        let label = configuration.label
            .gentleText(textRoleToUse, colorRole: labelColorRole)
            .foregroundStyle(labelColor)

        let sizedLabel = Group {
            if expandsHorizontally {
                label.frame(maxWidth: .infinity, alignment: contentAlignment)
            } else {
                label
            }
        }

        return AnyView(
            sizedLabel
                .padding(.horizontal, CGFloat(gap.xl))
                .padding(.vertical, verticalPadding)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(backgroundColor))
                .overlay(
                    Group {
                        if let borderColor {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .strokeBorder(borderColor, lineWidth: 1)
                        }
                    }
                )
                .scaleEffect(configuration.isPressed ? spec.pressedScale : 1.0)
                .opacity(configuration.isPressed ? spec.pressedOpacity : 1.0)
                .animation(animation, value: configuration.isPressed)
                .saturation(saturation)
                .opacity(disabledOpacity)
        )
    }
}

// MARK: - Property Wrapper (Runtime)

@propertyWrapper
public struct GentleDesignRuntime: DynamicProperty {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    public init() {}

    public var wrappedValue: Resolver { Resolver(theme: theme, colorScheme: colorScheme) }

    public struct Resolver {
        public let theme: GentleTheme
        let colorScheme: ColorScheme

        public var layout: GentleLayoutFacade { .init(tokens: theme.layout) }
        public var visual: GentleVisualTokens { theme.visual }
        public var buttons: GentleButtonTokens { theme.buttons }
        public var surfaces: GentleSurfaceTokens { theme.surfaces }

        public var radii: GentleRadiusTokens { theme.radii }
        public var shadows: GentleShadowTokens { theme.shadows }

        public func color(_ role: GentleColorRole) -> Color { theme.color(for: role, scheme: colorScheme) }

        public var surface: Color { color(.surface) }
        public var background: Color { color(.background) }
        public var borderSubtle: Color { color(.borderSubtle) }
        public var textPrimary: Color { color(.textPrimary) }
        public var themePrimary: Color { color(.themePrimary) }
    }
}

// MARK: - Theme Manager (ergonomics)

@Observable
@MainActor
public final class GentleThemeManager {
    public var theme: GentleTheme
    public let store: GentleThemeSpecStore
    public private(set) var hasUnsavedChanges: Bool = false
    public private(set) var currentPresetName: String?

    public init(theme: GentleTheme = .default,
                store: GentleThemeSpecStore = GentleFileThemeSpecStore()) {
        self.theme = theme
        self.store = store
    }

    /// Loads the persisted editable spec (if present) into `theme.editableSpec`.
    public func load() throws {
        var t = theme
        if let presetName = currentPresetName,
           let savedSpec = try store.loadEditableSpec(forPreset: presetName) {
            t.editableSpec = savedSpec
        } else if let savedSpec = try store.loadEditableSpec() {
            t.editableSpec = savedSpec
        } else {
            t.editableSpec = t.defaultSpec
        }
        theme = t
        hasUnsavedChanges = false
    }

    /// Persists the current `theme.editableSpec`.
    public func save() throws {
        try store.saveEditableSpec(theme.editableSpec)
        // Also save to preset-specific file if we have a current preset
        if let presetName = currentPresetName {
            try store.saveEditableSpec(theme.editableSpec, forPreset: presetName)
        }
        hasUnsavedChanges = false
    }

    /// Resets the theme back to defaults and clears persisted overrides.
    public func reset() throws {
        var t = theme
        t.editableSpec = t.defaultSpec
        theme = t
        try store.clearEditableSpec()
        if let presetName = currentPresetName {
            try store.clearEditableSpec(forPreset: presetName)
        }
    }

    // MARK: - Preset Selection

    /// Selects a preset and loads any saved edits for it.
    /// - Parameters:
    ///   - name: The preset name
    ///   - defaultSpec: The preset's default spec (used if no saved edits exist)
    public func selectPreset(name: String, defaultSpec: GentleDesignSystemSpec) throws {
        currentPresetName = name
        var t = theme
        t.defaultSpec = defaultSpec
        // Try to load saved edits for this preset, otherwise use the default
        if let savedSpec = try store.loadEditableSpec(forPreset: name) {
            t.editableSpec = savedSpec
        } else {
            t.editableSpec = defaultSpec
        }
        theme = t
        hasUnsavedChanges = false
    }

    /// Checks if a preset has saved edits.
    public func hasEditableSpec(forPreset name: String) -> Bool {
        (try? store.hasEditableSpec(forPreset: name)) ?? false
    }

    public func bindingForTypographyRole(_ role: GentleTextRole) -> Binding<GentleTypographyRoleSpec> {
        Binding(
            get: { self.theme.editableSpec.typography.roleSpec(for: role) },
            set: { newSpec in
                var t = self.theme
                t.editableSpec.typography.roles[role.rawValue] = newSpec
                self.theme = t
                self.hasUnsavedChanges = true
            }
        )
    }

    public func bindingForButtonRole(_ role: GentleButtonRole) -> Binding<GentleButtonRoleSpec> {
        Binding(
            get: { self.theme.editableSpec.buttons.roleSpec(for: role) },
            set: { newSpec in
                var t = self.theme
                t.editableSpec.buttons.roles[role.rawValue] = newSpec
                self.theme = t
                self.hasUnsavedChanges = true
            }
        )
    }

    public func bindingForSurfaceRole(_ role: GentleSurfaceRole) -> Binding<GentleSurfaceRoleSpec> {
        Binding(
            get: { self.theme.editableSpec.surfaces.roleSpec(for: role) },
            set: { newSpec in
                var t = self.theme
                t.editableSpec.surfaces.roles[role.rawValue] = newSpec
                self.theme = t
                self.hasUnsavedChanges = true
            }
        )
    }

    public func bindingForColorRole(_ role: GentleColorRole) -> Binding<GentleColorPair> {
        Binding(
            get: {
                self.theme.editableSpec.colors.pair(for: role)
                    ?? GentleColorPair(lightHex: "#000000", darkHex: "#FFFFFF")
            },
            set: { newPair in
                var t = self.theme
                t.editableSpec.colors.pairByRole[role.rawValue] = newPair
                self.theme = t
                self.hasUnsavedChanges = true
            }
        )
    }

    // MARK: - Export

    /// Exports the current editable spec to a temporary JSON file and returns its URL.
    /// Suitable for use with ShareLink or other sharing mechanisms.
    public func exportURL() throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "GentleTheme_\(formattedTimestamp()).json"
        let url = tempDir.appendingPathComponent(fileName)
        let data = try theme.editableSpec.encodedJSONData()
        try data.write(to: url, options: [.atomic])
        return url
    }

    private func formattedTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HHmmss"
        return formatter.string(from: Date())
    }
}

private struct GentleThemeManagerKey: EnvironmentKey {
    static let defaultValue: GentleThemeManager? = nil
}

public extension EnvironmentValues {
    var gentleThemeManager: GentleThemeManager? {
        get { self[GentleThemeManagerKey.self] }
        set { self[GentleThemeManagerKey.self] = newValue }
    }
}

@propertyWrapper
public struct GentleThemeManagerRuntime: DynamicProperty {
    @Environment(\.gentleThemeManager) private var manager
    public var wrappedValue: GentleThemeManager {
        guard let manager else {
            fatalError("gentleThemeManager is missing. Inject it with .environment(\\.gentleThemeManager, manager).")
        }
        return manager
    }
    public init() {}
}
