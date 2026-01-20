import SwiftUI
import UIKit

public struct GentleDesignStudioView: View {
    enum ActiveSheet: String, Identifiable {
        case settings
        case share
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
            GentleDesignFoundationView()
                .navigationTitle("Design System")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            activeSheet = .share
                        } label: {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                        .disabled(exportURL == nil)
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            activeSheet = .settings
                        } label: {
                            Label("Customize", systemImage: "slider.horizontal.3")
                        }
                    }
                }
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .settings:
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
