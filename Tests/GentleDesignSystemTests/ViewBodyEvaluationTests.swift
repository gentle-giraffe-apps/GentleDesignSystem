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

    @Test("GentleDesignFoundationView body evaluates without crash")
    func testFoundationViewBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleDesignFoundationView())
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
        let surfaceRoles: [GentleSurfaceRole] = [.appBackground, .card, .cardElevated, .surfaceOverlay]
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
            Text("Content").gentleBackground(.surface)
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

    @Test("GentleDesignFoundationView body evaluates with all presets")
    func testFoundationViewBodyWithAllPresets() {
        for preset in Self.allPresets {
            let theme = GentleTheme(defaultSpec: preset)
            let manager = GentleThemeManager(theme: theme)
            let view = GentleDesignFoundationView()
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

// MARK: - GentleDesignFoundationView Extended Tests

@Suite("GentleDesignFoundationView Extended Tests")
@MainActor
struct GentleDesignFoundationViewExtendedTests {

    // MARK: - GentleDesignMaterialsSection Tests

    @Test("GentleDesignMaterialsSection can be created and body accessed")
    func testMaterialsSectionCreation() {
        let section = GentleDesignMaterialsSection()
        // Just verify creation doesn't crash - struct is always non-nil
        let view = wrapWithGentleEnvironment(section)
        renderViewForCoverage(view)
    }

    @Test("GentleDesignMaterialsSection body evaluates without crash")
    func testMaterialsSectionBodyEvaluates() {
        let view = wrapWithGentleEnvironment(GentleDesignMaterialsSection())
        renderViewForCoverage(view)
    }

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

    @Test("GentleDesignMaterialsSection body evaluates with all presets")
    func testMaterialsSectionWithAllPresets() {
        let presets: [GentleDesignSystemSpec] = [.gentleDefault, .classic, .modern, .soft, .editorial, .technical, .bold, .elegant, .compact]
        for preset in presets {
            let theme = GentleTheme(defaultSpec: preset)
            let manager = GentleThemeManager(theme: theme)
            let view = GentleDesignMaterialsSection()
                .environment(\.gentleTheme, theme)
                .environment(\.gentleThemeManager, manager)
            renderViewForCoverage(view)
        }
    }

    // MARK: - Complete Foundation View Tests

    @Test("GentleDesignFoundationView body evaluates in both color schemes")
    func testFoundationViewColorSchemes() {
        let theme = GentleTheme(defaultSpec: .gentleDefault)
        let manager = GentleThemeManager(theme: theme)

        let lightView = GentleDesignFoundationView()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .light)
        renderViewForCoverage(lightView)

        let darkView = GentleDesignFoundationView()
            .environment(\.gentleTheme, theme)
            .environment(\.gentleThemeManager, manager)
            .environment(\.colorScheme, .dark)
        renderViewForCoverage(darkView)
    }
}
