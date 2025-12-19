import SwiftUI
import GentleDesignSystem

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) { // tighter (was 32)
                    TypographySection()
                    ButtonsSection()
                    SurfacesSection()
                    ColorsSection()
                }
                .padding(.horizontal, 12) // tighter (was 16)
                .padding(.vertical, 16)   // tighter (was 24)
            }
            .gentleSurface(.appBackground)
            .navigationTitle("Design System")
        }
    }
}

// MARK: - Typography Section

struct TypographySection: View {
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]

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
        VStack(alignment: .leading, spacing: 12) {
            Text("Typography")
                .gentleText(.title_xl)

            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                ForEach(styles, id: \.0) { name, role in
                    VStack(alignment: .leading, spacing: 4) {
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

struct ButtonsSection: View {
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Buttons")
                .gentleText(.title_xl)

            LazyVGrid(columns: columns, spacing: 12) {
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
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Surfaces")
                .gentleText(.title_xl)

            HStack(spacing: 12) {
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
        VStack(alignment: .leading, spacing: 6) {
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

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]
    
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
        VStack(alignment: .leading, spacing: 12) {
            Text("Colors")
                .gentleText(.title_xl)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.0) { name, color in
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                            .frame(width: 28, height: 28)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(Color.gray.opacity(0.25), lineWidth: 1)
                            )

                        Text(name)
                            .gentleText(.caption_s)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)

                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 6)
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
