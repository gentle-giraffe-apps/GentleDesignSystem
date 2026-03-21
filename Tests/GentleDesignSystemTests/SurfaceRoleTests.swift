//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - GentleSurfaceRole Property Tests

@Suite("GentleSurfaceRole Property Tests")
struct GentleSurfaceRolePropertyTests {

    @Test("All surface roles have display names")
    func testSurfaceRoleDisplayNames() {
        for role in GentleSurfaceRole.allCases {
            #expect(!role.displayName.isEmpty)
        }
    }

    @Test("Surface role display names are correct")
    func testSurfaceRoleDisplayNameValues() {
        #expect(GentleSurfaceRole.appBackground.displayName == "App Background")
        #expect(GentleSurfaceRole.card.displayName == "Card")
        #expect(GentleSurfaceRole.cardElevated.displayName == "Card Elevated")
        #expect(GentleSurfaceRole.cardSecondary.displayName == "Card Secondary")
        #expect(GentleSurfaceRole.chrome.displayName == "Chrome")
        #expect(GentleSurfaceRole.overlaySheet.displayName == "Overlay Sheet")
        #expect(GentleSurfaceRole.overlayPopover.displayName == "Overlay Popover")
        #expect(GentleSurfaceRole.overlayScrim.displayName == "Overlay Scrim")
        #expect(GentleSurfaceRole.floatingPanel.displayName == "Floating Panel")
        #expect(GentleSurfaceRole.floatingWidget.displayName == "Floating Widget")
    }

    @Test("All surface roles have subtitles")
    func testSurfaceRoleSubtitles() {
        for role in GentleSurfaceRole.allCases {
            #expect(!role.subtitle.isEmpty)
        }
    }

    @Test("Surface role subtitle values are correct")
    func testSurfaceRoleSubtitleValues() {
        #expect(GentleSurfaceRole.appBackground.subtitle == "Full-screen background")
        #expect(GentleSurfaceRole.card.subtitle == "Standard content card")
        #expect(GentleSurfaceRole.cardElevated.subtitle == "Elevated with shadow")
        #expect(GentleSurfaceRole.cardSecondary.subtitle == "Nested/secondary content")
        #expect(GentleSurfaceRole.chrome.subtitle == "Nav bars, toolbars")
        #expect(GentleSurfaceRole.overlaySheet.subtitle == "Modal sheets")
        #expect(GentleSurfaceRole.overlayPopover.subtitle == "Menus, popovers")
        #expect(GentleSurfaceRole.overlayScrim.subtitle == "Dark contrast band")
        #expect(GentleSurfaceRole.floatingPanel.subtitle == "Floating panels")
        #expect(GentleSurfaceRole.floatingWidget.subtitle == "Widget style")
    }

    @Test("Surface roles have correct categories")
    func testSurfaceRoleCategories() {
        #expect(GentleSurfaceRole.appBackground.category == .structure)
        #expect(GentleSurfaceRole.card.category == .structure)
        #expect(GentleSurfaceRole.cardElevated.category == .structure)
        #expect(GentleSurfaceRole.cardSecondary.category == .structure)
        #expect(GentleSurfaceRole.chrome.category == .chrome)
        #expect(GentleSurfaceRole.overlaySheet.category == .overlay)
        #expect(GentleSurfaceRole.overlayPopover.category == .overlay)
        #expect(GentleSurfaceRole.overlayScrim.category == .overlay)
        #expect(GentleSurfaceRole.floatingPanel.category == .floating)
        #expect(GentleSurfaceRole.floatingWidget.category == .floating)
    }

    @Test("SurfaceCategory has all cases")
    func testSurfaceCategoryAllCases() {
        let categories = GentleSurfaceRole.SurfaceCategory.allCases
        #expect(categories.count == 4)
        #expect(categories.contains(.structure))
        #expect(categories.contains(.chrome))
        #expect(categories.contains(.overlay))
        #expect(categories.contains(.floating))
    }

