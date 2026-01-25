//  Jonathan Ritchey

import SwiftUI
import UIKit

public struct GentleThemeEditor: View {
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
            ("surfaceTint", .surfaceTint),
            ("surfaceSpecular", .surfaceSpecular),
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

struct ColorSwatchRow: View {
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
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
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
                        VStack(alignment: .leading) {
                            Text("Aa")
                                .gentleText(role)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Text(name.camelCaseBreakable)
                                .gentleText(.caption_s)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
                        .padding(.vertical, design.layout.gap.s)
                        .padding(.horizontal, design.layout.gap.m)
                        .gentleSurface(.card, showTappableHint: true)
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
    @State private var editingRole: GentleButtonRole?

    public init() {}

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100), spacing: design.layout.grid.regular)]
    }

    private let buttonStyles: [(String, GentleButtonRole)] = [
        ("Primary", .primary),
        ("Secondary", .secondary),
        ("Tertiary", .tertiary),
        ("Quaternary", .quaternary),
        ("Destructive", .destructive)
    ]

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Buttons")
                .gentleText(.title_xl)
                .opacity(0.7)

            LazyVGrid(columns: columns, spacing: design.layout.grid.regular) {
                ForEach(buttonStyles, id: \.0) { name, role in
                    ButtonPreviewCard(name: name, role: role) {
                        editingRole = role
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(item: $editingRole) { role in
            ButtonRoleEditorSheet(role: role)
        }
    }
}

// MARK: - Button Preview (non-interactive)

/// A non-interactive view that renders the appearance of a gentle button.
/// Use this when you need to display a button preview inside another tappable area.
/// Set `isMiniature: true` for a compact chip representation (e.g., in theme pickers).
public struct GentleButtonPreview: View {
    public let role: GentleButtonRole
    public var isPressed: Bool = false
    public var isMiniature: Bool = false

    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(role: GentleButtonRole, isPressed: Bool = false, isMiniature: Bool = false) {
        self.role = role
        self.isPressed = isPressed
        self.isMiniature = isMiniature
    }

    public var body: some View {
        let spec = theme.buttons.roleSpec(for: role)

        if isMiniature {
            miniatureBody(spec: spec)
        } else {
            fullSizeBody(spec: spec)
                .padding(theme.buttons.roleSpec(for: role).usesNativeStyle ? 4 : 0)
        }
    }

    // MARK: - Miniature (chip) rendering

    @ViewBuilder
    private func miniatureBody(spec: GentleButtonRoleSpec) -> some View {
        // Derive colors from material role
        let (backgroundColor, iconColorRole): (Color, GentleColorRole) = {
            switch spec.fillRole {
            case .solidFillPrimaryCTA:
                return (theme.color(for: .primaryCTA, scheme: colorScheme), .onPrimaryCTA)
            case .solidFillDestructive:
                return (theme.color(for: .destructive, scheme: colorScheme), .onPrimaryCTA)
            case .hollow:
                // Use surface color for miniature chips so they're visible
                return (theme.color(for: .surface, scheme: colorScheme), .primaryCTA)
            }
        }()
        let iconColor = theme.color(for: iconColorRole, scheme: colorScheme)

        // Resolve border color from border role
        let borderColor: Color? = {
            switch spec.borderRole {
            case .hidden: return nil
            case .accent: return theme.color(for: .primaryCTA, scheme: colorScheme)
            case .subtle: return theme.color(for: .borderSubtle, scheme: colorScheme)
            }
        }()

        // When usesNativeStyle is true, show minimal chip with just the icon
        if spec.usesNativeStyle {
            Image(systemName: "ellipsis")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(theme.color(for: .primaryCTA, scheme: colorScheme))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
        } else {
            let isPill = spec.shape == .pill

            Image(systemName: "ellipsis")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(iconColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Group {
                        if isPill {
                            Capsule().fill(backgroundColor)
                        } else {
                            RoundedRectangle(cornerRadius: 6).fill(backgroundColor)
                        }
                    }
                )
                .overlay(
                    Group {
                        if let borderColor {
                            if isPill {
                                Capsule().strokeBorder(borderColor, lineWidth: 1)
                            } else {
                                RoundedRectangle(cornerRadius: 6).strokeBorder(borderColor, lineWidth: 1)
                            }
                        }
                    }
                )
        }
    }

    // MARK: - Full-size rendering

    @ViewBuilder
    private func fullSizeBody(spec: GentleButtonRoleSpec) -> some View {
        let textRole = role.defaultTextRole
        let animSpec = theme.buttons.animationSpec(for: spec.animationRole)
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: reduceMotion,
            role: spec.animationRole,
            spec: animSpec
        )

        // Derive colors from material role
        let (backgroundColor, labelColorRole): (Color, GentleColorRole) = {
            switch spec.fillRole {
            case .solidFillPrimaryCTA:
                return (theme.color(for: .primaryCTA, scheme: colorScheme), .onPrimaryCTA)
            case .solidFillDestructive:
                return (theme.color(for: .destructive, scheme: colorScheme), .onPrimaryCTA)
            case .hollow:
                return (Color.clear, .primaryCTA)
            }
        }()
        let labelColor = theme.color(for: labelColorRole, scheme: colorScheme)

        // When usesNativeStyle is true, skip background/border/padding - just text styling with accent color
        if spec.usesNativeStyle {
            Text("Edit")
                .gentleText(textRole, colorRole: labelColorRole)
                .scaleEffect(isPressed ? spec.pressedScale : 1.0)
                .opacity(isPressed ? spec.pressedOpacity : 1.0)
                .animation(animation, value: isPressed)
        } else {
            let gap = theme.gap
            let radii = theme.radii

            let cornerRadius: CGFloat = (spec.shape == .pill)
                ? CGFloat(radii.pill)
                : CGFloat(radii.medium)

            // Secondary buttons have optical trim adjustment
            let secondaryOpticalTrim: CGFloat = (role == .secondary) ? 1.0 : 0.0
            let verticalPadding: CGFloat = max(0, CGFloat(gap.s) - secondaryOpticalTrim)

            // Resolve border color from border role
            let borderColor: Color? = {
                switch spec.borderRole {
                case .hidden: return nil
                case .accent: return theme.color(for: .primaryCTA, scheme: colorScheme)
                case .subtle: return theme.color(for: .borderSubtle, scheme: colorScheme)
                }
            }()

            Text("Edit")
                .gentleText(textRole, colorRole: labelColorRole)
                .padding(.horizontal, CGFloat(gap.xl))
                .padding(.vertical, verticalPadding)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(backgroundColor))
                .overlay(
                    Group {
                        if let borderColor {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .strokeBorder(borderColor, lineWidth: 1)
                        }
                    }
                )
                .foregroundStyle(labelColor)
                .scaleEffect(isPressed ? spec.pressedScale : 1.0)
                .opacity(isPressed ? spec.pressedOpacity : 1.0)
                .animation(animation, value: isPressed)
        }
    }
}

