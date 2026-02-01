//  Jonathan Ritchey
import Testing
import SnapshotTesting
import SwiftUI
@testable import GentleDesignSystem

// MARK: - Snapshot Tests for Spec Presets

@Suite("Spec JSON Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct SpecJSONSnapshotTests {

    @Test("gentleDefault spec JSON snapshot")
    func testGentleDefaultSnapshot() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }

    @Test("classic spec JSON snapshot")
    func testClassicSnapshot() throws {
        let spec = GentleDesignSystemSpec.classic
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }

    @Test("modern spec JSON snapshot")
    func testModernSnapshot() throws {
        let spec = GentleDesignSystemSpec.modern
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }

    @Test("soft spec JSON snapshot")
    func testSoftSnapshot() throws {
        let spec = GentleDesignSystemSpec.soft
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }

    @Test("compact spec JSON snapshot")
    func testCompactSnapshot() throws {
        let spec = GentleDesignSystemSpec.compact
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }

    @Test("editorial spec JSON snapshot")
    func testEditorialSnapshot() throws {
        let spec = GentleDesignSystemSpec.editorial
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }

    @Test("technical spec JSON snapshot")
    func testTechnicalSnapshot() throws {
        let spec = GentleDesignSystemSpec.technical
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }

    @Test("bold spec JSON snapshot")
    func testBoldSnapshot() throws {
        let spec = GentleDesignSystemSpec.bold
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }

    @Test("elegant spec JSON snapshot")
    func testElegantSnapshot() throws {
        let spec = GentleDesignSystemSpec.elegant
        let jsonString = try spec.encodedJSONString()
        assertSnapshot(of: jsonString, as: .lines)
    }
}

// MARK: - Color Tokens Snapshot Tests

@Suite("Color Tokens Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct ColorTokensSnapshotTests {

    @Test("All color roles have consistent hex values")
    func testColorRolesSnapshot() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        var colorOutput = ""

        for role in GentleColorRole.allCases.sorted(by: { $0.rawValue < $1.rawValue }) {
            if let pair = spec.colors.pair(for: role) {
                colorOutput += "\(role.rawValue): light=\(pair.lightHex), dark=\(pair.darkHex)\n"
            }
        }

        assertSnapshot(of: colorOutput, as: .lines)
    }
}

// MARK: - Typography Tokens Snapshot Tests

@Suite("Typography Tokens Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct TypographyTokensSnapshotTests {

    @Test("All typography roles have consistent specs")
    func testTypographyRolesSnapshot() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        var typographyOutput = ""

        for role in GentleTextRole.allCases.sorted(by: { $0.rawValue < $1.rawValue }) {
            let roleSpec = spec.typography.roleSpec(for: role)
            typographyOutput += "\(role.rawValue): size=\(roleSpec.pointSize), weight=\(roleSpec.weight), design=\(roleSpec.design)\n"
        }

        assertSnapshot(of: typographyOutput, as: .lines)
    }
}

// MARK: - Layout Tokens Snapshot Tests

@Suite("Layout Tokens Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct LayoutTokensSnapshotTests {

    @Test("Layout scale tokens snapshot")
    func testLayoutScaleSnapshot() {
        let spec = GentleDesignSystemSpec.gentleDefault
        let scale = spec.layout.scale

        let layoutOutput = """
        xs: \(scale.xs)
        s: \(scale.s)
        m: \(scale.m)
        l: \(scale.l)
        xl: \(scale.xl)
        xxl: \(scale.xxl)
        """

        assertSnapshot(of: layoutOutput, as: .lines)
    }
}

// MARK: - Visual Tokens Snapshot Tests

@Suite("Visual Tokens Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct VisualTokensSnapshotTests {

    @Test("Visual radii tokens snapshot")
    func testVisualRadiiSnapshot() {
        let spec = GentleDesignSystemSpec.gentleDefault
        let radii = spec.visual.radii

        let radiiOutput = """
        small: \(radii.small)
        medium: \(radii.medium)
        large: \(radii.large)
        pill: \(radii.pill)
        """

        assertSnapshot(of: radiiOutput, as: .lines)
    }

    @Test("Visual shadows tokens snapshot")
    func testVisualShadowsSnapshot() {
        let spec = GentleDesignSystemSpec.gentleDefault
        let shadows = spec.visual.shadows

        let shadowsOutput = """
        none: \(shadows.none)
        small: \(shadows.small)
        medium: \(shadows.medium)
        """

        assertSnapshot(of: shadowsOutput, as: .lines)
    }
}

// MARK: - Button Tokens Snapshot Tests

@Suite("Button Tokens Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct ButtonTokensSnapshotTests {

    @Test("All button roles have consistent specs")
    func testButtonRolesSnapshot() {
        let spec = GentleDesignSystemSpec.gentleDefault
        let buttonRoles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        var buttonOutput = ""

        for role in buttonRoles {
            let roleSpec = spec.buttons.roleSpec(for: role)
            buttonOutput += "\(role): shape=\(roleSpec.shape), fill=\(roleSpec.fillRole), pressedScale=\(roleSpec.pressedScale), pressedOpacity=\(roleSpec.pressedOpacity)\n"
        }

        assertSnapshot(of: buttonOutput, as: .lines)
    }
}
