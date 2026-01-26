//  Jonathan Ritchey
import Foundation
import SwiftUI

public enum GentleSurfaceRole: String, Codable, Sendable {
    // Structure
    case appBackground
    case card
    case cardElevated
    case cardSecondary

    // Chrome (navigation elements)
    case chrome             // Nav bars, tab bars, toolbars - ultraThin material

    // Overlays
    case overlaySheet       // Modal sheets - regular material or glass
    case overlayPopover     // Menus, popovers, dropdowns - regular material

    // Floating
    case floatingPanel      // Picture-in-picture, floating panels - glass
    case floatingWidget     // Home screen widget style - glass
}

// MARK: - Apple Material

/// Apple's built-in blur materials for surface backgrounds.
public enum GentleAppleMaterial: String, Codable, Sendable, CaseIterable, Identifiable {
    case noMaterial
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick
    case bar

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .noMaterial: return "None"
        case .ultraThin: return "Ultra Thin"
        case .thin: return "Thin"
        case .regular: return "Regular"
        case .thick: return "Thick"
        case .ultraThick: return "Ultra Thick"
        case .bar: return "Bar"
        }
    }

    @available(iOS 15.0, *)
    public var swiftUIMaterial: Material? {
        switch self {
        case .noMaterial: return nil
        case .ultraThin: return .ultraThinMaterial
        case .thin: return .thinMaterial
        case .regular: return .regularMaterial
        case .thick: return .thickMaterial
        case .ultraThick: return .ultraThickMaterial
        case .bar: return .bar
        }
    }
}

// MARK: - Specular Effect

/// Specular highlight effect for surface depth cues.
public enum GentleSpecularEffect: String, Codable, Sendable, CaseIterable, Identifiable {
    case noEffect
    case indent      // Inset/pressed appearance
    case highlight   // Raised/lit appearance

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .noEffect: return "None"
        case .indent: return "Indent"
        case .highlight: return "Highlight"
        }
    }
}

// MARK: - Surface Background Style

/// Defines the background rendering style for a surface.
/// Mutually exclusive options that make the relationship between solid, material, and glass explicit.
public enum GentleSurfaceBackgroundStyle: Codable, Sendable, Equatable {
    /// Solid color background
    case solid(colorRole: GentleColorRole)

    /// Apple blur material with optional tint color
    /// - material: The Apple blur material to use
    /// - tintColorRole: Optional color to tint the material
    /// - tintOpacity: Opacity of the tint (0.0...1.0), typically ~0.1 to allow blur to show through
    case material(material: GentleAppleMaterial, tintColorRole: GentleColorRole?, tintOpacity: Double)

    /// iOS 26+ glass effect with fallback for older iOS versions
    case glass(fallbackMaterial: GentleAppleMaterial?, fallbackColorRole: GentleColorRole)

    // MARK: - Coding

    private enum CodingKeys: String, CodingKey {
        case type
        case colorRole
        case material
        case tintColorRole
        case tintOpacity
        case fallbackMaterial
        case fallbackColorRole
    }

    private enum StyleType: String, Codable {
        case solid
        case material
        case glass
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(StyleType.self, forKey: .type)

        switch type {
        case .solid:
            let colorRole = try container.decode(GentleColorRole.self, forKey: .colorRole)
            self = .solid(colorRole: colorRole)

        case .material:
            let material = try container.decode(GentleAppleMaterial.self, forKey: .material)
            let tintColorRole = try container.decodeIfPresent(GentleColorRole.self, forKey: .tintColorRole)
            let tintOpacity = try container.decodeIfPresent(Double.self, forKey: .tintOpacity) ?? 0.1
            self = .material(material: material, tintColorRole: tintColorRole, tintOpacity: tintOpacity)

        case .glass:
            let fallbackMaterial = try container.decodeIfPresent(GentleAppleMaterial.self, forKey: .fallbackMaterial)
            let fallbackColorRole = try container.decode(GentleColorRole.self, forKey: .fallbackColorRole)
            self = .glass(fallbackMaterial: fallbackMaterial, fallbackColorRole: fallbackColorRole)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .solid(let colorRole):
            try container.encode(StyleType.solid, forKey: .type)
            try container.encode(colorRole, forKey: .colorRole)

        case .material(let material, let tintColorRole, let tintOpacity):
            try container.encode(StyleType.material, forKey: .type)
            try container.encode(material, forKey: .material)
            try container.encodeIfPresent(tintColorRole, forKey: .tintColorRole)
            try container.encode(tintOpacity, forKey: .tintOpacity)

        case .glass(let fallbackMaterial, let fallbackColorRole):
            try container.encode(StyleType.glass, forKey: .type)
            try container.encodeIfPresent(fallbackMaterial, forKey: .fallbackMaterial)
            try container.encode(fallbackColorRole, forKey: .fallbackColorRole)
        }
    }

