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

// MARK: - New Portfolio-Quality Card

struct ThemePresetCard: View {
    let preset: ThemePreset
    let index: Int

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
        (.surface, "Surface"),
        (.textPrimary, "Text"),
        (.borderSubtle, "Border")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: Header
            headerSection

            divider

            // MARK: Colors
            colorsSection

            divider

            // MARK: Typography (Expandable)
            typographySection

            divider

            // MARK: Buttons (Expandable)
            buttonsSection
        }
        .gentleInset(.card)
        .background(theme.color(for: .surface, scheme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.25), radius: 12, x: 8, y: 8)
    }

    // MARK: - Header Section

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(preset.name)
                    .gentleText(.title_xl)
                Text(preset.summary)
                    .gentleText(.subheadline_ms)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.body.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(design.layout.stack.regular)
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
            .background(theme.color(for: .surface, scheme: colorScheme))
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
        .tint(theme.color(for: .textSecondary, scheme: colorScheme))
        .padding(design.layout.stack.regular)
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
            .padding(design.layout.gap.regular)
            .background(theme.color(for: .surface, scheme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: 12))
//            .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 12)
//            .padding(.top, design.layout.gap.tight)
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
        .tint(theme.color(for: .textSecondary, scheme: colorScheme))
        .padding(design.layout.stack.regular)
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
                    .opacity(0.7)
            }
        }
        .tint(theme.color(for: .textSecondary, scheme: colorScheme))
        .padding(design.layout.stack.regular)
    }

    // MARK: - Button Chip Previews

    private var buttonChips: some View {
        HStack(spacing: 6) {
            // Primary
            buttonChip(
                background: .primaryCTA,
                icon: .onPrimaryCTA,
                border: nil
            )
            // Secondary
            buttonChip(
                background: .surface,
                icon: .primaryCTA,
                border: .primaryCTA
            )
            // Tertiary
            buttonChip(
                background: .surface,
                icon: .primaryCTA,
                border: nil
            )
        }
    }

    private func buttonChip(
        background: GentleColorRole,
        icon: GentleColorRole,
        border: GentleColorRole?
    ) -> some View {
        Image(systemName: "ellipsis")
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(theme.color(for: icon, scheme: colorScheme))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(theme.color(for: background, scheme: colorScheme))
            )
            .overlay(
                Group {
                    if let border {
                        Capsule()
                            .strokeBorder(theme.color(for: border, scheme: colorScheme), lineWidth: 1)
                    }
                }
            )
    }

    // MARK: - Divider

    private var divider: some View {
        Rectangle()
            .fill(theme.color(for: .borderSubtle, scheme: colorScheme))
            .frame(height: 1)
            .padding(.horizontal, design.layout.stack.regular)
    }
}

// MARK: - Legacy Card (for reference)

struct ThemePresetCardLegacy: View {
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
