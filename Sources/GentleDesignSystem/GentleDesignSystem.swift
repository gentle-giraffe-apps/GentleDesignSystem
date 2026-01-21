//  Jonathan Ritchey
import SwiftUI
import Foundation
import Observation
import UIKit

public enum GentleDesignSystemSpecVersion {
    public static let current = "0.2.3" // adds button press animation roles in spec
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
    case onPrimaryCTA
    case background, surface, surfaceElevated
    case surfaceOverlay, onSurfaceOverlayPrimary, onSurfaceOverlaySecondary
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
        case .background: return "Background"
        case .surface: return "Surface"
        case .surfaceElevated: return "Surface Elevated"
        case .surfaceOverlay: return "Surface Overlay"
        case .onSurfaceOverlayPrimary: return "On Overlay Primary"
        case .onSurfaceOverlaySecondary: return "On Overlay Secondary"
        case .borderSubtle: return "Border Subtle"
        case .destructive: return "Destructive"
        case .primaryCTA: return "Primary CTA"
        case .themePrimary: return "Theme Primary"
        case .themeSecondary: return "Theme Secondary"
        }
    }
}

public enum GentleButtonRole: String, Codable, Sendable { case primary, secondary, tertiary, quaternary, destructive }

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

public enum GentleSurfaceRole: String, Codable, Sendable {
    case appBackground
    case card
    case cardElevated
    case surfaceOverlay
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

    enum CodingKeys: String, CodingKey {
        case specVersion = "_specVersion"
        case colors, typography, layout, visual, buttons
    }

    public init(
        specVersion: String = GentleDesignSystemSpecVersion.current,
        colors: GentleColorTokens,
        typography: GentleTypographyTokens,
        layout: GentleLayoutTokens,
        visual: GentleVisualTokens,
        buttons: GentleButtonTokens
    ) {
        self.specVersion = specVersion
        self.colors = colors
        self.typography = typography
        self.layout = layout
        self.visual = visual
        self.buttons = buttons
    }
}

public extension GentleDesignSystemSpec {
    static let gentleDefault: GentleDesignSystemSpec = .init(
        colors: .gentleDefault,
        typography: .gentleDefault,
        layout: .gentleDefault,
        visual: .gentleDefault,
        buttons: .gentleDefault
    )
}

// MARK: - Theme Presets

public extension GentleDesignSystemSpec {