// MARK: - Button Preview Card

struct ButtonPreviewCard: View {
    let name: String
    let role: GentleButtonRole
    let action: () -> Void

    @GentleDesignRuntime private var design
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            ButtonPreviewCardContent(name: name, role: role)
        }
        .buttonStyle(ButtonPreviewCardStyle())
        .gentleSurface(.card, showTappableHint: true)
    }
}

struct ButtonPreviewCardContent: View {
    let name: String
    let role: GentleButtonRole

    @GentleDesignRuntime private var design
    @Environment(\.buttonPreviewCardIsPressed) private var isPressed

    var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.tight) {
            GentleButtonPreview(role: role, isPressed: isPressed)

            Text(name.camelCaseBreakable)
                .gentleText(.caption_s)
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
        .padding(.vertical, design.layout.gap.s)
        .padding(.horizontal, design.layout.gap.m)
        .contentShape(Rectangle())
    }
}

struct ButtonPreviewCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        // This is a workaround - we need to rebuild content with isPressed
        // The actual isPressed passing happens via environment or reconstruction
        configuration.label
            .environment(\.buttonPreviewCardIsPressed, configuration.isPressed)
    }
}

struct ButtonPreviewCardIsPressedKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var buttonPreviewCardIsPressed: Bool {
        get { self[ButtonPreviewCardIsPressedKey.self] }
        set { self[ButtonPreviewCardIsPressedKey.self] = newValue }
    }
}

// MARK: - Button Role Editor Sheet

