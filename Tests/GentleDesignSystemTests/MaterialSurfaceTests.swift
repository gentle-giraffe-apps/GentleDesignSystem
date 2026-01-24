//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - Helper for rendering views

@MainActor
private func renderViewForCoverage<V: View>(_ view: V) {
    let renderer = ImageRenderer(content: view)
    renderer.proposedSize = .init(width: 375, height: 667)
    _ = renderer.cgImage
}

// MARK: - GentleMaterialSurface Tests

@Suite("GentleMaterialSurface Extended Tests")
@MainActor
struct GentleMaterialSurfaceExtendedTests {

    // MARK: - Recipe and Struct Tests

    @Test("Recipe can be created with all parameters")
    func testRecipeCreation() {
        let recipe = GentleMaterialSurface.Recipe(
            lighting: .init(style: .softTop, intensity: 0.1),
            texture: .init(pattern: .noise, intensity: 0.2, scale: 1.0),
            secondaryTexture: .init(pattern: .weave, intensity: 0.1, scale: 0.5),
            depth: .init(innerHighlight: 0.05, ambientOcclusion: 0.08)
        )

        #expect(recipe.lighting.intensity == 0.1)
        #expect(recipe.texture.intensity == 0.2)
        #expect(recipe.secondaryTexture?.intensity == 0.1)
        #expect(recipe.depth.innerHighlight == 0.05)
    }

    @Test("Lighting styles can be created")
    func testLightingStyles() {
        let noLighting = GentleMaterialSurface.Lighting(style: .noLighting, intensity: 0)
        let softTop = GentleMaterialSurface.Lighting(style: .softTop, intensity: 0.15)
        let directional = GentleMaterialSurface.Lighting(style: .directional(angle: .degrees(45)), intensity: 0.2)

        #expect(noLighting.intensity == 0)
        #expect(softTop.intensity == 0.15)
        #expect(directional.intensity == 0.2)
    }

    @Test("Texture can be created with uniform scale")
    func testTextureUniformScale() {
        let texture = GentleMaterialSurface.Texture(
            pattern: .noise,
            intensity: 0.3,
            scale: 1.5,
            rotation: .degrees(30),
            blur: 0.5
        )

        #expect(texture.scaleX == 1.5)
        #expect(texture.scaleY == 1.5)
        #expect(texture.blur == 0.5)
    }

    @Test("Texture can be created with anisotropic scale")
    func testTextureAnisotropicScale() {
        let texture = GentleMaterialSurface.Texture(
            pattern: .brushed,
            intensity: 0.25,
            scaleX: 1.2,
            scaleY: 0.8,
            rotation: .degrees(15),
            blur: 0.3
        )

        #expect(texture.scaleX == 1.2)
        #expect(texture.scaleY == 0.8)
    }

    @Test("SecondaryTexture can be created with uniform scale")
    func testSecondaryTextureUniformScale() {
        let secondary = GentleMaterialSurface.SecondaryTexture(
            pattern: .weave,
            intensity: 0.1,
            scale: 0.8,
            rotation: .degrees(22),
            blur: 0.2
        )

        #expect(secondary.scaleX == 0.8)
        #expect(secondary.scaleY == 0.8)
    }

    @Test("SecondaryTexture can be created with anisotropic scale")
    func testSecondaryTextureAnisotropicScale() {
        let secondary = GentleMaterialSurface.SecondaryTexture(
            pattern: .noise,
            intensity: 0.08,
            scaleX: 1.0,
            scaleY: 0.85,
            rotation: .degrees(22),
            blur: 0.1
        )

        #expect(secondary.scaleX == 1.0)
        #expect(secondary.scaleY == 0.85)
    }

    @Test("Depth struct stores values correctly")
    func testDepthStruct() {
        let depth = GentleMaterialSurface.Depth(
            innerHighlight: 0.12,
            ambientOcclusion: 0.18
        )

        #expect(depth.innerHighlight == 0.12)
        #expect(depth.ambientOcclusion == 0.18)
    }

    // MARK: - View Body Evaluation Tests