    // MARK: Preset 1: Classic - Serif titles, traditional feel
    static let classic: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Warm cream/brown colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#2C2416", darkHex: "#F5F0E6"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#5A4D3A", darkHex: "#D4C8B4"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#7A6E5A", darkHex: "#B0A48E"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#FAF8F3", darkHex: "#1A1610"),
            GentleColorRole.surface.rawValue:       .init(lightHex: "#F5F0E6", darkHex: "#2C2416"),
            GentleColorRole.surfaceOverlay.rawValue:.init(lightHex: "#2C2416CC", darkHex: "#0D0B08CC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue:   .init(lightHex: "#FAF8F3", darkHex: "#FAF8F3"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#D4C8B4", darkHex: "#D4C8B4"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#3D3426"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#E0D8C8", darkHex: "#4A4030"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#8B4513", darkHex: "#CD853F"),
            GentleColorRole.onPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#1A1610"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#A0522D", darkHex: "#E07850"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#8B4513", darkHex: "#CD853F"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#B8860B", darkHex: "#DAA520"),
        ])
        // Serif titles, traditional typography
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 36, weight: .bold, design: .serif, width: nil,
            relativeTo: .largeTitle, lineSpacing: 4, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 28, weight: .semibold, design: .serif, width: nil,
            relativeTo: .title, lineSpacing: 3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 22, weight: .semibold, design: .serif, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .medium, design: .serif, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .serif, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 3, colorRole: .textPrimary
        )
        // Button titles – use default (not serif) for buttons
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 2: Modern - Clean, minimal default design
    static let modern: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Cool gray/blue colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#1A1A2E", darkHex: "#EAEAF4"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#4A4A5E", darkHex: "#B0B0C4"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#6A6A7E", darkHex: "#8A8A9E"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#FAFAFC", darkHex: "#0D0D14"),
            GentleColorRole.surface.rawValue:       .init(lightHex: "#F0F0F4", darkHex: "#1A1A28"),
            GentleColorRole.surfaceOverlay.rawValue:.init(lightHex: "#1A1A2ECC", darkHex: "#08080CCC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue:   .init(lightHex: "#FAFAFC", darkHex: "#FAFAFC"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#B0B0C4", darkHex: "#B0B0C4"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#26263A"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#E0E0E8", darkHex: "#3A3A4E"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#3B5BDB", darkHex: "#5C7CFA"),
            GentleColorRole.onPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#0D0D14"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#E03131", darkHex: "#FF6B6B"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#3B5BDB", darkHex: "#5C7CFA"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#748FFC", darkHex: "#91A7FF"),
        ])
        // Clean default design, medium weights
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 32, weight: .semibold, design: .default, width: nil,
            relativeTo: .largeTitle, lineSpacing: 4, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 26, weight: .semibold, design: .default, width: nil,
            relativeTo: .title, lineSpacing: 3, letterSpacing: -0.3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 21, weight: .medium, design: .default, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 19, weight: .medium, design: .default, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 16, weight: .medium, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 3, colorRole: .textPrimary
        )
        // Button titles – clean default design with medium weight
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 16, weight: .medium, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 16, weight: .medium, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 16, weight: .medium, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 3: Soft - Rounded throughout, friendly feel
    static let soft: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Soft mint/teal colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#1A3A2F", darkHex: "#E8F5F0"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#3D5A4F", darkHex: "#B8D4C8"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#5A7A6A", darkHex: "#8AB09E"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#F5FAF8", darkHex: "#0D1F18"),
            GentleColorRole.surface.rawValue:       .init(lightHex: "#E8F5F0", darkHex: "#142E24"),
            GentleColorRole.surfaceOverlay.rawValue:.init(lightHex: "#1A3A2FCC", darkHex: "#0A1A14CC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue:   .init(lightHex: "#F5FAF8", darkHex: "#F5FAF8"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#B8D4C8", darkHex: "#B8D4C8"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#1E3D30"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#C5E0D4", darkHex: "#2A4D3D"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#2E8B6E", darkHex: "#4ADE9F"),
            GentleColorRole.onPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#0D1F18"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#D9534F", darkHex: "#FF6B6B"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#2E8B6E", darkHex: "#4ADE9F"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#6FCF97", darkHex: "#7EEAB8"),
        ])
        // All rounded, soft weights
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 34, weight: .bold, design: .rounded, width: nil,
            relativeTo: .largeTitle, lineSpacing: 6, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 28, weight: .bold, design: .rounded, width: nil,
            relativeTo: .title, lineSpacing: 4, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 22, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .title2, lineSpacing: 3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .title3, lineSpacing: 3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .rounded, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .rounded, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.callout_ms.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .rounded, width: nil,
            relativeTo: .callout, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.subheadline_ms.rawValue] = .init(
            pointSize: 15, weight: .regular, design: .rounded, width: nil,
            relativeTo: .subheadline, colorRole: .textSecondary
        )
        // Button titles – rounded design to match the soft theme
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .rounded, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 4: Editorial - Serif throughout, magazine feel
    static let editorial: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // High contrast black/white
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#000000", darkHex: "#FFFFFF"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#333333", darkHex: "#CCCCCC"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#666666", darkHex: "#999999"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#000000"),
            GentleColorRole.surface.rawValue:       .init(lightHex: "#F5F5F5", darkHex: "#1A1A1A"),
            GentleColorRole.surfaceOverlay.rawValue:.init(lightHex: "#000000CC", darkHex: "#000000CC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#CCCCCC", darkHex: "#CCCCCC"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#262626"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#E0E0E0", darkHex: "#404040"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#000000", darkHex: "#FFFFFF"),
            GentleColorRole.onPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#000000"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#B91C1C", darkHex: "#F87171"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#000000", darkHex: "#FFFFFF"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#666666", darkHex: "#999999"),
        ])
        // All serif, editorial typography
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 40, weight: .bold, design: .serif, width: nil,
            relativeTo: .largeTitle, lineSpacing: 2, letterSpacing: -1.0, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 30, weight: .bold, design: .serif, width: nil,
            relativeTo: .title, lineSpacing: 2, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 24, weight: .semibold, design: .serif, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .semibold, design: .serif, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .serif, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 18, weight: .regular, design: .serif, width: nil,
            relativeTo: .body, lineSpacing: 4, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 18, weight: .regular, design: .serif, width: nil,
            relativeTo: .body, lineSpacing: 4, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.callout_ms.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .serif, width: nil,
            relativeTo: .callout, colorRole: .textSecondary
        )
        // Button titles – use default (not serif) for buttons
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 5: Technical - Monospace accents, developer feel
    static let technical: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Cool blue/gray tech colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#0A2540", darkHex: "#E6F0FA"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#334E68", darkHex: "#A3C4E0"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#5A7A94", darkHex: "#7BA3C4"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#F0F7FC", darkHex: "#061623"),
            GentleColorRole.surface.rawValue:       .init(lightHex: "#E1EFF9", darkHex: "#0C2236"),
            GentleColorRole.surfaceOverlay.rawValue:.init(lightHex: "#0A2540CC", darkHex: "#041020CC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue:   .init(lightHex: "#F0F7FC", darkHex: "#F0F7FC"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#A3C4E0", darkHex: "#A3C4E0"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#123456"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#C4DCF0", darkHex: "#1E4060"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#0066CC", darkHex: "#4DA6FF"),
            GentleColorRole.onPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#061623"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#D64545", darkHex: "#FF7070"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#0066CC", darkHex: "#4DA6FF"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#4D94DB", darkHex: "#80C0FF"),
        ])
        // Monospace titles, condensed
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 30, weight: .bold, design: .monospaced, width: nil,
            relativeTo: .largeTitle, lineSpacing: 4, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 24, weight: .bold, design: .monospaced, width: nil,
            relativeTo: .title, lineSpacing: 3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 20, weight: .semibold, design: .monospaced, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 18, weight: .semibold, design: .monospaced, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 15, weight: .semibold, design: .monospaced, width: nil,
            relativeTo: .headline, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 15, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.monoCode_m.rawValue] = .init(
            pointSize: 14, weight: .regular, design: .monospaced, width: nil,
            relativeTo: .body, letterSpacing: 0, colorRole: .textPrimary
        )
        // Button titles – condensed default design (monospaced would be too wide for buttons)
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 15, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 15, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 15, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 15, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 6: Bold - Heavy weights, strong presence
    static let bold: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Warm orange/sunset colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#3D1E0A", darkHex: "#FFF0E6"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#664433", darkHex: "#E0C4B0"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#8B6B55", darkHex: "#C4A088"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#FFF8F3", darkHex: "#1A0D06"),
            GentleColorRole.surface.rawValue:       .init(lightHex: "#FFEFE5", darkHex: "#2D1A0F"),
            GentleColorRole.surfaceOverlay.rawValue:.init(lightHex: "#3D1E0ACC", darkHex: "#140A05CC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue:   .init(lightHex: "#FFF8F3", darkHex: "#FFF8F3"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#E0C4B0", darkHex: "#E0C4B0"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#3D2418"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#F0D4C0", darkHex: "#4D3020"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#E85D04", darkHex: "#FF8C42"),
            GentleColorRole.onPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#1A0D06"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#CC3300", darkHex: "#FF6644"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#E85D04", darkHex: "#FF8C42"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#F5A060", darkHex: "#FFB87A"),
        ])
        // Heavy weights throughout
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 38, weight: .black, design: .default, width: nil,
            relativeTo: .largeTitle, lineSpacing: 4, letterSpacing: -1.0, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 30, weight: .heavy, design: .default, width: nil,
            relativeTo: .title, lineSpacing: 3, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 24, weight: .bold, design: .default, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .bold, design: .default, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .medium, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 17, weight: .medium, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textSecondary
        )
        // Button titles – bold/heavy weights to match the bold theme
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .heavy, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .medium, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 7: Elegant - Light weights, expanded, airy feel
    static let elegant: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Soft lavender/purple colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#2D1B4E", darkHex: "#F0E6FF"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#4D3A6B", darkHex: "#D0C0E8"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#6E5A8A", darkHex: "#B0A0C8"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#F8F5FF", darkHex: "#120D1F"),
            GentleColorRole.surface.rawValue:       .init(lightHex: "#F0E8FF", darkHex: "#1E1630"),
            GentleColorRole.surfaceOverlay.rawValue:.init(lightHex: "#2D1B4ECC", darkHex: "#0D0818CC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue:   .init(lightHex: "#F8F5FF", darkHex: "#F8F5FF"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#D0C0E8", darkHex: "#D0C0E8"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#2A2040"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#E0D0F0", darkHex: "#3D2D60"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#7C4DFF", darkHex: "#A580FF"),
            GentleColorRole.onPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#120D1F"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#D946EF", darkHex: "#F472B6"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#7C4DFF", darkHex: "#A580FF"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#B388FF", darkHex: "#C9A0FF"),
        ])
        // Light weights, expanded, generous spacing
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 36, weight: .light, design: .default, width: .expanded,
            relativeTo: .largeTitle, lineSpacing: 8, letterSpacing: 1.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 28, weight: .light, design: .default, width: .expanded,
            relativeTo: .title, lineSpacing: 6, letterSpacing: 1.0, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 22, weight: .regular, design: .default, width: .expanded,
            relativeTo: .title2, lineSpacing: 4, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .regular, design: .default, width: nil,
            relativeTo: .title3, lineSpacing: 4, letterSpacing: 0.3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .headline, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .light, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 4, letterSpacing: 0.2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 17, weight: .light, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 4, letterSpacing: 0.2, colorRole: .textSecondary
        )
        // Button titles – light/regular weights with letter spacing for elegance
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .headline, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .headline, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .headline, letterSpacing: 0.3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .light, design: .default, width: nil,
            relativeTo: .body, letterSpacing: 0.2, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 8: Compact - Condensed, information-dense
    static let compact: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Deep forest green colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#1B3D2F", darkHex: "#E6F2EC"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#3A5A4A", darkHex: "#B8D4C4"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#5A7A6A", darkHex: "#94B8A4"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#F2F8F5", darkHex: "#0D1A14"),
            GentleColorRole.surface.rawValue:       .init(lightHex: "#E4F0EA", darkHex: "#1A2D24"),
            GentleColorRole.surfaceOverlay.rawValue:.init(lightHex: "#1B3D2FCC", darkHex: "#0A1810CC"),
            GentleColorRole.onSurfaceOverlayPrimary.rawValue:   .init(lightHex: "#F2F8F5", darkHex: "#F2F8F5"),
            GentleColorRole.onSurfaceOverlaySecondary.rawValue: .init(lightHex: "#B8D4C4", darkHex: "#B8D4C4"),
            GentleColorRole.surfaceElevated.rawValue: .init(lightHex: "#FFFFFF", darkHex: "#243D32"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#C4DCD0", darkHex: "#2D4D3D"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#166534", darkHex: "#4ADE80"),
            GentleColorRole.onPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#0D1A14"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#B91C1C", darkHex: "#F87171"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#166534", darkHex: "#4ADE80"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#22C55E", darkHex: "#86EFAC"),
        ])
        // Condensed, smaller sizes, tight spacing
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 28, weight: .bold, design: .default, width: .condensed,
            relativeTo: .largeTitle, lineSpacing: 2, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 22, weight: .bold, design: .default, width: .condensed,
            relativeTo: .title, lineSpacing: 2, letterSpacing: -0.3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 18, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .title2, lineSpacing: 1, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 16, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .title3, lineSpacing: 1, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 14, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 14, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, lineSpacing: 1, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 14, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, lineSpacing: 1, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.callout_ms.rawValue] = .init(
            pointSize: 13, weight: .regular, design: .default, width: .condensed,
            relativeTo: .callout, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.subheadline_ms.rawValue] = .init(
            pointSize: 12, weight: .regular, design: .default, width: .condensed,
            relativeTo: .subheadline, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.footnote_s.rawValue] = .init(
            pointSize: 11, weight: .regular, design: .default, width: .condensed,
            relativeTo: .footnote, colorRole: .textTertiary
        )
        typo.roles[GentleTextRole.caption_s.rawValue] = .init(
            pointSize: 10, weight: .regular, design: .default, width: .condensed,
            relativeTo: .caption, colorRole: .textTertiary
        )
        typo.roles[GentleTextRole.caption2_s.rawValue] = .init(
            pointSize: 9, weight: .regular, design: .default, width: .condensed,
            relativeTo: .caption2, colorRole: .textTertiary
        )
        // Button titles – condensed design to match the compact theme
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 14, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 14, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 14, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 14, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    /// All built-in theme presets with display names and descriptions
    static let allPresets: [(name: String, summary: String, description: String, purpose: String, systemImageString: String, spec: GentleDesignSystemSpec)] = [
        ("Gentle Default",
         "Calm, balanced foundation for any app",
         "A neutral theme with soft surfaces and confident accent colors that work across all contexts.",
         "Use when you want a versatile starting point with clean hierarchy and accessible contrast.",
         "circle.hexagongrid",
         .gentleDefault),
        ("Classic Tan",
         "Warm, timeless feel with earthy tones",
         "Rich tan backgrounds paired with warm accents create a cozy, established aesthetic.",
         "Use for apps that benefit from warmth and a sense of heritage or craftsmanship.",
         "book.closed.fill",
         .classic),
        ("Modern Gray",
         "Sleek, minimal with neutral foundations",
         "Cool gray surfaces with sharp accents deliver a contemporary, professional appearance.",
         "Use for business apps or tools where clarity and efficiency are paramount.",
         "cube.fill",
         .modern),
        ("Soft Green",
         "Fresh, natural with calming green accents",
         "Gentle green tones create a refreshing, organic feel that reduces visual fatigue.",
         "Use for wellness, productivity, or any app where calm focus matters.",
         "leaf.fill",
         .soft),
        ("Editorial Paper",
         "Refined, print-inspired reading experience",
         "Paper-like backgrounds and classic typography evoke the quality of fine publications.",
         "Use for content-heavy apps where long-form reading is the primary experience.",
         "newspaper.fill",
         .editorial),
        ("Technical Blue",
         "Precise, trustworthy with blue highlights",
         "Professional blue accents on clean surfaces convey reliability and technical competence.",
         "Use for developer tools, dashboards, or apps requiring user trust.",
         "terminal.fill",
         .technical),
        ("Bold Orange",
         "Vibrant, energetic with strong presence",
         "High-energy orange accents demand attention and create memorable interactions.",
         "Use for apps that need to motivate action or stand out boldly.",
         "bolt.fill",
         .bold),
        ("Elegant Purple",
         "Sophisticated, luxurious with rich tones",
         "Deep purple accents on refined surfaces create a premium, distinguished appearance.",
         "Use for lifestyle, creative, or premium apps where elegance matters.",
         "crown.fill",
         .elegant),
        ("Compact Mint",
         "Dense, efficient with fresh accents",
         "Tighter spacing with mint highlights maximizes information density while staying fresh.",
         "Use for data-rich interfaces where screen real estate is precious.",
         "square.grid.3x3.fill",
         .compact),
    ]
}

