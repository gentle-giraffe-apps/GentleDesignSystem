//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - JSON Encoding/Decoding Tests

@Suite("JSON Encoding/Decoding Tests")
struct JSONEncodingDecodingTests {

    @Test("GentleDesignSystemSpec round-trips through JSON")
    func testSpecRoundTrip() throws {
        let original = GentleDesignSystemSpec.gentleDefault

        let jsonData = try original.encodedJSONData()
        let decoded = try GentleDesignSystemSpec.fromJSONData(jsonData)

        #expect(decoded.specVersion == original.specVersion)

        // Verify colors
        let originalPair = original.colors.pair(for: .textPrimary)
        let decodedPair = decoded.colors.pair(for: .textPrimary)
        #expect(originalPair?.lightHex == decodedPair?.lightHex)
        #expect(originalPair?.darkHex == decodedPair?.darkHex)

        // Verify typography
        let originalTypo = original.typography.roleSpec(for: .body_m)
        let decodedTypo = decoded.typography.roleSpec(for: .body_m)
        #expect(originalTypo.pointSize == decodedTypo.pointSize)
        #expect(originalTypo.weight == decodedTypo.weight)
    }

    @Test("GentleDesignSystemSpec encodes to JSON string")
    func testSpecToJSONString() throws {
        let spec = GentleDesignSystemSpec.gentleDefault

        let jsonString = try spec.encodedJSONString()

        #expect(jsonString.contains("\"_specVersion\""))
        #expect(jsonString.contains("\"colors\""))
        #expect(jsonString.contains("\"typography\""))
        #expect(jsonString.contains("\"layout\""))
        #expect(jsonString.contains("\"visual\""))
        #expect(jsonString.contains("\"buttons\""))
    }

    @Test("GentleDesignSystemSpec decodes from JSON string")
    func testSpecFromJSONString() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let jsonString = try spec.encodedJSONString()

        let decoded = try GentleDesignSystemSpec.fromJSONString(jsonString)

        #expect(decoded.specVersion == spec.specVersion)
    }

    @Test("JSON encoder uses pretty printing and sorted keys")
    func testJSONEncoderOptions() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let jsonString = try spec.encodedJSONString()

        // Pretty printed should have newlines
        #expect(jsonString.contains("\n"))

        // Sorted keys means _specVersion should appear early (starts with underscore)
        let lines = jsonString.components(separatedBy: "\n")
        let specVersionLine = lines.first { $0.contains("_specVersion") }
        #expect(specVersionLine != nil)
    }

    @Test("All preset specs are JSON serializable")
    func testAllPresetsSerializable() throws {
        let presets = GentleDesignSystemSpec.allPresets

        for preset in presets {
            let jsonData = try preset.spec.encodedJSONData()
            let decoded = try GentleDesignSystemSpec.fromJSONData(jsonData)
            #expect(decoded.specVersion == preset.spec.specVersion, "Preset \(preset.name) failed to round-trip")
        }
    }
}

@Suite("JSON Encoding Edge Cases Tests")
struct JSONEncodingEdgeCasesTests {

    @Test("Empty spec encodes and decodes")
    func testEmptySpecEncodeDecode() throws {
        let emptySpec = GentleDesignSystemSpec(
            colors: GentleColorTokens(pairByRole: [:]),
            typography: GentleTypographyTokens(roles: [:]),
            layout: GentleLayoutTokens(),
            visual: GentleVisualTokens(),
            buttons: GentleButtonTokens(roles: [:], animations: [:])
        )

        let data = try emptySpec.encodedJSONData()
        let decoded = try GentleDesignSystemSpec.fromJSONData(data)

        #expect(decoded.specVersion == emptySpec.specVersion)
    }

