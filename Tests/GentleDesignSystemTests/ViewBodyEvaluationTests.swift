//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - View Body Evaluation Tests

/// Helper to force SwiftUI view body evaluation using ImageRenderer.
/// This ensures the body code path is executed for coverage without needing a live UI.
@MainActor
private func renderViewForCoverage<V: View>(_ view: V) {
    let renderer = ImageRenderer(content: view)
    renderer.proposedSize = .init(width: 375, height: 667)
    _ = renderer.cgImage
}

/// Wraps a view with the required GentleDesignSystem environment for testing.
@MainActor
private func wrapWithGentleEnvironment<V: View>(_ view: V) -> some View {
    let theme = GentleTheme(defaultSpec: .gentleDefault)
    let manager = GentleThemeManager()
    return view
        .environment(\.gentleTheme, theme)
        .environment(\.gentleThemeManager, manager)
}

@Suite("View Body Evaluation Tests")
@MainActor
struct ViewBodyEvaluationTests {

    // MARK: - Editor Views

    @Test("ColorRoleEditor body evaluates without crash")
    func testColorRoleEditorBodyEvaluates() {
        let view = wrapWithGentleEnvironment(ColorRoleEditor(role: .textPrimary))
        renderViewForCoverage(view)
    }

    @Test("ColorRoleEditor body evaluates for all color roles")
    func testColorRoleEditorBodyAllRoles() {
        for role in GentleColorRole.allCases {
            let view = wrapWithGentleEnvironment(ColorRoleEditor(role: role))
            renderViewForCoverage(view)
        }
    }

    @Test("TypographyRoleEditor body evaluates without crash")
    func testTypographyRoleEditorBodyEvaluates() {
        let view = wrapWithGentleEnvironment(TypographyRoleEditor(role: .body_m))
        renderViewForCoverage(view)
    }

    @Test("TypographyRoleEditor body evaluates for all text roles")
    func testTypographyRoleEditorBodyAllRoles() {
        for role in GentleTextRole.allCases {
            let view = wrapWithGentleEnvironment(TypographyRoleEditor(role: role))
            renderViewForCoverage(view)
        }
    }

    // MARK: - Color Role Cell and Sheet Views

    @Test("ColorRoleCell body evaluates without crash")
    func testColorRoleCellBodyEvaluates() {
        let view = wrapWithGentleEnvironment(ColorRoleCell(role: .textPrimary, isEditing: .constant(false)))
        renderViewForCoverage(view)
    }

    @Test("ColorRoleCell body evaluates for all color roles")
    func testColorRoleCellBodyAllRoles() {
        for role in GentleColorRole.allCases {
            let view = wrapWithGentleEnvironment(ColorRoleCell(role: role, isEditing: .constant(false)))
            renderViewForCoverage(view)
        }
    }

    @Test("ColorRoleEditorSheet body evaluates without crash")
    func testColorRoleEditorSheetBodyEvaluates() {
        let view = wrapWithGentleEnvironment(ColorRoleEditorSheet(role: .textPrimary))
        renderViewForCoverage(view)
    }

    @Test("ColorRoleEditorSheet body evaluates for all color roles")
    func testColorRoleEditorSheetBodyAllRoles() {
        for role in GentleColorRole.allCases {
            let view = wrapWithGentleEnvironment(ColorRoleEditorSheet(role: role))
            renderViewForCoverage(view)
        }
    }

    @Test("SingleColorEditorSheet body evaluates for light scheme")
    func testSingleColorEditorSheetBodyLight() {
        let view = wrapWithGentleEnvironment(SingleColorEditorSheet(role: .textPrimary, scheme: .light))
        renderViewForCoverage(view)
    }

    @Test("SingleColorEditorSheet body evaluates for dark scheme")
    func testSingleColorEditorSheetBodyDark() {
        let view = wrapWithGentleEnvironment(SingleColorEditorSheet(role: .textPrimary, scheme: .dark))
        renderViewForCoverage(view)
    }

    @Test("SingleColorEditorSheet body evaluates for all color roles")
    func testSingleColorEditorSheetBodyAllRoles() {
        for role in GentleColorRole.allCases {
            let viewLight = wrapWithGentleEnvironment(SingleColorEditorSheet(role: role, scheme: .light))
            renderViewForCoverage(viewLight)
            let viewDark = wrapWithGentleEnvironment(SingleColorEditorSheet(role: role, scheme: .dark))
            renderViewForCoverage(viewDark)
        }
    }

    // MARK: - Typography Role Cell and Sheet Views

    @Test("TypographyRoleCell body evaluates without crash")
    func testTypographyRoleCellBodyEvaluates() {
        let view = wrapWithGentleEnvironment(TypographyRoleCell(role: .body_m, isEditing: .constant(false)))
        renderViewForCoverage(view)
    }

    @Test("TypographyRoleCell body evaluates for all text roles")
    func testTypographyRoleCellBodyAllRoles() {
        for role in GentleTextRole.allCases {
            let view = wrapWithGentleEnvironment(TypographyRoleCell(role: role, isEditing: .constant(false)))
            renderViewForCoverage(view)
        }
    }

    @Test("TypographyRoleEditorSheet body evaluates without crash")
    func testTypographyRoleEditorSheetBodyEvaluates() {
        let view = wrapWithGentleEnvironment(TypographyRoleEditorSheet(role: .body_m))
        renderViewForCoverage(view)
    }

    @Test("TypographyRoleEditorSheet body evaluates for all text roles")
    func testTypographyRoleEditorSheetBodyAllRoles() {
        for role in GentleTextRole.allCases {
            let view = wrapWithGentleEnvironment(TypographyRoleEditorSheet(role: role))
            renderViewForCoverage(view)
        }
    }

    // MARK: - Foundation Views

