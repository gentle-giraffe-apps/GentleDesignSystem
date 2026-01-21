//  Jonathan Ritchey

import Foundation
import SwiftUI

// MARK: - Default JSON Encoding

public protocol GentleJSONEncodable: Encodable { static func makeJSONEncoder() -> JSONEncoder }

public extension GentleJSONEncodable {
    static func makeJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }

    func encodedJSONData(encoder: JSONEncoder = Self.makeJSONEncoder()) throws -> Data { try encoder.encode(self) }

    func encodedJSONString(encoder: JSONEncoder = Self.makeJSONEncoder()) throws -> String {
        let data = try encodedJSONData(encoder: encoder)
        guard let s = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(data, .init(codingPath: [], debugDescription: "UTF-8 conversion failed"))
        }
        return s
    }
}

public protocol GentleJSONDecodable: Decodable { static func makeJSONDecoder() -> JSONDecoder }

public extension GentleJSONDecodable {
    static func makeJSONDecoder() -> JSONDecoder { JSONDecoder() }
    static func fromJSONData(_ data: Data, decoder: JSONDecoder = Self.makeJSONDecoder()) throws -> Self {
        try decoder.decode(Self.self, from: data)
    }
    static func fromJSONString(_ string: String, decoder: JSONDecoder = Self.makeJSONDecoder()) throws -> Self {
        try fromJSONData(Data(string.utf8), decoder: decoder)
    }
}

// MARK: - Theme Spec Store

public protocol GentleThemeSpecStore: Sendable {
    func loadEditableSpec() throws -> GentleDesignSystemSpec?
    func saveEditableSpec(_ spec: GentleDesignSystemSpec) throws
    func clearEditableSpec() throws

    // Per-preset storage
    func loadEditableSpec(forPreset name: String) throws -> GentleDesignSystemSpec?
    func saveEditableSpec(_ spec: GentleDesignSystemSpec, forPreset name: String) throws
    func clearEditableSpec(forPreset name: String) throws
    func hasEditableSpec(forPreset name: String) throws -> Bool
}

/// File-backed JSON store (Application Support).
public struct GentleFileThemeSpecStore: GentleThemeSpecStore, Sendable {
    public enum StoreError: Error, Sendable {
        case applicationSupportUnavailable
    }

    public let fileName: String
    public let subdirectory: String?

    public init(fileName: String = "gentle_theme_spec.json",
                subdirectory: String? = "GentleDesignSystem") {
        self.fileName = fileName
        self.subdirectory = subdirectory
    }

    public func loadEditableSpec() throws -> GentleDesignSystemSpec? {
        let url = try fileURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try GentleDesignSystemSpec.fromJSONData(data)
    }

    public func saveEditableSpec(_ spec: GentleDesignSystemSpec) throws {
        let url = try fileURL()
        let data = try spec.encodedJSONData()
        try data.write(to: url, options: [.atomic])
    }

    public func clearEditableSpec() throws {
        let url = try fileURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        try FileManager.default.removeItem(at: url)
    }

    // MARK: - Per-Preset Storage

    public func loadEditableSpec(forPreset name: String) throws -> GentleDesignSystemSpec? {
        let url = try presetFileURL(for: name)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try GentleDesignSystemSpec.fromJSONData(data)
    }

    public func saveEditableSpec(_ spec: GentleDesignSystemSpec, forPreset name: String) throws {
        let url = try presetFileURL(for: name)
        let data = try spec.encodedJSONData()
        try data.write(to: url, options: [.atomic])
    }

    public func clearEditableSpec(forPreset name: String) throws {
        let url = try presetFileURL(for: name)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        try FileManager.default.removeItem(at: url)
    }

    public func hasEditableSpec(forPreset name: String) throws -> Bool {
        let url = try presetFileURL(for: name)
        return FileManager.default.fileExists(atPath: url.path)
    }

    // MARK: - Paths

    private func fileURL() throws -> URL {
        let dir = try baseDirectory()
        return dir.appendingPathComponent(fileName, isDirectory: false)
    }

    private func presetFileURL(for presetName: String) throws -> URL {
        let presetsDir = try presetsDirectory()
        let safeFileName = presetName
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "/", with: "_")
            .lowercased() + ".json"
        return presetsDir.appendingPathComponent(safeFileName, isDirectory: false)
    }

    private func baseDirectory() throws -> URL {
        let fm = FileManager.default
        guard let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw StoreError.applicationSupportUnavailable
        }

        let dir: URL
        if let subdirectory {
            dir = base.appendingPathComponent(subdirectory, isDirectory: true)
            if !fm.fileExists(atPath: dir.path) {
                try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            }
        } else {
            dir = base
        }
        return dir
    }

    private func presetsDirectory() throws -> URL {
        let fm = FileManager.default
        let dir = try baseDirectory().appendingPathComponent("presets", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }
}