struct ButtonRoleEditorSheet: View {
    let role: GentleButtonRole
    @Environment(\.dismiss) private var dismiss
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var manager

    /// The initial spec captured when the sheet appears, used to revert on cancel/drag-dismiss.
    @State private var initialSpec: GentleButtonRoleSpec?
    /// Tracks whether the user explicitly saved changes.
    @State private var didSave = false

    private let shapes: [GentleButtonShape] = [.rounded, .pill]
    private let fillRoles: [GentleButtonFillRole] = GentleButtonFillRole.allCases
    private let borderRoles: [GentleButtonBorderRole] = GentleButtonBorderRole.allCases
    private let animationRoles: [GentleButtonAnimationRole] = GentleButtonAnimationRole.allCases

    var body: some View {
        let binding = manager.bindingForButtonRole(role)

        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: design.layout.stack.regular) {
                    Text(role.rawValue.capitalized)
                        .gentleText(.title_xl)

                    HStack(spacing: design.layout.stack.regular) {
                        VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                            Text("Default")
                                .gentleText(.caption_s)
                                .opacity(0.7)
                            GentleButtonPreview(role: role)
                        }

                        VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                            Text("Pressed")
                                .gentleText(.caption_s)
                                .opacity(0.7)
                            GentleButtonPreview(role: role, isPressed: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, design.layout.gap.m)
                .padding(.vertical, design.layout.gap.s)

                List {
                    Section {
                        Picker("Shape", selection: binding.shape) {
                            ForEach(shapes, id: \.self) { shape in
                                Text(shape.rawValue.capitalized).tag(shape)
                            }
                        }
                        .disabled(binding.usesNativeStyle.wrappedValue)

                        Picker("Fill", selection: binding.fillRole) {
                            ForEach(fillRoles, id: \.self) { fill in
                                Text(fill.displayName).tag(fill)
                            }
                        }
                        .disabled(binding.usesNativeStyle.wrappedValue)
                        .onChange(of: binding.fillRole.wrappedValue) { _, newValue in
                            // Solid fills don't need borders
                            if newValue != .hollow {
                                binding.borderRole.wrappedValue = .hidden
                            }
                        }

                        // Only show border picker for hollow buttons
                        if binding.fillRole.wrappedValue == .hollow {
                            Picker("Border", selection: binding.borderRole) {
                                ForEach(borderRoles, id: \.self) { border in
                                    Text(border.displayName).tag(border)
                                }
                            }
                            .disabled(binding.usesNativeStyle.wrappedValue)
                        }

                        Picker("Animation Role", selection: binding.animationRole) {
                            ForEach(animationRoles, id: \.self) { role in
                                Text(role.rawValue.capitalized).tag(role)
                            }
                        }
                    }

                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Pressed Scale")
                                Spacer()
                                Text(String(format: "%.2f", binding.pressedScale.wrappedValue))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: binding.pressedScale, in: 0.7...1.0, step: 0.01)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Pressed Opacity")
                                Spacer()
                                Text(String(format: "%.2f", binding.pressedOpacity.wrappedValue))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: binding.pressedOpacity, in: 0.3...1.0, step: 0.01)
                        }

                        Toggle("Uses Native Style", isOn: binding.usesNativeStyle)

                        if binding.usesNativeStyle.wrappedValue {
                            Text("Native style ignores background, border, and shape.")
                                .gentleText(.caption_s)
                                .opacity(0.7)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .gentleSurface(.appBackground)
            .navigationTitle("Customize Buttons")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        revertChanges()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        didSave = true
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .presentationDetents([.large])
        .onAppear {
            // Capture initial state for potential revert
            initialSpec = manager.bindingForButtonRole(role).wrappedValue
        }
        .onDisappear {
            // If user dragged to dismiss without saving, revert changes
            if !didSave {
                revertChanges()
            }
        }
    }

    private func revertChanges() {
        guard let initialSpec else { return }
        manager.bindingForButtonRole(role).wrappedValue = initialSpec
    }
}

// MARK: - Surfaces Section