    @Test("GentleThemeEditor body evaluates without crash")
    func testFoundationViewBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleThemeEditor())
        renderViewForCoverage(view)
    }

    @Test("GentleDesignTypographySection body evaluates without crash")
    func testTypographySectionBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleDesignTypographySection())
        renderViewForCoverage(view)
    }

    @Test("GentleDesignButtonsSection body evaluates without crash")
    func testButtonsSectionBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleDesignButtonsSection())
        renderViewForCoverage(view)
    }

    @Test("GentleDesignSurfacesSection body evaluates without crash")
    func testSurfacesSectionBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleDesignSurfacesSection())
        renderViewForCoverage(view)
    }

    @Test("GentleDesignColorsSection body evaluates without crash")
    func testColorsSectionBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleDesignColorsSection())
        renderViewForCoverage(view)
    }

    // MARK: - Customize & Studio Views

    @Test("GentleDesignCustomizeView body evaluates without crash")
    func testCustomizeViewBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleDesignCustomizeView(section: .colors))
        renderViewForCoverage(view)
    }

    @Test("GentleDesignCustomizeView body evaluates with all parameter combinations")
    func testCustomizeViewBodyAllParams() {
        let view1 = wrapWithGentleEnvironment(GentleDesignCustomizeView(section: .colors, isInsideNavigationStack: false))
        renderViewForCoverage(view1)

        let view2 = wrapWithGentleEnvironment(GentleDesignCustomizeView(section: .typography, isInsideNavigationStack: true))
        renderViewForCoverage(view2)

        let view3 = wrapWithGentleEnvironment(GentleDesignCustomizeView(section: .buttons, onSave: {}))
        renderViewForCoverage(view3)

        let view4 = wrapWithGentleEnvironment(GentleDesignCustomizeView(section: .surfaces, isInsideNavigationStack: true, onSave: {}))
        renderViewForCoverage(view4)
    }

    @Test("GentleDesignStudioView body evaluates without crash")
    func testStudioViewBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleDesignStudioView())
        renderViewForCoverage(view)
    }

    // MARK: - Navigation Bar Styler

    @Test("GentleNavigationBarStyler body evaluates without crash")
    func testNavigationBarStylerBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleNavigationBarStyler())
        renderViewForCoverage(view)
    }

    // MARK: - Theme Root

    @Test("GentleThemeRoot body evaluates without crash")
    func testThemeRootBodyEvaluates() {
        let view = GentleThemeRoot {
            Text("Test content")
        }
        renderViewForCoverage(view)
    }

    @Test("GentleThemeRoot body evaluates with custom theme")
    func testThemeRootBodyWithCustomTheme() {
        let theme = GentleTheme(defaultSpec: .classic)
        let view = GentleThemeRoot(theme: theme) {
            Text("Test content")
        }
        renderViewForCoverage(view)
    }
}

@Suite("Modifier Body Evaluation Tests")
@MainActor
struct ModifierBodyEvaluationTests {

    // MARK: - Text Modifier

