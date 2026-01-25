//  Jonathan Ritchey
import Foundation
import SwiftUI

public enum GentleSurfaceRole: String, Codable, Sendable {
    case appBackground
    case card
    case cardElevated
    case surfaceOverlay
}

// MARK: - Surface Color Role

/// Restricted color roles for surface backgrounds.
/// Maps to GentleColorRole but limited to surface-appropriate colors.
public enum GentleSurfaceColorRole: String, Codable, Sendable, CaseIterable, Identifiable {
    case background
    case surface
    case surfaceOverlay

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .background: return "Background"
        case .surface: return "Surface"
        case .surfaceOverlay: return "Surface Overlay"
        }
    }

    /// Maps to the corresponding GentleColorRole
    public var colorRole: GentleColorRole {
        switch self {
        case .background: return .background
        case .surface: return .surface
        case .surfaceOverlay: return .surfaceOverlay
        }
    }
}

// MARK: - Apple Material

/// Apple's built-in blur materials for surface backgrounds.
public enum GentleAppleMaterial: String, Codable, Sendable, CaseIterable, Identifiable {
    case none
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick
    case bar

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .none: return "None"
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
        case .none: return nil
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
    case none
    case indent      // Inset/pressed appearance
    case highlight   // Raised/lit appearance

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .none: return "None"
        case .indent: return "Indent"
        case .highlight: return "Highlight"
        }
    }
}

// MARK: - Surface specs

/// Defines the visual appearance of a surface role.
public struct GentleSurfaceRoleSpec: Codable, Sendable, Equatable {
    /// Base color (restricted to surface-related roles for semantic clarity)
    public var colorRole: GentleSurfaceColorRole

    /// Apple's blur material
    public var appleMaterial: GentleAppleMaterial

    /// iOS 26+ glass effect (when true, specular options hidden in UI)
    public var useGlass: Bool

    /// Specular highlights (disabled when useGlass or thick material)
    public var specularEffect: GentleSpecularEffect

    /// Specular strength (0.0...1.0)
    public var specularStrength: Double

    // Existing properties
    public var border: GentleColorPair

    // Structure
    public var cornerRadius: Double
    public var borderWidth: Double

    // Shadow
    public var shadowRadius: Double
    public var shadowOpacity: Double
    public var shadowOffsetX: Double
    public var shadowOffsetY: Double

    public init(
        colorRole: GentleSurfaceColorRole = .surface,
        appleMaterial: GentleAppleMaterial = .none,
        useGlass: Bool = false,
        specularEffect: GentleSpecularEffect = .none,
        specularStrength: Double = 0,
        border: GentleColorPair,
        cornerRadius: Double = 20,
        borderWidth: Double = 1,
        shadowRadius: Double = 0,
        shadowOpacity: Double = 0,
        shadowOffsetX: Double = 0,
        shadowOffsetY: Double = 0
    ) {
        self.colorRole = colorRole
        self.appleMaterial = appleMaterial
        self.useGlass = useGlass
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
        case colorRole
        case appleMaterial
        case useGlass
        case specularEffect
        case specularStrength
        case border
        case cornerRadius
        case borderWidth
        case shadowRadius
        case shadowOpacity
        case shadowOffsetX
        case shadowOffsetY
        // Legacy key for migration
        case visualEffect
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Migration: if old "visualEffect" key exists, convert to new properties
        if let visualEffect = try? container.decode(GentleVisualEffect.self, forKey: .visualEffect) {
            switch visualEffect {
            case .appBackground:
                self.colorRole = .background
                self.appleMaterial = .none
            case .surface:
                self.colorRole = .surface
                self.appleMaterial = .none
            case .surfaceOverlay:
                self.colorRole = .surfaceOverlay
                self.appleMaterial = .regular
            }
            self.useGlass = false
            self.specularEffect = .none
            self.specularStrength = 0
        } else {
            // Decode new properties normally
            self.colorRole = try container.decodeIfPresent(GentleSurfaceColorRole.self, forKey: .colorRole) ?? .surface
            self.appleMaterial = try container.decodeIfPresent(GentleAppleMaterial.self, forKey: .appleMaterial) ?? .none
            self.useGlass = try container.decodeIfPresent(Bool.self, forKey: .useGlass) ?? false
            self.specularEffect = try container.decodeIfPresent(GentleSpecularEffect.self, forKey: .specularEffect) ?? .none
            self.specularStrength = try container.decodeIfPresent(Double.self, forKey: .specularStrength) ?? 0
        }

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
        try container.encode(colorRole, forKey: .colorRole)
        try container.encode(appleMaterial, forKey: .appleMaterial)
        try container.encode(useGlass, forKey: .useGlass)
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
            colorRole: .surface,
            appleMaterial: .none,
            useGlass: false,
            specularEffect: .none,
            specularStrength: 0,
            border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151")
        )
    }
}

public extension GentleSurfaceTokens {
    static let gentleDefault: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                colorRole: .background,
                appleMaterial: .none,
                useGlass: false,
                specularEffect: .none,
                specularStrength: 0,
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0,
                shadowRadius: 0,
                shadowOpacity: 0,
                shadowOffsetX: 0,
                shadowOffsetY: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                colorRole: .surface,
                appleMaterial: .none,
                useGlass: false,
                specularEffect: .none,
                specularStrength: 0,
                border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151"),
                cornerRadius: 20,
                borderWidth: 1,
                shadowRadius: 0,
                shadowOpacity: 0,
                shadowOffsetX: 0,
                shadowOffsetY: 0
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                colorRole: .surface,
                appleMaterial: .none,
                useGlass: false,
                specularEffect: .highlight,
                specularStrength: 0.1,
                border: GentleColorPair(lightHex: "#E5E7EB59", darkHex: "#37415159"),
                cornerRadius: 20,
                borderWidth: 0.5,
                shadowRadius: 8,
                shadowOpacity: 0.08,
                shadowOffsetX: 0,
                shadowOffsetY: 6
            ),
            GentleSurfaceRole.surfaceOverlay.rawValue: .init(
                colorRole: .surfaceOverlay,
                appleMaterial: .regular,
                useGlass: false,
                specularEffect: .none,
                specularStrength: 0,
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0,
                shadowRadius: 0,
                shadowOpacity: 0,
                shadowOffsetX: 0,
                shadowOffsetY: 0
            )
        ]
    )
}
