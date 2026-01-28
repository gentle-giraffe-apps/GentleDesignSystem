//  Jonathan Ritchey

import SwiftUI
import UIKit

public struct GentleThemeEditor: View {
    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var themeManager
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let isTitleEditable: Bool
    @State private var editableTitle: String = ""

    public init(isTitleEditable: Bool = false) {
        self.isTitleEditable = isTitleEditable
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: design.layout.stack.loose) {
                // Theme name - editable or read-only
                if isTitleEditable {
                    VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                        Text("Theme Name")
                            .gentleText(.subheadline_ms, colorRole: .textSecondary)
                        TextField("Theme Name", text: $editableTitle)
                            .gentleText(.title_xl)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(theme.color(for: .surfaceBase, scheme: colorScheme))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(theme.color(for: .borderSubtle, scheme: colorScheme), lineWidth: 1)
                            )
                            .onAppear {
                                editableTitle = themeManager.currentPresetName ?? "New Theme"
                            }
                            .onChange(of: editableTitle) { _, newValue in
                                themeManager.renamePreset(to: newValue)
                            }
                    }
                } else {
                    Text(themeManager.currentPresetName ?? "Design System")
                        .gentleText(.title_xl)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

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

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: design.layout.stack.regular) {
            Text("Colors")
                .gentleText(.title_xl)
                .opacity(0.7)

            HStack(alignment: .top, spacing: design.layout.stack.tight) {
                ColorGroupColumn(title: "Text", roles: GentleColorRole.textRoles)
                ColorGroupColumn(title: "Surface", roles: GentleColorRole.surfaceRoles)
                ColorGroupColumn(title: "Action", roles: GentleColorRole.actionRoles)
                ColorGroupColumn(title: "Theme", roles: GentleColorRole.themeRoles)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ColorGroupColumn: View {
    let title: String
    let roles: [GentleColorRole]

    @GentleDesignRuntime private var design

    var body: some View {
        VStack(alignment: .center, spacing: design.layout.stack.tight) {
            Text(title)
                .gentleText(.headline_m)
                .opacity(0.7)

            VStack(spacing: design.layout.stack.regular) {
                ForEach(roles, id: \.rawValue) { role in
                    ColorSwatchRow(role: role)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ColorSwatchRow: View {
    let role: GentleColorRole

    @GentleDesignRuntime private var design
    @GentleThemeManagerRuntime private var manager

    private var abbreviatedName: String {
        role.rawValue
            .replacingOccurrences(of: "text", with: "")
            .replacingOccurrences(of: "surface", with: "")
    }

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

        VStack(alignment: .center, spacing: 4) {
            HStack(spacing: 12) {
                ZStack {
                    lightBinding.wrappedValue.clipShape(RoundedRectangle(cornerRadius: 6))
                    ColorPicker("", selection: lightBinding, supportsOpacity: true)
                        .labelsHidden()
                        .opacity(0.1)
                }
                .frame(width: 22, height: 22)

                ZStack {
                    darkBinding.wrappedValue.clipShape(RoundedRectangle(cornerRadius: 6))
                    ColorPicker("", selection: darkBinding, supportsOpacity: true)
                        .labelsHidden()
                        .opacity(0.1)
                }
                .frame(width: 22, height: 22)
            }

            Text(abbreviatedName.camelCaseBreakable)
                .gentleText(.caption2_s)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
        }
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
                return (theme.color(for: .primaryCTA, scheme: colorScheme), .textOnPrimaryCTA)
            case .solidFillDestructive:
                return (theme.color(for: .destructive, scheme: colorScheme), .textOnPrimaryCTA)
            case .hollow:
                // Use surface color for miniature chips so they're visible
                return (theme.color(for: .surfaceBase, scheme: colorScheme), .primaryCTA)
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
                return (theme.color(for: .primaryCTA, scheme: colorScheme), .textOnPrimaryCTA)
            case .solidFillDestructive:
                return (theme.color(for: .destructive, scheme: colorScheme), .textOnPrimaryCTA)
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

            ForEach(GentleSurfaceRole.groupedByCategory, id: \.category) { group in
                VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                    Text(group.category.rawValue)
                        .gentleText(.subheadline_ms)
                        .opacity(0.6)

                    surfaceRow(for: group.roles)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(item: $editingRole) { role in
            SurfaceRoleEditorSheet(role: role)
        }
    }

    @ViewBuilder
    private func surfaceRow(for roles: [GentleSurfaceRole]) -> some View {
        let columns = min(roles.count, 3)
        let rows = (roles.count + columns - 1) / columns

        VStack(spacing: design.layout.stack.tight) {
            ForEach(0..<rows, id: \.self) { rowIndex in
                HStack(spacing: design.layout.stack.tight) {
                    ForEach(0..<columns, id: \.self) { colIndex in
                        let index = rowIndex * columns + colIndex
                        if index < roles.count {
                            surfaceCard(for: roles[index])
                        } else {
                            Color.clear
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }

    private func surfaceCard(for role: GentleSurfaceRole) -> some View {
        Button {
            editingRole = role
        } label: {
            ZStack {
                // Miniature mock UI content (visible through blur/glass effects)
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 4) {
                            Circle().fill(design.color(.themePrimary)).frame(width: 10, height: 10)
                            Text("Primary")
                                .font(.system(size: 8))
                        }
                        HStack(spacing: 4) {
                            Circle().fill(design.color(.themeSecondary)).frame(width: 10, height: 10)
                            Text("Secondary")
                                .font(.system(size: 8))
                        }
                        HStack(spacing: 4) {
                            Circle().fill(design.color(.primaryCTA)).frame(width: 10, height: 10)
                            Text("CTA")
                                .font(.system(size: 8))
                        }
                    }
                    .padding(.leading, 8)

                    Spacer()

                    // Mini mesh gradient
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
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.trailing, 8)
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)

                // Surface content on top
                VStack(alignment: .leading, spacing: design.layout.stack.tight) {
                    Text(role.displayName)
                        .gentleText(.caption_s)
                        .fontWeight(.semibold)

                    Text(role.subtitle)
                        .gentleText(.caption2_s)
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .gentleSurface(role, inset: .card, showTappableHint: true)
            }
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
                                .gentleText(.title2_l, colorRole: isOverlayStyle(binding.wrappedValue.backgroundStyle) ? .textOnOverlay : .textPrimary)
                            Text("Sample content")
                                .gentleText(.body_m, colorRole: isOverlayStyle(binding.wrappedValue.backgroundStyle) ? .textOnOverlaySecondary : .textSecondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .center)
                        .gentleSurface(role, inset: .card)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, design.layout.gap.xl)
                .padding(.vertical, design.layout.gap.s)

                List {
                    Section("Background Style") {
                        Picker("Style", selection: backgroundStyleTypeBinding(binding)) {
                            Text("Solid").tag(BackgroundStyleType.solid)
                            Text("Material").tag(BackgroundStyleType.material)
                            Text("Glass (iOS 26+)").tag(BackgroundStyleType.glass)
                        }
                        .pickerStyle(.segmented)

                        // Show options based on selected style type
                        switch binding.wrappedValue.backgroundStyle {
                        case .solid:
                            Picker("Color Role", selection: solidColorRoleBinding(binding)) {
                                ForEach(GentleColorRole.surfaceBackgroundRoles, id: \.self) { colorRole in
                                    Text(colorRole.displayName).tag(colorRole)
                                }
                            }

                        case .material(let material, _, let tintOpacity):
                            Picker("Material", selection: materialBinding(binding)) {
                                ForEach(GentleAppleMaterial.allCases.filter { $0 != .noMaterial }, id: \.self) { mat in
                                    Text(mat.displayName).tag(mat)
                                }
                            }

                            Picker("Tint Color", selection: materialTintBinding(binding)) {
                                Text("None").tag(Optional<GentleColorRole>.none)
                                ForEach(GentleColorRole.surfaceBackgroundRoles, id: \.self) { colorRole in
                                    Text(colorRole.displayName).tag(Optional(colorRole))
                                }
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Tint Opacity")
                                    Spacer()
                                    Text(String(format: "%.0f%%", materialTintOpacityBinding(binding).wrappedValue * 100))
                                        .monospacedDigit()
                                        .foregroundStyle(.secondary)
                                }
                                Slider(value: materialTintOpacityBinding(binding), in: 0...1, step: 0.01)
                            }

                        case .glass:
                            Picker("Fallback Material", selection: glassFallbackMaterialBinding(binding)) {
                                Text("None (use color)").tag(Optional<GentleAppleMaterial>.none)
                                ForEach(GentleAppleMaterial.allCases.filter { $0 != .noMaterial }, id: \.self) { mat in
                                    Text(mat.displayName).tag(Optional(mat))
                                }
                            }

                            Picker("Fallback Color", selection: glassFallbackColorBinding(binding)) {
                                ForEach(GentleColorRole.surfaceBackgroundRoles, id: \.self) { colorRole in
                                    Text(colorRole.displayName).tag(colorRole)
                                }
                            }
                        }
                    }

                    // Specular section - hidden when glass is selected
                    if !binding.wrappedValue.backgroundStyle.isGlass {
                        Section("Specular") {
                            Picker("Effect", selection: binding.specularEffect) {
                                ForEach(GentleSpecularEffect.allCases, id: \.self) { effect in
                                    Text(effect.displayName).tag(effect)
                                }
                            }

                            if binding.specularEffect.wrappedValue != .noEffect {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Strength")
                                        Spacer()
                                        Text(String(format: "%.0f%%", binding.specularStrength.wrappedValue * 100))
                                            .monospacedDigit()
                                            .foregroundStyle(.secondary)
                                    }
                                    Slider(value: binding.specularStrength, in: 0...1, step: 0.05)
                                }
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

    // MARK: - Background Style Helpers

    private enum BackgroundStyleType: String, CaseIterable {
        case solid, material, glass
    }

    /// Returns true for surfaces that use overlay styling (surfaceOverlay color role).
    /// These surfaces use textOnOverlay/textOnOverlaySecondary for text colors.
    private func isOverlayStyle(_ style: GentleSurfaceBackgroundStyle) -> Bool {
        switch style {
        case .solid(let colorRole):
            return colorRole == .surfaceOverlay
        case .material(_, let tintColorRole, _):
            return tintColorRole == .surfaceOverlay
        case .glass(_, let fallbackColorRole):
            return fallbackColorRole == .surfaceOverlay
        }
    }

    private func backgroundStyleTypeBinding(_ binding: Binding<GentleSurfaceRoleSpec>) -> Binding<BackgroundStyleType> {
        Binding(
            get: {
                switch binding.wrappedValue.backgroundStyle {
                case .solid: return .solid
                case .material: return .material
                case .glass: return .glass
                }
            },
            set: { newType in
                let currentStyle = binding.wrappedValue.backgroundStyle
                switch newType {
                case .solid:
                    // Extract color role from current style for continuity
                    let colorRole: GentleColorRole
                    switch currentStyle {
                    case .solid(let cr): colorRole = cr
                    case .material(_, let tcr, _): colorRole = tcr ?? .surfaceBase
                    case .glass(_, let fcr): colorRole = fcr
                    }
                    binding.wrappedValue.backgroundStyle = .solid(colorRole: colorRole)

                case .material:
                    // Extract values from current style
                    let material: GentleAppleMaterial
                    let tintColor: GentleColorRole?
                    let tintOpacity: Double
                    switch currentStyle {
                    case .solid(let cr):
                        material = .regular
                        tintColor = cr
                        tintOpacity = 0.1
                    case .material(let m, let tcr, let to):
                        material = m
                        tintColor = tcr
                        tintOpacity = to
                    case .glass(let fm, let fcr):
                        material = fm ?? .regular
                        tintColor = fcr
                        tintOpacity = 0.1
                    }
                    binding.wrappedValue.backgroundStyle = .material(material: material, tintColorRole: tintColor, tintOpacity: tintOpacity)

                case .glass:
                    // Extract values from current style for fallback
                    let fallbackMaterial: GentleAppleMaterial?
                    let fallbackColor: GentleColorRole
                    switch currentStyle {
                    case .solid(let cr):
                        fallbackMaterial = nil
                        fallbackColor = cr
                    case .material(let m, let tcr, _):
                        fallbackMaterial = m
                        fallbackColor = tcr ?? .surfaceBase
                    case .glass(let fm, let fcr):
                        fallbackMaterial = fm
                        fallbackColor = fcr
                    }
                    binding.wrappedValue.backgroundStyle = .glass(fallbackMaterial: fallbackMaterial, fallbackColorRole: fallbackColor)
                }
            }
        )
    }

    private func solidColorRoleBinding(_ binding: Binding<GentleSurfaceRoleSpec>) -> Binding<GentleColorRole> {
        Binding(
            get: {
                if case .solid(let colorRole) = binding.wrappedValue.backgroundStyle {
                    return colorRole
                }
                return .surfaceBase
            },
            set: { newValue in
                binding.wrappedValue.backgroundStyle = .solid(colorRole: newValue)
            }
        )
    }

    private func materialBinding(_ binding: Binding<GentleSurfaceRoleSpec>) -> Binding<GentleAppleMaterial> {
        Binding(
            get: {
                if case .material(let material, _, _) = binding.wrappedValue.backgroundStyle {
                    return material
                }
                return .regular
            },
            set: { newValue in
                if case .material(_, let tintColorRole, let tintOpacity) = binding.wrappedValue.backgroundStyle {
                    binding.wrappedValue.backgroundStyle = .material(material: newValue, tintColorRole: tintColorRole, tintOpacity: tintOpacity)
                }
            }
        )
    }

    private func materialTintBinding(_ binding: Binding<GentleSurfaceRoleSpec>) -> Binding<GentleColorRole?> {
        Binding(
            get: {
                if case .material(_, let tintColorRole, _) = binding.wrappedValue.backgroundStyle {
                    return tintColorRole
                }
                return nil
            },
            set: { newValue in
                if case .material(let material, _, let tintOpacity) = binding.wrappedValue.backgroundStyle {
                    binding.wrappedValue.backgroundStyle = .material(material: material, tintColorRole: newValue, tintOpacity: tintOpacity)
                }
            }
        )
    }

    private func materialTintOpacityBinding(_ binding: Binding<GentleSurfaceRoleSpec>) -> Binding<Double> {
        Binding(
            get: {
                if case .material(_, _, let tintOpacity) = binding.wrappedValue.backgroundStyle {
                    return tintOpacity
                }
                return 0.1
            },
            set: { newValue in
                if case .material(let material, let tintColorRole, _) = binding.wrappedValue.backgroundStyle {
                    binding.wrappedValue.backgroundStyle = .material(material: material, tintColorRole: tintColorRole, tintOpacity: newValue)
                }
            }
        )
    }

    private func glassFallbackMaterialBinding(_ binding: Binding<GentleSurfaceRoleSpec>) -> Binding<GentleAppleMaterial?> {
        Binding(
            get: {
                if case .glass(let fallbackMaterial, _) = binding.wrappedValue.backgroundStyle {
                    return fallbackMaterial
                }
                return nil
            },
            set: { newValue in
                if case .glass(_, let fallbackColorRole) = binding.wrappedValue.backgroundStyle {
                    binding.wrappedValue.backgroundStyle = .glass(fallbackMaterial: newValue, fallbackColorRole: fallbackColorRole)
                }
            }
        )
    }

    private func glassFallbackColorBinding(_ binding: Binding<GentleSurfaceRoleSpec>) -> Binding<GentleColorRole> {
        Binding(
            get: {
                if case .glass(_, let fallbackColorRole) = binding.wrappedValue.backgroundStyle {
                    return fallbackColorRole
                }
                return .surfaceBase
            },
            set: { newValue in
                if case .glass(let fallbackMaterial, _) = binding.wrappedValue.backgroundStyle {
                    binding.wrappedValue.backgroundStyle = .glass(fallbackMaterial: fallbackMaterial, fallbackColorRole: newValue)
                }
            }
        )
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
