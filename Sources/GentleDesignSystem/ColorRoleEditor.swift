//  Jonathan Ritchey
import SwiftUI

#if canImport(UIKit)
/// Compact grid cell for displaying a color role.
/// Tapping opens a sheet for editing.
public struct ColorRoleCell: View {
    private let role: GentleColorRole
    @Binding var isEditing: Bool

    @GentleThemeManagerRuntime private var manager

    public init(role: GentleColorRole, isEditing: Binding<Bool>) {
        self.role = role
        self._isEditing = isEditing
    }

    public var body: some View {
        let binding = manager.bindingForColorRole(role)

        Button {
            isEditing = true
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                // Color swatches (light and dark)
                HStack(spacing: 3) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(gentleHex: binding.lightHex.wrappedValue))
                        .frame(width: 28, height: 28)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Color.primary.opacity(0.2), lineWidth: 0.5)
                        )
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(gentleHex: binding.darkHex.wrappedValue))
                        .frame(width: 28, height: 28)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Color.primary.opacity(0.2), lineWidth: 0.5)
                        )
                }

                Text(role.displayName)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

/// Sheet-based editor for a single color variant (light or dark).
public struct SingleColorEditorSheet: View {
    private let role: GentleColorRole
    private let scheme: ColorScheme
    @Environment(\.dismiss) private var dismiss
    @GentleThemeManagerRuntime private var manager

    /// Local working copy - only committed on Save.
    @State private var workingPair: GentleColorPair?
    /// The initial value for reset functionality.
    @State private var initialPair: GentleColorPair?

    public init(role: GentleColorRole, scheme: ColorScheme) {
        self.role = role
        self.scheme = scheme
    }

    public var body: some View {
        NavigationStack {
            if let workingPair, let initialPair {
                let hexBinding = Binding<String>(
                    get: { scheme == .light ? workingPair.lightHex : workingPair.darkHex },
                    set: { newHex in
                        if scheme == .light {
                            self.workingPair?.lightHex = newHex
                        } else {
                            self.workingPair?.darkHex = newHex
                        }
                    }
                )
                let colorBinding = Binding<Color>(
                    get: { Color(gentleHex: hexBinding.wrappedValue) },
                    set: { newColor in hexBinding.wrappedValue = newColor.toHexString() }
                )

                VStack(spacing: 24) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorBinding.wrappedValue)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                        )
                        .padding(.horizontal)

                    ColorPicker("", selection: colorBinding, supportsOpacity: true)
                        .labelsHidden()
                        .scaleEffect(1.5)

                    Text(hexBinding.wrappedValue.uppercased())
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)

                    // Reset button - only show if changed from initial
                    if workingPair != initialPair {
                        Button {
                            self.workingPair = initialPair
                        } label: {
                            Label("Reset", systemImage: "arrow.uturn.backward")
                        }
                        .buttonStyle(.bordered)
                    }

                    Spacer()
                }
                .padding(.top, 24)
            }
        }
        .navigationTitle("\(role.displayName) (\(scheme == .light ? "Light" : "Dark"))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    if let workingPair {
                        manager.bindingForColorRole(role).wrappedValue = workingPair
                    }
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                }
            }
        }
        .onAppear {
            let current = manager.bindingForColorRole(role).wrappedValue
            initialPair = current
            workingPair = current
        }
    }
}

/// Sheet-based editor for a single color role.
public struct ColorRoleEditorSheet: View {
    private let role: GentleColorRole
    @Environment(\.dismiss) private var dismiss
    @GentleThemeManagerRuntime private var manager

    /// Local working copy - only committed on Save.
    @State private var workingPair: GentleColorPair?
    /// The initial value for reset functionality.
    @State private var initialPair: GentleColorPair?

    public init(role: GentleColorRole) {
        self.role = role
    }

