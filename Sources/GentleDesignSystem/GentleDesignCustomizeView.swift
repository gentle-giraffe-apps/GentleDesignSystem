//  Jonathan Ritchey

import SwiftUI

public struct GentleDesignCustomizeView: View {
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var themeManager

    @State private var fontsExpanded = false
    @State private var colorsExpanded = false
    @State private var buttonsExpanded = false
    @State private var surfacesExpanded = false

    private let isInsideNavigationStack: Bool
    private let onSave: (() async -> Void)?

    public init(isInsideNavigationStack: Bool = false, onSave: (() async -> Void)? = nil) {
        self.isInsideNavigationStack = isInsideNavigationStack
        self.onSave = onSave
    }

    public var body: some View {
        if isInsideNavigationStack {
            content
        } else {
            NavigationStack {
                content
            }
        }
    }

    @ViewBuilder
    private var content: some View {
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
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task { @MainActor in
                        // allow the press state to visually register
                        try? await Task.sleep(nanoseconds: 80_000_000) // 80ms (tune 60–120)
                        do {
                            try themeManager.save()
                            await onSave?()
                        } catch {
                            print("\(error)")
                        }
                    }
                }
                .gentleButton(.tertiary)
                .disabled(!themeManager.hasUnsavedChanges)
            }
        }
    }
}
