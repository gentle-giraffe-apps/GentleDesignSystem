//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - GentleJSONEncodable Tests

@Suite("GentleJSONEncodable Tests")
struct GentleJSONEncodableTests {

    @Test("makeJSONEncoder returns encoder with pretty printing and sorted keys")
    func testMakeJSONEncoder() throws {
        let encoder = GentleDesignSystemSpec.makeJSONEncoder()
        let spec = GentleDesignSystemSpec.gentleDefault

        let data = try encoder.encode(spec)
        let jsonString = String(data: data, encoding: .utf8) ?? ""

        // Pretty printed JSON has newlines
        #expect(jsonString.contains("\n"))
        // Sorted keys means _specVersion appears early
        #expect(jsonString.hasPrefix("{\n  \"_specVersion\""))
    }

    @Test("encodedJSONData produces valid JSON")
    func testEncodedJSONData() throws {
        let spec = GentleDesignSystemSpec.gentleDefault

        let data = try spec.encodedJSONData()

        #expect(data.isEmpty == false)

        // Should be parseable
        let decoded = try GentleDesignSystemSpec.fromJSONData(data)
        #expect(decoded.specVersion == spec.specVersion)
    }

    @Test("encodedJSONString produces valid string")
    func testEncodedJSONString() throws {
        let spec = GentleDesignSystemSpec.gentleDefault

        let jsonString = try spec.encodedJSONString()

        #expect(!jsonString.isEmpty)
        #expect(jsonString.contains("_specVersion"))
        #expect(jsonString.contains(GentleDesignSystemSpecVersion.current))
    }

    @Test("encodedJSONData with custom encoder")
    func testEncodedJSONDataWithCustomEncoder() throws {
        let spec = GentleDesignSystemSpec.gentleDefault
        let encoder = JSONEncoder()
        encoder.outputFormatting = [] // No formatting

        let data = try spec.encodedJSONData(encoder: encoder)
        let jsonString = String(data: data, encoding: .utf8) ?? ""

        // Should not have newlines (compact format)
        #expect(!jsonString.contains("\n"))
    }
}

// MARK: - GentleJSONDecodable Tests

@Suite("GentleJSONDecodable Tests")
struct GentleJSONDecodableTests {

    @Test("makeJSONDecoder returns decoder")
    func testMakeJSONDecoder() {
        let decoder = GentleDesignSystemSpec.makeJSONDecoder()
        #expect(decoder != nil)
    }

    @Test("fromJSONData decodes valid data")
    func testFromJSONData() throws {
        let original = GentleDesignSystemSpec.gentleDefault
        let data = try original.encodedJSONData()

        let decoded = try GentleDesignSystemSpec.fromJSONData(data)

        #expect(decoded.specVersion == original.specVersion)
    }

    @Test("fromJSONString decodes valid string")
    func testFromJSONString() throws {
        let original = GentleDesignSystemSpec.gentleDefault
        let jsonString = try original.encodedJSONString()

        let decoded = try GentleDesignSystemSpec.fromJSONString(jsonString)

        #expect(decoded.specVersion == original.specVersion)
    }

    @Test("fromJSONData with custom decoder")
    func testFromJSONDataWithCustomDecoder() throws {
        let original = GentleDesignSystemSpec.gentleDefault
        let data = try original.encodedJSONData()
        let decoder = JSONDecoder()

        let decoded = try GentleDesignSystemSpec.fromJSONData(data, decoder: decoder)

        #expect(decoded.specVersion == original.specVersion)
    }

    @Test("fromJSONData throws on invalid data")
    func testFromJSONDataThrowsOnInvalid() {
        let invalidData = Data("not valid json".utf8)

        #expect(throws: DecodingError.self) {
            _ = try GentleDesignSystemSpec.fromJSONData(invalidData)
        }
    }

    @Test("fromJSONString throws on invalid string")
    func testFromJSONStringThrowsOnInvalid() {
        let invalidString = "not valid json"

        #expect(throws: DecodingError.self) {
            _ = try GentleDesignSystemSpec.fromJSONString(invalidString)
        }
    }
}

// MARK: - GentleFileThemeSpecStore Extended Tests

@Suite("GentleFileThemeSpecStore Listing Tests")
struct GentleFileThemeSpecStoreListingTests {

    @Test("listSavedPresetNames returns empty array when no presets saved")
    func testListSavedPresetNamesEmpty() throws {
        // Use unique subdirectory to avoid conflicts
        let store = GentleFileThemeSpecStore(
            fileName: "test_list_\(UUID().uuidString).json",
            subdirectory: "TestListEmpty_\(UUID().uuidString)"
        )

        let names = try store.listSavedPresetNames()
        #expect(names.isEmpty)
    }

    @Test("listSavedPresetNames returns saved preset names")
    func testListSavedPresetNamesWithPresets() throws {
        let uniqueId = UUID().uuidString
        let store = GentleFileThemeSpecStore(
            fileName: "test_list_\(uniqueId).json",
            subdirectory: "TestList_\(uniqueId)"
        )
        let presetName = "Test Preset"
        let spec = GentleDesignSystemSpec.gentleDefault

        // Save a preset
        try store.saveEditableSpec(spec, forPreset: presetName)

        // List should contain the preset
        let names = try store.listSavedPresetNames()
        #expect(names.count >= 1)

        // Cleanup
        try store.clearEditableSpec(forPreset: presetName)
    }

    @Test("clearEditableSpec for non-existent preset does not throw")
    func testClearNonExistentPreset() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_clear_\(UUID().uuidString).json")

        // Should not throw
        try store.clearEditableSpec(forPreset: "NonExistent_\(UUID().uuidString)")
    }

    @Test("clearEditableSpec for non-existent file does not throw")
    func testClearNonExistentFile() throws {
        let store = GentleFileThemeSpecStore(fileName: "nonexistent_\(UUID().uuidString).json")

        // Should not throw
        try store.clearEditableSpec()
    }

    @Test("loadEditableSpec for preset returns nil when not saved")
    func testLoadPresetReturnsNilWhenNotSaved() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_\(UUID().uuidString).json")

        let loaded = try store.loadEditableSpec(forPreset: "NonExistent_\(UUID().uuidString)")
        #expect(loaded == nil)
    }
}

// MARK: - Theme Manager Rename Preset Tests

@Suite("Theme Manager Rename Preset Tests")
@MainActor
struct ThemeManagerRenamePresetTests {

    @Test("Manager can rename preset")
    func testManagerRenamePreset() throws {
        let store = GentleFileThemeSpecStore(fileName: "test_rename_\(UUID().uuidString).json")
        let manager = GentleThemeManager(store: store)

        // Select a preset
        try manager.selectPreset(name: "Original", defaultSpec: .classic)
        #expect(manager.currentPresetName == "Original")

        // Rename
        manager.renamePreset(to: "Renamed")
        #expect(manager.currentPresetName == "Renamed")
    }
}

// MARK: - Theme Manager Export PDF Tests

@Suite("Theme Manager Export PDF Tests")
@MainActor
struct ThemeManagerExportPDFTests {

    @Test("Manager can export PDF")
    func testManagerExportPDF() throws {
        let manager = GentleThemeManager()

        let url = try manager.exportPDFURL()

        #expect(url.pathExtension == "pdf")
        #expect(FileManager.default.fileExists(atPath: url.path))

        // Cleanup
        try FileManager.default.removeItem(at: url)
    }
}