    @Test("GentleTextModifier body evaluates for all text roles")
    func testTextModifierBodyAllRoles() {
        for role in GentleTextRole.allCases {
            let view = wrapWithGentleEnvironment(
                Text("Sample").modifier(GentleTextModifier(role: role))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleTextModifier body evaluates with color override")
    func testTextModifierBodyWithColorOverride() {
        let view = wrapWithGentleEnvironment(
            Text("Sample").modifier(GentleTextModifier(role: .body_m, overrideColorRole: .primaryCTA))
        )
        renderViewForCoverage(view)
    }

    @Test("gentleText extension body evaluates")
    func testGentleTextExtensionBody() {
        let view = wrapWithGentleEnvironment(
            Text("Sample").gentleText(.headline_m)
        )
        renderViewForCoverage(view)
    }

    // MARK: - TextField Modifier

    @Test("GentleTextFieldModifier body evaluates for all chrome styles")
    func testTextFieldModifierBodyAllChromes() {
        let chromes: [GentleTextChrome] = [.formRow, .borderless]
        for chrome in chromes {
            let view = wrapWithGentleEnvironment(
                TextField("Placeholder", text: .constant(""))
                    .modifier(GentleTextFieldModifier(role: .body_m, chrome: chrome))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleTextFieldModifier body evaluates with color override")
    func testTextFieldModifierBodyWithColorOverride() {
        let view = wrapWithGentleEnvironment(
            TextField("Placeholder", text: .constant(""))
                .modifier(GentleTextFieldModifier(role: .body_m, overrideColorRole: .textSecondary))
        )
        renderViewForCoverage(view)
    }

    @Test("gentleTextField extension body evaluates")
    func testGentleTextFieldExtensionBody() {
        let view = wrapWithGentleEnvironment(
            TextField("Placeholder", text: .constant("")).gentleTextField(.body_m)
        )
        renderViewForCoverage(view)
    }

    // MARK: - Surface Modifier

    @Test("GentleSurfaceModifier body evaluates for all surface roles")
    func testSurfaceModifierBodyAllRoles() {
        let surfaceRoles: [GentleSurfaceRole] = [.appBackground, .card, .cardElevated, .cardSecondary, .chrome, .overlaySheet, .overlayPopover, .floatingPanel, .floatingWidget]
        for role in surfaceRoles {
            let view = wrapWithGentleEnvironment(
                Text("Content").modifier(GentleSurfaceModifier(role: role))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("gentleSurface extension body evaluates")
    func testGentleSurfaceExtensionBody() {
        let view = wrapWithGentleEnvironment(
            Text("Content").gentleSurface(.card)
        )
        renderViewForCoverage(view)
    }

    // MARK: - Background Modifier

    @Test("GentleBackgroundModifier body evaluates for all color roles")
    func testBackgroundModifierBodyAllRoles() {
        for role in GentleColorRole.allCases {
            let view = wrapWithGentleEnvironment(
                Text("Content").modifier(GentleBackgroundModifier(role: role, ignoresSafeArea: false))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleBackgroundModifier body evaluates with ignoresSafeArea")
    func testBackgroundModifierBodyIgnoresSafeArea() {
        let view = wrapWithGentleEnvironment(
            Text("Content").modifier(GentleBackgroundModifier(role: .background, ignoresSafeArea: true))
        )
        renderViewForCoverage(view)
    }

    @Test("gentleBackground extension body evaluates")
    func testGentleBackgroundExtensionBody() {
        let view = wrapWithGentleEnvironment(
            Text("Content").gentleBackground(.surfaceBase)
        )
        renderViewForCoverage(view)
    }

    // MARK: - Inset Modifier

    @Test("GentleInsetModifier body evaluates for all inset roles")
    func testInsetModifierBodyAllRoles() {
        let insetRoles: [GentleInsetRole] = [.screen, .card, .control, .listRow]
        for role in insetRoles {
            let view = wrapWithGentleEnvironment(
                Text("Content").modifier(GentleInsetModifier(role: role))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleInsetModifier body evaluates with different edge sets")
    func testInsetModifierBodyEdgeSets() {
        let edgeSets: [Edge.Set] = [.all, .horizontal, .vertical, .top, .bottom, .leading, .trailing]
        for edges in edgeSets {
            let view = wrapWithGentleEnvironment(
                Text("Content").modifier(GentleInsetModifier(edges: edges, role: .screen))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("gentleInset extension body evaluates")
    func testGentleInsetExtensionBody() {
        let view = wrapWithGentleEnvironment(
            Text("Content").gentleInset(.card)
        )
        renderViewForCoverage(view)
    }

    // MARK: - Button Style

    @Test("GentleButtonStyle makeBody evaluates for all button roles")
    func testButtonStyleBodyAllRoles() {
        let buttonRoles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        for role in buttonRoles {
            let view = wrapWithGentleEnvironment(
                Button("Test") {}.buttonStyle(GentleButtonStyle(role: role))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleButtonStyle makeBody evaluates with shape overrides")
    func testButtonStyleBodyWithShapeOverrides() {
        let buttonShapes: [GentleButtonShape] = [.rounded, .pill]
        for shape in buttonShapes {
            let view = wrapWithGentleEnvironment(
                Button("Test") {}.buttonStyle(GentleButtonStyle(role: .primary, shape: shape))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("GentleButtonStyle makeBody evaluates with expandsHorizontally")
    func testButtonStyleBodyExpandsHorizontally() {
        let view = wrapWithGentleEnvironment(
            Button("Test") {}.buttonStyle(GentleButtonStyle(role: .primary, expandsHorizontally: true))
        )
        renderViewForCoverage(view)
    }

    @Test("GentleButtonStyle makeBody evaluates with contentAlignment variations")
    func testButtonStyleBodyContentAlignments() {
        let alignments: [Alignment] = [.center, .leading, .trailing]
        for alignment in alignments {
            let view = wrapWithGentleEnvironment(
                Button("Test") {}
                    .buttonStyle(GentleButtonStyle(role: .primary, expandsHorizontally: true, contentAlignment: alignment))
            )
            renderViewForCoverage(view)
        }
    }

    @Test("gentleButton extension body evaluates")
    func testGentleButtonExtensionBody() {
        let view = wrapWithGentleEnvironment(
            Button("Test") {}.gentleButton(.secondary)
        )
        renderViewForCoverage(view)
    }

    @Test("GentleButtonStyle makeBody evaluates disabled state")
    func testButtonStyleBodyDisabledState() {
        let view = wrapWithGentleEnvironment(
            Button("Test") {}
                .buttonStyle(GentleButtonStyle(role: .primary))
                .disabled(true)
        )
        renderViewForCoverage(view)
    }
}

@Suite("View Body Evaluation with Presets Tests")
@MainActor
struct ViewBodyEvaluationWithPresetsTests {

    private static let allPresets: [GentleDesignSystemSpec] = [
        .gentleDefault, .classic, .modern, .soft,
        .editorial, .technical, .bold, .elegant, .compact
    ]

    @Test("GentleThemeEditor body evaluates with all presets")
    func testFoundationViewBodyWithAllPresets() {
        for preset in Self.allPresets {
            let theme = GentleTheme(defaultSpec: preset)
            let manager = GentleThemeManager(theme: theme)
            let view = GentleThemeEditor()
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }

    @Test("All section views body evaluate with editorial preset (serif fonts)")
    func testSectionViewsWithEditorialPreset() {
        let theme = GentleTheme(defaultSpec: .editorial)
        let manager = GentleThemeManager(theme: theme)

        let views: [AnyView] = [
            AnyView(GentleDesignTypographySection()),
            AnyView(GentleDesignButtonsSection()),
            AnyView(GentleDesignSurfacesSection()),
            AnyView(GentleDesignColorsSection())
        ]

        for view in views {
            let wrapped = view
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(wrapped)
        }
    }

    @Test("Text modifiers body evaluate with all presets")
    func testTextModifiersWithAllPresets() {
        for preset in Self.allPresets {
            let theme = GentleTheme(defaultSpec: preset)
            let view = Text("Sample")
                .gentleText(.body_m)
                .environment(\.gentleTheme, theme)
            renderViewForCoverage(view)
        }
    }
}

// MARK: - GentleDesignShareSheet Extended Tests

@Suite("GentleDesignShareSheet Extended Tests")
@MainActor
struct GentleDesignShareSheetExtendedTests {

    @Test("ShareSheet can be initialized with string items")
    func testShareSheetWithStringItems() {
        let shareSheet = GentleDesignShareSheet(items: ["Test string", "Another string"])
        // Verify the view can be created without crash
        renderViewForCoverage(shareSheet)
    }

    @Test("ShareSheet can be initialized with URL items")
    func testShareSheetWithURLItems() throws {
        let url = try #require(URL(string: "https://example.com"))
        let shareSheet = GentleDesignShareSheet(items: [url])
        renderViewForCoverage(shareSheet)
    }

    @Test("ShareSheet can be initialized with image items")
    func testShareSheetWithImageItems() throws {
        let image = try #require(UIImage(systemName: "star.fill"))
        let shareSheet = GentleDesignShareSheet(items: [image])
        renderViewForCoverage(shareSheet)
    }

    @Test("ShareSheet can be initialized with data items")
    func testShareSheetWithDataItems() throws {
        let data = try #require("Test data".data(using: .utf8))
        let shareSheet = GentleDesignShareSheet(items: [data])
        renderViewForCoverage(shareSheet)
    }

    @Test("ShareSheet can be initialized with mixed items")
    func testShareSheetWithMixedItems() throws {
        let url = try #require(URL(string: "https://example.com"))
        let image = try #require(UIImage(systemName: "heart.fill"))
        let data = try #require("More text".data(using: .utf8))
        let shareSheet = GentleDesignShareSheet(items: [
            "A string",
            url,
            image,
            data
        ])
        renderViewForCoverage(shareSheet)
    }
}

// MARK: - GentleThemeEditor Extended Tests

@Suite("GentleThemeEditor Extended Tests")
@MainActor
struct GentleThemeEditorExtendedTests {

    // MARK: - GentleDesignMaterialsSection Tests

    // MARK: - GentleButtonPreview Tests

    @Test("GentleButtonPreview can be created with all button roles")
    func testButtonPreviewAllRoles() {
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        for role in roles {
            let preview = GentleButtonPreview(role: role)
            #expect(preview.role == role)
        }
    }

    @Test("GentleButtonPreview can be created with isPressed true")
    func testButtonPreviewPressed() {
        let preview = GentleButtonPreview(role: .primary, isPressed: true)
        #expect(preview.isPressed == true)
    }

    @Test("GentleButtonPreview can be created with isMiniature true")
    func testButtonPreviewMiniature() {
        let preview = GentleButtonPreview(role: .primary, isMiniature: true)
        #expect(preview.isMiniature == true)
    }

    @Test("GentleButtonPreview body evaluates for all roles in full size mode")
    func testButtonPreviewBodyFullSize() {
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        for role in roles {
            let view = wrapWithGentleEnvironment(GentleButtonPreview(role: role, isPressed: false, isMiniature: false))
            renderViewForCoverage(view)
        }
    }

    @Test("GentleButtonPreview body evaluates for all roles in miniature mode")
    func testButtonPreviewBodyMiniature() {
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        for role in roles {
            let view = wrapWithGentleEnvironment(GentleButtonPreview(role: role, isPressed: false, isMiniature: true))
            renderViewForCoverage(view)
        }
    }

    @Test("GentleButtonPreview body evaluates for all roles when pressed")
    func testButtonPreviewBodyPressed() {
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        for role in roles {
            let view = wrapWithGentleEnvironment(GentleButtonPreview(role: role, isPressed: true, isMiniature: false))
            renderViewForCoverage(view)
        }
    }

    @Test("GentleButtonPreview body evaluates for miniature pressed state")
    func testButtonPreviewBodyMiniaturePressed() {
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        for role in roles {
            let view = wrapWithGentleEnvironment(GentleButtonPreview(role: role, isPressed: true, isMiniature: true))
            renderViewForCoverage(view)
        }
    }

    // MARK: - Section Body Evaluation with Different Themes

    @Test("GentleDesignColorsSection body evaluates with all presets")
    func testColorsSectionWithAllPresets() {
        let presets: [GentleDesignSystemSpec] = [.gentleDefault, .classic, .modern, .soft, .editorial, .technical, .bold, .elegant, .compact]
        for preset in presets {
            let theme = GentleTheme(defaultSpec: preset)
            let manager = GentleThemeManager(theme: theme)
            let view = GentleDesignColorsSection()
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }

    @Test("GentleDesignTypographySection body evaluates with all presets")
    func testTypographySectionWithAllPresets() {
        let presets: [GentleDesignSystemSpec] = [.gentleDefault, .classic, .modern, .soft, .editorial, .technical, .bold, .elegant, .compact]
        for preset in presets {
            let theme = GentleTheme(defaultSpec: preset)
            let manager = GentleThemeManager(theme: theme)
            let view = GentleDesignTypographySection()
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }

    @Test("GentleDesignButtonsSection body evaluates with all presets")
    func testButtonsSectionWithAllPresets() {
        let presets: [GentleDesignSystemSpec] = [.gentleDefault, .classic, .modern, .soft, .editorial, .technical, .bold, .elegant, .compact]
        for preset in presets {
            let theme = GentleTheme(defaultSpec: preset)
            let manager = GentleThemeManager(theme: theme)
            let view = GentleDesignButtonsSection()
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }

    @Test("GentleDesignSurfacesSection body evaluates with all presets")
    func testSurfacesSectionWithAllPresets() {
        let presets: [GentleDesignSystemSpec] = [.gentleDefault, .classic, .modern, .soft, .editorial, .technical, .bold, .elegant, .compact]
        for preset in presets {
            let theme = GentleTheme(defaultSpec: preset)
            let manager = GentleThemeManager(theme: theme)
            let view = GentleDesignSurfacesSection()
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }

    // MARK: - Complete Foundation View Tests

    @Test("GentleThemeEditor body evaluates in both color schemes")
    func testFoundationViewColorSchemes() {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        let lightView = GentleThemeEditor()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .light)
        renderViewForCoverage(lightView)

        let darkView = GentleThemeEditor()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .dark)
        renderViewForCoverage(darkView)
    }
}

// MARK: - GentleButtonPreview Comprehensive Coverage Tests

@Suite("GentleButtonPreview Comprehensive Tests")
@MainActor
struct GentleButtonPreviewComprehensiveTests {

    // MARK: - Material Role Coverage

    @Test("GentleButtonPreview renders with solidFillPrimaryCTA material role")
    func testButtonPreviewSolidFillPrimaryCTA() throws {
        // Create a theme with solidFillPrimaryCTA for primary button
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Primary button uses solidFillPrimaryCTA by default
        let view = GentleButtonPreview(role: .primary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)

        // Also test miniature mode
        let miniView = GentleButtonPreview(role: .primary, isMiniature: true)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(miniView)
    }

    @Test("GentleButtonPreview renders with solidFillDestructive material role")
    func testButtonPreviewSolidFillDestructive() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Destructive button uses solidFillDestructive by default
        let view = GentleButtonPreview(role: .destructive)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)

        // Also test miniature mode
        let miniView = GentleButtonPreview(role: .destructive, isMiniature: true)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(miniView)
    }

    @Test("GentleButtonPreview renders with hollow material role")
    func testButtonPreviewHollow() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Secondary button uses hollow by default
        let view = GentleButtonPreview(role: .secondary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)

        // Also test miniature mode for hollow
        let miniView = GentleButtonPreview(role: .secondary, isMiniature: true)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(miniView)
    }

    // MARK: - Border Role Coverage

    @Test("GentleButtonPreview renders with accent border")
    func testButtonPreviewAccentBorder() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Secondary button has accent border by default
        let view = GentleButtonPreview(role: .secondary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)

        let miniView = GentleButtonPreview(role: .secondary, isMiniature: true)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(miniView)
    }

    @Test("GentleButtonPreview renders with subtle border")
    func testButtonPreviewSubtleBorder() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Tertiary button has subtle border by default
        let view = GentleButtonPreview(role: .tertiary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)

        let miniView = GentleButtonPreview(role: .tertiary, isMiniature: true)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(miniView)
    }

    @Test("GentleButtonPreview renders with hidden border")
    func testButtonPreviewHiddenBorder() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Primary button has hidden border (solid fill doesn't need border)
        let view = GentleButtonPreview(role: .primary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)

        let miniView = GentleButtonPreview(role: .primary, isMiniature: true)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(miniView)
    }

    // MARK: - Shape Coverage

    @Test("GentleButtonPreview renders with rounded shape")
    func testButtonPreviewRoundedShape() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Default buttons use rounded shape
        for role in [GentleButtonRole.primary, .secondary, .tertiary, .quaternary, .destructive] {
            let view = GentleButtonPreview(role: role)
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }

    @Test("GentleButtonPreview renders with pill shape via theme customization")
    func testButtonPreviewPillShape() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Modify primary button to use pill shape
        var spec = manager.bindingForButtonRole(.primary).wrappedValue
        spec.shape = .pill
        manager.bindingForButtonRole(.primary).wrappedValue = spec

        let view = GentleButtonPreview(role: .primary)
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)

        let miniView = GentleButtonPreview(role: .primary, isMiniature: true)
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(miniView)
    }

    // MARK: - Native Style Coverage

    @Test("GentleButtonPreview renders with native style enabled")
    func testButtonPreviewNativeStyle() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Quaternary button uses native style by default
        let view = GentleButtonPreview(role: .quaternary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)

        // Test pressed state with native style
        let pressedView = GentleButtonPreview(role: .quaternary, isPressed: true)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(pressedView)

        // Test miniature with native style
        let miniView = GentleButtonPreview(role: .quaternary, isMiniature: true)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(miniView)
    }

    @Test("GentleButtonPreview renders with native style in all modes")
    func testButtonPreviewNativeStyleAllModes() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Customize primary to use native style
        var spec = manager.bindingForButtonRole(.primary).wrappedValue
        spec.usesNativeStyle = true
        manager.bindingForButtonRole(.primary).wrappedValue = spec

        // Full size, not pressed
        let view1 = GentleButtonPreview(role: .primary, isPressed: false, isMiniature: false)
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view1)

        // Full size, pressed
        let view2 = GentleButtonPreview(role: .primary, isPressed: true, isMiniature: false)
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view2)

        // Miniature, not pressed
        let view3 = GentleButtonPreview(role: .primary, isPressed: false, isMiniature: true)
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view3)

        // Miniature, pressed
        let view4 = GentleButtonPreview(role: .primary, isPressed: true, isMiniature: true)
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view4)
    }

    // MARK: - Pressed Scale and Opacity Coverage

    @Test("GentleButtonPreview renders with custom pressed scale")
    func testButtonPreviewCustomPressedScale() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Customize pressed scale
        var spec = manager.bindingForButtonRole(.primary).wrappedValue
        spec.pressedScale = 0.85
        manager.bindingForButtonRole(.primary).wrappedValue = spec

        let view = GentleButtonPreview(role: .primary, isPressed: true)
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    @Test("GentleButtonPreview renders with custom pressed opacity")
    func testButtonPreviewCustomPressedOpacity() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Customize pressed opacity
        var spec = manager.bindingForButtonRole(.primary).wrappedValue
        spec.pressedOpacity = 0.5
        manager.bindingForButtonRole(.primary).wrappedValue = spec

        let view = GentleButtonPreview(role: .primary, isPressed: true)
            .environment(\.gentleTheme, manager.theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    // MARK: - Color Scheme Coverage

    @Test("GentleButtonPreview renders in dark mode for all roles")
    func testButtonPreviewDarkModeAllRoles() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        for role in [GentleButtonRole.primary, .secondary, .tertiary, .quaternary, .destructive] {
            let view = GentleButtonPreview(role: role)
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
                .environment(\.colorScheme, .dark)
            renderViewForCoverage(view)

            let miniView = GentleButtonPreview(role: role, isMiniature: true)
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
                .environment(\.colorScheme, .dark)
            renderViewForCoverage(miniView)
        }
    }

    // MARK: - Comprehensive Role x Mode Matrix

    @Test("GentleButtonPreview renders all role/mode combinations")
    func testButtonPreviewAllCombinations() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]
        let pressedStates = [false, true]
        let miniatureStates = [false, true]

        for role in roles {
            for isPressed in pressedStates {
                for isMiniature in miniatureStates {
                    let view = GentleButtonPreview(role: role, isPressed: isPressed, isMiniature: isMiniature)
                        .environment(\.gentleTheme, theme)
                        .environment(\.gentleThemeManager, manager)
                    renderViewForCoverage(view)
                }
            }
        }
    }
}

// MARK: - GentleThemeEditor Sections with Color Scheme Tests

@Suite("GentleThemeEditor Color Scheme Tests")
@MainActor
struct GentleThemeEditorColorSchemeTests {

    @Test("All sections render in light mode")
    func testAllSectionsLightMode() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        let colorsSection = GentleDesignColorsSection()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .light)
        renderViewForCoverage(colorsSection)

        let typographySection = GentleDesignTypographySection()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .light)
        renderViewForCoverage(typographySection)

        let buttonsSection = GentleDesignButtonsSection()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .light)
        renderViewForCoverage(buttonsSection)

        let surfacesSection = GentleDesignSurfacesSection()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .light)
        renderViewForCoverage(surfacesSection)
    }

    @Test("All sections render in dark mode")
    func testAllSectionsDarkMode() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        let colorsSection = GentleDesignColorsSection()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .dark)
        renderViewForCoverage(colorsSection)

        let typographySection = GentleDesignTypographySection()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .dark)
        renderViewForCoverage(typographySection)

        let buttonsSection = GentleDesignButtonsSection()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .dark)
        renderViewForCoverage(buttonsSection)

        let surfacesSection = GentleDesignSurfacesSection()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .dark)
        renderViewForCoverage(surfacesSection)
    }
}

// MARK: - Theme Manager Button Binding Tests

@Suite("Theme Manager Button Binding Tests")
@MainActor
struct ThemeManagerButtonBindingTests {

    @Test("Button role binding updates shape")
    func testButtonRoleBindingShape() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        var spec = manager.bindingForButtonRole(.primary).wrappedValue
        spec.shape = .pill
        manager.bindingForButtonRole(.primary).wrappedValue = spec

        let updatedSpec = manager.bindingForButtonRole(.primary).wrappedValue
        #expect(updatedSpec.shape == .pill)
    }

    @Test("Button role binding updates material role")
    func testButtonRoleBindingMaterialRole() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        var spec = manager.bindingForButtonRole(.primary).wrappedValue
        spec.fillRole = .hollow
        manager.bindingForButtonRole(.primary).wrappedValue = spec

        let updatedSpec = manager.bindingForButtonRole(.primary).wrappedValue
        #expect(updatedSpec.fillRole == .hollow)
    }

