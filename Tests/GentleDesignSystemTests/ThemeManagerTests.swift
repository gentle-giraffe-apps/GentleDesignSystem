//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - GentleThemeManager Tests

@Suite("GentleThemeManager Tests")
@MainActor
struct GentleThemeManagerTests {

    @Test("Manager initializes with default theme")
    func testManagerInitialization() {
        let manager = GentleThemeManager()

        #expect(manager.theme.spec.specVersion == GentleDesignSystemSpecVersion.current)
        #expect(manager.hasUnsavedChanges == false)
        #expect(manager.currentPresetName == nil)
    }

    @Test("Manager tracks unsaved changes through typography binding")
    func testManagerTypographyBinding() {
        let manager = GentleThemeManager()

        #expect(manager.hasUnsavedChanges == false)

        let binding = manager.bindingForTypographyRole(.body_m)
        var spec = binding.wrappedValue
        spec.pointSize = 20
        binding.wrappedValue = spec

        #expect(manager.hasUnsavedChanges == true)
        #expect(manager.theme.editableSpec.typography.roleSpec(for: .body_m).pointSize == 20)
    }

    @Test("Manager tracks unsaved changes through color binding")
    func testManagerColorBinding() {
        let manager = GentleThemeManager()

        #expect(manager.hasUnsavedChanges == false)

        let binding = manager.bindingForColorRole(.textPrimary)
        binding.wrappedValue = GentleColorPair(lightHex: "#123456", darkHex: "#654321")

        #expect(manager.hasUnsavedChanges == true)
        #expect(manager.theme.editableSpec.colors.pair(for: .textPrimary)?.lightHex == "#123456")
    }

    @Test("Manager tracks unsaved changes through button binding")
    func testManagerButtonBinding() {
        let manager = GentleThemeManager()

        #expect(manager.hasUnsavedChanges == false)

        let binding = manager.bindingForButtonRole(.primary)
        var spec = binding.wrappedValue
        spec.pressedScale = 0.9
        binding.wrappedValue = spec

        #expect(manager.hasUnsavedChanges == true)
        #expect(manager.theme.editableSpec.buttons.roleSpec(for: .primary).pressedScale == 0.9)
    }

    @Test("Manager color binding returns fallback for missing role")
    func testManagerColorBindingFallback() {
        let emptySpec = GentleDesignSystemSpec(
            colors: GentleColorTokens(pairByRole: [:]),
            typography: .gentleDefault,
            layout: .gentleDefault,
            visual: .gentleDefault,
            buttons: .gentleDefault
        )
        let theme = GentleTheme(defaultSpec: emptySpec, editableSpec: emptySpec)
        let manager = GentleThemeManager(theme: theme)

        let binding = manager.bindingForColorRole(.textPrimary)
        let pair = binding.wrappedValue

        #expect(pair.lightHex == "#000000")
        #expect(pair.darkHex == "#FFFFFF")
    }
}

@Suite("GentleThemeManager Extended Tests")
@MainActor
struct GentleThemeManagerExtendedTests {

    @Test("Manager can save and load theme")
    func testManagerSaveAndLoad() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_manager_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)

        // Modify the theme
        let binding = manager.bindingForColorRole(.textPrimary)
        binding.wrappedValue = GentleColorPair(lightHex: "#AABBCC", darkHex: "#DDEEFF")

        #expect(manager.hasUnsavedChanges == true)

        // Save
        try manager.save()
        #expect(manager.hasUnsavedChanges == false)

        // Create a new manager with same store
        let newManager = GentleThemeManager(store: store)
        try newManager.load()

        let loadedPair = newManager.theme.editableSpec.colors.pair(for: .textPrimary)
        #expect(loadedPair?.lightHex == "#AABBCC")
        #expect(loadedPair?.darkHex == "#DDEEFF")

        // Cleanup
        try store.clearEditableSpec()
    }

    @Test("Manager can reset theme")
    func testManagerReset() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_reset_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)

        // Get original value
        let originalPair = manager.theme.defaultSpec.colors.pair(for: .textPrimary)

        // Modify and save
        let binding = manager.bindingForColorRole(.textPrimary)
        binding.wrappedValue = GentleColorPair(lightHex: "#111111", darkHex: "#222222")
        try manager.save()

        // Verify modification
        #expect(manager.theme.editableSpec.colors.pair(for: .textPrimary)?.lightHex == "#111111")

        // Reset
        try manager.reset()

        // Verify reset to default
        #expect(manager.theme.editableSpec.colors.pair(for: .textPrimary)?.lightHex == originalPair?.lightHex)
    }

    @Test("Manager can select preset")
    func testManagerSelectPreset() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_preset_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)

        // Select the classic preset
        try manager.selectPreset(name: "Classic", defaultSpec: .classic)

        #expect(manager.currentPresetName == "Classic")
        #expect(manager.theme.defaultSpec.typography.roleSpec(for: .largeTitle_xxl).design == .serif)
        #expect(manager.theme.editableSpec.typography.roleSpec(for: .largeTitle_xxl).design == .serif)
    }

    @Test("Manager preset saves and loads edits")
    func testManagerPresetSavesEdits() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_preset_edits_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)
        let presetName = "TestPreset_\(UUID().uuidString)"

        // Select a preset
        try manager.selectPreset(name: presetName, defaultSpec: .modern)

        // Make edits
        let binding = manager.bindingForTypographyRole(.body_m)
        var spec = binding.wrappedValue
        spec.pointSize = 25
        binding.wrappedValue = spec

        // Save
        try manager.save()

        // Create new manager and select same preset
        let newManager = GentleThemeManager(store: store)
        try newManager.selectPreset(name: presetName, defaultSpec: .modern)

        // Verify edits were loaded
        #expect(newManager.theme.editableSpec.typography.roleSpec(for: .body_m).pointSize == 25)

        // Cleanup
        try store.clearEditableSpec(forPreset: presetName)
    }

    @Test("Manager hasEditableSpec for preset")
    func testManagerHasEditableSpecForPreset() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_has_editable_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)
        let presetName = "CheckPreset_\(UUID().uuidString)"

        // Initially no saved spec
        #expect(manager.hasEditableSpec(forPreset: presetName) == false)

        // Select and save
        try manager.selectPreset(name: presetName, defaultSpec: .soft)
        let binding = manager.bindingForColorRole(.background)
        binding.wrappedValue = GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")
        try manager.save()

        // Now has saved spec
        #expect(manager.hasEditableSpec(forPreset: presetName) == true)

        // Cleanup
        try store.clearEditableSpec(forPreset: presetName)
    }

    @Test("Manager exportURL creates valid file")
    func testManagerExportURL() throws {
        let manager = GentleThemeManager()

        let url = try manager.exportURL()

        #expect(url.pathExtension == "json")
        #expect(FileManager.default.fileExists(atPath: url.path))

        // Verify content is valid JSON
        let data = try Data(contentsOf: url)
        let decoded = try GentleDesignSystemSpec.fromJSONData(data)
        #expect(decoded.specVersion == GentleDesignSystemSpecVersion.current)

        // Cleanup
        try FileManager.default.removeItem(at: url)
    }
}

