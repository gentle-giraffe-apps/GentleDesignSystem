//  Jonathan Ritchey

import SwiftUI

public enum GentleCustomizeSection: String, CaseIterable {
    case colors
    case typography
    case buttons
    case surfaces

    var title: String {
        switch self {
        case .colors: "Colors"
        case .typography: "Typography"
        case .buttons: "Buttons"
        case .surfaces: "Surfaces"
        }
    }
}

#if canImport(UIKit)
public struct GentleDesignCustomizeView: View {
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var themeManager

    private let section: GentleCustomizeSection
    private let isInsideNavigationStack: Bool
    private let onSave: (() async -> Void)?

    @State private var editingColorRole: GentleColorRole?
    @State private var editingTypographyRole: GentleTextRole?

    public init(
        section: GentleCustomizeSection,
        isInsideNavigationStack: Bool = false,
        onSave: (() async -> Void)? = nil
    ) {
        self.section = section
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
                sectionContent
            }
        }
        .navigationTitle(section.title)
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

    @ViewBuilder
    private var sectionContent: some View {
        switch section {
        case .colors:
            colorsGrid
        case .typography:
            typographyGrid
        case .buttons:
            Text("Button editor coming soon")
                .foregroundStyle(.secondary)
        case .surfaces:
            Text("Surface editor coming soon")
                .foregroundStyle(.secondary)
        }
    }

    private var colorsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(GentleColorRole.allCases) { role in
                ColorRoleCell(
                    role: role,
                    isEditing: Binding(
                        get: { editingColorRole == role },
                        set: { if $0 { editingColorRole = role } }
                    )
                )
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .sheet(item: $editingColorRole) { role in
            ColorRoleEditorSheet(role: role)
                .environment(\.gentleTheme, themeManager.theme)
        }
    }

    private var typographyGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(GentleTextRole.allCases) { role in
                TypographyRoleCell(
                    role: role,
                    isEditing: Binding(
                        get: { editingTypographyRole == role },
                        set: { if $0 { editingTypographyRole = role } }
                    )
                )
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .sheet(item: $editingTypographyRole) { role in
            TypographyRoleEditorSheet(role: role)
                .environment(\.gentleTheme, themeManager.theme)
        }
    }
}
#endif