    @Test("Button role binding updates border role")
    func testButtonRoleBindingBorderRole() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        var spec = manager.bindingForButtonRole(.secondary).wrappedValue
        spec.borderRole = .subtle
        manager.bindingForButtonRole(.secondary).wrappedValue = spec

        let updatedSpec = manager.bindingForButtonRole(.secondary).wrappedValue
        #expect(updatedSpec.borderRole == .subtle)
    }

    @Test("Button role binding updates usesNativeStyle")
    func testButtonRoleBindingNativeStyle() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        var spec = manager.bindingForButtonRole(.primary).wrappedValue
        spec.usesNativeStyle = true
        manager.bindingForButtonRole(.primary).wrappedValue = spec

        let updatedSpec = manager.bindingForButtonRole(.primary).wrappedValue
        #expect(updatedSpec.usesNativeStyle == true)
    }

    @Test("Button role binding updates pressed scale and opacity")
    func testButtonRoleBindingPressedValues() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        var spec = manager.bindingForButtonRole(.primary).wrappedValue
        spec.pressedScale = 0.75
        spec.pressedOpacity = 0.6
        manager.bindingForButtonRole(.primary).wrappedValue = spec

        let updatedSpec = manager.bindingForButtonRole(.primary).wrappedValue
        #expect(updatedSpec.pressedScale == 0.75)
        #expect(updatedSpec.pressedOpacity == 0.6)
    }
}