    // MARK: - Convenience

    public var displayName: String {
        switch self {
        case .solid: return "Solid"
        case .material: return "Material"
        case .glass: return "Glass"
        }
    }

    /// Returns true if this style uses iOS 26+ glass effect
    public var isGlass: Bool {
        if case .glass = self { return true }
        return false
    }
}

// MARK: - Surface specs

/// Defines the visual appearance of a surface role.
public struct GentleSurfaceRoleSpec: Codable, Sendable, Equatable {
    /// Background rendering style (solid, material, or glass)
    public var backgroundStyle: GentleSurfaceBackgroundStyle

    /// Specular highlights for depth cues
    public var specularEffect: GentleSpecularEffect

    /// Specular strength (0.0...1.0)
    public var specularStrength: Double

    /// Border color
    public var border: GentleColorPair

    /// Corner radius
    public var cornerRadius: Double

    /// Border width
    public var borderWidth: Double

    /// Shadow radius
    public var shadowRadius: Double

    /// Shadow opacity
    public var shadowOpacity: Double

    /// Shadow X offset
    public var shadowOffsetX: Double

    /// Shadow Y offset
    public var shadowOffsetY: Double

    public init(
        backgroundStyle: GentleSurfaceBackgroundStyle,
        specularEffect: GentleSpecularEffect = .noEffect,
        specularStrength: Double = 0,
        border: GentleColorPair,
        cornerRadius: Double = 20,
        borderWidth: Double = 1,
        shadowRadius: Double = 0,
        shadowOpacity: Double = 0,
        shadowOffsetX: Double = 0,
        shadowOffsetY: Double = 0
    ) {
        self.backgroundStyle = backgroundStyle
        self.specularEffect = specularEffect
        self.specularStrength = specularStrength
        self.border = border
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffsetX = shadowOffsetX
        self.shadowOffsetY = shadowOffsetY
    }

    enum CodingKeys: String, CodingKey {
        case backgroundStyle
        case specularEffect
        case specularStrength
        case border
        case cornerRadius
        case borderWidth
        case shadowRadius
        case shadowOpacity
        case shadowOffsetX
        case shadowOffsetY
        // Legacy keys for migration
        case visualEffect
        case colorRole
        case appleMaterial
        case useGlass
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Try to decode new backgroundStyle first
        if let backgroundStyle = try? container.decode(GentleSurfaceBackgroundStyle.self, forKey: .backgroundStyle) {
            self.backgroundStyle = backgroundStyle
        }
        // Migration: if old "visualEffect" key exists, convert to new backgroundStyle
        else if let visualEffect = try? container.decode(GentleVisualEffect.self, forKey: .visualEffect) {
            switch visualEffect {
            case .appBackground:
                self.backgroundStyle = .solid(colorRole: .background)
            case .surface:
                self.backgroundStyle = .solid(colorRole: .surfaceBase)
            case .surfaceOverlay:
                self.backgroundStyle = .material(material: .regular, tintColorRole: .surfaceOverlay, tintOpacity: 0.1)
            }
        }
        // Migration: if old flat properties exist (colorRole, appleMaterial, useGlass)
        else if container.contains(.colorRole) || container.contains(.appleMaterial) || container.contains(.useGlass) {
            let colorRole = try container.decodeIfPresent(GentleColorRole.self, forKey: .colorRole) ?? .surfaceBase
            let appleMaterial = try container.decodeIfPresent(GentleAppleMaterial.self, forKey: .appleMaterial) ?? .noMaterial
            let useGlass = try container.decodeIfPresent(Bool.self, forKey: .useGlass) ?? false

            if useGlass {
                let fallbackMaterial: GentleAppleMaterial? = appleMaterial != .noMaterial ? appleMaterial : nil
                self.backgroundStyle = .glass(fallbackMaterial: fallbackMaterial, fallbackColorRole: colorRole)
            } else if appleMaterial != .noMaterial {
                self.backgroundStyle = .material(material: appleMaterial, tintColorRole: colorRole, tintOpacity: 0.1)
            } else {
                self.backgroundStyle = .solid(colorRole: colorRole)
            }
        }
        // Default fallback
        else {
            self.backgroundStyle = .solid(colorRole: .surfaceBase)
        }

