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

    static let allPresets: [ThemePreset] = GentleDesignSystemSpec.allPresets.map {
        ThemePreset(
            name: $0.name,
            summary: $0.summary,
            description: $0.description,
            purpose: $0.purpose,
            systemImageString: $0.systemImageString,
            spec: $0.spec
        )
    }
}