extension GentleDesignSystemSpec: GentleJSONEncodable {}
extension GentleDesignSystemSpec: GentleJSONDecodable {}

// MARK: - Colors (Light/Dark pairs)

public struct GentleColorPair: Codable, Sendable {
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

// MARK: - Button tokens (NEW)

/// JSON-friendly definition of a button "role" style.
/// This is intentionally close to your existing hard-coded mapping,
/// so current visuals remain unchanged while becoming editable.
public struct GentleButtonRoleSpec: Codable, Sendable {
    public var shape: GentleButtonShape

    /// Typography role to apply to the button label.
    public var textRole: GentleTextRole

    /// Background fill color role.
    public var backgroundRole: GentleColorRole

    /// Foreground (label) color role.
    public var labelColorRole: GentleColorRole

    /// Optional border color role. If nil, no border.
    public var borderRole: GentleColorRole?

    /// Which "feel" to use for press feedback (animation curve + tuning).
    public var animationRole: GentleButtonAnimationRole

    /// Interaction affordances (kept JSON-friendly and tweakable).
    /// These remain per-role to preserve existing behavior and allow overrides.
    public var pressedScale: Double
    public var pressedOpacity: Double

    public init(
        shape: GentleButtonShape = .rounded,
        textRole: GentleTextRole,
        backgroundRole: GentleColorRole,
        labelColorRole: GentleColorRole,
        borderRole: GentleColorRole? = nil,
        animationRole: GentleButtonAnimationRole = .squish,
        pressedScale: Double = 0.97,
        pressedOpacity: Double = 0.9
    ) {
        self.shape = shape
        self.textRole = textRole
        self.backgroundRole = backgroundRole
        self.labelColorRole = labelColorRole
        self.borderRole = borderRole
        self.animationRole = animationRole
        self.pressedScale = pressedScale
        self.pressedOpacity = pressedOpacity
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
            textRole: .headline_m,
            backgroundRole: .primaryCTA,
            labelColorRole: .onPrimaryCTA,
            borderRole: nil,
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
                textRole: .primaryButtonTitle_m,
                backgroundRole: .primaryCTA,
                labelColorRole: .onPrimaryCTA,
                borderRole: nil,
                animationRole: .springBack, // .squish,
                pressedScale: 0.9, // 0.97
                pressedOpacity: 0.86 // 0.92
            ),
            GentleButtonRole.secondary.rawValue: .init(
                shape: .pill,
                textRole: .secondaryButtonTitle_m,
                backgroundRole: .surface,
                labelColorRole: .primaryCTA,
                borderRole: .primaryCTA,
                animationRole: .subtlePress,
                pressedScale: 0.85, // 0.98
                pressedOpacity: 0.9 // 0.95
            ),
            GentleButtonRole.tertiary.rawValue: .init(
                shape: .pill,
                textRole: .tertiaryButtonTitle_m,
                backgroundRole: .surface,
                labelColorRole: .primaryCTA,
                borderRole: nil,
                animationRole: .subtlePress,
                pressedScale: 0.85,
                pressedOpacity: 0.9
            ),
            GentleButtonRole.quaternary.rawValue: .init(
                shape: .pill,
                textRole: .quaternaryButtonTitle_m,
                backgroundRole: .background,
                labelColorRole: .primaryCTA,
                borderRole: nil,
                animationRole: .subtlePress,
                pressedScale: 0.95,
                pressedOpacity: 0.93
            ),
            GentleButtonRole.destructive.rawValue: .init(
                shape: .pill,
                textRole: .primaryButtonTitle_m,
                backgroundRole: .destructive,
                labelColorRole: .onPrimaryCTA,
                borderRole: nil,
                animationRole: .squish,
                pressedScale: 0.9, // 0.97
                pressedOpacity: 0.86 // 0.92
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
                GentleInsetVariant.tight.rawValue:   .init(horizontal: .l,   vertical: .m),
                GentleInsetVariant.regular.rawValue: .init(horizontal: .xl,  vertical: .l),
                GentleInsetVariant.roomy.rawValue:   .init(horizontal: .xxl, vertical: .xl)
            ],
            GentleInsetRole.card.rawValue: [
                GentleInsetVariant.tight.rawValue:   .init(horizontal: .xs, vertical: .xs),
                GentleInsetVariant.regular.rawValue: .init(horizontal: .m,  vertical: .m),
                GentleInsetVariant.roomy.rawValue:   .init(horizontal: .l,  vertical: .l)
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

    public func textStyle(for role: GentleTextRole, sizeCategory: ContentSizeCategory) -> GentleResolvedTextStyle {
        let roleSpec = activeSpec.typography.roleSpec(for: role)

        let metrics = UIFontMetrics(forTextStyle: roleSpec.relativeTo.uiKitTextStyle)
        let traits = UITraitCollection(preferredContentSizeCategory: sizeCategory.uiContentSizeCategory)
        let scaledSize = metrics.scaledValue(for: CGFloat(roleSpec.pointSize), compatibleWith: traits)

        var baseFont = Font.system(size: scaledSize,
                                   weight: roleSpec.weight.swiftUIWeight,
                                   design: roleSpec.design.swiftUIDesign)

        if let width = roleSpec.width {
            if #available(iOS 17.0, *) {
                if roleSpec.design == .default {
                    baseFont = baseFont.width(width.swiftUIWidth)
                }
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
//            .minimumScaleFactor(0.9)
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
        let gap = theme.gap

        let fill = theme.color(for: .surface, scheme: colorScheme)
        let border = theme.color(for: .borderSubtle, scheme: colorScheme)

        let base = content
            .font(style.font)
            .foregroundColor(textColor)
            .tint(theme.color(for: .primaryCTA, scheme: colorScheme))

        switch chrome {
        case .standalone(let shape):
            let horizontal = CGFloat(gap.l)
            let vertical = CGFloat(gap.m)

            return AnyView(
                base
                    .padding(.horizontal, horizontal)
                    .padding(.vertical, vertical)
                    .background(
                        Group {
                            switch shape {
                            case .rounded:
                                RoundedRectangle(cornerRadius: CGFloat(theme.radii.medium), style: .continuous).fill(fill)
                            case .pill:
                                Capsule().fill(fill)
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
                                Capsule().strokeBorder(border, lineWidth: 1)
                            }
                        }
                    )
            )

        case .formRow:
            return AnyView(base.padding(.vertical, CGFloat(gap.s)))

        case .borderless:
            return AnyView(base)
        }
    }
}

public struct GentleSurfaceModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleSurfaceRole
    private let inset: GentleInsetRole?
    private let insetVariant: GentleInsetVariant

    public init(role: GentleSurfaceRole, inset: GentleInsetRole? = nil, insetVariant: GentleInsetVariant = .regular) {
        self.role = role
        self.inset = inset
        self.insetVariant = insetVariant
    }

    public func body(content: Content) -> some View {
        let radii = theme.radii
        let insetContent = inset.map { AnyView(content.gentleInset($0, variant: insetVariant)) } ?? AnyView(content)

        switch role {
        case .appBackground:
            return AnyView(
                insetContent.background(theme.color(for: .background, scheme: colorScheme).ignoresSafeArea())
            )

        case .surfaceOverlay:
            return AnyView(insetContent.background(theme.color(for: .surfaceOverlay, scheme: colorScheme)))

        case .card:
            return AnyView(
                insetContent
                    .background(theme.color(for: .surface, scheme: colorScheme))
                    .cornerRadius(CGFloat(radii.large))
                    .overlay(
                        RoundedRectangle(cornerRadius: CGFloat(radii.large))
                            .stroke(theme.color(for: .borderSubtle, scheme: colorScheme), lineWidth: 1)
                    )
            )

        case .cardElevated:
            return AnyView(
                insetContent
                    .background(theme.color(for: .surfaceElevated, scheme: colorScheme))
                    .cornerRadius(CGFloat(radii.large))
                    .overlay(
                        RoundedRectangle(cornerRadius: CGFloat(radii.large))
                            .stroke(theme.color(for: .borderSubtle, scheme: colorScheme).opacity(0.35), lineWidth: 0.5)
                    )
                    .shadow(
                        color: Color.black.opacity(colorScheme == .dark ? 0.45 : 0.12),
                        radius: 1,
                        x: 0,
                        y: 1
                    )
                    .shadow(
                        color: Color.black.opacity(colorScheme == .dark ? 0.30 : 0.08),
                        radius: 8,
                        x: 0,
                        y: 6
                    )
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
                if ignoresSafeArea { c.ignoresSafeArea() } else { c }
            }
        )
    }
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
        let gap = theme.gap
        let radii = theme.radii

        let spec = theme.buttons.roleSpec(for: role)
        let animSpec = theme.buttons.animationSpec(for: spec.animationRole)
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: reduceMotion,
            role: spec.animationRole,
            spec: animSpec
        )