    @Test("SurfaceCategory raw values")
    func testSurfaceCategoryRawValues() {
        #expect(GentleSurfaceRole.SurfaceCategory.structure.rawValue == "Structure")
        #expect(GentleSurfaceRole.SurfaceCategory.chrome.rawValue == "Chrome")
        #expect(GentleSurfaceRole.SurfaceCategory.overlay.rawValue == "Overlays")
        #expect(GentleSurfaceRole.SurfaceCategory.floating.rawValue == "Floating")
    }

    @Test("groupedByCategory returns all categories")
    func testGroupedByCategory() {
        let grouped = GentleSurfaceRole.groupedByCategory
        #expect(grouped.count == 4)

        // Verify structure category
        let structureGroup = grouped.first { $0.category == .structure }
        #expect(structureGroup != nil)
        #expect(structureGroup?.roles.count == 4)

        // Verify chrome category
        let chromeGroup = grouped.first { $0.category == .chrome }
        #expect(chromeGroup != nil)
        #expect(chromeGroup?.roles.count == 1)

        // Verify overlay category
        let overlayGroup = grouped.first { $0.category == .overlay }
        #expect(overlayGroup != nil)
        #expect(overlayGroup?.roles.count == 3)

        // Verify floating category
        let floatingGroup = grouped.first { $0.category == .floating }
        #expect(floatingGroup != nil)
        #expect(floatingGroup?.roles.count == 2)
    }

    @Test("groupedByCategory contains all roles")
    func testGroupedByCategoryContainsAllRoles() {
        let grouped = GentleSurfaceRole.groupedByCategory
        let allRolesInGroups = grouped.flatMap { $0.roles }
        #expect(allRolesInGroups.count == GentleSurfaceRole.allCases.count)
    }
}

// MARK: - GentleAppleMaterial Tests

@Suite("GentleAppleMaterial Tests")
struct GentleAppleMaterialTests {

    @Test("All apple materials have display names")
    func testAppleMaterialDisplayNames() {
        for material in GentleAppleMaterial.allCases {
            #expect(!material.displayName.isEmpty)
        }
    }

    @Test("Apple material display name values")
    func testAppleMaterialDisplayNameValues() {
        #expect(GentleAppleMaterial.noMaterial.displayName == "None")
        #expect(GentleAppleMaterial.ultraThin.displayName == "Ultra Thin")
        #expect(GentleAppleMaterial.thin.displayName == "Thin")
        #expect(GentleAppleMaterial.regular.displayName == "Regular")
        #expect(GentleAppleMaterial.thick.displayName == "Thick")
        #expect(GentleAppleMaterial.ultraThick.displayName == "Ultra Thick")
        #expect(GentleAppleMaterial.bar.displayName == "Bar")
    }

    @Test("Apple material id equals rawValue")
    func testAppleMaterialId() {
        for material in GentleAppleMaterial.allCases {
            #expect(material.id == material.rawValue)
        }
    }

    @Test("Apple material swiftUIMaterial returns correct values")
    func testAppleMaterialSwiftUIMaterial() {
        #expect(GentleAppleMaterial.noMaterial.swiftUIMaterial == nil)
        #expect(GentleAppleMaterial.ultraThin.swiftUIMaterial != nil)
        #expect(GentleAppleMaterial.thin.swiftUIMaterial != nil)
        #expect(GentleAppleMaterial.regular.swiftUIMaterial != nil)
        #expect(GentleAppleMaterial.thick.swiftUIMaterial != nil)
        #expect(GentleAppleMaterial.ultraThick.swiftUIMaterial != nil)
        #expect(GentleAppleMaterial.bar.swiftUIMaterial != nil)
    }

    @Test("Apple material is codable")
    func testAppleMaterialCodable() throws {
        for material in GentleAppleMaterial.allCases {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()

            let data = try encoder.encode(material)
            let decoded = try decoder.decode(GentleAppleMaterial.self, from: data)

            #expect(decoded == material)
        }
    }
}

// MARK: - GentleSurfaceBackgroundStyle Tests

@Suite("GentleSurfaceBackgroundStyle Tests")
struct GentleSurfaceBackgroundStyleTests {

    @Test("solid style properties")
    func testSolidStyleProperties() {
        let style = GentleSurfaceBackgroundStyle.solid(colorRole: .surfaceBase)
        #expect(style.displayName == "Solid")
        #expect(style.isSolid == true)
        #expect(style.isGlass == false)
    }

