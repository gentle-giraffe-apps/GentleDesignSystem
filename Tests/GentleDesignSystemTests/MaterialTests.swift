//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - Test Error

enum MaterialTestError: Error {
    case invalidTestData(String)
}

// MARK: - GentleDesignMaterial Tests

@Suite("GentleDesignMaterial Tests")
struct GentleDesignMaterialTests {

    @Test("Material can be created with solid base")
    func testMaterialWithSolidBase() {
        let material = GentleDesignMaterial(
            id: "testSolid",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000"))
        )

        #expect(material.id == "testSolid")
        if case .solid(let colorPair) = material.base {
            #expect(colorPair.lightHex == "#FFFFFF")
            #expect(colorPair.darkHex == "#000000")
        } else {
            Issue.record("Expected solid base")
        }
    }

    @Test("Material can be created with all optional properties")
    func testMaterialWithAllProperties() {
        let material = GentleDesignMaterial(
            id: "testFull",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")),
            tint: GentleColorPair(lightHex: "#FF000010", darkHex: "#00FF0010"),
            specular: GentleSpecularSpec(rimStrokeOpacity: 0.2, rimStrokeWidth: 1.5),
            innerEdges: GentleInnerEdgeSpec(highlightOpacity: 0.15, shadowOpacity: 0.08, inset: 2.0, blur: 8.0)
        )

        #expect(material.id == "testFull")
        #expect(material.tint != nil)
        #expect(material.specular != nil)
        #expect(material.innerEdges != nil)
    }

    @Test("Material is identifiable")
    func testMaterialIdentifiable() {
        let material = GentleDesignMaterial(
            id: "uniqueId",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000"))
        )

        #expect(material.id == "uniqueId")
    }

    @Test("Material is equatable")
    func testMaterialEquatable() {
        let material1 = GentleDesignMaterial(
            id: "test",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000"))
        )
        let material2 = GentleDesignMaterial(
            id: "test",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000"))
        )
        let material3 = GentleDesignMaterial(
            id: "different",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000"))
        )

        #expect(material1 == material2)
        #expect(material1 != material3)
    }

    @Test("Material is codable with solid base")
    func testMaterialCodableSolid() throws {
        let original = GentleDesignMaterial(
            id: "testSolid",
            base: .solid(GentleColorPair(lightHex: "#FF0000", darkHex: "#00FF00"))
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleDesignMaterial.self, from: data)

        #expect(decoded.id == original.id)
        if case .solid(let colorPair) = decoded.base {
            #expect(colorPair.lightHex == "#FF0000")
            #expect(colorPair.darkHex == "#00FF00")
        } else {
            Issue.record("Expected solid base after decoding")
        }
    }

    @Test("Material is codable with appleMaterial base")
    func testMaterialCodableAppleMaterial() throws {
        let original = GentleDesignMaterial(
            id: "testApple",
            base: .appleMaterial(GentleAppleMaterialSpec(kind: .regular, opacity: 0.8))
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleDesignMaterial.self, from: data)

        #expect(decoded.id == original.id)
        if case .appleMaterial(let spec) = decoded.base {
            #expect(spec.kind == .regular)
            #expect(spec.opacity == 0.8)
        } else {
            Issue.record("Expected appleMaterial base after decoding")
        }
    }

    @Test("Material is codable with blur base")
    func testMaterialCodableBlur() throws {
        let original = GentleDesignMaterial(
            id: "testBlur",
            base: .blur(GentleBlurSpec(radius: 15, isBackgroundOnly: true, opacity: 0.9))
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleDesignMaterial.self, from: data)

        #expect(decoded.id == original.id)
        if case .blur(let spec) = decoded.base {
            #expect(spec.radius == 15)
            #expect(spec.isBackgroundOnly == true)
            #expect(spec.opacity == 0.9)
        } else {
            Issue.record("Expected blur base after decoding")
        }
    }

    @Test("Material is codable with glass base")
    func testMaterialCodableGlass() throws {
        let original = GentleDesignMaterial(
            id: "testGlass",
            base: .glass(GentleGlassSpec(style: .clear, isInteractive: true, tint: nil))
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleDesignMaterial.self, from: data)

        #expect(decoded.id == original.id)
        if case .glass(let spec) = decoded.base {
            #expect(spec.style == .clear)
            #expect(spec.isInteractive == true)
        } else {
            Issue.record("Expected glass base after decoding")
        }
    }

