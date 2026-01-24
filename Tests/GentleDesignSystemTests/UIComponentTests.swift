//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - ColorRoleEditor Tests

@Suite("ColorRoleEditor Tests")
@MainActor
struct ColorRoleEditorTests {

    @Test("ColorRoleEditor can be created with textPrimary role")
    func testColorRoleEditorTextPrimary() {
        _ = ColorRoleEditor(role: .textPrimary)
    }

    @Test("ColorRoleEditor can be created with all color roles")
    func testColorRoleEditorAllRoles() {
        for role in GentleColorRole.allCases {
            _ = ColorRoleEditor(role: role)
        }
    }
}

// MARK: - ColorRoleCell Tests

@Suite("ColorRoleCell Tests")
@MainActor
struct ColorRoleCellTests {

    @Test("ColorRoleCell can be created with textPrimary role")
    func testColorRoleCellTextPrimary() {
        _ = ColorRoleCell(role: .textPrimary, isEditing: .constant(false))
    }

    @Test("ColorRoleCell can be created with all color roles")
    func testColorRoleCellAllRoles() {
        for role in GentleColorRole.allCases {
            _ = ColorRoleCell(role: role, isEditing: .constant(false))
        }
    }

    @Test("ColorRoleCell can be created with editing state true")
    func testColorRoleCellEditingTrue() {
        _ = ColorRoleCell(role: .background, isEditing: .constant(true))
    }
}

// MARK: - ColorRoleEditorSheet Tests

@Suite("ColorRoleEditorSheet Tests")
@MainActor
struct ColorRoleEditorSheetTests {

    @Test("ColorRoleEditorSheet can be created with textPrimary role")
    func testColorRoleEditorSheetTextPrimary() {
        _ = ColorRoleEditorSheet(role: .textPrimary)
    }

    @Test("ColorRoleEditorSheet can be created with all color roles")
    func testColorRoleEditorSheetAllRoles() {
        for role in GentleColorRole.allCases {
            _ = ColorRoleEditorSheet(role: role)
        }
    }
}

// MARK: - SingleColorEditorSheet Tests

@Suite("SingleColorEditorSheet Tests")
@MainActor
struct SingleColorEditorSheetTests {

    @Test("SingleColorEditorSheet can be created with light scheme")
    func testSingleColorEditorSheetLight() {
        _ = SingleColorEditorSheet(role: .textPrimary, scheme: .light)
    }

    @Test("SingleColorEditorSheet can be created with dark scheme")
    func testSingleColorEditorSheetDark() {
        _ = SingleColorEditorSheet(role: .textPrimary, scheme: .dark)
    }

    @Test("SingleColorEditorSheet can be created with all color roles in light mode")
    func testSingleColorEditorSheetAllRolesLight() {
        for role in GentleColorRole.allCases {
            _ = SingleColorEditorSheet(role: role, scheme: .light)
        }
    }

    @Test("SingleColorEditorSheet can be created with all color roles in dark mode")
    func testSingleColorEditorSheetAllRolesDark() {
        for role in GentleColorRole.allCases {
            _ = SingleColorEditorSheet(role: role, scheme: .dark)
        }
    }
}

// MARK: - TypographyRoleEditor Tests

@Suite("TypographyRoleEditor Tests")
@MainActor
struct TypographyRoleEditorTests {

    @Test("TypographyRoleEditor can be created with body role")
    func testTypographyRoleEditorBody() {
        _ = TypographyRoleEditor(role: .body_m)
    }

    @Test("TypographyRoleEditor can be created with all text roles")
    func testTypographyRoleEditorAllRoles() {
        for role in GentleTextRole.allCases {
            _ = TypographyRoleEditor(role: role)
        }
    }

    @Test("TypographyRoleEditor can be created with custom size range")
    func testTypographyRoleEditorCustomSizeRange() {
        _ = TypographyRoleEditor(role: .headline_m, sizeRange: 8...72, sizeStep: 2)
    }