    @Test("material style properties")
    func testMaterialStyleProperties() {
        let style = GentleSurfaceBackgroundStyle.material(
            material: .regular,
            tintColorRole: .surfaceTint,
            tintOpacity: 0.1
        )
        #expect(style.displayName == "Material")
        #expect(style.isSolid == false)
        #expect(style.isGlass == false)
    }

    @Test("glass style properties")
    func testGlassStyleProperties() {
        let style = GentleSurfaceBackgroundStyle.glass(
            fallbackMaterial: .regular,
            fallbackColorRole: .surfaceBase
        )
        #expect(style.displayName == "Glass")
        #expect(style.isSolid == false)
        #expect(style.isGlass == true)
    }

    @Test("solid style is codable")
    func testSolidStyleCodable() throws {
        let original = GentleSurfaceBackgroundStyle.solid(colorRole: .background)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSurfaceBackgroundStyle.self, from: data)

        #expect(decoded == original)
    }

    @Test("material style is codable")
    func testMaterialStyleCodable() throws {
        let original = GentleSurfaceBackgroundStyle.material(
            material: .thick,
            tintColorRole: .surfaceBase,
            tintOpacity: 0.2
        )
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSurfaceBackgroundStyle.self, from: data)

        #expect(decoded == original)
    }

    @Test("material style with nil tint is codable")
    func testMaterialStyleNilTintCodable() throws {
        let original = GentleSurfaceBackgroundStyle.material(
            material: .ultraThin,
            tintColorRole: nil,
            tintOpacity: 0
        )
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSurfaceBackgroundStyle.self, from: data)

        if case .material(let mat, let tint, _) = decoded {
            #expect(mat == .ultraThin)
            #expect(tint == nil)
        } else {
            Issue.record("Expected material style")
        }
    }

    @Test("glass style is codable")
    func testGlassStyleCodable() throws {
        let original = GentleSurfaceBackgroundStyle.glass(
            fallbackMaterial: .regular,
            fallbackColorRole: .surfaceBase
        )
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSurfaceBackgroundStyle.self, from: data)

        #expect(decoded == original)
    }

    @Test("glass style with nil fallback material is codable")
    func testGlassStyleNilFallbackCodable() throws {
        let original = GentleSurfaceBackgroundStyle.glass(
            fallbackMaterial: nil,
            fallbackColorRole: .background
        )
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSurfaceBackgroundStyle.self, from: data)

        if case .glass(let fallbackMat, let fallbackColor) = decoded {
            #expect(fallbackMat == nil)
            #expect(fallbackColor == .background)
        } else {
            Issue.record("Expected glass style")
        }
    }

    @Test("background style equatable")
    func testBackgroundStyleEquatable() {
        let solid1 = GentleSurfaceBackgroundStyle.solid(colorRole: .surfaceBase)
        let solid2 = GentleSurfaceBackgroundStyle.solid(colorRole: .surfaceBase)
        let solid3 = GentleSurfaceBackgroundStyle.solid(colorRole: .background)
        let material = GentleSurfaceBackgroundStyle.material(
            material: .regular,
            tintColorRole: nil,
            tintOpacity: 0
        )

        #expect(solid1 == solid2)
        #expect(solid1 != solid3)
        #expect(solid1 != material)
    }
}

// MARK: - GentleSurfaceRoleSpec Legacy Decoding Tests

@Suite("GentleSurfaceRoleSpec Legacy Decoding Tests")
struct GentleSurfaceRoleSpecLegacyDecodingTests {

    @Test("Decodes legacy visualEffect to solid background")
    func testDecodesLegacyVisualEffect() throws {
        let json = """
        {
            "visualEffect": "appBackground",
            "border": {"lightHex": "#FFFFFF", "darkHex": "#000000"}
        }
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(GentleSurfaceRoleSpec.self, from: data)

        if case .solid(let colorRole) = decoded.backgroundStyle {
            #expect(colorRole == .background)
        } else {
            Issue.record("Expected solid background style from legacy visualEffect")
        }
    }

    @Test("Decodes legacy visualEffect surface to surfaceBase")
    func testDecodesLegacyVisualEffectSurface() throws {
        let json = """
        {
            "visualEffect": "surface",
            "border": {"lightHex": "#FFFFFF", "darkHex": "#000000"}
        }
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(GentleSurfaceRoleSpec.self, from: data)

        if case .solid(let colorRole) = decoded.backgroundStyle {
            #expect(colorRole == .surfaceBase)
        } else {
            Issue.record("Expected solid background style from legacy visualEffect")
        }
    }