    public var body: some View {
        NavigationStack {
            if let initialPair, var workingPair {
                let lightHexBinding = Binding<String>(
                    get: { workingPair.lightHex },
                    set: { self.workingPair?.lightHex = $0 }
                )
                let darkHexBinding = Binding<String>(
                    get: { workingPair.darkHex },
                    set: { self.workingPair?.darkHex = $0 }
                )

                List {
                    Section {
                        // Light mode color
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Light Mode")
                                    .font(.subheadline)
                                Spacer()
                                Text(lightHexBinding.wrappedValue.uppercased())
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                            HStack(spacing: 12) {
                                ColorPicker("", selection: colorBinding(for: lightHexBinding), supportsOpacity: true)
                                    .labelsHidden()

                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(gentleHex: lightHexBinding.wrappedValue))
                                    .frame(height: 32)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.vertical, 4)

                        // Dark mode color
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Dark Mode")
                                    .font(.subheadline)
                                Spacer()
                                Text(darkHexBinding.wrappedValue.uppercased())
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                            HStack(spacing: 12) {
                                ColorPicker("", selection: colorBinding(for: darkHexBinding), supportsOpacity: true)
                                    .labelsHidden()

                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(gentleHex: darkHexBinding.wrappedValue))
                                    .frame(height: 32)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    // Reset button - only show if changed from initial
                    if self.workingPair != initialPair {
                        Section {
                            Button {
                                self.workingPair = initialPair
                            } label: {
                                Label("Reset to Original", systemImage: "arrow.uturn.backward")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(role.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    if let workingPair {
                        manager.bindingForColorRole(role).wrappedValue = workingPair
                    }
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                }
            }
        }
        .presentationDetents([.medium])
        .onAppear {
            let current = manager.bindingForColorRole(role).wrappedValue
            initialPair = current
            workingPair = current
        }
    }

    private func colorBinding(for hexBinding: Binding<String>) -> Binding<Color> {
        Binding<Color>(
            get: { Color(gentleHex: hexBinding.wrappedValue) },
            set: { newColor in hexBinding.wrappedValue = newColor.toHexString() }
        )
    }
}

/// Collapsible, compact editor for a single color role (legacy list-based).
/// Edits lightHex and darkHex values for the GentleColorPair.
public struct ColorRoleEditor: View {
    private let role: GentleColorRole

    @State private var isExpanded: Bool = false
    @GentleThemeManagerRuntime private var manager

    public init(role: GentleColorRole) {
        self.role = role
    }

    public var body: some View {
        let binding = manager.bindingForColorRole(role)

        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    // Color swatches (light and dark)
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(gentleHex: binding.lightHex.wrappedValue))
                            .frame(width: 24, height: 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(Color.primary.opacity(0.2), lineWidth: 0.5)
                            )
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(gentleHex: binding.darkHex.wrappedValue))
                            .frame(width: 24, height: 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(Color.primary.opacity(0.2), lineWidth: 0.5)
                            )
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(role.displayName)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary)
                        Text(summaryText(for: binding.wrappedValue))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Light mode color
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Light Mode")
                                .font(.subheadline)
                            Spacer()
                            Text(binding.lightHex.wrappedValue.uppercased())
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                        HStack(spacing: 12) {
                            ColorPicker("", selection: lightColorBinding(binding), supportsOpacity: true)
                                .labelsHidden()

                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(gentleHex: binding.lightHex.wrappedValue))
                                .frame(height: 32)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                                )
                        }
                    }

                    // Dark mode color
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Dark Mode")
                                .font(.subheadline)
                            Spacer()
                            Text(binding.darkHex.wrappedValue.uppercased())
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                        HStack(spacing: 12) {
                            ColorPicker("", selection: darkColorBinding(binding), supportsOpacity: true)
                                .labelsHidden()

                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(gentleHex: binding.darkHex.wrappedValue))
                                .frame(height: 32)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 8)
    }

    private func lightColorBinding(_ pairBinding: Binding<GentleColorPair>) -> Binding<Color> {
        Binding<Color>(
            get: { Color(gentleHex: pairBinding.lightHex.wrappedValue) },
            set: { newColor in
                pairBinding.lightHex.wrappedValue = newColor.toHexString()
            }
        )
    }

    private func darkColorBinding(_ pairBinding: Binding<GentleColorPair>) -> Binding<Color> {
        Binding<Color>(
            get: { Color(gentleHex: pairBinding.darkHex.wrappedValue) },
            set: { newColor in
                pairBinding.darkHex.wrappedValue = newColor.toHexString()
            }
        )
    }

    private func summaryText(for pair: GentleColorPair) -> String {
        "Light: \(pair.lightHex.uppercased()) • Dark: \(pair.darkHex.uppercased())"
    }
}

// MARK: - Color to Hex conversion

import UIKit

private extension Color {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        #if canImport(UIKit)
        let uiColor = UIColor(self)
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self).usingColorSpace(.deviceRGB) ?? NSColor(self)
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif

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
#endif
