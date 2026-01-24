//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - GentleDesignSystemSpec Tests

@Suite("GentleDesignSystemSpec Tests")
struct GentleDesignSystemSpecTests {

    @Test("Spec version is current")
    func testSpecVersion() {
        let spec = GentleDesignSystemSpec.gentleDefault
        #expect(spec.specVersion == GentleDesignSystemSpecVersion.current)
    }

    @Test("Default spec contains all token groups")
    func testDefaultSpecContainsAllTokenGroups() {
        let spec = GentleDesignSystemSpec.gentleDefault

        // Colors
        for role in GentleColorRole.allCases {
            #expect(spec.colors.pair(for: role) != nil)
        }

        // Typography
        for role in GentleTextRole.allCases {
            let typoSpec = spec.typography.roleSpec(for: role)
            #expect(typoSpec.pointSize > 0)
        }

        // Layout
        #expect(spec.layout.scale.m == 12)

        // Visual
        #expect(spec.visual.radii.medium == 12)

        // Buttons
        #expect(spec.buttons.roleSpec(for: .primary).materialRole == .solidFillPrimaryCTA)
    }

    @Test("Spec is codable")
    func testSpecCodable() throws {
        let original = GentleDesignSystemSpec.gentleDefault
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleDesignSystemSpec.self, from: data)

        #expect(decoded.specVersion == original.specVersion)
        #expect(decoded.colors.pair(for: .textPrimary)?.lightHex == original.colors.pair(for: .textPrimary)?.lightHex)
    }

    @Test("Spec version key uses underscore prefix")
    func testSpecVersionCodingKey() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let encoder = JSONEncoder()

        let data = try encoder.encode(spec)
        if let jsonString = String(data: data, encoding: .utf8) {
            #expect(jsonString.contains("\"_specVersion\""))
        } else {
            Issue.record("Could not convert encoded data to a UTF-8 string")
        }
    }
}

@Suite("GentleDesignSystemSpec Presets Tests")
struct GentleDesignSystemSpecPresetsTests {

    @Test("All presets exist and are valid")
    func testAllPresetsExist() {
        let presets = GentleDesignSystemSpec.allPresets
        #expect(presets.count == 9)

        for preset in presets {
            #expect(!preset.name.isEmpty)
            #expect(!preset.summary.isEmpty)
            #expect(!preset.description.isEmpty)
            #expect(!preset.purpose.isEmpty)
            #expect(!preset.systemImageString.isEmpty)
        }
    }

    @Test("Classic preset has serif typography")
    func testClassicPresetHasSerif() {
        let classic = GentleDesignSystemSpec.classic
        let titleSpec = classic.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.design == .serif)
    }

    @Test("Soft preset has rounded typography")
    func testSoftPresetHasRounded() {
        let soft = GentleDesignSystemSpec.soft
        let titleSpec = soft.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.design == .rounded)
    }

    @Test("Modern preset has default design")
    func testModernPresetHasDefault() {
        let modern = GentleDesignSystemSpec.modern
        let titleSpec = modern.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.design == .default)
    }

    @Test("Compact preset has smaller point sizes")
    func testCompactPresetHasSmallerSizes() {
        let compact = GentleDesignSystemSpec.compact
        let defaultSpec = GentleDesignSystemSpec.gentleDefault

        let compactBody = compact.typography.roleSpec(for: .body_m)
        let defaultBody = defaultSpec.typography.roleSpec(for: .body_m)

        #expect(compactBody.pointSize <= defaultBody.pointSize)
    }

    @Test("Editorial preset has serif design")
    func testEditorialPresetHasSerif() {
        let editorial = GentleDesignSystemSpec.editorial
        let bodySpec = editorial.typography.roleSpec(for: .body_m)
        #expect(bodySpec.design == .serif)
    }

    @Test("Technical preset exists and is valid")
    func testTechnicalPreset() {
        let technical = GentleDesignSystemSpec.technical
        let titleSpec = technical.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.pointSize > 0)
    }

    @Test("Bold preset exists and is valid")
    func testBoldPreset() {
        let bold = GentleDesignSystemSpec.bold
        let titleSpec = bold.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.weight == .black || titleSpec.weight == .bold || titleSpec.weight == .heavy)
    }

    @Test("Elegant preset exists and is valid")
    func testElegantPreset() {
        let elegant = GentleDesignSystemSpec.elegant
        let titleSpec = elegant.typography.roleSpec(for: .largeTitle_xxl)
        #expect(titleSpec.pointSize > 0)
    }
}

@Suite("All Presets Comprehensive Tests")
struct AllPresetsComprehensiveTests {

    @Test("All presets have valid colors for all roles")
    func testAllPresetsHaveValidColors() {
        let presets = GentleDesignSystemSpec.allPresets

        for preset in presets {
            for role in GentleColorRole.allCases {
                let pair = preset.spec.colors.pair(for: role)
                #expect(pair != nil, "Preset \(preset.name) missing color for role \(role)")
            }
        }
    }

    @Test("All presets have valid typography for all roles")
    func testAllPresetsHaveValidTypography() {
        let presets = GentleDesignSystemSpec.allPresets

        for preset in presets {
            for role in GentleTextRole.allCases {
                let spec = preset.spec.typography.roleSpec(for: role)
                #expect(spec.pointSize > 0, "Preset \(preset.name) has invalid point size for role \(role)")
            }
        }
    }

    @Test("All presets have valid button specs")
    func testAllPresetsHaveValidButtonSpecs() {
        let presets = GentleDesignSystemSpec.allPresets
        let buttonRoles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]

        for preset in presets {
            for role in buttonRoles {
                let spec = preset.spec.buttons.roleSpec(for: role)
                #expect(spec.pressedScale > 0 && spec.pressedScale <= 1.0)
                #expect(spec.pressedOpacity > 0 && spec.pressedOpacity <= 1.0)
            }
        }
    }
}