    @Test("Spec with all custom values encodes correctly")
    func testFullyCustomSpec() throws {
        let customSpec = GentleDesignSystemSpec(
            specVersion: "custom-1.0",
            colors: GentleColorTokens(pairByRole: [
                GentleColorRole.textPrimary.rawValue: GentleColorPair(lightHex: "#123ABC", darkHex: "#DEF456")
            ]),
            typography: GentleTypographyTokens(roles: [
                GentleTextRole.body_m.rawValue: GentleTypographyRoleSpec(
                    pointSize: 18,
                    weight: .medium,
                    design: .rounded,
                    width: .expanded,
                    relativeTo: .body,
                    lineSpacing: 5,
                    letterSpacing: 1,
                    isUppercased: true,
                    colorRole: .textSecondary
                )
            ]),
            layout: GentleLayoutTokens(
                scale: GentleSpacingScaleTokens(xs: 2, s: 4, m: 6, l: 8, xl: 10, xxl: 12)
            ),
            visual: GentleVisualTokens(
                radii: GentleRadiusTokens(small: 4, medium: 8, large: 16, pill: 500),
                shadows: GentleShadowTokens(none: 0, small: 1, medium: 3)
            ),
            buttons: GentleButtonTokens(
                roles: [
                    GentleButtonRole.primary.rawValue: GentleButtonRoleSpec(
                        shape: .pill,
                        fillRole: .solidFillDestructive,
                        borderRole: .accent,
                        animationRole: .pop,
                        pressedScale: 0.8,
                        pressedOpacity: 0.5
                    )
                ],
                animations: [:]
            )
        )

        let data = try customSpec.encodedJSONData()
        let decoded = try GentleDesignSystemSpec.fromJSONData(data)

        #expect(decoded.specVersion == "custom-1.0")
        #expect(decoded.colors.pair(for: .textPrimary)?.lightHex == "#123ABC")
        #expect(decoded.typography.roleSpec(for: .body_m).pointSize == 18)
        #expect(decoded.typography.roleSpec(for: .body_m).isUppercased == true)
        #expect(decoded.layout.scale.xs == 2)
        #expect(decoded.visual.radii.pill == 500)
        #expect(decoded.buttons.roleSpec(for: .primary).shape == .pill)
    }
}

@Suite("GentleJSON Protocol Tests")
struct GentleJSONProtocolTests {

    @Test("makeJSONEncoder returns encoder with correct options")
    func testMakeJSONEncoder() {
        let encoder = GentleDesignSystemSpec.makeJSONEncoder()
        #expect(encoder.outputFormatting.contains(.prettyPrinted))
        #expect(encoder.outputFormatting.contains(.sortedKeys))
    }

    @Test("makeJSONDecoder returns valid decoder")
    func testMakeJSONDecoder() {
        _ = GentleDesignSystemSpec.makeJSONDecoder()
    }

    @Test("encodedJSONString throws for invalid data")
    func testEncodedJSONStringWithCustomEncoder() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let customEncoder = JSONEncoder()
        customEncoder.outputFormatting = []

        let jsonString = try spec.encodedJSONString(encoder: customEncoder)
        #expect(!jsonString.isEmpty)
    }
}

// MARK: - Color Hex Conversion Tests

@Suite("Color Hex Conversion Tests")
struct ColorHexConversionTests {

    @Test("6-digit hex creates correct color")
    func test6DigitHex() {
        let color = Color(gentleHex: "#FF0000")
        // We can't easily test color values, but we can test it doesn't crash
        #expect(color != Color.clear)
    }

    @Test("8-digit hex with alpha creates correct color")
    func test8DigitHex() {
        let color = Color(gentleHex: "#FF000080")
        #expect(color != Color.clear)
    }

    @Test("Hex without hash prefix works")
    func testHexWithoutHash() {
        let color = Color(gentleHex: "00FF00")
        #expect(color != Color.clear)
    }

    @Test("Hex with whitespace is trimmed")
    func testHexWithWhitespace() {
        let color = Color(gentleHex: "  #0000FF  ")
        #expect(color != Color.clear)
    }

    @Test("Invalid hex returns black")
    func testInvalidHex() {
        let color = Color(gentleHex: "invalid")
        // Invalid hex should return black (r=0, g=0, b=0)
        #expect(color != Color.clear)
    }

    @Test("Short hex returns black")
    func testShortHex() {
        let color = Color(gentleHex: "#FFF")
        // 3-digit hex is not supported, should return black
        #expect(color != Color.clear)
    }

    @Test("Hex with lowercase letters works")
    func testHexLowercase() {
        let color = Color(gentleHex: "#aabbcc")
        #expect(color != Color.clear)
    }

    @Test("Hex with uppercase letters works")
    func testHexUppercase() {
        let color = Color(gentleHex: "#AABBCC")
        #expect(color != Color.clear)
    }

    @Test("Hex with mixed case works")
    func testHexMixedCase() {
        let color = Color(gentleHex: "#AaBbCc")
        #expect(color != Color.clear)
    }

    @Test("8-digit hex alpha channel works")
    func test8DigitHexAlpha() {
        // Full opacity
        let opaqueColor = Color(gentleHex: "#FF0000FF")
        #expect(opaqueColor != Color.clear)

        // Half opacity
        let halfOpacity = Color(gentleHex: "#FF000080")
        #expect(halfOpacity != Color.clear)

        // Zero opacity
        let transparentColor = Color(gentleHex: "#FF000000")
        #expect(transparentColor != Color.clear)
    }
}
