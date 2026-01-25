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
    // Material role (resolved into a material recipe at runtime)
    public var materialRole: GentleDesignMaterialRole
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
        materialRole: GentleDesignMaterialRole,
        border: GentleColorPair,
        cornerRadius: Double = 20,
        borderWidth: Double = 1,
        shadowRadius: Double = 0,
        shadowOpacity: Double = 0,
        shadowOffsetX: Double = 0,
        shadowOffsetY: Double = 0
    ) {
        self.materialRole = materialRole
        self.border = border
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffsetX = shadowOffsetX
        self.shadowOffsetY = shadowOffsetY
    }

    enum CodingKeys: String, CodingKey {
        case materialRole
        case material // legacy payload (GentleDesignMaterial)
        case border
        case cornerRadius
        case borderWidth
        case shadowRadius
        case shadowOpacity
        case shadowOffsetX
        case shadowOffsetY
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let role = try container.decodeIfPresent(GentleDesignMaterialRole.self, forKey: .materialRole) {
            self.materialRole = role
        } else if let legacyMaterial = try container.decodeIfPresent(GentleDesignMaterial.self, forKey: .material) {
            if legacyMaterial.id == "card" || legacyMaterial.id == "cardElevated" {
                self.materialRole = .surface
            } else if legacyMaterial.id == "appBackground" {
                self.materialRole = .appBackground
            } else if legacyMaterial.id == "surfaceOverlay" {
                self.materialRole = .surfaceOverlay
            } else {
                self.materialRole = .surface
            }
        } else {
            self.materialRole = .surface
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
        try container.encode(materialRole, forKey: .materialRole)
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
            materialRole: .surface,
            border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151")
        )
    }
}

public extension GentleSurfaceTokens {
    static let gentleDefault: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                materialRole: .appBackground,
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0,
                shadowRadius: 0,
                shadowOpacity: 0,
                shadowOffsetX: 0,
                shadowOffsetY: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                materialRole: .surface,
                border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151"),
                cornerRadius: 20,
                borderWidth: 1,
                shadowRadius: 0,
                shadowOpacity: 0,
                shadowOffsetX: 0,
                shadowOffsetY: 0
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                materialRole: .surface,
                border: GentleColorPair(lightHex: "#E5E7EB59", darkHex: "#37415159"),
                cornerRadius: 20,
                borderWidth: 0.5,
                shadowRadius: 8,
                shadowOpacity: 0.08,
                shadowOffsetX: 0,
                shadowOffsetY: 6
            ),
            GentleSurfaceRole.surfaceOverlay.rawValue: .init(
                materialRole: .surfaceOverlay,
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