    @Test("Material decoding throws on invalid JSON")
    func testMaterialDecodingThrowsOnInvalid() throws {
        let jsonString = """
        {"id": "test", "base": {"invalid": "data"}}
        """
        guard let invalidJSON = jsonString.data(using: .utf8) else {
            throw MaterialTestError.invalidTestData("Could not convert JSON string to data")
        }

        let decoder = JSONDecoder()

        #expect(throws: DecodingError.self) {
            _ = try decoder.decode(GentleDesignMaterial.self, from: invalidJSON)
        }
    }
}

// MARK: - GentleMaterialBaseSpec Tests

@Suite("GentleMaterialBaseSpec Tests")
struct GentleMaterialBaseSpecTests {

    @Test("Solid base spec stores color pair")
    func testSolidBase() {
        let base = GentleMaterialBaseSpec.solid(GentleColorPair(lightHex: "#AABBCC", darkHex: "#112233"))

        if case .solid(let colorPair) = base {
            #expect(colorPair.lightHex == "#AABBCC")
            #expect(colorPair.darkHex == "#112233")
        } else {
            Issue.record("Expected solid case")
        }
    }

    @Test("AppleMaterial base spec stores spec")
    func testAppleMaterialBase() {
        let base = GentleMaterialBaseSpec.appleMaterial(GentleAppleMaterialSpec(kind: .thick, opacity: 0.5))

        if case .appleMaterial(let spec) = base {
            #expect(spec.kind == .thick)
            #expect(spec.opacity == 0.5)
        } else {
            Issue.record("Expected appleMaterial case")
        }
    }

    @Test("Blur base spec stores spec")
    func testBlurBase() {
        let base = GentleMaterialBaseSpec.blur(GentleBlurSpec(radius: 20, isBackgroundOnly: false, opacity: 0.7))

        if case .blur(let spec) = base {
            #expect(spec.radius == 20)
            #expect(spec.isBackgroundOnly == false)
            #expect(spec.opacity == 0.7)
        } else {
            Issue.record("Expected blur case")
        }
    }

    @Test("Glass base spec stores spec")
    func testGlassBase() {
        let tint = GentleColorPair(lightHex: "#FF000020", darkHex: "#0000FF20")
        let base = GentleMaterialBaseSpec.glass(GentleGlassSpec(style: .identity, isInteractive: false, tint: tint))

        if case .glass(let spec) = base {
            #expect(spec.style == .identity)
            #expect(spec.isInteractive == false)
            #expect(spec.tint?.lightHex == "#FF000020")
        } else {
            Issue.record("Expected glass case")
        }
    }

    @Test("Base spec is equatable")
    func testBaseSpecEquatable() {
        let base1 = GentleMaterialBaseSpec.solid(GentleColorPair(lightHex: "#FFF", darkHex: "#000"))
        let base2 = GentleMaterialBaseSpec.solid(GentleColorPair(lightHex: "#FFF", darkHex: "#000"))
        let base3 = GentleMaterialBaseSpec.appleMaterial(GentleAppleMaterialSpec(kind: .regular, opacity: 1.0))

        #expect(base1 == base2)
        #expect(base1 != base3)
    }
}

// MARK: - GentleAppleMaterialSpec Tests

@Suite("GentleAppleMaterialSpec Tests")
struct GentleAppleMaterialSpecTests {

    @Test("Apple material spec stores kind and opacity")
    func testAppleMaterialSpec() {
        let spec = GentleAppleMaterialSpec(kind: .ultraThin, opacity: 0.75)

        #expect(spec.kind == .ultraThin)
        #expect(spec.opacity == 0.75)
    }

    @Test("Apple material spec defaults opacity to 1.0")
    func testAppleMaterialSpecDefaultOpacity() {
        let spec = GentleAppleMaterialSpec(kind: .regular)

        #expect(spec.opacity == 1.0)
    }

    @Test("All apple material kinds exist")
    func testAllAppleMaterialKinds() {
        let kinds: [GentleAppleMaterialSpec.Kind] = [.ultraThin, .thin, .regular, .thick, .ultraThick, .bar]

        for kind in kinds {
            let spec = GentleAppleMaterialSpec(kind: kind)
            #expect(spec.kind == kind)
        }
    }

