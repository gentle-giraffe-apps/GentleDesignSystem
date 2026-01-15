import SwiftUI
import GentleDesignSystem

struct ThemePickerView: View {
    @GentleThemeManagerRuntime private var themeManager
    @GentleDesignRuntime private var design
    @State private var showingContentView = false

    private let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 220), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: design.layout.grid.regular) {
                    ForEach(Array(ThemePreset.allPresets.enumerated()), id: \.element.id) { index, preset in
                        let previewTheme = GentleTheme(
                            defaultSpec: preset.spec,
                            editableSpec: preset.spec
                        )

                        Button {
                            themeManager.theme.editableSpec = preset.spec
                            showingContentView = true
                        } label: {
                            GentleThemeRoot(theme: previewTheme) {
                                ThemePresetCard(preset: preset, index: index + 1)
                            }
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
    let index: Int
    @GentleDesignRuntime private var design
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    /// Key color roles to display in the color grid
    private static let displayColorRoles: [GentleColorRole] = [
        .primaryCTA, .themePrimary, .themeSecondary, .destructive,
        .background, .surface, .surfaceElevated, .borderSubtle,
        .textPrimary, .textSecondary, .textTertiary, .onPrimaryCTA
    ]

    private var nameWords: (first: String, second: String?) {
        let words = preset.name.split(separator: " ").map(String.init)
        return (first: words.first ?? preset.name, second: words.count > 1 ? words[1] : nil)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.tight) {
            // Index number + theme name in elevated surface
            VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                HStack(alignment: .firstTextBaseline, spacing: design.layout.stack.tight) {
                    Text("\(index)")
                        .gentleText(.largeTitle_xxl)
                    Text(nameWords.first)
                        .gentleText(.title_xl)
                }

                if let secondWord = nameWords.second {
                    Text(secondWord)
                        .gentleText(.title2_l)
                }
            }
            .gentleSurface(.cardElevated)

            // Text samples
            Text("headline_m")
                .gentleText(.headline_m)
            Text("body_m")
                .gentleText(.body_m)
            Text("subheadline_ms")
                .gentleText(.subheadline_ms)
            Text("caption_s")
                .gentleText(.caption_s)

            // Buttons
            Button("Go") { }
                .gentleButton(.primary)

            Button("Edit") { }
                .gentleButton(.secondary)

            // Color grid
            colorGrid
        }
        .gentleSurface(.card)
    }

    private static let colorGridColumns = Array(repeating: GridItem(.fixed(16), spacing: 2), count: 6)

    private var colorGrid: some View {
        LazyVGrid(
            columns: Self.colorGridColumns,
            spacing: 2
        ) {
            ForEach(Self.displayColorRoles) { role in
                theme.color(for: role, scheme: colorScheme)
                    .frame(width: 16, height: 16)
            }
        }
        .fixedSize()
        .padding(2)
        .background(Color.black.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    @Previewable @State var manager = GentleThemeManager()
    GentleThemeRoot(theme: manager.theme) {
        ThemePickerView()
    }
    .environment(\.gentleThemeManager, manager)
}
