//  Jonathan Ritchey
import Testing
@testable import GentleDesignSystem

// MARK: - BackgroundStyleType Tests

@Suite("BackgroundStyleType Tests")
struct BackgroundStyleTypeTests {

    @Test("BackgroundStyleType has all cases")
    func testAllCases() {
        let cases = BackgroundStyleType.allCases
        #expect(cases.count == 3)
        #expect(cases.contains(.solid))
        #expect(cases.contains(.material))
        #expect(cases.contains(.glass))
    }

    @Test("BackgroundStyleType raw values are correct")
    func testRawValues() {
        #expect(BackgroundStyleType.solid.rawValue == "solid")
        #expect(BackgroundStyleType.material.rawValue == "material")
        #expect(BackgroundStyleType.glass.rawValue == "glass")
    }
}

// MARK: - Style Type Detection Tests

@Suite("BackgroundStyleConverter Style Type Detection Tests")
struct BackgroundStyleConverterTypeDetectionTests {

    @Test("styleType returns solid for solid style")
    func testStyleTypeSolid() {
        let style = GentleSurfaceBackgroundStyle.solid(colorRole: .surfaceBase)
        #expect(BackgroundStyleConverter.styleType(of: style) == .solid)
    }

    @Test("styleType returns material for material style")
    func testStyleTypeMaterial() {
        let style = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: .surfaceTint, tintOpacity: 0.1)
        #expect(BackgroundStyleConverter.styleType(of: style) == .material)
    }

    @Test("styleType returns glass for glass style")
    func testStyleTypeGlass() {
        let style = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .thin, fallbackColorRole: .surfaceBase)
        #expect(BackgroundStyleConverter.styleType(of: style) == .glass)
    }
}

// MARK: - Color Role Extraction Tests

@Suite("BackgroundStyleConverter Color Role Extraction Tests")
struct BackgroundStyleConverterExtractionTests {

    @Test("extractColorRole from solid style")
    func testExtractColorRoleFromSolid() {
        let style = GentleSurfaceBackgroundStyle.solid(colorRole: .primaryCTA)
        #expect(BackgroundStyleConverter.extractColorRole(from: style) == .primaryCTA)
    }

    @Test("extractColorRole from material style with tint")
    func testExtractColorRoleFromMaterialWithTint() {
        let style = GentleSurfaceBackgroundStyle.material(material: .thick, tintColorRole: .surfaceTint, tintOpacity: 0.2)
        #expect(BackgroundStyleConverter.extractColorRole(from: style) == .surfaceTint)
    }

    @Test("extractColorRole from material style without tint returns surfaceBase")
    func testExtractColorRoleFromMaterialWithoutTint() {
        let style = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: nil, tintOpacity: 0.1)
        #expect(BackgroundStyleConverter.extractColorRole(from: style) == .surfaceBase)
    }

    @Test("extractColorRole from glass style")
    func testExtractColorRoleFromGlass() {
        let style = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .thin, fallbackColorRole: .textPrimary)
        #expect(BackgroundStyleConverter.extractColorRole(from: style) == .textPrimary)
    }

    @Test("extractMaterial from solid returns default")
    func testExtractMaterialFromSolid() {
        let style = GentleSurfaceBackgroundStyle.solid(colorRole: .surfaceBase)
        #expect(BackgroundStyleConverter.extractMaterial(from: style) == .regular)
        #expect(BackgroundStyleConverter.extractMaterial(from: style, default: .thick) == .thick)
    }

    @Test("extractMaterial from material style")
    func testExtractMaterialFromMaterial() {
        let style = GentleSurfaceBackgroundStyle.material(material: .ultraThick, tintColorRole: nil, tintOpacity: 0.1)
        #expect(BackgroundStyleConverter.extractMaterial(from: style) == .ultraThick)
    }

    @Test("extractMaterial from glass with fallback material")
    func testExtractMaterialFromGlassWithFallback() {
        let style = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .thin, fallbackColorRole: .surfaceBase)
        #expect(BackgroundStyleConverter.extractMaterial(from: style) == .thin)
    }

    @Test("extractMaterial from glass without fallback material returns default")
    func testExtractMaterialFromGlassWithoutFallback() {
        let style = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: nil, fallbackColorRole: .surfaceBase)
        #expect(BackgroundStyleConverter.extractMaterial(from: style) == .regular)
    }
}

// MARK: - Style Conversion Tests

@Suite("BackgroundStyleConverter Conversion Tests")
struct BackgroundStyleConverterConversionTests {

    // MARK: - To Solid