    @Test("Apple material spec is codable")
    func testAppleMaterialSpecCodable() throws {
        let original = GentleAppleMaterialSpec(kind: .bar, opacity: 0.6)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleAppleMaterialSpec.self, from: data)

        #expect(decoded.kind == .bar)
        #expect(decoded.opacity == 0.6)
    }

    @Test("Apple material kind decoding throws on invalid value")
    func testAppleMaterialKindDecodingThrows() throws {
        let jsonString = """
        {"kind": "invalidKind", "opacity": 1.0}
        """
        guard let invalidJSON = jsonString.data(using: .utf8) else {
            throw MaterialTestError.invalidTestData("Could not convert JSON string to data")
        }

        let decoder = JSONDecoder()

        #expect(throws: DecodingError.self) {
            _ = try decoder.decode(GentleAppleMaterialSpec.self, from: invalidJSON)
        }
    }
}

// MARK: - GentleBlurSpec Tests

@Suite("GentleBlurSpec Tests")
struct GentleBlurSpecTests {

    @Test("Blur spec stores all properties")
    func testBlurSpec() {
        let spec = GentleBlurSpec(radius: 12, isBackgroundOnly: false, opacity: 0.85)

        #expect(spec.radius == 12)
        #expect(spec.isBackgroundOnly == false)
        #expect(spec.opacity == 0.85)
    }

    @Test("Blur spec has default values")
    func testBlurSpecDefaults() {
        let spec = GentleBlurSpec(radius: 10)

        #expect(spec.isBackgroundOnly == true)
        #expect(spec.opacity == 1.0)
    }

    @Test("Blur spec is codable")
    func testBlurSpecCodable() throws {
        let original = GentleBlurSpec(radius: 25, isBackgroundOnly: true, opacity: 0.5)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleBlurSpec.self, from: data)

        #expect(decoded.radius == 25)
        #expect(decoded.isBackgroundOnly == true)
        #expect(decoded.opacity == 0.5)
    }
}

// MARK: - GentleGlassSpec Tests

@Suite("GentleGlassSpec Tests")
struct GentleGlassSpecTests {

    @Test("Glass spec stores all properties")
    func testGlassSpec() {
        let tint = GentleColorPair(lightHex: "#FFFFFF10", darkHex: "#00000010")
        let spec = GentleGlassSpec(style: .clear, isInteractive: true, tint: tint)

        #expect(spec.style == .clear)
        #expect(spec.isInteractive == true)
        #expect(spec.tint?.lightHex == "#FFFFFF10")
    }

    @Test("Glass spec has default values")
    func testGlassSpecDefaults() {
        let spec = GentleGlassSpec()

        #expect(spec.style == .regular)
        #expect(spec.isInteractive == false)
        #expect(spec.tint == nil)
    }

    @Test("All glass styles exist")
    func testAllGlassStyles() {
        let styles: [GentleGlassSpec.Style] = [.regular, .clear, .identity]

        for style in styles {
            let spec = GentleGlassSpec(style: style)
            #expect(spec.style == style)
        }
    }

    @Test("Glass spec is codable")
    func testGlassSpecCodable() throws {
        let original = GentleGlassSpec(style: .identity, isInteractive: true, tint: nil)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleGlassSpec.self, from: data)

        #expect(decoded.style == .identity)
        #expect(decoded.isInteractive == true)
    }

    @Test("Glass style decoding throws on invalid value")
    func testGlassStyleDecodingThrows() throws {
        let jsonString = """
        {"style": "invalidStyle", "isInteractive": false}
        """
        guard let invalidJSON = jsonString.data(using: .utf8) else {
            throw MaterialTestError.invalidTestData("Could not convert JSON string to data")
        }

        let decoder = JSONDecoder()

        #expect(throws: DecodingError.self) {
            _ = try decoder.decode(GentleGlassSpec.self, from: invalidJSON)
        }
    }
}

// MARK: - GentleSpecularSpec Tests

@Suite("GentleSpecularSpec Tests")
struct GentleSpecularSpecTests {

    @Test("Specular spec stores rim properties")
    func testSpecularSpecRim() {
        let spec = GentleSpecularSpec(rimStrokeOpacity: 0.25, rimStrokeWidth: 2.0)

        #expect(spec.rimStrokeOpacity == 0.25)
        #expect(spec.rimStrokeWidth == 2.0)
    }

