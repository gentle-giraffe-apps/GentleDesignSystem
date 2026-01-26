import SwiftUI
import GentleDesignSystem

struct ThemePickerView: View {
    @GentleThemeManagerRuntime private var themeManager
    @GentleDesignRuntime private var design
    @State private var showingThemeStudio = false
    @State private var refreshID = UUID()
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

    /// Creates a preview theme for a preset, using saved edits if available.
    private func previewThemeForPreset(_ preset: ThemePreset) -> GentleTheme {
        let _ = refreshID // Force dependency on refreshID for redraw
        let savedSpec = try? themeManager.store.loadEditableSpec(forPreset: preset.name)
        return GentleTheme(
            defaultSpec: preset.spec,
            editableSpec: savedSpec ?? preset.spec
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: design.layout.grid.regular) {
                    ForEach(Array(ThemePreset.allPresets.enumerated()), id: \.element.id) { index, preset in
                        let previewTheme = previewThemeForPreset(preset)

                        Button {
                            try? themeManager.selectPreset(name: preset.name, defaultSpec: preset.spec)
                            showingThemeStudio = true
                        } label: {
                            GentleThemeRoot(theme: previewTheme) {
                                ThemePresetCard(preset: preset, index: index + 1, refreshID: refreshID)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Theme")
            .navigationDestination(isPresented: $showingThemeStudio) {
                ThemeStudioView()
            }
            .onChange(of: showingThemeStudio) { _, isShowing in
                if !isShowing {
                    refreshID = UUID()
                }
            }
        }
    }
}

// MARK: - New Portfolio-Quality Card

struct ThemePresetCard: View {
    let preset: ThemePreset
    let index: Int
    var refreshID: UUID = UUID()

    @GentleDesignRuntime private var design
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    @State private var isColorsExpanded = false
    @State private var isTypographyExpanded = false
    @State private var isButtonsExpanded = false

    // Row 1: Brand/Action colors
    private static let brandColors: [(GentleColorRole, String)] = [
        (.themePrimary, "Primary"),
        (.themeSecondary, "Secondary"),
        (.primaryCTA, "CTA"),
        (.destructive, "Destructive")
    ]

    // Row 2: Surface/Text colors
    private static let surfaceColors: [(GentleColorRole, String)] = [
        (.background, "Background"),
        (.surfaceBase, "SurfaceBase"),
        (.textPrimary, "Text"),
        (.borderSubtle, "Border")
    ]

    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Header
            headerSection

            divider

            // MARK: Colors
            colorsSection.padding(.trailing, 12)

            divider

            // MARK: Typography (Expandable)
            typographySection.padding(.trailing, 12)

            divider

            // MARK: Buttons (Expandable)
            buttonsSection
        }
        .gentleSurface(.card, inset: .card, insetVariant: .roomy)
        .shadow(color: .black.opacity(0.25), radius: 12, x: 8, y: 8)
    }

    // MARK: - Header Section

    private var headerSection: some View {
        HStack(alignment: .center) { // .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(preset.name)
                    .gentleText(.title_xl)
                Text(preset.summary)
                    .gentleText(.subheadline_ms)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .gentleText(.title2_l)
        }
    }

    // MARK: - Colors Section

    private var colorsSection: some View {
        DisclosureGroup(isExpanded: $isColorsExpanded) {
            // Color swatches in elevated container
            VStack(spacing: design.layout.gap.regular) {
                // Row 1: Brand/Action
                colorRow(Self.brandColors)

                // Row 2: Surface/Text
                colorRow(Self.surfaceColors)
            }
            .frame(maxWidth: .infinity)
            .padding(design.layout.gap.regular)
            .background(theme.color(for: .surfaceBase, scheme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)
        } label: {
            HStack(spacing: 0) {
                Text("Colors")
                    .gentleText(.headline_m)
                Spacer()
                colorBar
                    .opacity(0.7)
            }
        }
        .disclosureGroupStyle(GentleDisclosureStyle())
    }

    private var colorBar: some View {
        HStack(spacing: 0) {
            ForEach(Self.brandColors + Self.surfaceColors, id: \.0) { role, _ in
                theme.color(for: role, scheme: colorScheme)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Rectangle()
                            .stroke(Color(red: 0.7, green: 0.75, blue: 0.85), lineWidth: 1)
                            .opacity(0.5)
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private func colorRow(_ colors: [(GentleColorRole, String)]) -> some View {
        HStack(spacing: design.layout.gap.regular) {
            ForEach(colors, id: \.0) { role, label in
                colorSwatch(role: role, label: label)
            }
        }
    }

    private func colorSwatch(role: GentleColorRole, label: String) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.color(for: role, scheme: colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .frame(height: 32)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Typography Section

    private var typographySection: some View {
        DisclosureGroup(isExpanded: $isTypographyExpanded) {
            VStack(spacing: design.layout.gap.tight) {
                HStack(spacing: design.layout.gap.regular) {
                    typographySample(text: "Aa", label: "Title", style: .title_xl)
                    typographySample(text: "Aa", label: "Headline", style: .headline_m)
                }
                HStack(spacing: design.layout.gap.regular) {
                    typographySample(text: "Aa", label: "Body", style: .body_m)
                    typographySample(text: "Aa", label: "Callout", style: .callout_ms)
                }
                HStack(spacing: design.layout.gap.regular) {
                    typographySample(text: "Aa", label: "Subheadline", style: .subheadline_ms)
                    typographySample(text: "Aa", label: "Caption", style: .caption_s)
                }
            }
            // .padding(design.layout.gap.regular)
            .background(theme.color(for: .surfaceBase, scheme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } label: {
            HStack(spacing: 0) {
                Text("Typography")
                    .gentleText(.headline_m)
                Spacer()
                HStack(spacing: 8) {
                    Text("Aa")
                        .gentleText(.title_xl)
                    Text("Aa")
                        .gentleText(.headline_m)
                    Text("Aa")
                        .gentleText(.body_m)
                    Text("Aa")
                        .gentleText(.callout_ms)
                    Text("Aa")
                        .gentleText(.subheadline_ms)
                    Text("Aa")
                        .gentleText(.caption_s)
                }
            }
        }
        .disclosureGroupStyle(GentleDisclosureStyle())
    }

    private func typographySample(text: String, label: String, style: GentleTextRole) -> some View {
        HStack {
            Text(text)
                .gentleText(style)
            Text(label)
                .gentleText(.body_m)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    // MARK: - Buttons Section

    private var buttonsSection: some View {
        DisclosureGroup(isExpanded: $isButtonsExpanded) {
            HStack(spacing: design.layout.gap.tight) {
                Button("Main") { }
                    .gentleButton(.primary)
                Button("Alt") { }
                    .gentleButton(.secondary)
                Button("Ghost") { }
                    .gentleButton(.tertiary)
                Spacer()
            }
            .padding(.leading, 12)
            .padding(.top, design.layout.gap.tight)
            .allowsHitTesting(false)
        } label: {
            HStack(spacing: 0) {
                Text("Buttons")
                    .gentleText(.headline_m)
                Spacer()
                buttonChips
                    .id(refreshID)
                    .opacity(0.7)
            }
        }
        .disclosureGroupStyle(GentleDisclosureStyle())
    }

    // MARK: - Button Chip Previews

    private var buttonChips: some View {
        HStack(spacing: 6) {
            GentleButtonPreview(role: .primary, isMiniature: true)
            GentleButtonPreview(role: .secondary, isMiniature: true)
            GentleButtonPreview(role: .tertiary, isMiniature: true)
        }
    }

    // MARK: - Divider

    private var divider: some View {
        Rectangle()
            .fill(theme.color(for: .borderSubtle, scheme: colorScheme))
            .frame(height: 1)
            .padding(.horizontal, design.layout.stack.regular)
    }
}

// MARK: - Left Chevron Disclosure Style

struct GentleDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.right")
                        .gentleText(.subheadline_ms)
                        .opacity(0.5)
                        .rotationEffect(.degrees(configuration.isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: configuration.isExpanded)

                    configuration.label
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if configuration.isExpanded {
                configuration.content
                    .padding(.leading, 20)
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = GentleThemeManager()
    GentleThemeRoot(theme: manager.theme) {
        ThemePickerView()
    }
    .environment(\.gentleThemeManager, manager)
}
