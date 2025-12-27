import SwiftUI
import GentleDesignSystem

struct ContentView: View {
    @GentleDesignRuntime private var design
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: design.layout.stack.loose) {
                    TypographySection()
                    ButtonsSection()
                    SurfacesSection()
                    ColorsSection()
                }
                .gentleInset(.screen)
            }
            .gentleSurface(.appBackground)
            .navigationTitle("Design System")
        }
    }
}

// MARK: - Typography Section

struct TypographySection: View {
    @GentleDesignRuntime private var design
    
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
        ("callout_ms", .callout_ms),
        ("subheadline_ms", .subheadline_ms),
        ("footnote_s", .footnote_s),
        ("caption_s", .caption_s),
        ("caption2_s", .caption2_s)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Typography")
                .gentleText(.title_xl)

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
        .task {
            let spec = design.theme.spec
            do {
                let encodedJSONString = try spec.encodedJSONString()
                print("spec: \(encodedJSONString)")
            } catch {
                print("jritchey: \(error)")
            }
        }
    }
}

// MARK: - Buttons Section

struct ButtonsSection: View {
    @GentleDesignRuntime private var design
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150), spacing: design.layout.grid.regular)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Buttons")
                .gentleText(.title_xl)

            LazyVGrid(columns: columns, spacing: design.layout.grid.regular) {
                Button("Primary") {}
                    .gentleButton(.primary)

                Button("Secondary") {}
                    .gentleButton(.secondary)

                Button("Tertiary") {}
                    .gentleButton(.tertiary)

                Button("Destructive") {}
                    .gentleButton(.destructive)
            }
            .gentleSurface(.card)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Surfaces Section

struct SurfacesSection: View {
    @GentleDesignRuntime private var design
    
    var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Surfaces")
                .gentleText(.title_xl)

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

struct ColorsSection: View {
    @Environment(\.gentleTheme) var theme
    @Environment(\.colorScheme) var colorScheme
    @GentleDesignRuntime private var design
    
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

    var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Colors")
                .gentleText(.title_xl)

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