public struct GentleDesignSurfacesSection: View {
    @GentleDesignRuntime private var design
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @State private var editingRole: GentleSurfaceRole?

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
        .sheet(item: $editingRole) { role in
            SurfaceRoleEditorSheet(role: role)
        }
    }

    private func surfaceCard(
        title: String,
        subtitle: String,
        surface: GentleSurfaceRole
    ) -> some View {
        Button {
            editingRole = surface
        } label: {
            VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                Text(title)
                    .gentleText(.headline_m)

                Text(subtitle)
                    .gentleText(.caption_s)
                    .opacity(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .gentleSurface(surface, inset: .card, showTappableHint: true)
        }
        .buttonStyle(.plain)
    }
}

extension GentleSurfaceRole: Identifiable {
    public var id: String { rawValue }
}

// MARK: - Surface Role Editor Sheet

struct SurfaceRoleEditorSheet: View {
    let role: GentleSurfaceRole
    @Environment(\.dismiss) private var dismiss
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var manager

    /// The initial spec captured when the sheet appears, used to revert on cancel/drag-dismiss.
    @State private var initialSpec: GentleSurfaceRoleSpec?
    /// Tracks whether the user explicitly saved changes.
    @State private var didSave = false

    var body: some View {
        let binding = manager.bindingForSurfaceRole(role)

        NavigationStack {
            VStack(spacing: 0) {
                // Preview section
                VStack(alignment: .leading, spacing: design.layout.stack.regular) {
                    Text(role.rawValue.capitalized)
                        .gentleText(.title_xl)

                    // Surface preview with background content to showcase blur/glass effects
                    ZStack {
                        // Background mock UI content (visible through blur/glass effects)
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 8) {
                                    Circle().fill(design.color(.themePrimary)).frame(width: 20, height: 20)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Primary Action")
                                            .gentleText(.caption_s)
                                        Text("Theme primary color")
                                            .gentleText(.caption2_s)
                                    }
                                }
                                HStack(spacing: 8) {
                                    Circle().fill(design.color(.themeSecondary)).frame(width: 20, height: 20)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Secondary Item")
                                            .gentleText(.caption_s)
                                        Text("Theme secondary color")
                                            .gentleText(.caption2_s)
                                    }
                                }
                                HStack(spacing: 8) {
                                    Circle().fill(design.color(.primaryCTA)).frame(width: 20, height: 20)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Call to Action")
                                            .gentleText(.caption_s)
                                        Text("Primary CTA color")
                                            .gentleText(.caption2_s)
                                    }
                                }
                            }
                            .padding(.leading)

                            Spacer()

                            // Mesh gradient to showcase blur effects
                            MeshGradient(
                                width: 3,
                                height: 3,
                                points: [
                                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                                    [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
                                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                                ],
                                colors: [
                                    .red, .purple, .indigo,
                                    .orange, .pink, .blue,
                                    .yellow, .green, .cyan
                                ]
                            )
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            Spacer()
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)

                        // Surface preview overlay
                        VStack(spacing: design.layout.stack.tight) {
                            Text("Preview")
                                .gentleText(.title2_l, colorRole: binding.visualEffect.wrappedValue == .surfaceOverlay ? .onOverlay : .textPrimary)
                            Text("Sample content")
                                .gentleText(.body_m, colorRole: binding.visualEffect.wrappedValue == .surfaceOverlay ? .onOverlaySecondary : .textSecondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .center)
                        .gentleSurface(role, inset: .card)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, design.layout.gap.xl)
                .padding(.vertical, design.layout.gap.s)

