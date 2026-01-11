//  Jonathan Ritchey

import SwiftUI

public struct GentleDesignSettingsView: View {
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var themeManager

    @State private var fontsExpanded = false
    @State private var colorsExpanded = false
    @State private var buttonsExpanded = false
    @State private var surfacesExpanded = false

    public init() {
    }

    public var body: some View {
        List {
            Section {
                DisclosureGroup("Fonts", isExpanded: $fontsExpanded) {
                    ForEach(GentleTextRole.allCases) { role in
                        TypographyRoleEditor(role: role)
                    }
                }
            }

            Section {
                DisclosureGroup("Colors", isExpanded: $colorsExpanded) {
                    ForEach(GentleColorRole.allCases) { role in
                        ColorRoleEditor(role: role)
                    }
                }
            }

            Section {
                DisclosureGroup("Buttons", isExpanded: $buttonsExpanded) {
                    Text("Button editor coming soon")
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                DisclosureGroup("Surfaces", isExpanded: $surfacesExpanded) {
                    Text("Surface editor coming soon")
                        .foregroundStyle(.secondary)
                }
            }

            Button("Update and Save") {
                Task { @MainActor in
                    // allow the press state to visually register
                    try? await Task.sleep(nanoseconds: 80_000_000) // 80ms (tune 60–120)
                    do {
                        try themeManager.save()
                    } catch {
                        print("\(error)")
                    }
                }
            }
            .gentleButton(.primary)
        }
        .task {
            do {
                try themeManager.load()
            } catch {
                print("\(error)")
            }
        }
    }
}
