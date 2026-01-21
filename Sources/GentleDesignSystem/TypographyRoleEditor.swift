//  Jonathan Ritchey
import SwiftUI

/// Compact grid cell for displaying a typography role.
/// Tapping opens a sheet for editing.
public struct TypographyRoleCell: View {
    private let role: GentleTextRole
    @Binding var isEditing: Bool

    @GentleThemeManagerRuntime private var manager

    public init(role: GentleTextRole, isEditing: Binding<Bool>) {
        self.role = role
        self._isEditing = isEditing
    }

    public var body: some View {
        let binding = manager.bindingForTypographyRole(role)

        Button {
            isEditing = true
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text("Aa")
                    .gentleText(role)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                Text(role.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text("\(Int(binding.pointSize.wrappedValue))pt • \(binding.weight.wrappedValue.displayName)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
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

/// Sheet-based editor for a single typography role.
public struct TypographyRoleEditorSheet: View {
    private let role: GentleTextRole

    private let sizeRange: ClosedRange<Double>
    private let sizeStep: Double
    private let lineSpacingRange: ClosedRange<Double>
    private let letterSpacingRange: ClosedRange<Double>

    @Environment(\.dismiss) private var dismiss
    @GentleThemeManagerRuntime private var manager

    public init(
        role: GentleTextRole,
        sizeRange: ClosedRange<Double> = 10...96,
        sizeStep: Double = 1,
        lineSpacingRange: ClosedRange<Double> = 0...12,
        letterSpacingRange: ClosedRange<Double> = -1.5...2.5
    ) {
        self.role = role
        self.sizeRange = sizeRange
        self.sizeStep = sizeStep
        self.lineSpacingRange = lineSpacingRange
        self.letterSpacingRange = letterSpacingRange
    }

    public var body: some View {
        let binding = manager.bindingForTypographyRole(role)

        NavigationStack {
            VStack(spacing: 0) {
                // Preview text at top
                Text("The quick brown fox\njumps over the lazy dog")
                    .gentleText(role)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)

                List {
                    // Size
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Size")
                            Spacer()
                            Text("\(Int(binding.pointSize.wrappedValue)) pt")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: binding.pointSize, in: sizeRange, step: sizeStep)
                    }

                    // Weight
                    Picker("Weight", selection: binding.weight) {
                        ForEach(GentleFontWeightToken.allCases, id: \.self) { w in
                            Text(w.displayName).tag(w)
                        }
                    }

                    // Design
                    Picker("Design", selection: binding.design) {
                        ForEach(GentleFontDesignToken.allCases, id: \.self) { d in
                            Text(String(describing: d).capitalized).tag(d)
                        }
                    }

                    // Width (only available when design is Default)
                    if binding.design.wrappedValue == .default {
                        Picker("Width", selection: widthBinding(binding)) {
                            Text("None").tag(Optional<GentleFontWidthToken>.none)
                            ForEach(GentleFontWidthToken.allCases, id: \.self) { w in
                                Text(w.displayName).tag(Optional(w))
                            }
                        }
                    }

                    // Line spacing
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Line spacing")
                            Spacer()
                            Text(String(format: "%.1f", binding.lineSpacing.wrappedValue))
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: binding.lineSpacing, in: lineSpacingRange, step: 0.5)
                    }

                    // Letter spacing
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Letter spacing")
                            Spacer()
                            Text(String(format: "%.1f", binding.letterSpacing.wrappedValue))
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: binding.letterSpacing, in: letterSpacingRange, step: 0.1)
                    }

                    Toggle("Uppercased", isOn: binding.isUppercased)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle(role.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.large])
    }

    private func widthBinding(_ roleSpec: Binding<GentleTypographyRoleSpec>) -> Binding<GentleFontWidthToken?> {
        Binding<GentleFontWidthToken?>(
            get: { roleSpec.width.wrappedValue },
            set: { roleSpec.width.wrappedValue = $0 }
        )
    }
}