    @Test("TypographyRoleEditor can be created with custom spacing ranges")
    func testTypographyRoleEditorCustomSpacingRanges() {
        _ = TypographyRoleEditor(
            role: .title_xl,
            lineSpacingRange: 0...20,
            letterSpacingRange: -2.0...3.0
        )
    }
}

// MARK: - TypographyRoleCell Tests

@Suite("TypographyRoleCell Tests")
@MainActor
struct TypographyRoleCellTests {

    @Test("TypographyRoleCell can be created with body role")
    func testTypographyRoleCellBody() {
        _ = TypographyRoleCell(role: .body_m, isEditing: .constant(false))
    }

    @Test("TypographyRoleCell can be created with all text roles")
    func testTypographyRoleCellAllRoles() {
        for role in GentleTextRole.allCases {
            _ = TypographyRoleCell(role: role, isEditing: .constant(false))
        }
    }

    @Test("TypographyRoleCell can be created with editing state true")
    func testTypographyRoleCellEditingTrue() {
        _ = TypographyRoleCell(role: .headline_m, isEditing: .constant(true))
    }
}

// MARK: - TypographyRoleEditorSheet Tests

@Suite("TypographyRoleEditorSheet Tests")
@MainActor
struct TypographyRoleEditorSheetTests {

    @Test("TypographyRoleEditorSheet can be created with body role")
    func testTypographyRoleEditorSheetBody() {
        _ = TypographyRoleEditorSheet(role: .body_m)
    }

    @Test("TypographyRoleEditorSheet can be created with all text roles")
    func testTypographyRoleEditorSheetAllRoles() {
        for role in GentleTextRole.allCases {
            _ = TypographyRoleEditorSheet(role: role)
        }
    }

    @Test("TypographyRoleEditorSheet can be created with custom size range")
    func testTypographyRoleEditorSheetCustomSizeRange() {
        _ = TypographyRoleEditorSheet(role: .title_xl, sizeRange: 12...80, sizeStep: 2)
    }

    @Test("TypographyRoleEditorSheet can be created with custom spacing ranges")
    func testTypographyRoleEditorSheetCustomSpacingRanges() {
        _ = TypographyRoleEditorSheet(
            role: .headline_m,
            lineSpacingRange: 0...16,
            letterSpacingRange: -2.0...4.0
        )
    }

    @Test("TypographyRoleEditorSheet can be created with all custom parameters")
    func testTypographyRoleEditorSheetAllParams() {
        _ = TypographyRoleEditorSheet(
            role: .largeTitle_xxl,
            sizeRange: 8...100,
            sizeStep: 0.5,
            lineSpacingRange: 0...24,
            letterSpacingRange: -3.0...5.0
        )
    }
}

// MARK: - GentleDesignCustomizeView Tests

@Suite("GentleDesignCustomizeView Tests")
@MainActor
struct GentleDesignCustomizeViewTests {

    @Test("GentleDesignCustomizeView can be created with defaults")
    func testCustomizeViewDefault() {
        _ = GentleDesignCustomizeView(section: .colors)
    }

    @Test("GentleDesignCustomizeView can be created inside navigation stack")
    func testCustomizeViewInsideNavigationStack() {
        _ = GentleDesignCustomizeView(section: .typography, isInsideNavigationStack: true)
    }

    @Test("GentleDesignCustomizeView can be created with onSave callback")
    func testCustomizeViewWithOnSave() {
        _ = GentleDesignCustomizeView(section: .buttons, onSave: {})
    }

    @Test("GentleDesignCustomizeView can be created with all parameters")
    func testCustomizeViewAllParameters() {
        _ = GentleDesignCustomizeView(section: .surfaces, isInsideNavigationStack: true, onSave: {})
    }
}

// MARK: - GentleThemeEditor Tests

