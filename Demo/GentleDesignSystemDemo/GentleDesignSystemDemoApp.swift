import SwiftUI
import GentleDesignSystem

@main
struct GentleDesignSystemDemoApp: App {
    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: .default) {
                ContentView()
            }
        }
    }
}
