import SwiftUI
import GentleDesignSystem

struct ContentView: View {
    @GentleDesignRuntime private var design
    @State private var isShowingSettings = false
    
    var body: some View {
        NavigationStack {
            GentleDesignFoundationView()
            .navigationTitle("Design System")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("settings")
                        isShowingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                GentleDesignSettingsView()
            }
        }
    }
}

// MARK: - Previews

#Preview("Light") {
    GentleThemeRoot(theme: .default) {
        ContentView()
    }
}

#Preview("Dark") {
    GentleThemeRoot(theme: .default) {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