    @Test("Specular spec has default values")
    func testSpecularSpecDefaults() {
        let spec = GentleSpecularSpec()

        #expect(spec.rimStrokeOpacity == 0.18)
        #expect(spec.rimStrokeWidth == 1.0)
        #expect(spec.topLeft == nil)
        #expect(spec.topRight == nil)
        #expect(spec.bottomLeft == nil)
        #expect(spec.bottomRight == nil)
    }

    @Test("Specular spec corner stores properties")
    func testSpecularSpecCorner() {
        let corner = GentleSpecularSpec.Corner(
            opacity: 0.3,
            radius: 50,
            blur: 12,
            color: GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")
        )

        #expect(corner.opacity == 0.3)
        #expect(corner.radius == 50)
        #expect(corner.blur == 12)
        #expect(corner.color.lightHex == "#FFFFFF")
    }

    @Test("Specular spec with corners")
    func testSpecularSpecWithCorners() {
        let corner = GentleSpecularSpec.Corner(
            opacity: 0.2,
            radius: 40,
            blur: 10,
            color: GentleColorPair(lightHex: "#FFFFFF", darkHex: "#CCCCCC")
        )

        let spec = GentleSpecularSpec(
            topLeft: corner,
            bottomRight: corner
        )

        #expect(spec.topLeft != nil)
        #expect(spec.topRight == nil)
        #expect(spec.bottomLeft == nil)
        #expect(spec.bottomRight != nil)
    }

    @Test("Specular spec is codable")
    func testSpecularSpecCodable() throws {
        let corner = GentleSpecularSpec.Corner(
            opacity: 0.15,
            radius: 30,
            blur: 8,
            color: GentleColorPair(lightHex: "#AABBCC", darkHex: "#112233")
        )

        let original = GentleSpecularSpec(
            topLeft: corner,
            rimStrokeOpacity: 0.22,
            rimStrokeWidth: 1.5
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSpecularSpec.self, from: data)

        #expect(decoded.rimStrokeOpacity == 0.22)
        #expect(decoded.rimStrokeWidth == 1.5)
        #expect(decoded.topLeft?.opacity == 0.15)
        #expect(decoded.topLeft?.radius == 30)
    }
}

// MARK: - GentleInnerEdgeSpec Tests

@Suite("GentleInnerEdgeSpec Tests")
struct GentleInnerEdgeSpecTests {

    @Test("Inner edge spec stores all properties")
    func testInnerEdgeSpec() {
        let spec = GentleInnerEdgeSpec(
            highlightOpacity: 0.12,
            shadowOpacity: 0.08,
            inset: 1.5,
            blur: 8.0
        )

        #expect(spec.highlightOpacity == 0.12)
        #expect(spec.shadowOpacity == 0.08)
        #expect(spec.inset == 1.5)
        #expect(spec.blur == 8.0)
    }

    @Test("Inner edge spec has default values")
    func testInnerEdgeSpecDefaults() {
        let spec = GentleInnerEdgeSpec()

        #expect(spec.highlightOpacity == 0.10)
        #expect(spec.shadowOpacity == 0.06)
        #expect(spec.inset == 1.0)
        #expect(spec.blur == 6.0)
    }

    @Test("Inner edge spec is codable")
    func testInnerEdgeSpecCodable() throws {
        let original = GentleInnerEdgeSpec(
            highlightOpacity: 0.20,
            shadowOpacity: 0.15,
            inset: 2.5,
            blur: 10.0
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleInnerEdgeSpec.self, from: data)

        #expect(decoded.highlightOpacity == 0.20)
        #expect(decoded.shadowOpacity == 0.15)
        #expect(decoded.inset == 2.5)
        #expect(decoded.blur == 10.0)
    }
}

// MARK: - GentleSurfaceRoleSpec Tests

@Suite("GentleSurfaceRoleSpec Tests")
struct GentleSurfaceRoleSpecTests {

    @Test("Surface role spec stores material and border")
    func testSurfaceRoleSpec() {
        let material = GentleDesignMaterial(
            id: "test",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000"))
        )
        let border = GentleColorPair(lightHex: "#CCCCCC", darkHex: "#333333")

        let spec = GentleSurfaceRoleSpec(material: material, border: border)

        #expect(spec.material.id == "test")
        #expect(spec.border.lightHex == "#CCCCCC")
    }