        let shapeToUse = shapeOverride ?? spec.shape
        let textRoleToUse = textRoleOverride ?? spec.textRole
        let cornerRadius: CGFloat = (shapeToUse == .pill) ? CGFloat(radii.pill) : CGFloat(radii.medium)

        let secondaryOpticalTrim: CGFloat = (role == .secondary) ? 1.0 : 0.0
        let verticalPadding: CGFloat = max(0, CGFloat(gap.s) - secondaryOpticalTrim)

        let backgroundColor = theme.color(for: spec.backgroundRole, scheme: colorScheme)
        let labelColor = theme.color(for: spec.labelColorRole, scheme: colorScheme)
        let borderColor = spec.borderRole.map { theme.color(for: $0, scheme: colorScheme) }

        let saturation: Double
        let opacity: Double
        if isEnabled {
            saturation = 1.0
            opacity = 1.0
        } else {
            if spec.labelColorRole != .onPrimaryCTA {
                saturation = 0.3
                opacity = 0.6
            } else {
                saturation = 1.0
                opacity = 0.4
            }
        }

        // ✅ IMPORTANT: expand the label *inside* the style, before background/overlay.
        let label = configuration.label
            .gentleText(textRoleToUse, colorRole: spec.labelColorRole)

        let sizedLabel = Group {
            if expandsHorizontally {
                label.frame(maxWidth: .infinity, alignment: contentAlignment)
            } else {
                label
            }
        }