// MARK: - GentleFileThemeSpecStore Tests

@Suite("GentleFileThemeSpecStore Tests")
struct GentleFileThemeSpecStoreTests {

    @Test("Store initializes with default values")
    func testStoreInitialization() {
        let store = GentleFileThemeSpecStore()

        #expect(store.fileName == "gentle_theme_spec.json")
        #expect(store.subdirectory == "GentleDesignSystem")
    }

    @Test("Store initializes with custom values")
    func testStoreCustomInitialization() {
        let store = GentleFileThemeSpecStore(fileName: "custom.json", subdirectory: "CustomDir")

        #expect(store.fileName == "custom.json")
        #expect(store.subdirectory == "CustomDir")
    }

    @Test("Store can save and load spec")
    func testStoreSaveAndLoad() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_theme_\(UUID().uuidString).json")
        let spec = GentleDesignSystemSpec.gentleDefault

        // Save
        try store.saveEditableSpec(spec)

        // Load
        let loaded = try store.loadEditableSpec()

        #expect(loaded != nil)
        #expect(loaded?.specVersion == spec.specVersion)

        // Cleanup
        try store.clearEditableSpec()
    }

    @Test("Store returns nil for non-existent file")
    func testStoreLoadNonExistent() throws {
        let store = GentleFileThemeSpecStore(fileName: "non_existent_\(UUID().uuidString).json")

        let loaded = try store.loadEditableSpec()

        #expect(loaded == nil)
    }

    @Test("Store can clear spec")
    func testStoreClear() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_clear_\(UUID().uuidString).json")
        let spec = GentleDesignSystemSpec.gentleDefault

        try store.saveEditableSpec(spec)

        // Verify it exists
        let beforeClear = try store.loadEditableSpec()
        #expect(beforeClear != nil)

        // Clear
        try store.clearEditableSpec()

        // Verify it's gone
        let afterClear = try store.loadEditableSpec()
        #expect(afterClear == nil)
    }

    @Test("Store handles preset-specific files")
    func testStorePresetFiles() throws {
        let store = GentleFileThemeSpecStore()
        let presetName = "Test Preset \(UUID().uuidString)"
        let spec = GentleDesignSystemSpec.classic

        // Initially no saved spec
        #expect(try store.hasEditableSpec(forPreset: presetName) == false)

        // Save
        try store.saveEditableSpec(spec, forPreset: presetName)

        // Now exists
        #expect(try store.hasEditableSpec(forPreset: presetName) == true)

        // Load
        let loaded = try store.loadEditableSpec(forPreset: presetName)
        #expect(loaded?.typography.roleSpec(for: .largeTitle_xxl).design == .serif)

        // Clear
        try store.clearEditableSpec(forPreset: presetName)
        #expect(try store.hasEditableSpec(forPreset: presetName) == false)
    }
}

@Suite("GentleFileThemeSpecStore Extended Tests")
struct GentleFileThemeSpecStoreExtendedTests {

    @Test("Store with nil subdirectory")
    func testStoreWithNilSubdirectory() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_nil_subdir_\(UUID().uuidString).json", subdirectory: nil)
        let spec = GentleDesignSystemSpec.gentleDefault

        // Save
        try store.saveEditableSpec(spec)

        // Load
        let loaded = try store.loadEditableSpec()
        #expect(loaded != nil)

        // Cleanup
        try store.clearEditableSpec()
    }

    @Test("Store sanitizes preset names")
    func testStoreSanitizesPresetNames() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_sanitize_\(UUID().uuidString).json")
        let presetName = "Test/Preset With Spaces"
        let spec = GentleDesignSystemSpec.gentleDefault

        // Should not crash with special characters
        try store.saveEditableSpec(spec, forPreset: presetName)
        let loaded = try store.loadEditableSpec(forPreset: presetName)
        #expect(loaded != nil)

        // Cleanup
        try store.clearEditableSpec(forPreset: presetName)
    }
}
