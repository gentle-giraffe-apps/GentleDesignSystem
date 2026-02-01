//  Jonathan Ritchey
import Testing
import SnapshotTesting
import SnapshotTestingHEIC
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

// MARK: - Image Snapshot Tests

@Suite("Button Image Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct ButtonImageSnapshotTests {

    @Test("All button roles light mode")
    func testButtonRolesLightMode() {
        let view = GentleThemeRoot {
            VStack(spacing: 12) {
                Button("Primary") {}
                    .gentleButton(.primary)

                Button("Secondary") {}
                    .gentleButton(.secondary)

                Button("Tertiary") {}
                    .gentleButton(.tertiary)

                Button("Quaternary") {}
                    .gentleButton(.quaternary)

                Button("Destructive") {}
                    .gentleButton(.destructive)
            }
            .padding(20)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 300)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("All button roles dark mode")
    func testButtonRolesDarkMode() {
        let view = GentleThemeRoot {
            VStack(spacing: 12) {
                Button("Primary") {}
                    .gentleButton(.primary)

                Button("Secondary") {}
                    .gentleButton(.secondary)

                Button("Tertiary") {}
                    .gentleButton(.tertiary)

                Button("Quaternary") {}
                    .gentleButton(.quaternary)

                Button("Destructive") {}
                    .gentleButton(.destructive)
            }
            .padding(20)
            .background(Color.black)
        }
        .environment(\.colorScheme, .dark)
        .frame(width: 300)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

@Suite("Typography Image Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct TypographyImageSnapshotTests {

    @Test("Typography roles light mode")
    func testTypographyLightMode() {
        let view = GentleThemeRoot {
            VStack(alignment: .leading, spacing: 8) {
                Text("Large Title XXL")
                    .gentleText(.largeTitle_xxl)

                Text("Title XL")
                    .gentleText(.title_xl)

                Text("Title L")
                    .gentleText(.title2_l)

                Text("Headline M")
                    .gentleText(.headline_m)

                Text("Body M")
                    .gentleText(.body_m)

                Text("Body S")
                    .gentleText(.callout_ms)

                Text("Caption S")
                    .gentleText(.caption_s)

                Text("Caption XS")
                    .gentleText(.caption2_s)
            }
            .padding(20)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 350)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Typography roles dark mode")
    func testTypographyDarkMode() {
        let view = GentleThemeRoot {
            VStack(alignment: .leading, spacing: 8) {
                Text("Large Title XXL")
                    .gentleText(.largeTitle_xxl)

                Text("Title XL")
                    .gentleText(.title_xl)

                Text("Title L")
                    .gentleText(.title2_l)

                Text("Headline M")
                    .gentleText(.headline_m)

                Text("Body M")
                    .gentleText(.body_m)

                Text("Body S")
                    .gentleText(.callout_ms)

                Text("Caption S")
                    .gentleText(.caption_s)

                Text("Caption XS")
                    .gentleText(.caption2_s)
            }
            .padding(20)
            .background(Color.black)
        }
        .environment(\.colorScheme, .dark)
        .frame(width: 350)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

@Suite("Color Swatch Image Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct ColorSwatchImageSnapshotTests {

    @Test("Color swatches light mode")
    func testColorSwatchesLightMode() {
        let roles: [GentleColorRole] = [
            .primaryCTA, .destructive, .themePrimary, .themeSecondary,
            .textPrimary, .textSecondary, .textTertiary,
            .background, .surfaceBase
        ]

        let view = GentleThemeRoot {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(roles, id: \.rawValue) { role in
                    ColorSwatchView(role: role)
                }
            }
            .padding(20)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 400)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Color swatches dark mode")
    func testColorSwatchesDarkMode() {
        let roles: [GentleColorRole] = [
            .primaryCTA, .destructive, .themePrimary, .themeSecondary,
            .textPrimary, .textSecondary, .textTertiary,
            .background, .surfaceBase
        ]

        let view = GentleThemeRoot {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(roles, id: \.rawValue) { role in
                    ColorSwatchView(role: role)
                }
            }
            .padding(20)
            .background(Color.black)
        }
        .environment(\.colorScheme, .dark)
        .frame(width: 400)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

// Helper view for color swatches
private struct ColorSwatchView: View {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    let role: GentleColorRole

    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.color(for: role, scheme: colorScheme))
                .frame(width: 60, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )

            Text(role.rawValue)
                .font(.system(size: 8))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

@Suite("Surface Image Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct SurfaceImageSnapshotTests {

    @Test("Surface cards light mode")
    func testSurfaceCardsLightMode() {
        let view = GentleThemeRoot {
            VStack(spacing: 16) {
                Text("Card Surface")
                    .gentleText(.body_m)
                    .gentleSurface(.card, inset: .card)

                Text("Card Elevated")
                    .gentleText(.body_m)
                    .gentleSurface(.cardElevated, inset: .card)

                Text("Card Secondary")
                    .gentleText(.body_m)
                    .gentleSurface(.cardSecondary, inset: .card)
            }
            .padding(24)
            .gentleSurface(.appBackground)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 300, height: 300)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Surface cards dark mode")
    func testSurfaceCardsDarkMode() {
        let view = GentleThemeRoot {
            VStack(spacing: 16) {
                Text("Card Surface")
                    .gentleText(.body_m)
                    .gentleSurface(.card, inset: .card)

                Text("Card Elevated")
                    .gentleText(.body_m)
                    .gentleSurface(.cardElevated, inset: .card)

                Text("Card Secondary")
                    .gentleText(.body_m)
                    .gentleSurface(.cardSecondary, inset: .card)
            }
            .padding(24)
            .gentleSurface(.appBackground)
        }
        .environment(\.colorScheme, .dark)
        .frame(width: 300, height: 300)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

// MARK: - Helper for Editor Component Tests

/// A helper view that sets up both the theme and manager environment needed for editor components.
private struct EditorTestEnvironment<Content: View>: View {
    let content: Content
    let manager: GentleThemeManager

    init(@ViewBuilder content: () -> Content) {
        self.manager = GentleThemeManager()
        self.content = content()
    }

    var body: some View {
        content
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
    }
}

// MARK: - Editor Component Snapshot Tests

@Suite("Typography Editor Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct TypographyEditorSnapshotTests {

    @Test("TypographyRoleCell renders correctly")
    func testTypographyRoleCell() {
        let view = EditorTestEnvironment {
            TypographyRoleCell(role: .headline_m, isEditing: .constant(false))
                .frame(width: 120)
                .padding(8)
                .background(Color.white)
        }
        .environment(\.colorScheme, .light)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("TypographyRoleEditor collapsed state")
    func testTypographyRoleEditorCollapsed() {
        let view = EditorTestEnvironment {
            VStack(spacing: 0) {
                TypographyRoleEditor(role: .title_xl)
                TypographyRoleEditor(role: .body_m)
                TypographyRoleEditor(role: .caption_s)
            }
            .padding(16)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 350)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Typography roles grid")
    func testTypographyRolesGrid() {
        let roles: [GentleTextRole] = [.largeTitle_xxl, .title_xl, .headline_m, .body_m, .caption_s]

        let view = EditorTestEnvironment {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(roles, id: \.rawValue) { role in
                    TypographyRoleCell(role: role, isEditing: .constant(false))
                }
            }
            .padding(16)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 300)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

@Suite("Color Editor Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct ColorEditorSnapshotTests {

    @Test("ColorRoleCell renders correctly")
    func testColorRoleCell() {
        let view = EditorTestEnvironment {
            HStack(spacing: 8) {
                ColorRoleCell(role: .primaryCTA, isEditing: .constant(false))
                ColorRoleCell(role: .textPrimary, isEditing: .constant(false))
                ColorRoleCell(role: .surfaceBase, isEditing: .constant(false))
            }
            .padding(16)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("ColorRoleEditor collapsed state")
    func testColorRoleEditorCollapsed() {
        let view = EditorTestEnvironment {
            VStack(spacing: 0) {
                ColorRoleEditor(role: .primaryCTA)
                ColorRoleEditor(role: .textPrimary)
                ColorRoleEditor(role: .surfaceBase)
            }
            .padding(16)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 350)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Color roles grid light mode")
    func testColorRolesGridLightMode() {
        let roles: [GentleColorRole] = [.primaryCTA, .destructive, .textPrimary, .textSecondary, .surfaceBase, .background]

        let view = EditorTestEnvironment {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(roles, id: \.rawValue) { role in
                    ColorRoleCell(role: role, isEditing: .constant(false))
                }
            }
            .padding(16)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 320)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Color roles grid dark mode")
    func testColorRolesGridDarkMode() {
        let roles: [GentleColorRole] = [.primaryCTA, .destructive, .textPrimary, .textSecondary, .surfaceBase, .background]

        let view = EditorTestEnvironment {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(roles, id: \.rawValue) { role in
                    ColorRoleCell(role: role, isEditing: .constant(false))
                }
            }
            .padding(16)
            .background(Color.black)
        }
        .environment(\.colorScheme, .dark)
        .frame(width: 320)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

@Suite("Button Preview Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct ButtonPreviewSnapshotTests {

    @Test("GentleButtonPreview all roles")
    func testGentleButtonPreviewAllRoles() {
        let view = GentleThemeRoot {
            VStack(spacing: 12) {
                GentleButtonPreview(role: .primary)
                GentleButtonPreview(role: .secondary)
                GentleButtonPreview(role: .tertiary)
                GentleButtonPreview(role: .quaternary)
                GentleButtonPreview(role: .destructive)
            }
            .padding(20)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 200)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("GentleButtonPreview pressed state")
    func testGentleButtonPreviewPressed() {
        let view = GentleThemeRoot {
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Default")
                        .font(.caption)
                    GentleButtonPreview(role: .primary, isPressed: false)
                }
                VStack(spacing: 8) {
                    Text("Pressed")
                        .font(.caption)
                    GentleButtonPreview(role: .primary, isPressed: true)
                }
            }
            .padding(20)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("GentleButtonPreview miniature mode")
    func testGentleButtonPreviewMiniature() {
        let view = GentleThemeRoot {
            HStack(spacing: 12) {
                GentleButtonPreview(role: .primary, isMiniature: true)
                GentleButtonPreview(role: .secondary, isMiniature: true)
                GentleButtonPreview(role: .tertiary, isMiniature: true)
                GentleButtonPreview(role: .destructive, isMiniature: true)
            }
            .padding(20)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

@Suite("Theme Editor Section Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct ThemeEditorSectionSnapshotTests {

    @Test("GentleDesignColorsSection renders")
    func testColorsSection() {
        let view = EditorTestEnvironment {
            ScrollView {
                GentleDesignColorsSection()
                    .padding(16)
            }
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 380, height: 400)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("GentleDesignTypographySection renders")
    func testTypographySection() {
        let view = EditorTestEnvironment {
            ScrollView {
                GentleDesignTypographySection()
                    .padding(16)
            }
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 380, height: 500)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("GentleDesignButtonsSection renders")
    func testButtonsSection() {
        let view = EditorTestEnvironment {
            ScrollView {
                GentleDesignButtonsSection()
                    .padding(16)
            }
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 380, height: 300)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("GentleDesignSurfacesSection renders")
    func testSurfacesSection() {
        let view = EditorTestEnvironment {
            ScrollView {
                GentleDesignSurfacesSection()
                    .padding(16)
            }
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 380, height: 600)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

@Suite("Studio and Customize View Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct StudioViewSnapshotTests {

    @Test("GentleDesignStudioView renders")
    func testStudioView() {
        let view = EditorTestEnvironment {
            GentleDesignStudioView()
        }
        .environment(\.colorScheme, .light)
        .frame(width: 400, height: 700)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("GentleThemeEditor renders")
    func testThemeEditor() {
        let view = EditorTestEnvironment {
            GentleThemeEditor()
        }
        .environment(\.colorScheme, .light)
        .frame(width: 400, height: 800)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("GentleThemeEditor with editable title")
    func testThemeEditorEditableTitle() {
        let view = EditorTestEnvironment {
            GentleThemeEditor(isTitleEditable: true)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 400, height: 800)

        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }
}

@Suite("Preset Comparison Image Snapshot Tests", .snapshots(record: .missing))
@MainActor
struct PresetComparisonImageSnapshotTests {

    @Test("GentleDefault preset UI")
    func testGentleDefaultPresetUI() {
        let view = makePresetPreview(spec: .gentleDefault, name: "Gentle Default")
        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Classic preset UI")
    func testClassicPresetUI() {
        let view = makePresetPreview(spec: .classic, name: "Classic")
        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Modern preset UI")
    func testModernPresetUI() {
        let view = makePresetPreview(spec: .modern, name: "Modern")
        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Soft preset UI")
    func testSoftPresetUI() {
        let view = makePresetPreview(spec: .soft, name: "Soft")
        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    @Test("Compact preset UI")
    func testCompactPresetUI() {
        let view = makePresetPreview(spec: .compact, name: "Compact")
        assertSnapshot(of: view, as: .imageHEIC(layout: .sizeThatFits, compressionQuality: .maximum))
    }

    private func makePresetPreview(spec: GentleDesignSystemSpec, name: String) -> some View {
        let theme = GentleTheme(defaultSpec: spec)

        return GentleThemeRoot(theme: theme) {
            VStack(alignment: .leading, spacing: 12) {
                Text(name)
                    .gentleText(.title_xl)

                Text("Body text sample for this preset theme.")
                    .gentleText(.body_m)

                HStack(spacing: 8) {
                    Button("Primary") {}
                        .gentleButton(.primary)

                    Button("Secondary") {}
                        .gentleButton(.secondary)
                }
            }
            .padding(20)
            .gentleSurface(.card, inset: .card)
            .padding(16)
            .background(Color.white)
        }
        .environment(\.colorScheme, .light)
        .frame(width: 350)
    }
}