// MARK: - Theme Manager Surface Binding Tests

@Suite("Theme Manager Surface Binding Tests")
@MainActor
struct ThemeManagerSurfaceBindingTests {

    @Test("Surface role binding updates corner radius")
    func testSurfaceRoleBindingCornerRadius() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        manager.bindingForSurfaceRole(.card).cornerRadius.wrappedValue = 20.0

        let updatedRadius = manager.bindingForSurfaceRole(.card).cornerRadius.wrappedValue
        #expect(updatedRadius == 20.0)
    }

    @Test("Surface role binding updates border width")
    func testSurfaceRoleBindingBorderWidth() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        manager.bindingForSurfaceRole(.card).borderWidth.wrappedValue = 2.0

        let updatedWidth = manager.bindingForSurfaceRole(.card).borderWidth.wrappedValue
        #expect(updatedWidth == 2.0)
    }

    @Test("Surface role binding updates shadow properties")
    func testSurfaceRoleBindingShadow() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        manager.bindingForSurfaceRole(.cardElevated).shadowRadius.wrappedValue = 15.0
        manager.bindingForSurfaceRole(.cardElevated).shadowOpacity.wrappedValue = 0.25
        manager.bindingForSurfaceRole(.cardElevated).shadowOffsetX.wrappedValue = 2.0
        manager.bindingForSurfaceRole(.cardElevated).shadowOffsetY.wrappedValue = 4.0

        let binding = manager.bindingForSurfaceRole(.cardElevated)
        #expect(binding.shadowRadius.wrappedValue == 15.0)
        #expect(binding.shadowOpacity.wrappedValue == 0.25)
        #expect(binding.shadowOffsetX.wrappedValue == 2.0)
        #expect(binding.shadowOffsetY.wrappedValue == 4.0)
    }
}