        return sizedLabel
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
            .foregroundStyle(labelColor)
            .scaleEffect(configuration.isPressed ? spec.pressedScale : 1.0)
            .opacity(configuration.isPressed ? spec.pressedOpacity : 1.0)
            .animation(animation, value: configuration.isPressed)
            .saturation(saturation)
            .opacity(opacity)
    }
}

public struct GentleInsetModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    private let edges: Edge.Set
    private let role: GentleInsetRole
    private let variant: GentleInsetVariant

    public init(edges: Edge.Set = .all, role: GentleInsetRole, variant: GentleInsetVariant = .regular) {
        self.edges = edges
        self.role = role
        self.variant = variant
    }

    public func body(content: Content) -> some View {
        let resolved = theme.insetValue(role, variant: variant, edges: edges)
        return content
            .padding(.horizontal, resolved.horizontal ?? 0)
            .padding(.vertical, resolved.vertical ?? 0)
    }
}

// MARK: - View extensions (ergonomic API)

public extension View {
    func gentleText(_ role: GentleTextRole, colorRole: GentleColorRole? = nil) -> some View {
        modifier(GentleTextModifier(role: role, overrideColorRole: colorRole))
    }

    func gentleTextField(_ role: GentleTextRole,
                         colorRole: GentleColorRole? = nil,
                         chrome: GentleTextChrome = .standalone(shape: .rounded)) -> some View {
        modifier(GentleTextFieldModifier(role: role, overrideColorRole: colorRole, chrome: chrome))
    }

