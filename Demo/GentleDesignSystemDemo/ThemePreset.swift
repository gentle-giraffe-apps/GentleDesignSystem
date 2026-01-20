import Foundation
import GentleDesignSystem

struct ThemePreset: Identifiable, Hashable {
    let name: String
    let summary: String
    let description: String
    let purpose: String
    let systemImageString: String
    let spec: GentleDesignSystemSpec

    var id: String { name }

    static func == (lhs: ThemePreset, rhs: ThemePreset) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static let allPresets: [ThemePreset] = GentleDesignSystemSpec.allPresets.map { preset in
        ThemePreset(
            name: preset.name,
            summary: preset.summary,
            description: preset.description,
            purpose: preset.purpose,
            systemImageString: preset.systemImageString,
            spec: preset.spec
        )
    }
}
