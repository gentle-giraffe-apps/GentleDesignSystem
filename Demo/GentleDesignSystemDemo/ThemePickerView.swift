import SwiftUI
import GentleDesignSystem

struct ThemePickerView: View {
    @GentleThemeManagerRuntime private var themeManager
    @GentleDesignRuntime private var design
    @State private var showingContentView = false

    private let columns = [
        GridItem(.adaptive(minimum: 140, maximum: 200), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: design.layout.grid.regular) {
                    ForEach(ThemePreset.allPresets) { preset in
                        Button {
                            themeManager.theme.editableSpec = preset.spec
                            showingContentView = true
                        } label: {
                            ThemePresetCard(preset: preset)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Theme")
            .gentleSurface(.appBackground)
            .navigationDestination(isPresented: $showingContentView) {
                ContentView()
            }
        }
    }
}

struct ThemePresetCard: View {
    let preset: ThemePreset
    @GentleDesignRuntime private var design
    @Environment(\.colorScheme) private var colorScheme

    private var previewColors: (primary: Color, secondary: Color, background: Color, surface: Color) {
        let colors = preset.spec.colors
        return (
            primary: Color(gentleHex: colors.pair(for: .primaryCTA)?.hex(for: colorScheme) ?? "#000000"),
            secondary: Color(gentleHex: colors.pair(for: .themeSecondary)?.hex(for: colorScheme) ?? "#666666"),
            background: Color(gentleHex: colors.pair(for: .background)?.hex(for: colorScheme) ?? "#FFFFFF"),
            surface: Color(gentleHex: colors.pair(for: .surface)?.hex(for: colorScheme) ?? "#F5F5F5")
        )
    }

    var body: some View {
        VStack(spacing: design.layout.stack.tight) {
            // Color preview strip
            HStack(spacing: 0) {
                previewColors.primary
                previewColors.secondary
                previewColors.background
                previewColors.surface
            }
            .frame(height: 8)
            .clipShape(RoundedRectangle(cornerRadius: 4))

            Text(preset.name)
                .gentleText(.headline_m)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .gentleSurface(.card)
    }
}

#Preview {
    @Previewable @State var manager = GentleThemeManager()
    GentleThemeRoot(theme: manager.theme) {
        ThemePickerView()
    }
    .environment(\.gentleThemeManager, manager)
}