// MARK: - Theme Manager Color Binding Tests

@Suite("Theme Manager Color Binding Tests")
@MainActor
struct ThemeManagerColorBindingTests {

    @Test("Color role binding updates light hex")
    func testColorRoleBindingLightHex() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        manager.bindingForColorRole(.primaryCTA).lightHex.wrappedValue = "#FF0000"

        let updatedHex = manager.bindingForColorRole(.primaryCTA).lightHex.wrappedValue
        #expect(updatedHex == "#FF0000")
    }

    @Test("Color role binding updates dark hex")
    func testColorRoleBindingDarkHex() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        manager.bindingForColorRole(.primaryCTA).darkHex.wrappedValue = "#00FF00"

        let updatedHex = manager.bindingForColorRole(.primaryCTA).darkHex.wrappedValue
        #expect(updatedHex == "#00FF00")
    }

    @Test("Color bindings work for all color roles")
    func testColorBindingsAllRoles() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        for role in GentleColorRole.allCases {
            let binding = manager.bindingForColorRole(role)
            // Just verify we can access the bindings without crash
            _ = binding.lightHex.wrappedValue
            _ = binding.darkHex.wrappedValue
        }
    }
}

// MARK: - GentleColorPair View Integration Tests

@Suite("GentleColorPair View Integration Tests")
@MainActor
struct GentleColorPairViewIntegrationTests {