    func gentleSurface(_ role: GentleSurfaceRole, inset: GentleInsetRole? = nil, insetVariant: GentleInsetVariant = .regular) -> some View {
        modifier(GentleSurfaceModifier(role: role, inset: inset, insetVariant: insetVariant))
    }

    func gentleButton(_ role: GentleButtonRole, expandsHorizontally: Bool = false, contentAlignment: Alignment = .center) -> some View {
        buttonStyle(GentleButtonStyle(role: role, expandsHorizontally: expandsHorizontally, contentAlignment: contentAlignment))
    }

    func gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape, expandsHorizontally: Bool = false, contentAlignment: Alignment = .center) -> some View {
        buttonStyle(GentleButtonStyle(role: role, shape: shape, expandsHorizontally: expandsHorizontally, contentAlignment: contentAlignment))
    }

    func gentleButton(_ role: GentleButtonRole, textRole: GentleTextRole, expandsHorizontally: Bool = false, contentAlignment: Alignment = .center) -> some View {
        buttonStyle(GentleButtonStyle(role: role, textRole: textRole, expandsHorizontally: expandsHorizontally, contentAlignment: contentAlignment))
    }

    func gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape, textRole: GentleTextRole, expandsHorizontally: Bool = false, contentAlignment: Alignment = .center) -> some View {
        buttonStyle(GentleButtonStyle(role: role, shape: shape, textRole: textRole, expandsHorizontally: expandsHorizontally, contentAlignment: contentAlignment))
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

    func gentleInset(_ role: GentleInsetRole, variant: GentleInsetVariant = .regular) -> some View {
        modifier(GentleInsetModifier(edges: .all, role: role, variant: variant))
    }

    func gentleInset(_ edges: Edge.Set, _ role: GentleInsetRole, variant: GentleInsetVariant = .regular) -> some View {
        modifier(GentleInsetModifier(edges: edges, role: role, variant: variant))
    }
}

