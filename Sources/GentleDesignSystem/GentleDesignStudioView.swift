import SwiftUI
import UIKit

public struct GentleDesignStudioView: View {
    enum ActiveSheet: Identifiable {
        case settings
        case share
        case editTypography
        case editButtons
        case editSurfaces
        var id: String {
            switch self {
            case .settings: "settings"
            case .share: "share"
            case .editTypography: "editTypography"
            case .editButtons: "editButtons"
            case .editSurfaces: "editSurfaces"
            }
        }
    }

    private let isTitleEditable: Bool
    private let embedInNavigationStack: Bool

    @State private var activeSheet: ActiveSheet?
    @State private var exportURL: URL?
    @State private var showRevertAlert = false
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
            .task { await refreshExportURL() }
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
                .task { await refreshExportURL() }
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
            .navigationTitle(isTitleEditable ? "New Theme" : (themeManager.currentPresetName ?? "Design System"))
            .navigationBarTitleDisplayMode(.inline)
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

                            Button {
                                activeSheet = .share
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .gentleText(.title3_ml)
                                    .padding()
                            }
                            .disabled(exportURL == nil)
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