    @Test("toSolidStyle from solid preserves color role")
    func testToSolidFromSolid() {
        let original = GentleSurfaceBackgroundStyle.solid(colorRole: .primaryCTA)
        let converted = BackgroundStyleConverter.toSolidStyle(from: original)

        if case .solid(let colorRole) = converted {
            #expect(colorRole == .primaryCTA)
        } else {
            Issue.record("Expected solid style")
        }
    }

    @Test("toSolidStyle from material extracts tint color role")
    func testToSolidFromMaterial() {
        let original = GentleSurfaceBackgroundStyle.material(material: .thick, tintColorRole: .surfaceTint, tintOpacity: 0.3)
        let converted = BackgroundStyleConverter.toSolidStyle(from: original)

        if case .solid(let colorRole) = converted {
            #expect(colorRole == .surfaceTint)
        } else {
            Issue.record("Expected solid style")
        }
    }

    @Test("toSolidStyle from material with nil tint uses surfaceBase")
    func testToSolidFromMaterialNilTint() {
        let original = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: nil, tintOpacity: 0.1)
        let converted = BackgroundStyleConverter.toSolidStyle(from: original)

        if case .solid(let colorRole) = converted {
            #expect(colorRole == .surfaceBase)
        } else {
            Issue.record("Expected solid style")
        }
    }

    @Test("toSolidStyle from glass extracts fallback color role")
    func testToSolidFromGlass() {
        let original = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .thin, fallbackColorRole: .textSecondary)
        let converted = BackgroundStyleConverter.toSolidStyle(from: original)

        if case .solid(let colorRole) = converted {
            #expect(colorRole == .textSecondary)
        } else {
            Issue.record("Expected solid style")
        }
    }

    // MARK: - To Material

    @Test("toMaterialStyle from solid uses defaults")
    func testToMaterialFromSolid() {
        let original = GentleSurfaceBackgroundStyle.solid(colorRole: .primaryCTA)
        let converted = BackgroundStyleConverter.toMaterialStyle(from: original)

        if case .material(let material, let tintColorRole, let tintOpacity) = converted {
            #expect(material == .regular)
            #expect(tintColorRole == .primaryCTA)
            #expect(tintOpacity == 0.1)
        } else {
            Issue.record("Expected material style")
        }
    }

    @Test("toMaterialStyle from material preserves all values")
    func testToMaterialFromMaterial() {
        let original = GentleSurfaceBackgroundStyle.material(material: .ultraThick, tintColorRole: .surfaceTint, tintOpacity: 0.5)
        let converted = BackgroundStyleConverter.toMaterialStyle(from: original)

        if case .material(let material, let tintColorRole, let tintOpacity) = converted {
            #expect(material == .ultraThick)
            #expect(tintColorRole == .surfaceTint)
            #expect(tintOpacity == 0.5)
        } else {
            Issue.record("Expected material style")
        }
    }

    @Test("toMaterialStyle from glass extracts fallback values")
    func testToMaterialFromGlass() {
        let original = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .thick, fallbackColorRole: .background)
        let converted = BackgroundStyleConverter.toMaterialStyle(from: original)

        if case .material(let material, let tintColorRole, let tintOpacity) = converted {
            #expect(material == .thick)
            #expect(tintColorRole == .background)
            #expect(tintOpacity == 0.1)
        } else {
            Issue.record("Expected material style")
        }
    }

    @Test("toMaterialStyle from glass with nil material uses regular")
    func testToMaterialFromGlassNilMaterial() {
        let original = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: nil, fallbackColorRole: .surfaceBase)
        let converted = BackgroundStyleConverter.toMaterialStyle(from: original)

        if case .material(let material, _, _) = converted {
            #expect(material == .regular)
        } else {
            Issue.record("Expected material style")
        }
    }

    // MARK: - To Glass

    @Test("toGlassStyle from solid uses nil fallback material")
    func testToGlassFromSolid() {
        let original = GentleSurfaceBackgroundStyle.solid(colorRole: .primaryCTA)
        let converted = BackgroundStyleConverter.toGlassStyle(from: original)

        if case .glass(let fallbackMaterial, let fallbackColorRole) = converted {
            #expect(fallbackMaterial == nil)
            #expect(fallbackColorRole == .primaryCTA)
        } else {
            Issue.record("Expected glass style")
        }
    }

    @Test("toGlassStyle from material extracts material and tint")
    func testToGlassFromMaterial() {
        let original = GentleSurfaceBackgroundStyle.material(material: .thin, tintColorRole: .surfaceTint, tintOpacity: 0.2)
        let converted = BackgroundStyleConverter.toGlassStyle(from: original)

        if case .glass(let fallbackMaterial, let fallbackColorRole) = converted {
            #expect(fallbackMaterial == .thin)
            #expect(fallbackColorRole == .surfaceTint)
        } else {
            Issue.record("Expected glass style")
        }
    }

    @Test("toGlassStyle from material with nil tint uses surfaceBase")
    func testToGlassFromMaterialNilTint() {
        let original = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: nil, tintOpacity: 0.1)
        let converted = BackgroundStyleConverter.toGlassStyle(from: original)

        if case .glass(_, let fallbackColorRole) = converted {
            #expect(fallbackColorRole == .surfaceBase)
        } else {
            Issue.record("Expected glass style")
        }
    }

    @Test("toGlassStyle from glass preserves all values")
    func testToGlassFromGlass() {
        let original = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .ultraThin, fallbackColorRole: .textPrimary)
        let converted = BackgroundStyleConverter.toGlassStyle(from: original)

        if case .glass(let fallbackMaterial, let fallbackColorRole) = converted {
            #expect(fallbackMaterial == .ultraThin)
            #expect(fallbackColorRole == .textPrimary)
        } else {
            Issue.record("Expected glass style")
        }
    }

    // MARK: - Generic Convert

    @Test("convert dispatches to correct conversion function")
    func testConvertDispatch() {
        let solid = GentleSurfaceBackgroundStyle.solid(colorRole: .primaryCTA)

        let toSolid = BackgroundStyleConverter.convert(solid, to: .solid)
        let toMaterial = BackgroundStyleConverter.convert(solid, to: .material)
        let toGlass = BackgroundStyleConverter.convert(solid, to: .glass)

        #expect(BackgroundStyleConverter.styleType(of: toSolid) == .solid)
        #expect(BackgroundStyleConverter.styleType(of: toMaterial) == .material)
        #expect(BackgroundStyleConverter.styleType(of: toGlass) == .glass)
    }
}