@Suite("GentleThemeEditor Tests")
@MainActor
struct GentleThemeEditorTests {

    @Test("GentleThemeEditor can be created")
    func testFoundationView() {
        _ = GentleThemeEditor()
    }
}

// MARK: - GentleDesignTypographySection Tests

@Suite("GentleDesignTypographySection Tests")
@MainActor
struct GentleDesignTypographySectionTests {

    @Test("GentleDesignTypographySection can be created")
    func testTypographySection() {
        _ = GentleDesignTypographySection()
    }
}

// MARK: - GentleDesignButtonsSection Tests

@Suite("GentleDesignButtonsSection Tests")
@MainActor
struct GentleDesignButtonsSectionTests {

    @Test("GentleDesignButtonsSection can be created")
    func testButtonsSection() {
        _ = GentleDesignButtonsSection()
    }
}

// MARK: - GentleDesignSurfacesSection Tests

@Suite("GentleDesignSurfacesSection Tests")
@MainActor
struct GentleDesignSurfacesSectionTests {

    @Test("GentleDesignSurfacesSection can be created")
    func testSurfacesSection() {
        _ = GentleDesignSurfacesSection()
    }
}

// MARK: - GentleDesignColorsSection Tests

@Suite("GentleDesignColorsSection Tests")
@MainActor
struct GentleDesignColorsSectionTests {

    @Test("GentleDesignColorsSection can be created")
    func testColorsSection() {
        _ = GentleDesignColorsSection()
    }
}

// MARK: - GentleDesignStudioView Tests

@Suite("GentleDesignStudioView Tests")
@MainActor
struct GentleDesignStudioViewTests {

    @Test("GentleDesignStudioView can be created")
    func testStudioView() {
        _ = GentleDesignStudioView()
    }

    @Test("GentleDesignStudioView ActiveSheet enum is identifiable")
    func testActiveSheetIdentifiable() {
        let settings = GentleDesignStudioView.ActiveSheet.settings
        let share = GentleDesignStudioView.ActiveSheet.share

        #expect(settings.id == "settings")
        #expect(share.id == "share")
    }
}

// MARK: - GentleDesignShareSheet Tests

@Suite("GentleDesignShareSheet Tests")
@MainActor
struct GentleDesignShareSheetTests {

    @Test("GentleDesignShareSheet can be created with string items")
    func testShareSheetWithStrings() {
        _ = GentleDesignShareSheet(items: ["Hello", "World"])
    }

    @Test("GentleDesignShareSheet can be created with URL items")
    func testShareSheetWithURLs() throws {
        let url = try #require(
            URL(string: "https://example.com"),
            "Expected valid URL"
        )

        _ = GentleDesignShareSheet(items: [url])
    }

    @Test("GentleDesignShareSheet can be created with mixed items")
    func testShareSheetWithMixedItems() throws {
        let url = try #require(
            URL(string: "https://example.com"),
            "Expected valid URL"
        )

        _ = GentleDesignShareSheet(items: ["Text", url, 42])
    }

    @Test("GentleDesignShareSheet can be created with empty items")
    func testShareSheetEmptyItems() {
        _ = GentleDesignShareSheet(items: [])
    }
}

// MARK: - GentleCustomizeSection Tests

@Suite("GentleCustomizeSection Tests")
struct GentleCustomizeSectionTests {

    @Test("All customize sections have titles")
    func testCustomizeSectionTitles() {
        for section in GentleCustomizeSection.allCases {
            #expect(!section.title.isEmpty)
        }
    }

    @Test("Customize sections have correct titles")
    func testCustomizeSectionCorrectTitles() {
        #expect(GentleCustomizeSection.colors.title == "Colors")
        #expect(GentleCustomizeSection.typography.title == "Typography")
        #expect(GentleCustomizeSection.buttons.title == "Buttons")
        #expect(GentleCustomizeSection.surfaces.title == "Surfaces")
    }
}
