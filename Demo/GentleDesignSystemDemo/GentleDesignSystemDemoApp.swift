import SwiftUI
import GentleDesignSystem

@main
struct GentleDesignSystemDemoApp: App {
    private var themeManager = GentleThemeManager(store: GentleFileThemeSpecStore())

    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: themeManager.theme) {
                ContentView()
            }
            .environment(\.gentleThemeManager, themeManager)
        }
    }
}
