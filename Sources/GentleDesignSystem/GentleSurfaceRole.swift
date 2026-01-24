//  Jonathan Ritchey
import Foundation

public enum GentleSurfaceRole: String, Codable, Sendable {
    case appBackground
    case card
    case cardElevated
    case surfaceOverlay
}

// MARK: - Surface specs

/// Defines the visual appearance of a surface role.
public struct GentleSurfaceRoleSpec: Codable, Sendable, Equatable {
    // Material (replaces simple background color)
    public var material: GentleDesignMaterial
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
        material: GentleDesignMaterial,
        border: GentleColorPair,
        cornerRadius: Double = 20,
        borderWidth: Double = 1,
        shadowRadius: Double = 0,
        shadowOpacity: Double = 0,
        shadowOffsetX: Double = 0,
        shadowOffsetY: Double = 0
    ) {
        self.material = material
        self.border = border
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffsetX = shadowOffsetX
        self.shadowOffsetY = shadowOffsetY
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
            material: GentleDesignMaterial(
                id: "fallback",
                base: .solid(GentleColorPair(lightHex: "#FAFAFE", darkHex: "#111827"))
            ),
            border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151")
        )
    }
}

public extension GentleSurfaceTokens {
    static let gentleDefault: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                material: GentleDesignMaterial(
                    id: "appBackground",
                    base: .solid(GentleColorPair(lightHex: "#F3F4F6", darkHex: "#030712"))
                ),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0,
                shadowRadius: 0,
                shadowOpacity: 0,
                shadowOffsetX: 0,
                shadowOffsetY: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                material: GentleDesignMaterial(
                    id: "card",
                    base: .solid(GentleColorPair(lightHex: "#FAFAFE", darkHex: "#111827"))
                ),
                border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151"),
                cornerRadius: 20,
                borderWidth: 1,
                shadowRadius: 0,
                shadowOpacity: 0,
                shadowOffsetX: 0,
                shadowOffsetY: 0
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                material: GentleDesignMaterial(
                    id: "cardElevated",
                    base: .solid(GentleColorPair(lightHex: "#FAFAFE", darkHex: "#111827"))
                ),
                border: GentleColorPair(lightHex: "#E5E7EB59", darkHex: "#37415159"),
                cornerRadius: 20,
                borderWidth: 0.5,
                shadowRadius: 8,
                shadowOpacity: 0.08,
                shadowOffsetX: 0,
                shadowOffsetY: 6
            ),
            GentleSurfaceRole.surfaceOverlay.rawValue: .init(
                material: GentleDesignMaterial(
                    id: "surfaceOverlay",
                    base: .solid(GentleColorPair(lightHex: "#111827CC", darkHex: "#020617CC"))
                ),
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