    @Test("Decodes legacy visualEffect surfaceOverlay to material")
    func testDecodesLegacyVisualEffectSurfaceOverlay() throws {
        let json = """
        {
            "visualEffect": "surfaceOverlay",
            "border": {"lightHex": "#FFFFFF", "darkHex": "#000000"}
        }
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(GentleSurfaceRoleSpec.self, from: data)

        if case .material(let mat, let tint, _) = decoded.backgroundStyle {
            #expect(mat == .regular)
            #expect(tint == .surfaceTint)
        } else {
            Issue.record("Expected material background style from legacy visualEffect")
        }
    }

    @Test("Decodes legacy flat properties with useGlass true")
    func testDecodesLegacyUseGlass() throws {
        let json = """
        {
            "colorRole": "surfaceBase",
            "appleMaterial": "regular",
            "useGlass": true,
            "border": {"lightHex": "#FFFFFF", "darkHex": "#000000"}
        }
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(GentleSurfaceRoleSpec.self, from: data)

        #expect(decoded.backgroundStyle.isGlass == true)
    }

    @Test("Decodes legacy flat properties with appleMaterial")
    func testDecodesLegacyAppleMaterial() throws {
        let json = """
        {
            "colorRole": "surfaceBase",
            "appleMaterial": "thick",
            "useGlass": false,
            "border": {"lightHex": "#FFFFFF", "darkHex": "#000000"}
        }
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(GentleSurfaceRoleSpec.self, from: data)

        if case .material(let mat, _, _) = decoded.backgroundStyle {
            #expect(mat == .thick)
        } else {
            Issue.record("Expected material background style")
        }
    }

    @Test("Decodes legacy flat properties with noMaterial as solid")
    func testDecodesLegacyNoMaterialAsSolid() throws {
        let json = """
        {
            "colorRole": "background",
            "appleMaterial": "noMaterial",
            "useGlass": false,
            "border": {"lightHex": "#FFFFFF", "darkHex": "#000000"}
        }
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(GentleSurfaceRoleSpec.self, from: data)

        if case .solid(let colorRole) = decoded.backgroundStyle {
            #expect(colorRole == .background)
        } else {
            Issue.record("Expected solid background style")
        }
    }

    @Test("Defaults to surfaceBase when no background specified")
    func testDefaultsToSurfaceBase() throws {
        let json = """
        {
            "border": {"lightHex": "#FFFFFF", "darkHex": "#000000"}
        }
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(GentleSurfaceRoleSpec.self, from: data)

        if case .solid(let colorRole) = decoded.backgroundStyle {
            #expect(colorRole == .surfaceBase)
        } else {
            Issue.record("Expected solid background style with surfaceBase default")
        }
    }
}

// MARK: - GentleVisualEffect Enum Tests

@Suite("GentleVisualEffect Enum Tests")
struct GentleVisualEffectEnumTests {

    @Test("GentleVisualEffect has correct display names")
    func testVisualEffectDisplayNames() {
        #expect(GentleVisualEffect.appBackground.displayName == "App Background")
        #expect(GentleVisualEffect.surface.displayName == "Surface")
        #expect(GentleVisualEffect.surfaceOverlay.displayName == "Surface Overlay")
    }

    @Test("GentleVisualEffect id equals rawValue")
    func testVisualEffectId() {
        for effect in GentleVisualEffect.allCases {
            #expect(effect.id == effect.rawValue)
        }
    }

    @Test("GentleVisualEffect is codable")
    func testVisualEffectCodable() throws {
        for effect in GentleVisualEffect.allCases {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()

            let data = try encoder.encode(effect)
            let decoded = try decoder.decode(GentleVisualEffect.self, from: data)

            #expect(decoded == effect)
        }
    }
}