                List {
                    Section("Visual Effect") {
                        Picker("Visual Effect", selection: binding.visualEffect) {
                            ForEach(GentleVisualEffect.allCases, id: \.self) { role in
                                Text(role.displayName).tag(role)
                            }
                        }
                    }

                    Section("Border") {
                        SurfaceColorPairRow(name: "Border Color", binding: binding.border)
                    }

                    Section("Structure") {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Corner Radius")
                                Spacer()
                                Text(String(format: "%.0f", binding.cornerRadius.wrappedValue))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: binding.cornerRadius, in: 0...40, step: 1)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Border Width")
                                Spacer()
                                Text(String(format: "%.1f", binding.borderWidth.wrappedValue))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: binding.borderWidth, in: 0...4, step: 0.5)
                        }
                    }

                    Section("Shadow") {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Shadow Radius")
                                Spacer()
                                Text(String(format: "%.0f", binding.shadowRadius.wrappedValue))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: binding.shadowRadius, in: 0...20, step: 1)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Shadow Opacity")
                                Spacer()
                                Text(String(format: "%.2f", binding.shadowOpacity.wrappedValue))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: binding.shadowOpacity, in: 0...0.5, step: 0.01)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Shadow Offset X")
                                Spacer()
                                Text(String(format: "%.0f", binding.shadowOffsetX.wrappedValue))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: binding.shadowOffsetX, in: -10...10, step: 1)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Shadow Offset Y")
                                Spacer()
                                Text(String(format: "%.0f", binding.shadowOffsetY.wrappedValue))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: binding.shadowOffsetY, in: -10...10, step: 1)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .gentleSurface(.appBackground)
            .navigationTitle("Customize Surface")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        revertChanges()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        didSave = true
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .presentationDetents([.large])
        .onAppear {
            // Capture initial state for potential revert
            initialSpec = manager.bindingForSurfaceRole(role).wrappedValue
        }
        .onDisappear {
            // If user dragged to dismiss without saving, revert changes
            if !didSave {
                revertChanges()
            }
        }
    }

    private func revertChanges() {
        guard let initialSpec else { return }
        manager.bindingForSurfaceRole(role).wrappedValue = initialSpec
    }
}

// MARK: - Surface Material Editor

/// Enum to represent the material base type for the picker
private enum MaterialBaseType: String, CaseIterable {
    case solid = "Solid Color"
    case appleMaterial = "Apple Material"
    case blur = "Blur"
    case glass = "Glass"

    static func from(_ base: GentleVisualEffectBase) -> MaterialBaseType {
        switch base {
        case .solid: return .solid
        case .appleMaterial: return .appleMaterial
        case .blur: return .blur
        case .glass: return .glass
        }
    }
}

struct SurfaceMaterialEditor: View {
    @Binding var binding: GentleVisualEffectRecipe

    var body: some View {
        let baseType = MaterialBaseType.from(binding.base)

        Picker("Type", selection: Binding(
            get: { baseType },
            set: { newType in
                // Convert to the new base type with default values
                switch newType {
                case .solid:
                    binding.base = .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#1F2937"))
                case .appleMaterial:
                    binding.base = .appleMaterial(GentleAppleMaterialSpec(kind: .regular, opacity: 1.0))
                case .blur:
                    binding.base = .blur(GentleBlurSpec(radius: 10, isBackgroundOnly: true, opacity: 1.0))
                case .glass:
                    binding.base = .glass(GentleGlassSpec(style: .regular, isInteractive: false, tint: nil))
                }
            }
        )) {
            ForEach(MaterialBaseType.allCases, id: \.self) { type in
                Text(type.rawValue).tag(type)
            }
        }

        // Show appropriate controls based on base type
        switch binding.base {
        case .solid(let colorPair):
            solidColorEditor(colorPair: colorPair)

        case .appleMaterial(let spec):
            appleMaterialEditor(spec: spec)

        case .blur(let spec):
            blurEditor(spec: spec)

        case .glass(let spec):
            glassEditor(spec: spec)
        }
    }

    @ViewBuilder
    private func solidColorEditor(colorPair: GentleColorPair) -> some View {
        let lightBinding = Binding<Color>(
            get: { Color(gentleHex: colorPair.lightHex) },
            set: { newColor in
                if case .solid(var pair) = binding.base {
                    pair.lightHex = newColor.toGentleHexString()
                    binding.base = .solid(pair)
                }
            }
        )
        let darkBinding = Binding<Color>(
            get: { Color(gentleHex: colorPair.darkHex) },
            set: { newColor in
                if case .solid(var pair) = binding.base {
                    pair.darkHex = newColor.toGentleHexString()
                    binding.base = .solid(pair)
                }
            }
        )

        HStack {
            Text("Color")

            Spacer()

            HStack(spacing: 4) {
                ZStack {
                    lightBinding.wrappedValue
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    ColorPicker("", selection: lightBinding, supportsOpacity: true)
                        .labelsHidden()
                        .opacity(0.1)
                }
                .frame(width: 36, height: 36)

                ZStack {
                    darkBinding.wrappedValue
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    ColorPicker("", selection: darkBinding, supportsOpacity: true)
                        .labelsHidden()
                        .opacity(0.1)
                }
                .frame(width: 36, height: 36)
            }
        }
    }

