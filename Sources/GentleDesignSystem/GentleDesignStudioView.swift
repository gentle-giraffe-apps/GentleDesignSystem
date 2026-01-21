import SwiftUI
import UIKit

public struct GentleDesignStudioView: View {
    enum ActiveSheet: String, Identifiable {
        case settings
        case share
        case editColors
        case editTypography
        case editButtons
        case editSurfaces
        var id: String { rawValue }
    }

    @State private var activeSheet: ActiveSheet?
    @State private var exportURL: URL?
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var themeManager

    public init() {
    }

    public var body: some View {
        NavigationStack {
            GentleDesignFoundationView(
                onEditColors: { activeSheet = .editColors },
                onEditTypography: { activeSheet = .editTypography },
                onEditButtons: { activeSheet = .editButtons },
                onEditSurfaces: { activeSheet = .editSurfaces }
            )
            .navigationTitle(themeManager.currentPresetName ?? "Design System")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            activeSheet = .share
                        } label: {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                        .disabled(exportURL == nil)
                    }
                }
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .settings, .editColors, .editTypography, .editButtons, .editSurfaces:
                        GentleDesignCustomizeView(onSave: {
                            activeSheet = nil
                        })
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)

                    case .share:
                        if let exportURL {
                            GentleDesignShareSheet(items: [exportURL])
                                .presentationDetents([.height(360), .medium, .large])
                                .presentationDragIndicator(.visible)
                                .presentationBackgroundInteraction(.enabled)
                        } else {
                            ProgressView("Preparing export…")
                                .presentationDetents([.height(260)])
                                .presentationDragIndicator(.visible)
                                .task { await refreshExportURL() }
                        }
                    }
                }
        }
        .task { await refreshExportURL() }
    }

    @MainActor
    private func refreshExportURL() async {
        do {
            exportURL = try themeManager.exportURL()
        } catch {
            print("themeManager.exportURL error: \(error)")
            exportURL = nil
        }
    }
}
