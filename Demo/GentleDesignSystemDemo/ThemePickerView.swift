import SwiftUI
import GentleDesignSystem

struct ThemePickerView: View {
    @GentleThemeManagerRuntime private var themeManager
    @GentleDesignRuntime private var design
    @State private var showingThemeStudio = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var columns: [GridItem] {
        if sizeClass == .compact {
            // iPhone: single column, full width
            [GridItem(.flexible())]
        } else {
            // iPad: adaptive grid
            [GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 8, alignment: .leading)]
        }
    }
    
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
                            showingThemeStudio = true
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
            .navigationDestination(isPresented: $showingThemeStudio) {
                ThemeStudioView()
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

    var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            // HERO — shows off the very top of your ramp
            Text(preset.name)
                .gentleText(.largeTitle_xxl)
                .lineLimit(2)

            VStack(spacing: 0) {
                Text("\(preset.summary) \(Image(systemName: preset.systemImageString))")
                .gentleText(.callout_ms)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: design.layout.gap.loose)
                
                HStack {
                    Text("About")
                        .gentleText(.title_xl)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    Text("Colors")
                        .gentleText(.title2_l)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                
                Spacer(minLength: design.layout.gap.regular)
                
                HStack(alignment: .top) {
                    Text(preset.description)
                        .gentleText(.subheadline_ms)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer(minLength: design.layout.gap.loose)
                    colorGrid
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Spacer(minLength: design.layout.gap.loose)
                
                HStack(alignment: .top) {
                    Text("Purpose")
                        .gentleText(.title3_ml)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    Text("Actions")
                        .gentleText(.headline_m)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                
                Spacer(minLength: design.layout.gap.regular)
                
                HStack(alignment: .top) {
                    Text(preset.purpose)
                        .gentleText(.body_m)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: design.layout.gap.loose)
                    VStack {
                        Button("Use preset") { }
                            .gentleButton(.primary, expandsHorizontally: true)
                        Button("Commit") { }
                            .gentleButton(.secondary, expandsHorizontally: true)
                        Button("Customize") { }
                            .gentleButton(.tertiary, expandsHorizontally: false)
                    }
                    .opacity(0.7)
                }
            }
            .opacity(0.8)
        }
        // .padding(.horizontal, design.layout.stack.regular)
        .padding(design.layout.stack.regular)
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