/// Collapsible, compact editor for a single typography role (legacy list-based).
/// Edits only:
/// - size, weight, design, width, line spacing, letter spacing, uppercase
public struct TypographyRoleEditor: View {
    private let role: GentleTextRole

    private let sizeRange: ClosedRange<Double>
    private let sizeStep: Double

    private let lineSpacingRange: ClosedRange<Double>
    private let letterSpacingRange: ClosedRange<Double>

    @State private var isExpanded: Bool = false
    @GentleThemeManagerRuntime private var manager

    public init(
        role: GentleTextRole,
        sizeRange: ClosedRange<Double> = 10...96,
        sizeStep: Double = 1,
        lineSpacingRange: ClosedRange<Double> = 0...12,
        letterSpacingRange: ClosedRange<Double> = -1.5...2.5
    ) {
        self.role = role
        self.sizeRange = sizeRange
        self.sizeStep = sizeStep
        self.lineSpacingRange = lineSpacingRange
        self.letterSpacingRange = letterSpacingRange
    }

    public var body: some View {
        let binding = manager.bindingForTypographyRole(role)

        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                    isExpanded.toggle()
                }
            } label: {
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(role.rawValue)
                                .gentleText(role)
                        }
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    Text(summaryText(for: binding.wrappedValue))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 14) {
                    // Size
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Size")
                            Spacer()
                            Text("\(Int(binding.pointSize.wrappedValue)) pt")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: binding.pointSize, in: sizeRange, step: sizeStep)
                    }

                    // Weight
                    Picker("Weight", selection: binding.weight) {
                        ForEach(GentleFontWeightToken.allCases, id: \.self) { w in
                            Text(w.displayName).tag(w)
                        }
                    }

                    // Design
                    Picker("Design", selection: binding.design) {
                        ForEach(GentleFontDesignToken.allCases, id: \.self) { d in
                            Text(String(describing: d).capitalized).tag(d)
                        }
                    }

                    // Width (optional)
                    Picker("Width", selection: widthBinding(binding)) {
                        Text("None").tag(Optional<GentleFontWidthToken>.none)
                        ForEach(GentleFontWidthToken.allCases, id: \.self) { w in
                            Text(w.displayName).tag(Optional(w))
                        }
                    }
                    .disabled(binding.design.wrappedValue != .default)

                    if binding.design.wrappedValue != .default {
                        Text("Width only supported when design is 'Default'.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    // Line spacing
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Line spacing")
                            Spacer()
                            Text(String(format: "%.1f", binding.lineSpacing.wrappedValue))
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: binding.lineSpacing, in: lineSpacingRange, step: 0.5)
                    }

                    // Letter spacing
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Letter spacing")
                            Spacer()
                            Text(String(format: "%.1f", binding.letterSpacing.wrappedValue))
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: binding.letterSpacing, in: letterSpacingRange, step: 0.1)
                    }

                    Toggle("Uppercased", isOn: binding.isUppercased)
                }
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 8)
    }

    private func widthBinding(_ roleSpec: Binding<GentleTypographyRoleSpec>) -> Binding<GentleFontWidthToken?> {
        Binding<GentleFontWidthToken?>(
            get: { roleSpec.width.wrappedValue },
            set: { roleSpec.width.wrappedValue = $0 }
        )
    }

    private func summaryText(for spec: GentleTypographyRoleSpec) -> String {
        func singleDigit(_ value: CGFloat) -> String {
            String(Int(value))
        }
        let size = "\(Int(spec.pointSize))pt"
        let weight = spec.weight.displayName
        let design = String(describing: spec.design).capitalized
        let width = spec.width?.displayName ?? "None"
        let letterSpacing = "letter \(singleDigit(spec.letterSpacing))"
        let lineSpacing = "line \(singleDigit(spec.lineSpacing))"
        return "\(size) • \(weight) • \(design) • \(width) • Spacing: \(letterSpacing) • \(lineSpacing)"
    }
}
