import SwiftUI
import UIKit

public struct GentleDesignStudioView: View {
    enum ActiveSheet: Identifiable {
        case settings
        case shareJSON
        case sharePDF
        case exportMenu
        case editTypography
        case editButtons
        case editSurfaces
        var id: String {
            switch self {
            case .settings: "settings"
            case .shareJSON: "shareJSON"
            case .sharePDF: "sharePDF"
            case .exportMenu: "exportMenu"
            case .editTypography: "editTypography"
            case .editButtons: "editButtons"
            case .editSurfaces: "editSurfaces"
            }
        }
    }

    private let isTitleEditable: Bool
    private let embedInNavigationStack: Bool

    @State private var activeSheet: ActiveSheet?
    @State private var exportJSONURL: URL?
    @State private var exportPDFURL: URL?
    @State private var showRevertAlert = false
    @State private var exportError: String?
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var themeManager

    public init(isTitleEditable: Bool = false, embedInNavigationStack: Bool = true) {
        self.isTitleEditable = isTitleEditable
        self.embedInNavigationStack = embedInNavigationStack
    }

    public var body: some View {
        if embedInNavigationStack {
            NavigationStack {
                studioContent
            }
            .alert("Revert Changes?", isPresented: $showRevertAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Revert", role: .destructive) {
                    try? themeManager.load()
                }
            } message: {
                Text("This will discard all unsaved changes and restore the last saved version.")
            }
        } else {
            studioContent
                .alert("Revert Changes?", isPresented: $showRevertAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Revert", role: .destructive) {
                        try? themeManager.load()
                    }
                } message: {
                    Text("This will discard all unsaved changes and restore the last saved version.")
                }
        }
    }

    @ViewBuilder
    private var studioContent: some View {
        GentleThemeEditor(isTitleEditable: isTitleEditable)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 16) {
                            Button {
                                showRevertAlert = true
                            } label: {
                                Image(systemName: "arrow.uturn.backward")
                                    .gentleText(.title3_ml, colorRole: themeManager.hasUnsavedChanges ? .destructive : .textTertiary)
                                    .opacity(themeManager.hasUnsavedChanges ? 1 : 0.5)
                                    .padding()
                            }
                            .disabled(!themeManager.hasUnsavedChanges)

                            Button {
                                Task {
                                    try? themeManager.save()
                                }
                            } label: {
                                Image(systemName: "checkmark")
                                    .gentleText(.title3_ml, colorRole: themeManager.hasUnsavedChanges ? .primaryCTA : .textTertiary)
                                    .opacity(themeManager.hasUnsavedChanges ? 1 : 0.5)
                                    .padding()
                            }
                            .disabled(!themeManager.hasUnsavedChanges)

                            Menu {
                                Button {
                                    exportJSONURL = nil
                                    activeSheet = .shareJSON
                                } label: {
                                    Label("Export JSON", systemImage: "doc.text")
                                }

                                Button {
                                    activeSheet = .sharePDF
                                } label: {
                                    Label("Export PDF", systemImage: "doc.richtext")
                                }
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .gentleText(.title3_ml)
                                    .padding()
                            }
                        }
                    }
                }
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .settings:
                        GentleDesignCustomizeView(section: .colors, onSave: {
                            activeSheet = nil
                        })
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)

                    case .editTypography:
                        GentleDesignCustomizeView(section: .typography, onSave: {
                            activeSheet = nil
                        })
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)

                    case .editButtons:
                        GentleDesignCustomizeView(section: .buttons, onSave: {
                            activeSheet = nil
                        })
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)

                    case .editSurfaces:
                        GentleDesignCustomizeView(section: .surfaces, onSave: {
                            activeSheet = nil
                        })
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)

                    case .shareJSON:
                        if let exportJSONURL {
                            GentleDesignShareSheet(items: [exportJSONURL])
                                .presentationDetents([.height(360), .medium, .large])
                                .presentationDragIndicator(.visible)
                                .presentationBackgroundInteraction(.enabled)
                        } else {
                            ProgressView("Preparing JSON export…")
                                .presentationDetents([.height(260)])
                                .presentationDragIndicator(.visible)
                                .task { await refreshExportURLs() }
                        }

                    case .sharePDF:
                        if let exportPDFURL {
                            GentleDesignShareSheet(items: [exportPDFURL])
                                .presentationDetents([.height(360), .medium, .large])
                                .presentationDragIndicator(.visible)
                                .presentationBackgroundInteraction(.enabled)
                        } else {
                            ProgressView("Preparing PDF export…")
                                .presentationDetents([.height(260)])
                                .presentationDragIndicator(.visible)
                                .task { await generatePDFExport() }
                        }

                    case .exportMenu:
                        EmptyView()
                    }
                }
                .alert("Export Error", isPresented: Binding(
                    get: { exportError != nil },
                    set: { if !$0 { exportError = nil } }
                )) {
                    Button("OK", role: .cancel) { exportError = nil }
                } message: {
                    Text(exportError ?? "An unknown error occurred.")
                }
    }

    @MainActor
    private func refreshExportURLs() async {
        do {
            exportJSONURL = try themeManager.exportURL()
        } catch {
            exportError = error.localizedDescription
            exportJSONURL = nil
        }
    }

    @MainActor
    private func generatePDFExport() async {
        exportPDFURL = nil
        do {
            exportPDFURL = try themeManager.exportPDFURL()
        } catch {
            exportError = error.localizedDescription
            exportPDFURL = nil
        }
    }
}
