//  Jonathan Ritchey

import SwiftUI

public struct GentleDesignFoundationView: View {
    @GentleDesignRuntime private var design

    private let onEditColors: (() -> Void)?
    private let onEditTypography: (() -> Void)?
    private let onEditButtons: (() -> Void)?
    private let onEditSurfaces: (() -> Void)?

    public init(
        onEditColors: (() -> Void)? = nil,
        onEditTypography: (() -> Void)? = nil,
        onEditButtons: (() -> Void)? = nil,
        onEditSurfaces: (() -> Void)? = nil
    ) {
        self.onEditColors = onEditColors
        self.onEditTypography = onEditTypography
        self.onEditButtons = onEditButtons
        self.onEditSurfaces = onEditSurfaces
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: design.layout.stack.loose) {
                GentleDesignColorsSection(onEdit: onEditColors)
                GentleDesignTypographySection(onEdit: onEditTypography)
                GentleDesignButtonsSection(onEdit: onEditButtons)
                GentleDesignSurfacesSection(onEdit: onEditSurfaces)
            }
            .gentleInset(.screen)
        }
        .gentleSurface(.appBackground)
    }
}

// MARK: - Typography Section

public struct GentleDesignTypographySection: View {
    @GentleDesignRuntime private var design

    private let onEdit: (() -> Void)?

    public init(onEdit: (() -> Void)? = nil) {
        self.onEdit = onEdit
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150), spacing: design.layout.grid.regular)]
    }

    private let styles: [(String, GentleTextRole)] = [
        ("largeTitle_xxl", .largeTitle_xxl),
        ("title_xl", .title_xl),
        ("title2_l", .title2_l),
        ("title3_ml", .title3_ml),
        ("headline_m", .headline_m),
        ("body_m", .body_m),
        ("bodySecondary_m", .bodySecondary_m),
        ("monoCode_m", .monoCode_m),
        ("primaryButtonTitle_m", .primaryButtonTitle_m),
        ("secondaryButtonTitle_m", .secondaryButtonTitle_m),
        ("tertiaryButtonTitle_m", .tertiaryButtonTitle_m),
        ("quaternaryButtonTitle_m", .quaternaryButtonTitle_m),
        ("callout_ms", .callout_ms),
        ("subheadline_ms", .subheadline_ms),
        ("footnote_s", .footnote_s),
        ("caption_s", .caption_s),
        ("caption2_s", .caption2_s)
    ]

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            HStack {
                Text("Typography")
                    .gentleText(.title_xl)
                Spacer()
                if let onEdit {
                    Button("Edit", action: onEdit)
                }
            }

            LazyVGrid(columns: columns, alignment: .leading, spacing: design.layout.grid.regular) {
                ForEach(styles, id: \.0) { name, role in
                    VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                        Text(name)
                            .gentleText(.callout_ms)
                            .opacity(0.8)
                        Text("Aa Bb")
                            .gentleText(role)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
            .gentleSurface(.card)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Buttons Section

public struct GentleDesignButtonsSection: View {
    @GentleDesignRuntime private var design

    private let onEdit: (() -> Void)?

    public init(onEdit: (() -> Void)? = nil) {
        self.onEdit = onEdit
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150), spacing: design.layout.grid.regular)]
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            HStack {
                Text("Buttons")
                    .gentleText(.title_xl)
                Spacer()
                if let onEdit {
                    Button("Edit", action: onEdit)
                }
            }

            LazyVGrid(columns: columns, spacing: design.layout.grid.regular) {
                Button("Primary") {}
                    .gentleButton(.primary)

                Button("Primary") {}
                    .gentleButton(.primary)
                    .disabled(true)

                Button("Secondary") {}
                    .gentleButton(.secondary)

                Button("Secondary") {}
                    .gentleButton(.secondary)
                    .disabled(true)
                
                Button("Tertiary") {}
                    .gentleButton(.tertiary)

                Button("Tertiary") {}
                    .gentleButton(.tertiary)
                    .disabled(true)
                
                Button("Quaternary") {}
                    .gentleButton(.quaternary)
                
                Button("Quaternary") {}
                    .gentleButton(.quaternary)
                    .disabled(true)
                
                Button("Destructive") {}
                    .gentleButton(.destructive)
            }
            .gentleSurface(.card)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Surfaces Section

public struct GentleDesignSurfacesSection: View {
    @GentleDesignRuntime private var design

    private let onEdit: (() -> Void)?

    public init(onEdit: (() -> Void)? = nil) {
        self.onEdit = onEdit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            HStack {
                Text("Surfaces")
                    .gentleText(.title_xl)
                Spacer()
                if let onEdit {
                    Button("Edit", action: onEdit)
                }
            }

            HStack(spacing: design.layout.stack.regular) {
                surfaceCard(
                    title: "card",
                    subtitle: "Subtle border",
                    surface: .card
                )

                surfaceCard(
                    title: "elevated",
                    subtitle: "Shadow",
                    surface: .cardElevated
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func surfaceCard(
        title: String,
        subtitle: String,
        surface: GentleSurfaceRole
    ) -> some View {
        VStack(alignment: .leading, spacing: design.layout.stack.tight) {
            Text(title)
                .gentleText(.headline_m)

            Text(subtitle)
                .gentleText(.caption_s)
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .gentleSurface(surface)
    }
}

// MARK: - Colors Section

public struct GentleDesignColorsSection: View {
    @Environment(\.gentleTheme) var theme
    @Environment(\.colorScheme) var colorScheme
    @GentleDesignRuntime private var design

    private let onEdit: (() -> Void)?

    public init(onEdit: (() -> Void)? = nil) {
        self.onEdit = onEdit
    }

    private var columns: [GridItem] { [
        GridItem(.adaptive(minimum: 150), spacing: design.layout.grid.regular)
        ]
    }

    private var items: [(String, Color)] {
        [
            ("textPrimary", theme.color(for: .textPrimary, scheme: colorScheme)),
            ("textSecondary", theme.color(for: .textSecondary, scheme: colorScheme)),
            ("textTertiary", theme.color(for: .textTertiary, scheme: colorScheme)),
            ("background", theme.color(for: .background, scheme: colorScheme)),
            ("surface", theme.color(for: .surface, scheme: colorScheme)),
            ("surfaceElevated", theme.color(for: .surfaceElevated, scheme: colorScheme)),
            ("borderSubtle", theme.color(for: .borderSubtle, scheme: colorScheme)),
            ("primaryCTA", theme.color(for: .primaryCTA, scheme: colorScheme)),
            ("onPrimaryCTA", theme.color(for: .onPrimaryCTA, scheme: colorScheme)),
            ("destructive", theme.color(for: .destructive, scheme: colorScheme))
        ]
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            HStack {
                Text("Colors")
                    .gentleText(.title_xl)
                Spacer()
                if let onEdit {
                    Button("Edit", action: onEdit)
                }
            }

            LazyVGrid(columns: columns, spacing: design.layout.grid.tight) {
                ForEach(items, id: \.0) { name, color in
                    HStack(spacing: design.layout.stack.regular) {
                        RoundedRectangle(cornerRadius: design.radii.small)
                            .fill(color)
                            .frame(width: 28, height: 28)
                            .overlay(
                                RoundedRectangle(cornerRadius: design.radii.small)
                                    .strokeBorder(design.color(.borderSubtle), lineWidth: 1)
                            )

                        Text(name)
                            .gentleText(.caption_s)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)

                        Spacer(minLength: 0)
                    }
                }
            }
            .gentleSurface(.card)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
