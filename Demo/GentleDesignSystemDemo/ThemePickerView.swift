import SwiftUI
import GentleDesignSystem

struct ThemePickerView: View {
    @GentleThemeManagerRuntime private var themeManager
    @GentleDesignRuntime private var design
    @State private var showingContentView = false

    private let columns = [
        GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 8, alignment: .leading)
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
                                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ fill cell
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
            VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                HStack(alignment: .firstTextBaseline, spacing: design.layout.stack.tight) {
                    Text("\(index)")
                        .gentleText(.largeTitle_xxl)
                        .fixedSize(horizontal: true, vertical: false)

                    Text(nameWords.first)
                        .gentleText(.title_xl)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .allowsTightening(true)
                        .frame(minWidth: 0, alignment: .leading)
                }

                if let secondWord = nameWords.second {
                    Text(secondWord)
                        .gentleText(.title2_l)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .allowsTightening(true)
                        .frame(minWidth: 0, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // ✅ gives the surface a full-width box
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
                .gentleButton(.primary, expandsHorizontally: true)

            Button("Edit") { }
                .gentleButton(.secondary, expandsHorizontally: true)

            // Color grid
            colorGrid
        }
        .frame(maxWidth: .infinity, alignment: .leading)   // ✅ expand first
        .gentleSurface(.card) // ✅ then draw card chrome to full width
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