// MARK: - Color helper (hex → Color)

public extension Color {
    init(gentleHex hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }

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

    public var wrappedValue: Resolver { Resolver(theme: theme, colorScheme: colorScheme) }

    public struct Resolver {
        public let theme: GentleTheme
        let colorScheme: ColorScheme

        public var layout: GentleLayoutFacade { .init(tokens: theme.layout) }
        public var visual: GentleVisualTokens { theme.visual }
        public var buttons: GentleButtonTokens { theme.buttons }

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

// MARK: - Default JSON Encoding

public protocol GentleJSONEncodable: Encodable { static func makeJSONEncoder() -> JSONEncoder }

public extension GentleJSONEncodable {
    static func makeJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }

    func encodedJSONData(encoder: JSONEncoder = Self.makeJSONEncoder()) throws -> Data { try encoder.encode(self) }

    func encodedJSONString(encoder: JSONEncoder = Self.makeJSONEncoder()) throws -> String {
        let data = try encodedJSONData(encoder: encoder)
        guard let s = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(data, .init(codingPath: [], debugDescription: "UTF-8 conversion failed"))
        }
        return s
    }
}

public protocol GentleJSONDecodable: Decodable { static func makeJSONDecoder() -> JSONDecoder }

public extension GentleJSONDecodable {
    static func makeJSONDecoder() -> JSONDecoder { JSONDecoder() }
    static func fromJSONData(_ data: Data, decoder: JSONDecoder = Self.makeJSONDecoder()) throws -> Self {
        try decoder.decode(Self.self, from: data)
    }
    static func fromJSONString(_ string: String, decoder: JSONDecoder = Self.makeJSONDecoder()) throws -> Self {
        try fromJSONData(Data(string.utf8), decoder: decoder)
    }
}