    @Test("GentleMaterialSurface body evaluates with noLighting")
    func testSurfaceWithNoLighting() {
        let view = GentleMaterialSurface(
            baseColor: .blue,
            cornerRadius: 12,
            recipe: .init(
                lighting: .init(style: .noLighting, intensity: 0),
                texture: .init(pattern: .noise, intensity: 0.1, scale: 1.0),
                depth: .init(innerHighlight: 0, ambientOcclusion: 0)
            )
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with softTop lighting")
    func testSurfaceWithSoftTopLighting() {
        let view = GentleMaterialSurface(
            baseColor: .gray,
            cornerRadius: 16,
            recipe: .init(
                lighting: .init(style: .softTop, intensity: 0.15),
                texture: .init(pattern: .weave, intensity: 0.2, scale: 1.0),
                depth: .init(innerHighlight: 0.05, ambientOcclusion: 0.08)
            )
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with directional lighting")
    func testSurfaceWithDirectionalLighting() {
        let view = GentleMaterialSurface(
            baseColor: .white,
            cornerRadius: 20,
            recipe: .init(
                lighting: .init(style: .directional(angle: .degrees(45)), intensity: 0.2),
                texture: .init(pattern: .brushed, intensity: 0.15, scale: 1.0),
                depth: .init(innerHighlight: 0.08, ambientOcclusion: 0.1)
            )
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with secondary texture")
    func testSurfaceWithSecondaryTexture() {
        let view = GentleMaterialSurface(
            baseColor: Color(red: 0.96, green: 0.94, blue: 0.90),
            cornerRadius: 12,
            recipe: .init(
                lighting: .init(style: .softTop, intensity: 0.08),
                texture: .init(pattern: .noise, intensity: 0.22, scaleX: 1.40, scaleY: 1.15),
                secondaryTexture: .init(pattern: .noise, intensity: 0.08, scaleX: 1.00, scaleY: 0.85, rotation: .degrees(22)),
                depth: .init(innerHighlight: 0.05, ambientOcclusion: 0.10)
            )
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with noPattern texture")
    func testSurfaceWithNoPatternTexture() {
        let view = GentleMaterialSurface(
            baseColor: .red,
            cornerRadius: 8,
            recipe: .init(
                lighting: .init(style: .softTop, intensity: 0.1),
                texture: .init(pattern: .noPattern, intensity: 0, scale: 1.0),
                depth: .init(innerHighlight: 0.05, ambientOcclusion: 0.05)
            )
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with zero intensity texture")
    func testSurfaceWithZeroIntensityTexture() {
        let view = GentleMaterialSurface(
            baseColor: .green,
            cornerRadius: 10,
            recipe: .init(
                lighting: .init(style: .softTop, intensity: 0.1),
                texture: .init(pattern: .noise, intensity: 0, scale: 1.0),
                depth: .init(innerHighlight: 0, ambientOcclusion: 0)
            )
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with zero depth values")
    func testSurfaceWithZeroDepth() {
        let view = GentleMaterialSurface(
            baseColor: .orange,
            cornerRadius: 14,
            recipe: .init(
                lighting: .init(style: .softTop, intensity: 0.1),
                texture: .init(pattern: .noise, intensity: 0.2, scale: 1.0),
                depth: .init(innerHighlight: 0, ambientOcclusion: 0)
            )
        )
        renderViewForCoverage(view)
    }

    // MARK: - All Preset Tests

    @Test("GentleMaterialSurface body evaluates with cloth preset")
    func testSurfaceWithClothPreset() {
        let view = GentleMaterialSurface(
            baseColor: Color(red: 0.96, green: 0.94, blue: 0.90),
            cornerRadius: 12,
            recipe: .cloth
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with paper preset")
    func testSurfaceWithPaperPreset() {
        let view = GentleMaterialSurface(
            baseColor: Color(red: 0.97, green: 0.96, blue: 0.94),
            cornerRadius: 12,
            recipe: .paper
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with plastic preset")
    func testSurfaceWithPlasticPreset() {
        let view = GentleMaterialSurface(
            baseColor: Color(red: 0.95, green: 0.95, blue: 0.96),
            cornerRadius: 12,
            recipe: .plastic
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with silk preset")
    func testSurfaceWithSilkPreset() {
        let view = GentleMaterialSurface(
            baseColor: Color(red: 0.95, green: 0.90, blue: 0.92),
            cornerRadius: 12,
            recipe: .silk
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with aluminum preset")
    func testSurfaceWithAluminumPreset() {
        let view = GentleMaterialSurface(
            baseColor: Color(red: 0.85, green: 0.86, blue: 0.88),
            cornerRadius: 12,
            recipe: .aluminum
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with linen preset")
    func testSurfaceWithLinenPreset() {
        let view = GentleMaterialSurface(
            baseColor: Color(red: 0.94, green: 0.91, blue: 0.86),
            cornerRadius: 12,
            recipe: .linen
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with all boosted presets")
    func testSurfaceWithBoostedPresets() {
        let presets: [GentleMaterialSurface.Recipe] = [
            .clothBoosted, .paperBoosted, .plasticBoosted,
            .silkBoosted, .aluminumBoosted, .linenBoosted
        ]
        for preset in presets {
            let view = GentleMaterialSurface(
                baseColor: .gray,
                cornerRadius: 12,
                recipe: preset
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleMaterialSurface body evaluates with all max presets")
    func testSurfaceWithMaxPresets() {
        let presets: [GentleMaterialSurface.Recipe] = [
            .clothMax, .paperMax, .plasticMax,
            .silkMax, .aluminumMax, .linenMax
        ]
        for preset in presets {
            let view = GentleMaterialSurface(
                baseColor: .gray,
                cornerRadius: 12,
                recipe: preset
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleMaterialSurface body evaluates with all full presets")
    func testSurfaceWithFullPresets() {
        let presets: [GentleMaterialSurface.Recipe] = [
            .clothFull, .paperFull, .plasticFull,
            .silkFull, .aluminumFull, .linenFull
        ]
        for preset in presets {
            let view = GentleMaterialSurface(
                baseColor: .gray,
                cornerRadius: 12,
                recipe: preset
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleMaterialSurface body evaluates with texture rotation and blur")
    func testSurfaceWithTextureRotationAndBlur() {
        let view = GentleMaterialSurface(
            baseColor: .purple,
            cornerRadius: 16,
            recipe: .init(
                lighting: .init(style: .softTop, intensity: 0.1),
                texture: .init(pattern: .noise, intensity: 0.3, scale: 1.2, rotation: .degrees(45), blur: 1.0),
                depth: .init(innerHighlight: 0.05, ambientOcclusion: 0.08)
            )
        )
        renderViewForCoverage(view)
    }

    @Test("GentleMaterialSurface body evaluates with directional lighting at various angles")
    func testSurfaceWithDirectionalAngles() {
        let angles: [Angle] = [.degrees(0), .degrees(90), .degrees(180), .degrees(270), .degrees(-45)]
        for angle in angles {
            let view = GentleMaterialSurface(
                baseColor: .cyan,
                cornerRadius: 12,
                recipe: .init(
                    lighting: .init(style: .directional(angle: angle), intensity: 0.15),
                    texture: .init(pattern: .brushed, intensity: 0.2, scale: 1.0),
                    depth: .init(innerHighlight: 0.05, ambientOcclusion: 0.08)
                )
            )
            renderViewForCoverage(view)
        }
    }
}
