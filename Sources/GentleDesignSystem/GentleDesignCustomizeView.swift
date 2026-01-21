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

public struct GentleDesignCustomizeView: View {
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var themeManager

    private let section: GentleCustomizeSection
    private let isInsideNavigationStack: Bool
    private let onSave: (() async -> Void)?

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
            ForEach(GentleColorRole.allCases) { role in
                ColorRoleEditor(role: role)
            }
        case .typography:
            ForEach(GentleTextRole.allCases) { role in
                TypographyRoleEditor(role: role)
            }
        case .buttons:
            Text("Button editor coming soon")
                .foregroundStyle(.secondary)
        case .surfaces:
            Text("Surface editor coming soon")
                .foregroundStyle(.secondary)
        }
    }
}
