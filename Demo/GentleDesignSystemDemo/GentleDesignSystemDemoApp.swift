import SwiftUI
import GentleDesignSystem

@main
struct GentleDesignSystemDemoApp: App {
    @State private var themeManager = GentleThemeManager(store: GentleFileThemeSpecStore())

    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: themeManager.theme) {
                ThemePickerView()
            }
            .environment(\.gentleThemeManager, themeManager)
            .task {
                try? themeManager.load()
            }
        }
    }
}