// MARK: - Material Property Update Tests

@Suite("BackgroundStyleConverter Material Update Tests")
struct BackgroundStyleConverterMaterialUpdateTests {

    @Test("updateMaterial changes material in material style")
    func testUpdateMaterial() {
        let original = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: .surfaceTint, tintOpacity: 0.2)
        let updated = BackgroundStyleConverter.updateMaterial(.ultraThick, in: original)

        if case .material(let material, let tintColorRole, let tintOpacity) = updated {
            #expect(material == .ultraThick)
            #expect(tintColorRole == .surfaceTint)
            #expect(tintOpacity == 0.2)
        } else {
            Issue.record("Expected material style")
        }
    }

    @Test("updateMaterial returns original for non-material style")
    func testUpdateMaterialNonMaterial() {
        let solid = GentleSurfaceBackgroundStyle.solid(colorRole: .surfaceBase)
        let updated = BackgroundStyleConverter.updateMaterial(.thick, in: solid)

        if case .solid(let colorRole) = updated {
            #expect(colorRole == .surfaceBase)
        } else {
            Issue.record("Expected solid style unchanged")
        }
    }

    @Test("updateMaterialTint changes tint color role")
    func testUpdateMaterialTint() {
        let original = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: .surfaceBase, tintOpacity: 0.1)
        let updated = BackgroundStyleConverter.updateMaterialTint(.primaryCTA, in: original)

        if case .material(_, let tintColorRole, _) = updated {
            #expect(tintColorRole == .primaryCTA)
        } else {
            Issue.record("Expected material style")
        }
    }

    @Test("updateMaterialTint can set nil")
    func testUpdateMaterialTintToNil() {
        let original = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: .surfaceTint, tintOpacity: 0.1)
        let updated = BackgroundStyleConverter.updateMaterialTint(nil, in: original)

        if case .material(_, let tintColorRole, _) = updated {
            #expect(tintColorRole == nil)
        } else {
            Issue.record("Expected material style")
        }
    }

    @Test("updateMaterialTintOpacity changes opacity")
    func testUpdateMaterialTintOpacity() {
        let original = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: .surfaceTint, tintOpacity: 0.1)
        let updated = BackgroundStyleConverter.updateMaterialTintOpacity(0.8, in: original)

        if case .material(_, _, let tintOpacity) = updated {
            #expect(tintOpacity == 0.8)
        } else {
            Issue.record("Expected material style")
        }
    }

    @Test("updateMaterialTintOpacity returns original for non-material")
    func testUpdateMaterialTintOpacityNonMaterial() {
        let glass = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .thin, fallbackColorRole: .surfaceBase)
        let updated = BackgroundStyleConverter.updateMaterialTintOpacity(0.5, in: glass)

        if case .glass = updated {
            // Expected - unchanged
        } else {
            Issue.record("Expected glass style unchanged")
        }
    }
}