    @Test("Surface role spec has default values")
    func testSurfaceRoleSpecDefaults() {
        let material = GentleDesignMaterial(
            id: "test",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000"))
        )
        let border = GentleColorPair(lightHex: "#CCCCCC", darkHex: "#333333")

        let spec = GentleSurfaceRoleSpec(material: material, border: border)

        #expect(spec.cornerRadius == 20)
        #expect(spec.borderWidth == 1)
        #expect(spec.shadowRadius == 0)
        #expect(spec.shadowOpacity == 0)
        #expect(spec.shadowOffsetX == 0)
        #expect(spec.shadowOffsetY == 0)
    }

    @Test("Surface role spec with all properties")
    func testSurfaceRoleSpecAllProperties() {
        let material = GentleDesignMaterial(
            id: "elevated",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#1F2937"))
        )

        let spec = GentleSurfaceRoleSpec(
            material: material,
            border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151"),
            cornerRadius: 24,
            borderWidth: 0.5,
            shadowRadius: 10,
            shadowOpacity: 0.1,
            shadowOffsetX: 2,
            shadowOffsetY: 4
        )

        #expect(spec.cornerRadius == 24)
        #expect(spec.borderWidth == 0.5)
        #expect(spec.shadowRadius == 10)
        #expect(spec.shadowOpacity == 0.1)
        #expect(spec.shadowOffsetX == 2)
        #expect(spec.shadowOffsetY == 4)
    }

    @Test("Surface role spec is codable")
    func testSurfaceRoleSpecCodable() throws {
        let material = GentleDesignMaterial(
            id: "card",
            base: .solid(GentleColorPair(lightHex: "#FAFAFE", darkHex: "#111827"))
        )

        let original = GentleSurfaceRoleSpec(
            material: material,
            border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151"),
            cornerRadius: 16,
            borderWidth: 1.5
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSurfaceRoleSpec.self, from: data)

        #expect(decoded.material.id == "card")
        #expect(decoded.cornerRadius == 16)
        #expect(decoded.borderWidth == 1.5)
    }

    @Test("Surface role spec with appleMaterial is codable")
    func testSurfaceRoleSpecWithAppleMaterialCodable() throws {
        let material = GentleDesignMaterial(
            id: "frosted",
            base: .appleMaterial(GentleAppleMaterialSpec(kind: .thin, opacity: 0.9))
        )

        let original = GentleSurfaceRoleSpec(
            material: material,
            border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000")
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSurfaceRoleSpec.self, from: data)

        #expect(decoded.material.id == "frosted")
        if case .appleMaterial(let spec) = decoded.material.base {
            #expect(spec.kind == .thin)
            #expect(spec.opacity == 0.9)
        } else {
            Issue.record("Expected appleMaterial base after decoding")
        }
    }
}

// MARK: - GentleSurfaceTokens Tests

@Suite("GentleSurfaceTokens Tests")
struct GentleSurfaceTokensTests {

    @Test("Default surface tokens contain all roles")
    func testDefaultSurfaceTokensContainAllRoles() {
        let tokens = GentleSurfaceTokens.gentleDefault
        let roles: [GentleSurfaceRole] = [.appBackground, .card, .cardElevated, .surfaceOverlay]

        for role in roles {
            let spec = tokens.roleSpec(for: role)
            #expect(!spec.material.id.isEmpty, "Missing surface spec for role: \(role)")
        }
    }

    @Test("Surface tokens fallback to card when role missing")
    func testSurfaceTokensFallbackToCard() {
        let cardMaterial = GentleDesignMaterial(
            id: "cardFallback",
            base: .solid(GentleColorPair(lightHex: "#FAFAFE", darkHex: "#111827"))
        )

        let tokens = GentleSurfaceTokens(roles: [
            GentleSurfaceRole.card.rawValue: GentleSurfaceRoleSpec(
                material: cardMaterial,
                border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151")
            )
        ])

        // Request missing role should fallback to card
        let spec = tokens.roleSpec(for: .appBackground)
        #expect(spec.material.id == "cardFallback")
    }