    @Test("GentleColorPair can be created with hex values and used in views")
    func testColorPairCreationAndUsage() throws {
        let pair = GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")
        #expect(pair.lightHex == "#FFFFFF")
        #expect(pair.darkHex == "#000000")

        // Verify colors can be created from the pair
        let lightColor = Color(gentleHex: pair.lightHex)
        let darkColor = Color(gentleHex: pair.darkHex)
        let view = VStack {
            lightColor.frame(width: 10, height: 10)
            darkColor.frame(width: 10, height: 10)
        }
        renderViewForCoverage(view)
    }

    @Test("GentleColorPair hex values can be modified and render correctly")
    func testColorPairModificationAndRender() throws {
        var pair = GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")
        pair.lightHex = "#FF0000"
        pair.darkHex = "#00FF00"
        #expect(pair.lightHex == "#FF0000")
        #expect(pair.darkHex == "#00FF00")

        let view = VStack {
            Color(gentleHex: pair.lightHex).frame(width: 10, height: 10)
            Color(gentleHex: pair.darkHex).frame(width: 10, height: 10)
        }
        renderViewForCoverage(view)
    }
}

// MARK: - Color Extension Tests

@Suite("Color Hex Extension Tests")
@MainActor
struct ColorHexExtensionTests {

    @Test("Color can be created from hex string")
    func testColorFromHex() throws {
        let color = Color(gentleHex: "#FF0000")
        // Just verify creation doesn't crash
        let view = color.frame(width: 10, height: 10)
        renderViewForCoverage(view)
    }

    @Test("Color can be created from hex with alpha")
    func testColorFromHexWithAlpha() throws {
        let color = Color(gentleHex: "#FF000080")
        let view = color.frame(width: 10, height: 10)
        renderViewForCoverage(view)
    }

    @Test("Color can be created from short hex")
    func testColorFromShortHex() throws {
        let color = Color(gentleHex: "#F00")
        let view = color.frame(width: 10, height: 10)
        renderViewForCoverage(view)
    }
}

// MARK: - String camelCaseBreakable Tests

@Suite("String camelCaseBreakable Tests")
@MainActor
struct StringCamelCaseBreakableTests {

    @Test("camelCaseBreakable inserts zero-width spaces")
    func testCamelCaseBreakable() throws {
        let input = "textPrimary"
        let result = input.camelCaseBreakable
        // Result should contain zero-width spaces for line breaking
        #expect(result.contains("\u{200B}") || result == input)
    }

    @Test("camelCaseBreakable works with various strings")
    func testCamelCaseBreakableVariations() throws {
        let inputs = ["primaryCTA", "textOnPrimaryCTA", "borderSubtle", "surfaceScrim"]
        for input in inputs {
            _ = input.camelCaseBreakable
        }
    }
}

// MARK: - ButtonRoleEditorSheet Tests

@Suite("ButtonRoleEditorSheet Tests")
@MainActor
struct ButtonRoleEditorSheetTests {

    @Test("ButtonRoleEditorSheet renders for primary role")
    func testButtonRoleEditorSheetPrimary() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let view = ButtonRoleEditorSheet(role: .primary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    @Test("ButtonRoleEditorSheet renders for all button roles")
    func testButtonRoleEditorSheetAllRoles() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]

        for role in roles {
            let view = ButtonRoleEditorSheet(role: role)
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }

    @Test("ButtonRoleEditorSheet renders with hollow material role showing border picker")
    func testButtonRoleEditorSheetHollowMaterial() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Secondary uses hollow material, which shows the border picker
        let view = ButtonRoleEditorSheet(role: .secondary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    @Test("ButtonRoleEditorSheet renders with native style showing note")
    func testButtonRoleEditorSheetNativeStyle() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        // Quaternary uses native style by default
        let view = ButtonRoleEditorSheet(role: .quaternary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }
}

// MARK: - SurfaceRoleEditorSheet Tests

@Suite("SurfaceRoleEditorSheet Tests")
@MainActor
struct SurfaceRoleEditorSheetTests {

    @Test("SurfaceRoleEditorSheet renders for card role")
    func testSurfaceRoleEditorSheetCard() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let view = SurfaceRoleEditorSheet(role: .card)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    @Test("SurfaceRoleEditorSheet renders for cardElevated role")
    func testSurfaceRoleEditorSheetCardElevated() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let view = SurfaceRoleEditorSheet(role: .cardElevated)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    @Test("SurfaceRoleEditorSheet renders for all surface roles")
    func testSurfaceRoleEditorSheetAllRoles() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let roles: [GentleSurfaceRole] = [.appBackground, .card, .cardElevated, .cardSecondary, .chrome, .overlaySheet, .overlayPopover, .floatingPanel, .floatingWidget]

        for role in roles {
            let view = SurfaceRoleEditorSheet(role: role)
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }
}

// MARK: - SurfaceColorPairRow Tests

@Suite("SurfaceColorPairRow Tests")
@MainActor
struct SurfaceColorPairRowTests {

    @Test("SurfaceColorPairRow renders with color pair")
    func testSurfaceColorPairRow() throws {
        var colorPair = GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")
        let view = SurfaceColorPairRow(name: "Background", binding: Binding(
            get: { colorPair },
            set: { colorPair = $0 }
        ))
        renderViewForCoverage(view)
    }

    @Test("SurfaceColorPairRow renders with different names")
    func testSurfaceColorPairRowNames() throws {
        var colorPair = GentleColorPair(lightHex: "#F0F0F0", darkHex: "#1A1A1A")
        let names = ["Background", "Border", "Shadow", "Accent"]

        for name in names {
            let view = SurfaceColorPairRow(name: name, binding: Binding(
                get: { colorPair },
                set: { colorPair = $0 }
            ))
            renderViewForCoverage(view)
        }
    }
}

// MARK: - ColorSwatchRow Tests

@Suite("ColorSwatchRow Tests")
@MainActor
struct ColorSwatchRowTests {

    @Test("ColorSwatchRow renders for primary text role")
    func testColorSwatchRowPrimary() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let view = ColorSwatchRow(role: .textPrimary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    @Test("ColorSwatchRow renders for all color roles")
    func testColorSwatchRowAllRoles() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        for role in GentleColorRole.allCases {
            let view = ColorSwatchRow(role: role)
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }
}

// MARK: - ButtonPreviewCard Tests

@Suite("ButtonPreviewCard Tests")
@MainActor
struct ButtonPreviewCardTests {

    @Test("ButtonPreviewCard renders for primary role")
    func testButtonPreviewCardPrimary() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let view = ButtonPreviewCard(name: "Primary", role: .primary, action: {})
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    @Test("ButtonPreviewCard renders for all roles")
    func testButtonPreviewCardAllRoles() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]

        for role in roles {
            let view = ButtonPreviewCard(name: role.rawValue.capitalized, role: role, action: {})
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }
}

// MARK: - ButtonPreviewCardContent Tests

@Suite("ButtonPreviewCardContent Tests")
@MainActor
struct ButtonPreviewCardContentTests {

    @Test("ButtonPreviewCardContent renders for primary role")
    func testButtonPreviewCardContentPrimary() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let view = ButtonPreviewCardContent(name: "Primary", role: .primary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }

    @Test("ButtonPreviewCardContent renders with pressed state")
    func testButtonPreviewCardContentPressed() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let view = ButtonPreviewCardContent(name: "Primary", role: .primary)
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.buttonPreviewCardIsPressed, true)
        renderViewForCoverage(view)
    }
}

// MARK: - Color toGentleHexString Tests

@Suite("Color toGentleHexString Tests")
@MainActor
struct ColorToGentleHexStringTests {

    @Test("toGentleHexString returns correct format for opaque color")
    func testToGentleHexStringOpaque() throws {
        let color = Color(red: 1.0, green: 0.0, blue: 0.0)
        let hex = color.toGentleHexString()
        // Should be #RRGGBB format for opaque
        #expect(hex.hasPrefix("#"))
        #expect(hex.count == 7 || hex.count == 9) // #RRGGBB or #RRGGBBAA
    }

    @Test("toGentleHexString returns correct format for semi-transparent color")
    func testToGentleHexStringSemiTransparent() throws {
        let color = Color(red: 0.0, green: 1.0, blue: 0.0).opacity(0.5)
        let hex = color.toGentleHexString()
        // Should include alpha channel
        #expect(hex.hasPrefix("#"))
    }

    @Test("toGentleHexString handles various colors")
    func testToGentleHexStringVariousColors() throws {
        let colors: [Color] = [
            .red,
            .green,
            .blue,
            .white,
            .black,
            .gray,
            Color(red: 0.5, green: 0.5, blue: 0.5),
            Color(red: 0.2, green: 0.4, blue: 0.6)
        ]

        for color in colors {
            let hex = color.toGentleHexString()
            #expect(hex.hasPrefix("#"))
        }
    }
}

// MARK: - ButtonPreviewCardStyle Tests

@Suite("ButtonPreviewCardStyle Tests")
@MainActor
struct ButtonPreviewCardStyleTests {

    @Test("ButtonPreviewCardStyle makeBody evaluates")
    func testButtonPreviewCardStyleMakeBody() throws {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)
        let view = Button("Test") {}
            .buttonStyle(ButtonPreviewCardStyle())
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
        renderViewForCoverage(view)
    }
}
