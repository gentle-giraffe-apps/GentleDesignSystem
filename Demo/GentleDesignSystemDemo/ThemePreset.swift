import Foundation
import GentleDesignSystem

struct ThemePreset: Identifiable, Hashable {
    let name: String
    let spec: GentleDesignSystemSpec

    var id: String { name }

    static func == (lhs: ThemePreset, rhs: ThemePreset) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static let allPresets: [ThemePreset] = GentleDesignSystemSpec.allPresets.map {
        ThemePreset(name: $0.name, spec: $0.spec)
    }
}
