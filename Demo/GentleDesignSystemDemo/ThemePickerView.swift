import SwiftUI
import GentleDesignSystem

struct ThemePickerView: View {
    @GentleThemeManagerRuntime private var themeManager
    @GentleDesignRuntime private var design
    @State private var showingThemeStudio = false
    @State private var isCreatingNewTheme = false
    @State private var refreshID = UUID()
    @State private var savedThemeNames: [String] = []
    @Environment(\.horizontalSizeClass) private var sizeClass

    /// Built-in preset names (to filter out from saved themes)
    private var builtInPresetNames: Set<String> {
        Set(ThemePreset.allPresets.map { $0.name.lowercased().replacingOccurrences(of: " ", with: "_") })
    }

    /// User-created themes (saved but not built-in presets)
    private var userSavedThemes: [String] {
        savedThemeNames.filter { name in
            let normalizedName = name.lowercased().replacingOccurrences(of: " ", with: "_")
            return !builtInPresetNames.contains(normalizedName)
        }
    }

    private var columns: [GridItem] {
        if sizeClass == .compact {
            // iPhone: single column, full width
            [GridItem(.flexible())]
        } else {
            // iPad: adaptive grid
            [GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 8, alignment: .leading)]
        }
    }

    /// Loads saved theme names from the filesystem
    private func loadSavedThemes() {
        do {
            savedThemeNames = try themeManager.store.listSavedPresetNames()
        } catch {
            print("Failed to load saved themes: \(error)")
            savedThemeNames = []
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
                VStack(alignment: .leading, spacing: design.layout.grid.regular) {
                    // MARK: - Create Theme Card (always rendered with Gentle Default theme)
                    if let defaultPreset = ThemePreset.allPresets.first {
                        let defaultTheme = GentleTheme(
                            defaultSpec: defaultPreset.spec,
                            editableSpec: defaultPreset.spec
                        )
                        GentleThemeRoot(theme: defaultTheme) {
                            CreateThemeCard(showingThemeStudio: $showingThemeStudio, isCreatingNewTheme: $isCreatingNewTheme)
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Saved Themes Section (if any user-created themes exist)
                    if !userSavedThemes.isEmpty {
                        Text("Saved Themes")
                            .gentleText(.title3_ml)
                            .padding(.horizontal)
                            .padding(.top, design.layout.gap.regular)

                        LazyVGrid(columns: columns, spacing: design.layout.grid.regular) {
                            ForEach(userSavedThemes, id: \.self) { themeName in
                                SavedThemeCard(themeName: themeName, refreshID: refreshID)
                                    .onTapGesture {
                                        // Load the saved theme and navigate to studio
                                        if let savedSpec = try? themeManager.store.loadEditableSpec(forPreset: themeName) {
                                            try? themeManager.selectPreset(name: themeName, defaultSpec: savedSpec)
                                            isCreatingNewTheme = true // Allow editing the name
                                            showingThemeStudio = true
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Preset Themes Section Header
                    Text("Preset Themes")
                        .gentleText(.title3_ml)
                        .padding(.horizontal)
                        .padding(.top, design.layout.gap.regular)

                    // MARK: - Preset Theme Cards
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
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Theme")
            .navigationDestination(isPresented: $showingThemeStudio) {
                ThemeStudioView(isTitleEditable: isCreatingNewTheme)
            }
            .onChange(of: showingThemeStudio) { _, isShowing in
                if !isShowing {
                    refreshID = UUID()
                    isCreatingNewTheme = false
                    loadSavedThemes()
                }
            }
            .onAppear {
                loadSavedThemes()
            }
        }
    }
}

// MARK: - Saved Theme Card

struct SavedThemeCard: View {
    let themeName: String
    var refreshID: UUID = UUID()

    @GentleThemeManagerRuntime private var themeManager
    @GentleDesignRuntime private var design
    @Environment(\.colorScheme) private var colorScheme

    // Color roles to preview
    private static let previewColors: [GentleColorRole] = [
        .themePrimary,
        .themeSecondary,
        .primaryCTA,
        .destructive,
        .background,
        .surfaceBase,
        .textPrimary,
        .borderSubtle
    ]

    /// Load the saved spec and create a preview theme
    private var previewTheme: GentleTheme? {
        let _ = refreshID // Force dependency on refreshID
        guard let savedSpec = try? themeManager.store.loadEditableSpec(forPreset: themeName) else {
            return nil
        }
        return GentleTheme(defaultSpec: savedSpec, editableSpec: savedSpec)
    }

    var body: some View {
        if let previewTheme {
            GentleThemeRoot(theme: previewTheme) {
                cardContent(theme: previewTheme)
            }
        } else {
            // Fallback if theme can't be loaded
            Text(themeName)
                .gentleText(.headline_m)
                .padding()
                .gentleSurface(.card)
        }
    }

    private func cardContent(theme: GentleTheme) -> some View {
        VStack(alignment: .leading, spacing: design.layout.gap.regular) {
            // Header
            HStack {
                Text(themeName)
                    .gentleText(.title_xl)
                Spacer()
                Image(systemName: "chevron.right")
                    .gentleText(.title2_l)
            }

            // Color bar preview
            HStack(spacing: 0) {
                ForEach(Self.previewColors, id: \.self) { role in
                    theme.color(for: role, scheme: colorScheme)
                        .frame(height: 24)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(theme.color(for: .borderSubtle, scheme: colorScheme), lineWidth: 0.5)
            )
        }
        .gentleSurface(.card, inset: .card, insetVariant: .roomy)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 4, y: 4)
    }
}

// MARK: - Create Theme Card

struct CreateThemeCard: View {
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var themeManager
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    @Binding var showingThemeStudio: Bool
    @Binding var isCreatingNewTheme: Bool
    @State private var selectedPresetName: String = ThemePreset.allPresets.first?.name ?? "Gentle Default"
    @State private var showingBaseThemePicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: design.layout.gap.regular) {
            // Title and Subtitle (matching preset card spacing)
            VStack(alignment: .leading, spacing: 4) {
                Text("Create Your Theme")
                    .gentleText(.title_xl)

                Text("Choose a base theme to start from")
                    .gentleText(.subheadline_ms, colorRole: .textSecondary)
            }

            // Dropdown picker and Create button row
            HStack(spacing: design.layout.gap.regular) {
                // Dropdown picker button
                Button {
                    showingBaseThemePicker = true
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedPresetName)
                            .gentleText(.body_m)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .truncationMode(.tail)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.color(for: .surfaceBase, scheme: colorScheme))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(theme.color(for: .borderSubtle, scheme: colorScheme), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showingBaseThemePicker) {
                    BaseThemePickerPopover(
                        selectedPresetName: $selectedPresetName,
                        onDismiss: { showingBaseThemePicker = false }
                    )
                }

                // Create button
                Button {
                    // Find the selected preset and create a new theme based on it
                    if let basePreset = ThemePreset.allPresets.first(where: { $0.name == selectedPresetName }) {
                        try? themeManager.selectPreset(name: "New Theme", defaultSpec: basePreset.spec)
                        isCreatingNewTheme = true
                        showingThemeStudio = true
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Create")
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .truncationMode(.tail)
                    }
                }
                .gentleButton(.primary)
            }
        }
        .gentleSurface(.card, inset: .card, insetVariant: .roomy)
        .overlay(
            RoundedRectangle(cornerRadius: max(8, theme.radii.large - 10))
                .strokeBorder(
                    theme.color(for: .borderSubtle, scheme: colorScheme),
                    style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                )
                .padding(10)
        )
    }
}

// MARK: - Base Theme Picker Popover

private struct BaseThemePickerPopover: View {
    @Binding var selectedPresetName: String
    let onDismiss: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(ThemePreset.allPresets) { preset in
                    BaseThemeOptionRow(
                        preset: preset,
                        isSelected: selectedPresetName == preset.name,
                        colorScheme: colorScheme,
                        onSelect: {
                            selectedPresetName = preset.name
                            onDismiss()
                        }
                    )
                    if preset.id != ThemePreset.allPresets.last?.id {
                        Divider()
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .frame(minWidth: 260, maxHeight: 400)
        .presentationCompactAdaptation(.popover)
    }
}

private struct BaseThemeOptionRow: View {
    let preset: ThemePreset
    let isSelected: Bool
    let colorScheme: ColorScheme
    let onSelect: () -> Void

    // Simplified color roles for swatches (4 colors)
    private static let previewColors: [GentleColorRole] = [
        .themePrimary,
        .primaryCTA,
        .destructive,
        .surfaceBase
    ]

    /// Get the preset's background color for the current color scheme
    private var presetBackgroundColor: Color {
        let pair = preset.spec.colors.pairByRole[GentleColorRole.background.rawValue]
        let hex = colorScheme == .dark ? pair?.darkHex : pair?.lightHex
        return colorFromHex(hex)
    }

    /// Get the preset's text color for the current color scheme
    private var presetTextColor: Color {
        let pair = preset.spec.colors.pairByRole[GentleColorRole.textPrimary.rawValue]
        let hex = colorScheme == .dark ? pair?.darkHex : pair?.lightHex
        return colorFromHex(hex)
    }

    /// Get the preset's theme primary color for the checkmark
    private var presetAccentColor: Color {
        let pair = preset.spec.colors.pairByRole[GentleColorRole.themePrimary.rawValue]
        let hex = colorScheme == .dark ? pair?.darkHex : pair?.lightHex
        return colorFromHex(hex)
    }

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Checkmark
                Image(systemName: "checkmark")
                    .foregroundStyle(presetAccentColor)
                    .opacity(isSelected ? 1 : 0)

                // Preset name
                Text(preset.name)
                    .foregroundStyle(presetTextColor)

                Spacer()

                // Color swatches
                presetColorSwatches
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(presetBackgroundColor)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var presetColorSwatches: some View {
        HStack(spacing: 0) {
            ForEach(Self.previewColors, id: \.self) { role in
                let pair = preset.spec.colors.pairByRole[role.rawValue]
                let hex = colorScheme == .dark ? pair?.darkHex : pair?.lightHex
                colorFromHex(hex)
                    .frame(width: 20, height: 20)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
    }

    private func colorFromHex(_ hex: String?) -> Color {
        guard let hex = hex else { return .gray }
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        return Color(red: r, green: g, blue: b)
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
    @State private var isSurfacesExpanded = false

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

            divider

            // MARK: Surfaces (Expandable)
            surfacesSection
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

    // MARK: - Surfaces Section

    private var surfacesSection: some View {
        DisclosureGroup(isExpanded: $isSurfacesExpanded) {
            VStack(spacing: design.layout.gap.regular) {
                // Structure surfaces
                HStack(spacing: design.layout.gap.tight) {
                    surfacePreview(role: .card, label: "Card")
                    surfacePreview(role: .cardElevated, label: "Elevated")
                    surfacePreview(role: .cardSecondary, label: "Secondary")
                }

                // Overlay/Floating surfaces
                HStack(spacing: design.layout.gap.tight) {
                    surfacePreview(role: .overlaySheet, label: "Sheet")
                    surfacePreview(role: .overlayPopover, label: "Popover")
                    surfacePreview(role: .floatingPanel, label: "Panel")
                }
            }
            .padding(design.layout.gap.regular)
            .padding(.leading, 12)
            .padding(.top, design.layout.gap.tight)
        } label: {
            HStack(spacing: 0) {
                Text("Surfaces")
                    .gentleText(.headline_m)
                Spacer()
                surfaceChips
            }
        }
        .disclosureGroupStyle(GentleDisclosureStyle())
    }

    private func surfacePreview(role: GentleSurfaceRole, label: String) -> some View {
        let cornerRadius = theme.surfaces.roleSpec(for: role).cornerRadius
        return VStack(spacing: 4) {
            ZStack {
                ColorfulStripesBackground(baseColor: theme.color(for: .themePrimary, scheme: colorScheme))
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.clear)
                    .gentleSurface(role)
            }
            .frame(height: 40)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    theme.color(for: .surfaceBase, scheme: colorScheme)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                )
        }
        .frame(maxWidth: .infinity)
    }

    private var surfaceChips: some View {
        HStack(spacing: 4) {
            ForEach(Array(GentleSurfaceRole.allCases.prefix(6)), id: \.self) { role in
                let cornerRadius = theme.surfaces.roleSpec(for: role).cornerRadius
                ZStack {
                    ColorfulStripesBackground(baseColor: theme.color(for: .themePrimary, scheme: colorScheme), stripeWidth: 4)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.clear)
                        .gentleSurface(role)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(theme.color(for: .borderSubtle, scheme: colorScheme), lineWidth: 1)
                )
                .frame(width: 28, height: 16)
            }
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

// MARK: - Diagonal Stripes Background

struct DiagonalStripesBackground: View {
    var body: some View {
        Canvas { context, size in
            // Draw diagonal stripes that darken the background
            let stripeWidth: CGFloat = 12
            let spacing: CGFloat = 8
            let totalWidth = size.width + size.height

            var x: CGFloat = -size.height
            while x < totalWidth {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x + size.height, y: size.height))
                path.addLine(to: CGPoint(x: x + size.height + stripeWidth, y: size.height))
                path.addLine(to: CGPoint(x: x + stripeWidth, y: 0))
                path.closeSubpath()

                context.fill(path, with: .color(.black.opacity(0.08)))
                x += spacing + stripeWidth
            }
        }
    }
}

// MARK: - Colorful Stripes Background

struct ColorfulStripesBackground: View {
    let baseColor: Color
    var stripeWidth: CGFloat = 10

    // Generate shades from the base color
    private var shades: [Color] {
        [
            baseColor.opacity(1.0),
            baseColor.opacity(0.85),
            baseColor.opacity(0.7),
            baseColor.opacity(0.9),
            baseColor.opacity(0.75)
        ]
    }

    var body: some View {
        Canvas { context, size in
            let stripeWidth = self.stripeWidth
            let totalWidth = size.width + size.height

            var x: CGFloat = -size.height
            var colorIndex = 0
            var isColoredStripe = true

            while x < totalWidth {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x + size.height, y: size.height))
                path.addLine(to: CGPoint(x: x + size.height + stripeWidth, y: size.height))
                path.addLine(to: CGPoint(x: x + stripeWidth, y: 0))
                path.closeSubpath()

                if isColoredStripe {
                    // Gradient from one shade to the next at full opacity
                    let color1 = shades[colorIndex % shades.count]
                    let color2 = shades[(colorIndex + 1) % shades.count]
                    let gradient = Gradient(colors: [color1, color2])

                    context.fill(
                        path,
                        with: .linearGradient(
                            gradient,
                            startPoint: CGPoint(x: x, y: 0),
                            endPoint: CGPoint(x: x + stripeWidth + size.height, y: size.height)
                        )
                    )
                    colorIndex += 1
                } else {
                    // Gap stripe - base color at 20% opacity
                    context.fill(path, with: .color(baseColor.opacity(0.2)))
                }

                isColoredStripe.toggle()
                x += stripeWidth
            }
        }
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
