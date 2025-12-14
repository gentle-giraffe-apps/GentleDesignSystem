import SwiftUI
import GentleDesignSystem

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    TypographySection()
                    ButtonsSection()
                    SurfacesSection()
                    ColorsSection()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
            .gentleSurface(.appBackground)
            .navigationTitle("Design System")
        }
    }
}

// MARK: - Typography Section

struct TypographySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Typography")
                .gentleText(.title_xl)

            VStack(alignment: .leading, spacing: 12) {
                Text("largeTitle_xxl")
                    .gentleText(.largeTitle_xxl)

                Text("title_xl")
                    .gentleText(.title_xl)

                Text("title2_l")
                    .gentleText(.title2_l)

                Text("title3_ml")
                    .gentleText(.title3_ml)

                Text("headline_m")
                    .gentleText(.headline_m)

                Text("body_m")
                    .gentleText(.body_m)

                Text("bodySecondary_m")
                    .gentleText(.bodySecondary_m)

                Text("monoCode_m")
                    .gentleText(.monoCode_m)

                Text("callout_ms")
                    .gentleText(.callout_ms)

                Text("subheadline_ms")
                    .gentleText(.subheadline_ms)

                Text("footnote_s")
                    .gentleText(.footnote_s)

                Text("caption_s")
                    .gentleText(.caption_s)

                Text("caption2_s")
                    .gentleText(.caption2_s)
            }
            .gentleSurface(.card)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Buttons Section

struct ButtonsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buttons")
                .gentleText(.title_xl)

            VStack(spacing: 16) {
                Button("Primary Button") {}
                    .gentleButton(.primary)

                Button("Secondary Button") {}
                    .gentleButton(.secondary)

                Button("Ghost Button") {}
                    .gentleButton(.ghost)

                Button("Destructive Button") {}
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Surfaces")
                .gentleText(.title_xl)

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("card")
                        .gentleText(.headline_m)
                    Text("Flat surface with subtle border")
                        .gentleText(.bodySecondary_m)
                }
                .gentleSurface(.card)

                VStack(alignment: .leading, spacing: 8) {
                    Text("cardElevated")
                        .gentleText(.headline_m)
                    Text("Elevated surface with shadow")
                        .gentleText(.bodySecondary_m)
                }
                .gentleSurface(.cardElevated)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Colors Section

struct ColorsSection: View {
    @Environment(\.gentleTheme) var theme
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Colors")
                .gentleText(.title_xl)

            VStack(spacing: 12) {
                ColorSwatch(
                    name: "textPrimary",
                    color: theme.color(for: .textPrimary, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "textSecondary",
                    color: theme.color(for: .textSecondary, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "textTertiary",
                    color: theme.color(for: .textTertiary, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "background",
                    color: theme.color(for: .background, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "surface",
                    color: theme.color(for: .surface, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "surfaceElevated",
                    color: theme.color(for: .surfaceElevated, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "borderSubtle",
                    color: theme.color(for: .borderSubtle, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "primaryCTA",
                    color: theme.color(for: .primaryCTA, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "onPrimaryCTA",
                    color: theme.color(for: .onPrimaryCTA, scheme: colorScheme)
                )

                ColorSwatch(
                    name: "destructive",
                    color: theme.color(for: .destructive, scheme: colorScheme)
                )
            }
            .gentleSurface(.card)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ColorSwatch: View {
    let name: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 48, height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )

            Text(name)
                .gentleText(.body_m)

            Spacer()
        }
    }
}

#Preview {
    GentleThemeRoot(theme: .default) {
        ContentView()
    }
}
