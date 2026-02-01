//  Jonathan Ritchey
import Foundation

/// Represents the high-level type of a surface background style.
/// Used for UI picker selection and style type conversion.
public enum BackgroundStyleType: String, CaseIterable, Sendable {
    case solid
    case material
    case glass
}

/// Pure functions for converting between `GentleSurfaceBackgroundStyle` variants.
/// Extracted from UI binding logic to enable unit testing.
public enum BackgroundStyleConverter {

    // MARK: - Type Detection

    /// Returns the high-level type of a background style.
    public static func styleType(of style: GentleSurfaceBackgroundStyle) -> BackgroundStyleType {
        switch style {
        case .solid: return .solid
        case .material: return .material
        case .glass: return .glass
        }
    }

    // MARK: - Color Role Extraction

    /// Extracts the primary color role from any background style.
    /// For solid: returns the color role directly.
    /// For material: returns the tint color role (or .surfaceBase if nil).
    /// For glass: returns the fallback color role.
    public static func extractColorRole(from style: GentleSurfaceBackgroundStyle) -> GentleColorRole {
        switch style {
        case .solid(let colorRole):
            return colorRole
        case .material(_, let tintColorRole, _):
            return tintColorRole ?? .surfaceBase
        case .glass(_, let fallbackColorRole):
            return fallbackColorRole
        }
    }

    /// Extracts the material from a style, returning a default if not applicable.
    public static func extractMaterial(from style: GentleSurfaceBackgroundStyle, default defaultMaterial: GentleAppleMaterial = .regular) -> GentleAppleMaterial {
        switch style {
        case .solid:
            return defaultMaterial
        case .material(let material, _, _):
            return material
        case .glass(let fallbackMaterial, _):
            return fallbackMaterial ?? defaultMaterial
        }
    }

    // MARK: - Style Conversion

    /// Converts any background style to a solid style, preserving the color role.
    public static func toSolidStyle(from style: GentleSurfaceBackgroundStyle) -> GentleSurfaceBackgroundStyle {
        let colorRole = extractColorRole(from: style)
        return .solid(colorRole: colorRole)
    }

    /// Converts any background style to a material style, preserving relevant values.
    public static func toMaterialStyle(from style: GentleSurfaceBackgroundStyle) -> GentleSurfaceBackgroundStyle {
        switch style {
        case .solid(let colorRole):
            return .material(material: .regular, tintColorRole: colorRole, tintOpacity: 0.1)

        case .material(let material, let tintColorRole, let tintOpacity):
            // Already material, return as-is
            return .material(material: material, tintColorRole: tintColorRole, tintOpacity: tintOpacity)

        case .glass(let fallbackMaterial, let fallbackColorRole):
            let material = fallbackMaterial ?? .regular
            return .material(material: material, tintColorRole: fallbackColorRole, tintOpacity: 0.1)
        }
    }

    /// Converts any background style to a glass style, preserving relevant values.
    public static func toGlassStyle(from style: GentleSurfaceBackgroundStyle) -> GentleSurfaceBackgroundStyle {
        switch style {
        case .solid(let colorRole):
            return .glass(fallbackMaterial: nil, fallbackColorRole: colorRole)

        case .material(let material, let tintColorRole, _):
            let colorRole = tintColorRole ?? .surfaceBase
            return .glass(fallbackMaterial: material, fallbackColorRole: colorRole)

        case .glass(let fallbackMaterial, let fallbackColorRole):
            // Already glass, return as-is
            return .glass(fallbackMaterial: fallbackMaterial, fallbackColorRole: fallbackColorRole)
        }
    }

    /// Converts a background style to the specified type.
    public static func convert(_ style: GentleSurfaceBackgroundStyle, to targetType: BackgroundStyleType) -> GentleSurfaceBackgroundStyle {
        switch targetType {
        case .solid:
            return toSolidStyle(from: style)
        case .material:
            return toMaterialStyle(from: style)
        case .glass:
            return toGlassStyle(from: style)
        }
    }

    // MARK: - Material Property Updates

    /// Updates the material in a material-style background, returning the original if not material.
    public static func updateMaterial(_ newMaterial: GentleAppleMaterial, in style: GentleSurfaceBackgroundStyle) -> GentleSurfaceBackgroundStyle {
        guard case .material(_, let tintColorRole, let tintOpacity) = style else {
            return style
        }
        return .material(material: newMaterial, tintColorRole: tintColorRole, tintOpacity: tintOpacity)
    }

    /// Updates the tint color role in a material-style background, returning the original if not material.
    public static func updateMaterialTint(_ newTintColorRole: GentleColorRole?, in style: GentleSurfaceBackgroundStyle) -> GentleSurfaceBackgroundStyle {
        guard case .material(let material, _, let tintOpacity) = style else {
            return style
        }
        return .material(material: material, tintColorRole: newTintColorRole, tintOpacity: tintOpacity)
    }

    /// Updates the tint opacity in a material-style background, returning the original if not material.
    public static func updateMaterialTintOpacity(_ newOpacity: Double, in style: GentleSurfaceBackgroundStyle) -> GentleSurfaceBackgroundStyle {
        guard case .material(let material, let tintColorRole, _) = style else {
            return style
        }
        return .material(material: material, tintColorRole: tintColorRole, tintOpacity: newOpacity)
    }

    // MARK: - Glass Property Updates

    /// Updates the fallback material in a glass-style background, returning the original if not glass.
    public static func updateGlassFallbackMaterial(_ newMaterial: GentleAppleMaterial?, in style: GentleSurfaceBackgroundStyle) -> GentleSurfaceBackgroundStyle {
        guard case .glass(_, let fallbackColorRole) = style else {
            return style
        }
        return .glass(fallbackMaterial: newMaterial, fallbackColorRole: fallbackColorRole)
    }

    /// Updates the fallback color role in a glass-style background, returning the original if not glass.
    public static func updateGlassFallbackColorRole(_ newColorRole: GentleColorRole, in style: GentleSurfaceBackgroundStyle) -> GentleSurfaceBackgroundStyle {
        guard case .glass(let fallbackMaterial, _) = style else {
            return style
        }
        return .glass(fallbackMaterial: fallbackMaterial, fallbackColorRole: newColorRole)
    }
}