    @ViewBuilder
    private func appleMaterialEditor(spec: GentleAppleMaterialSpec) -> some View {
        Picker("Style", selection: Binding(
            get: { spec.kind },
            set: { newKind in
                binding.base = .appleMaterial(GentleAppleMaterialSpec(kind: newKind, opacity: spec.opacity))
            }
        )) {
            Text("Ultra Thin").tag(GentleAppleMaterialSpec.Kind.ultraThin)
            Text("Thin").tag(GentleAppleMaterialSpec.Kind.thin)
            Text("Regular").tag(GentleAppleMaterialSpec.Kind.regular)
            Text("Thick").tag(GentleAppleMaterialSpec.Kind.thick)
            Text("Ultra Thick").tag(GentleAppleMaterialSpec.Kind.ultraThick)
            Text("Bar").tag(GentleAppleMaterialSpec.Kind.bar)
        }

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Opacity")
                Spacer()
                Text(String(format: "%.2f", spec.opacity))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            Slider(value: Binding(
                get: { spec.opacity },
                set: { newOpacity in
                    binding.base = .appleMaterial(GentleAppleMaterialSpec(kind: spec.kind, opacity: newOpacity))
                }
            ), in: 0...1, step: 0.05)
        }
    }

    @ViewBuilder
    private func blurEditor(spec: GentleBlurSpec) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Blur Radius")
                Spacer()
                Text(String(format: "%.0f", spec.radius))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            Slider(value: Binding(
                get: { spec.radius },
                set: { newRadius in
                    binding.base = .blur(GentleBlurSpec(radius: newRadius, isBackgroundOnly: spec.isBackgroundOnly, opacity: spec.opacity))
                }
            ), in: 0...30, step: 1)
        }

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Opacity")
                Spacer()
                Text(String(format: "%.2f", spec.opacity))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            Slider(value: Binding(
                get: { spec.opacity },
                set: { newOpacity in
                    binding.base = .blur(GentleBlurSpec(radius: spec.radius, isBackgroundOnly: spec.isBackgroundOnly, opacity: newOpacity))
                }
            ), in: 0...1, step: 0.05)
        }
    }

    @ViewBuilder
    private func glassEditor(spec: GentleGlassSpec) -> some View {
        Picker("Style", selection: Binding(
            get: { spec.style },
            set: { newStyle in
                binding.base = .glass(GentleGlassSpec(style: newStyle, isInteractive: spec.isInteractive, tint: spec.tint))
            }
        )) {
            Text("Regular").tag(GentleGlassSpec.Style.regular)
            Text("Clear").tag(GentleGlassSpec.Style.clear)
            Text("Identity").tag(GentleGlassSpec.Style.identity)
        }

        Toggle("Interactive", isOn: Binding(
            get: { spec.isInteractive },
            set: { newValue in
                binding.base = .glass(GentleGlassSpec(style: spec.style, isInteractive: newValue, tint: spec.tint))
            }
        ))

        Text("Glass effects require iOS 26+")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

// MARK: - Surface Color Pair Row

struct SurfaceColorPairRow: View {
    let name: String
    @Binding var binding: GentleColorPair

    var body: some View {
        let lightBinding = Binding<Color>(
            get: { Color(gentleHex: binding.lightHex) },
            set: { binding.lightHex = $0.toGentleHexString() }
        )
        let darkBinding = Binding<Color>(
            get: { Color(gentleHex: binding.darkHex) },
            set: { binding.darkHex = $0.toGentleHexString() }
        )

        HStack {
            Text(name)

            Spacer()

            HStack(spacing: 4) {
                ZStack {
                    lightBinding.wrappedValue
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    ColorPicker("", selection: lightBinding, supportsOpacity: true)
                        .labelsHidden()
                        .opacity(0.1)
                }
                .frame(width: 36, height: 36)

                ZStack {
                    darkBinding.wrappedValue
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    ColorPicker("", selection: darkBinding, supportsOpacity: true)
                        .labelsHidden()
                        .opacity(0.1)
                }
                .frame(width: 36, height: 36)
            }
        }
    }
}

// MARK: - Color to Hex conversion

extension Color {
    func toGentleHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        let uiColor = UIColor(self)
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