// MARK: - Glass Property Update Tests

@Suite("BackgroundStyleConverter Glass Update Tests")
struct BackgroundStyleConverterGlassUpdateTests {

    @Test("updateGlassFallbackMaterial changes fallback material")
    func testUpdateGlassFallbackMaterial() {
        let original = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase)
        let updated = BackgroundStyleConverter.updateGlassFallbackMaterial(.ultraThin, in: original)

        if case .glass(let fallbackMaterial, let fallbackColorRole) = updated {
            #expect(fallbackMaterial == .ultraThin)
            #expect(fallbackColorRole == .surfaceBase)
        } else {
            Issue.record("Expected glass style")
        }
    }

    @Test("updateGlassFallbackMaterial can set nil")
    func testUpdateGlassFallbackMaterialToNil() {
        let original = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .thick, fallbackColorRole: .surfaceBase)
        let updated = BackgroundStyleConverter.updateGlassFallbackMaterial(nil, in: original)

        if case .glass(let fallbackMaterial, _) = updated {
            #expect(fallbackMaterial == nil)
        } else {
            Issue.record("Expected glass style")
        }
    }

    @Test("updateGlassFallbackMaterial returns original for non-glass")
    func testUpdateGlassFallbackMaterialNonGlass() {
        let material = GentleSurfaceBackgroundStyle.material(material: .regular, tintColorRole: nil, tintOpacity: 0.1)
        let updated = BackgroundStyleConverter.updateGlassFallbackMaterial(.thick, in: material)

        if case .material = updated {
            // Expected - unchanged
        } else {
            Issue.record("Expected material style unchanged")
        }
    }

    @Test("updateGlassFallbackColorRole changes color role")
    func testUpdateGlassFallbackColorRole() {
        let original = GentleSurfaceBackgroundStyle.glass(fallbackMaterial: .thin, fallbackColorRole: .surfaceBase)
        let updated = BackgroundStyleConverter.updateGlassFallbackColorRole(.primaryCTA, in: original)

        if case .glass(let fallbackMaterial, let fallbackColorRole) = updated {
            #expect(fallbackMaterial == .thin)
            #expect(fallbackColorRole == .primaryCTA)
        } else {
            Issue.record("Expected glass style")
        }
    }

    @Test("updateGlassFallbackColorRole returns original for non-glass")
    func testUpdateGlassFallbackColorRoleNonGlass() {
        let solid = GentleSurfaceBackgroundStyle.solid(colorRole: .surfaceBase)
        let updated = BackgroundStyleConverter.updateGlassFallbackColorRole(.primaryCTA, in: solid)

        if case .solid(let colorRole) = updated {
            #expect(colorRole == .surfaceBase)
        } else {
            Issue.record("Expected solid style unchanged")
        }
    }
}

// MARK: - Round Trip Tests

@Suite("BackgroundStyleConverter Round Trip Tests")
struct BackgroundStyleConverterRoundTripTests {

    @Test("Round trip solid -> material -> solid preserves color role")
    func testRoundTripSolidMaterialSolid() {
        let original = GentleSurfaceBackgroundStyle.solid(colorRole: .primaryCTA)
        let toMaterial = BackgroundStyleConverter.toMaterialStyle(from: original)
        let backToSolid = BackgroundStyleConverter.toSolidStyle(from: toMaterial)

        if case .solid(let colorRole) = backToSolid {
            #expect(colorRole == .primaryCTA)
        } else {
            Issue.record("Expected solid style")
        }
    }

    @Test("Round trip solid -> glass -> solid preserves color role")
    func testRoundTripSolidGlassSolid() {
        let original = GentleSurfaceBackgroundStyle.solid(colorRole: .textSecondary)
        let toGlass = BackgroundStyleConverter.toGlassStyle(from: original)
        let backToSolid = BackgroundStyleConverter.toSolidStyle(from: toGlass)

        if case .solid(let colorRole) = backToSolid {
            #expect(colorRole == .textSecondary)
        } else {
            Issue.record("Expected solid style")
        }
    }

    @Test("Round trip material -> glass -> material preserves material")
    func testRoundTripMaterialGlassMaterial() {
        let original = GentleSurfaceBackgroundStyle.material(material: .thick, tintColorRole: .surfaceTint, tintOpacity: 0.3)
        let toGlass = BackgroundStyleConverter.toGlassStyle(from: original)
        let backToMaterial = BackgroundStyleConverter.toMaterialStyle(from: toGlass)

        if case .material(let material, let tintColorRole, _) = backToMaterial {
            #expect(material == .thick)
            #expect(tintColorRole == .surfaceTint)
        } else {
            Issue.record("Expected material style")
        }
    }
}
