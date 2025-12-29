//  Jonathan Ritchey
import SwiftUI

/// Collapsible, compact editor for a single color role.
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

private extension Color {
    func toHexString() -> String {
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