        self.specularEffect = try container.decodeIfPresent(GentleSpecularEffect.self, forKey: .specularEffect) ?? .noEffect
        self.specularStrength = try container.decodeIfPresent(Double.self, forKey: .specularStrength) ?? 0
        self.border = try container.decode(GentleColorPair.self, forKey: .border)
        self.cornerRadius = try container.decodeIfPresent(Double.self, forKey: .cornerRadius) ?? 20
        self.borderWidth = try container.decodeIfPresent(Double.self, forKey: .borderWidth) ?? 1
        self.shadowRadius = try container.decodeIfPresent(Double.self, forKey: .shadowRadius) ?? 0
        self.shadowOpacity = try container.decodeIfPresent(Double.self, forKey: .shadowOpacity) ?? 0
        self.shadowOffsetX = try container.decodeIfPresent(Double.self, forKey: .shadowOffsetX) ?? 0
        self.shadowOffsetY = try container.decodeIfPresent(Double.self, forKey: .shadowOffsetY) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(backgroundStyle, forKey: .backgroundStyle)
        try container.encode(specularEffect, forKey: .specularEffect)
        try container.encode(specularStrength, forKey: .specularStrength)
        try container.encode(border, forKey: .border)
        try container.encode(cornerRadius, forKey: .cornerRadius)
        try container.encode(borderWidth, forKey: .borderWidth)
        try container.encode(shadowRadius, forKey: .shadowRadius)
        try container.encode(shadowOpacity, forKey: .shadowOpacity)
        try container.encode(shadowOffsetX, forKey: .shadowOffsetX)
        try container.encode(shadowOffsetY, forKey: .shadowOffsetY)
    }
}

public struct GentleSurfaceTokens: Codable, Sendable {
    /// Stored using String keys for JSON stability (role.rawValue).
    public var roles: [String: GentleSurfaceRoleSpec]

    public init(roles: [String: GentleSurfaceRoleSpec]) {
        self.roles = roles
    }

    public func roleSpec(for role: GentleSurfaceRole) -> GentleSurfaceRoleSpec {
        if let spec = roles[role.rawValue] { return spec }
        // Fallback to card if missing.
        if let card = roles[GentleSurfaceRole.card.rawValue] { return card }
        // Last-resort defaults (should never happen with gentleDefault).
        return .init(
            backgroundStyle: .solid(colorRole: .surfaceBase),
            border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151")
        )
    }
}

public extension GentleSurfaceTokens {
    static let gentleDefault: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151"),
                cornerRadius: 20,
                borderWidth: 1
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                specularEffect: .highlight,
                specularStrength: 0.1,
                border: GentleColorPair(lightHex: "#E5E7EB59", darkHex: "#37415159"),
                cornerRadius: 20,
                borderWidth: 0.5,
                shadowRadius: 8,
                shadowOpacity: 0.08,
                shadowOffsetY: 6
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceOverlay),
                specularEffect: .indent,
                specularStrength: 0.05,
                border: GentleColorPair(lightHex: "#E5E7EB40", darkHex: "#37415140"),
                cornerRadius: 12,
                borderWidth: 0.5
            ),

            // Chrome
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .material(material: .ultraThin, tintColorRole: nil, tintOpacity: 0),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),

            // Overlays
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceOverlay, tintOpacity: 0.1),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 32,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceBase, tintOpacity: 0.15),
                border: GentleColorPair(lightHex: "#E5E7EB30", darkHex: "#37415130"),
                cornerRadius: 14,
                borderWidth: 0.5,
                shadowRadius: 16,
                shadowOpacity: 0.15,
                shadowOffsetY: 8
            ),

            // Floating
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#FFFFFF20", darkHex: "#FFFFFF10"),
                cornerRadius: 20,
                borderWidth: 0.5,
                shadowRadius: 24,
                shadowOpacity: 0.2,
                shadowOffsetY: 12
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .thick, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 24,
                borderWidth: 0,
                shadowRadius: 8,
                shadowOpacity: 0.1,
                shadowOffsetY: 4
            )
        ]
    )
}