    @Test("Surface tokens fallback to hardcoded defaults when empty")
    func testSurfaceTokensHardcodedFallback() {
        let tokens = GentleSurfaceTokens(roles: [:])
        let spec = tokens.roleSpec(for: .card)

        #expect(spec.material.id == "fallback")
        if case .solid(let colorPair) = spec.material.base {
            #expect(colorPair.lightHex == "#FAFAFE")
            #expect(colorPair.darkHex == "#111827")
        } else {
            Issue.record("Expected solid base in fallback")
        }
    }

    @Test("Surface tokens are codable")
    func testSurfaceTokensCodable() throws {
        let original = GentleSurfaceTokens.gentleDefault
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleSurfaceTokens.self, from: data)

        let roles: [GentleSurfaceRole] = [.appBackground, .card, .cardElevated, .surfaceOverlay]
        for role in roles {
            let originalSpec = original.roleSpec(for: role)
            let decodedSpec = decoded.roleSpec(for: role)
            #expect(originalSpec.material.id == decodedSpec.material.id)
            #expect(originalSpec.cornerRadius == decodedSpec.cornerRadius)
        }
    }

    @Test("Surface tokens decode throws on invalid JSON")
    func testSurfaceTokensDecodeThrows() throws {
        let jsonString = """
        {"roles": {"card": {"invalid": "structure"}}}
        """
        guard let invalidJSON = jsonString.data(using: .utf8) else {
            throw MaterialTestError.invalidTestData("Could not convert JSON string to data")
        }

        let decoder = JSONDecoder()

        #expect(throws: DecodingError.self) {
            _ = try decoder.decode(GentleSurfaceTokens.self, from: invalidJSON)
        }
    }
}

// MARK: - Material JSON Round-Trip Tests

@Suite("Material JSON Round-Trip Tests")
struct MaterialJSONRoundTripTests {

    @Test("Full spec with materials round-trips through JSON")
    func testFullSpecWithMaterialsRoundTrip() throws {
        let original = GentleDesignSystemSpec.gentleDefault

        let jsonData = try original.encodedJSONData()
        let decoded = try GentleDesignSystemSpec.fromJSONData(jsonData)

        // Verify surfaces
        let roles: [GentleSurfaceRole] = [.appBackground, .card, .cardElevated, .surfaceOverlay]
        for role in roles {
            let originalSpec = original.surfaces.roleSpec(for: role)
            let decodedSpec = decoded.surfaces.roleSpec(for: role)

            #expect(originalSpec.material.id == decodedSpec.material.id)
            #expect(originalSpec.cornerRadius == decodedSpec.cornerRadius)
            #expect(originalSpec.borderWidth == decodedSpec.borderWidth)
            #expect(originalSpec.shadowRadius == decodedSpec.shadowRadius)
        }
    }

    @Test("Custom spec with appleMaterial surfaces round-trips")
    func testCustomSpecWithAppleMaterialRoundTrip() throws {
        var spec = GentleDesignSystemSpec.gentleDefault

        // Replace card with appleMaterial
        let frostedMaterial = GentleDesignMaterial(
            id: "frostedCard",
            base: .appleMaterial(GentleAppleMaterialSpec(kind: .regular, opacity: 0.95))
        )
        spec.surfaces.roles[GentleSurfaceRole.card.rawValue] = GentleSurfaceRoleSpec(
            material: frostedMaterial,
            border: GentleColorPair(lightHex: "#FFFFFF20", darkHex: "#00000020"),
            cornerRadius: 16
        )

        let jsonData = try spec.encodedJSONData()
        let decoded = try GentleDesignSystemSpec.fromJSONData(jsonData)

        let decodedCardSpec = decoded.surfaces.roleSpec(for: .card)
        #expect(decodedCardSpec.material.id == "frostedCard")

        if case .appleMaterial(let appleMaterial) = decodedCardSpec.material.base {
            #expect(appleMaterial.kind == .regular)
            #expect(appleMaterial.opacity == 0.95)
        } else {
            Issue.record("Expected appleMaterial base after round-trip")
        }
    }

    @Test("Spec JSON contains surfaces key")
    func testSpecJSONContainsSurfacesKey() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let jsonString = try spec.encodedJSONString()

        #expect(jsonString.contains("\"surfaces\""))
        #expect(jsonString.contains("\"material\""))
        #expect(jsonString.contains("\"base\""))
    }
}