// MARK: - Theme Spec Store

public protocol GentleThemeSpecStore: Sendable {
    func loadEditableSpec() throws -> GentleDesignSystemSpec?
    func saveEditableSpec(_ spec: GentleDesignSystemSpec) throws
    func clearEditableSpec() throws

    // Per-preset storage
    func loadEditableSpec(forPreset name: String) throws -> GentleDesignSystemSpec?
    func saveEditableSpec(_ spec: GentleDesignSystemSpec, forPreset name: String) throws
    func clearEditableSpec(forPreset name: String) throws
    func hasEditableSpec(forPreset name: String) throws -> Bool
}

/// File-backed JSON store (Application Support).
public struct GentleFileThemeSpecStore: GentleThemeSpecStore, Sendable {
    public enum StoreError: Error, Sendable {
        case applicationSupportUnavailable
    }

    public let fileName: String
    public let subdirectory: String?

    public init(fileName: String = "gentle_theme_spec.json",
                subdirectory: String? = "GentleDesignSystem") {
        self.fileName = fileName
        self.subdirectory = subdirectory
    }

    public func loadEditableSpec() throws -> GentleDesignSystemSpec? {
        let url = try fileURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try GentleDesignSystemSpec.fromJSONData(data)
    }

    public func saveEditableSpec(_ spec: GentleDesignSystemSpec) throws {
        let url = try fileURL()
        let data = try spec.encodedJSONData()
        try data.write(to: url, options: [.atomic])
    }

    public func clearEditableSpec() throws {
        let url = try fileURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        try FileManager.default.removeItem(at: url)
    }

    // MARK: - Per-Preset Storage

    public func loadEditableSpec(forPreset name: String) throws -> GentleDesignSystemSpec? {
        let url = try presetFileURL(for: name)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try GentleDesignSystemSpec.fromJSONData(data)
    }

    public func saveEditableSpec(_ spec: GentleDesignSystemSpec, forPreset name: String) throws {
        let url = try presetFileURL(for: name)
        let data = try spec.encodedJSONData()
        try data.write(to: url, options: [.atomic])
    }

    public func clearEditableSpec(forPreset name: String) throws {
        let url = try presetFileURL(for: name)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        try FileManager.default.removeItem(at: url)
    }

    public func hasEditableSpec(forPreset name: String) throws -> Bool {
        let url = try presetFileURL(for: name)
        return FileManager.default.fileExists(atPath: url.path)
    }

    // MARK: - Paths

    private func fileURL() throws -> URL {
        let dir = try baseDirectory()
        return dir.appendingPathComponent(fileName, isDirectory: false)
    }

    private func presetFileURL(for presetName: String) throws -> URL {
        let presetsDir = try presetsDirectory()
        let safeFileName = presetName
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "/", with: "_")
            .lowercased() + ".json"
        return presetsDir.appendingPathComponent(safeFileName, isDirectory: false)
    }

    private func baseDirectory() throws -> URL {
        let fm = FileManager.default
        guard let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw StoreError.applicationSupportUnavailable
        }

        let dir: URL
        if let subdirectory {
            dir = base.appendingPathComponent(subdirectory, isDirectory: true)
            if !fm.fileExists(atPath: dir.path) {
                try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            }
        } else {
            dir = base
        }
        return dir
    }

    private func presetsDirectory() throws -> URL {
        let fm = FileManager.default
        let dir = try baseDirectory().appendingPathComponent("presets", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
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
        if let savedSpec = try store.loadEditableSpec() {
            var t = theme
            t.editableSpec = savedSpec
            theme = t
        }
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
