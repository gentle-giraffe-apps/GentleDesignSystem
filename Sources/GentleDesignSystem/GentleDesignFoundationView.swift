//  Jonathan Ritchey

import SwiftUI
import UIKit

public struct GentleDesignFoundationView: View {
    @GentleDesignRuntime private var design

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: design.layout.stack.loose) {
                GentleDesignColorsSection()
                GentleDesignTypographySection()
                GentleDesignButtonsSection()
                GentleDesignSurfacesSection()
            }
            .gentleInset(.screen)
        }
        .gentleSurface(.appBackground)
    }
}

// MARK: - Colors Section

public struct GentleDesignColorsSection: View {
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var manager

    private var columns: [GridItem] { [
        GridItem(.adaptive(minimum: 135), spacing: design.layout.grid.regular)
        ]
    }

    private var items: [(String, GentleColorRole)] {
        [
            ("textPrimary", .textPrimary),
            ("textSecondary", .textSecondary),
            ("textTertiary", .textTertiary),
            ("background", .background),
            ("surface", .surface),
            ("surfaceElevated", .surfaceElevated),
            ("borderSubtle", .borderSubtle),
            ("primaryCTA", .primaryCTA),
            ("onPrimaryCTA", .onPrimaryCTA),
            ("destructive", .destructive)
        ]
    }

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Colors")
                .gentleText(.title_xl)
                .opacity(0.7)
            
            LazyVGrid(columns: columns, spacing: design.layout.grid.tight) {
                ForEach(items, id: \.0) { name, role in
                    ColorSwatchRow(role: role, name: name)
                }
            }
            .gentleSurface(.card, inset: .card)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ColorSwatchRow: View {
    let role: GentleColorRole
    let name: String

    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var manager

    var body: some View {
        let binding = manager.bindingForColorRole(role)
        let lightBinding = Binding<Color>(
            get: { Color(gentleHex: binding.lightHex.wrappedValue) },
            set: { binding.lightHex.wrappedValue = $0.toGentleHexString() }
        )
        let darkBinding = Binding<Color>(
            get: { Color(gentleHex: binding.darkHex.wrappedValue) },
            set: { binding.darkHex.wrappedValue = $0.toGentleHexString() }
        )

        HStack(spacing: design.layout.stack.tight) {
            HStack(spacing: 2) {
                ZStack {
                    lightBinding.wrappedValue.clipShape(RoundedRectangle(cornerRadius: 4))

                    ColorPicker("", selection: lightBinding, supportsOpacity: true)
                        .labelsHidden()
                        .opacity(0.1)
                }
                .frame(width: 32, height: 32)

                ZStack {
                    darkBinding.wrappedValue.clipShape(RoundedRectangle(cornerRadius: 4))

                    ColorPicker("", selection: darkBinding, supportsOpacity: true)
                        .labelsHidden()
                        .opacity(0.1)
                }
                .frame(width: 32, height: 32)
            }

            Text(name.camelCaseBreakable)
                .gentleText(.caption_s)
                .lineLimit(2)
                .minimumScaleFactor(0.75)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Typography Section

public struct GentleDesignTypographySection: View {
    @GentleDesignRuntime private var design
    @State private var editingRole: GentleTextRole?

    public init() {}

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100), spacing: design.layout.grid.regular)]
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
            Text("Typography")
                .gentleText(.title_xl)
                .opacity(0.7)

            LazyVGrid(columns: columns, alignment: .leading, spacing: design.layout.grid.regular) {
                ForEach(styles, id: \.0) { name, role in
                    Button {
                        editingRole = role
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
//                                HStack(alignment: .top) {
//                                    Text(name.camelCaseBreakable)
//                                        .gentleText(.caption_s)
//                                    Spacer()
//                                    Image(systemName: "slider.horizontal.3")
//                                        .gentleText(.title3_ml)
//                                        .opacity(0.7)
//                                }
//                                Text("Aa Bb")
//                                    .gentleText(role)
//                                    .lineLimit(1)
//                                    .minimumScaleFactor(0.8)
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("Aa")
                                            .gentleText(role)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        Text(name.camelCaseBreakable)
                                            .gentleText(.caption_s)
                                    }
                                    Spacer()
                                    Image(systemName: "slider.horizontal.3")
                                        .gentleText(.title3_ml)
                                        .opacity(0.7)
                                }
                            }
                        }
                        .padding(.vertical, design.layout.gap.s)
                        .padding(.horizontal, design.layout.gap.m)
                        .gentleSurface(.card)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(item: $editingRole) { role in
            TypographyRoleEditorSheet(role: role)
        }
    }
}

// MARK: - Buttons Section

public struct GentleDesignButtonsSection: View {
    @GentleDesignRuntime private var design

    public init() {}

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 130), spacing: design.layout.grid.regular)]
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Buttons")
                .gentleText(.title_xl)
                .opacity(0.7)

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
            .gentleSurface(.card, inset: .card)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Surfaces Section

public struct GentleDesignSurfacesSection: View {
    @GentleDesignRuntime private var design

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Surfaces")
                .gentleText(.title_xl)
                .opacity(0.7)
            
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
        .gentleSurface(surface, inset: .card)
    }
}

// MARK: - Color to Hex conversion

private extension Color {
    func toGentleHexString() -> String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        if a < 1.0 {
            return String(
                format: "#%02X%02X%02X%02X",
                Int(r * 255),
                Int(g * 255),
                Int(b * 255),
                Int(a * 255)
            )
        } else {
            return String(
                format: "#%02X%02X%02X",
                Int(r * 255),
                Int(g * 255),
                Int(b * 255)
            )
        }
    }
}
