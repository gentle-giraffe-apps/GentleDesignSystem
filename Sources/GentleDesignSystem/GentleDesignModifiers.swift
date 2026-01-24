//  Jonathan Ritchey

import SwiftUI

// MARK: - Modifiers

public struct GentleTextModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleTextRole
    private let overrideColorRole: GentleColorRole?

    public init(role: GentleTextRole, overrideColorRole: GentleColorRole? = nil) {
        self.role = role
        self.overrideColorRole = overrideColorRole
    }

    public func body(content: Content) -> some View {
        let style = theme.textStyle(for: role, sizeCategory: sizeCategory)
        let resolvedColorRole = overrideColorRole ?? style.colorRole
        let color = theme.color(for: resolvedColorRole, scheme: colorScheme)

        return content
            .font(style.font)
            .foregroundColor(color)
            .lineSpacing(style.lineSpacing)
            .kerning(style.letterSpacing)
            .textCase(style.isUppercased ? .uppercase : .none)
    }
}

public struct GentleTextFieldModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleTextRole
    private let overrideColorRole: GentleColorRole?
    private let chrome: GentleTextChrome

    public init(role: GentleTextRole,
                overrideColorRole: GentleColorRole? = nil,
                chrome: GentleTextChrome = .standalone(shape: .rounded)) {
        self.role = role
        self.overrideColorRole = overrideColorRole
        self.chrome = chrome
    }

    public func body(content: Content) -> some View {
        let style = theme.textStyle(for: role, sizeCategory: sizeCategory)
        let resolvedColorRole = overrideColorRole ?? style.colorRole
        let textColor = theme.color(for: resolvedColorRole, scheme: colorScheme)
        let gap = theme.gap

        let fill = theme.color(for: .surface, scheme: colorScheme)
        let border = theme.color(for: .borderSubtle, scheme: colorScheme)

        let base = content
            .font(style.font)
            .foregroundColor(textColor)
            .tint(theme.color(for: .primaryCTA, scheme: colorScheme))

        switch chrome {
        case .standalone(let shape):
            let horizontal = CGFloat(gap.l)
            let vertical = CGFloat(gap.m)

            return AnyView(
                base
                    .padding(.horizontal, horizontal)
                    .padding(.vertical, vertical)
                    .background(
                        Group {
                            switch shape {
                            case .rounded:
                                RoundedRectangle(cornerRadius: CGFloat(theme.radii.medium), style: .continuous).fill(fill)
                            case .pill:
                                Capsule().fill(fill)
                            }
                        }
                    )
                    .overlay(
                        Group {
                            switch shape {
                            case .rounded:
                                RoundedRectangle(cornerRadius: CGFloat(theme.radii.medium), style: .continuous)
                                    .strokeBorder(border, lineWidth: 1)
                            case .pill:
                                Capsule().strokeBorder(border, lineWidth: 1)
                            }
                        }
                    )
            )

        case .formRow:
            return AnyView(base.padding(.vertical, CGFloat(gap.s)))

        case .borderless:
            return AnyView(base)
        }
    }
}

public struct GentleSurfaceModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let role: GentleSurfaceRole
    private let inset: GentleInsetRole?
    private let insetVariant: GentleInsetVariant
    private let showTappableHint: Bool

    public init(role: GentleSurfaceRole, inset: GentleInsetRole? = nil, insetVariant: GentleInsetVariant = .regular, showTappableHint: Bool = false) {
        self.role = role
        self.inset = inset
        self.insetVariant = insetVariant
        self.showTappableHint = showTappableHint
    }

    public func body(content: Content) -> some View {
        let spec = theme.surfaces.roleSpec(for: role)
        let insetContent = inset.map { AnyView(content.gentleInset($0, variant: insetVariant)) } ?? AnyView(content)

        let backgroundColor = Color(gentleHex: spec.background.hex(for: colorScheme))
        let borderColor = showTappableHint
        ? theme.color(for: .primaryCTA, scheme: colorScheme).opacity(0.4)
            : Color(gentleHex: spec.border.hex(for: colorScheme))
        let cornerRadius = CGFloat(spec.cornerRadius)

        switch role {
        case .appBackground:
            return AnyView(
                insetContent.background(backgroundColor.ignoresSafeArea())
            )

        case .surfaceOverlay:
            return AnyView(
                insetContent
                    .background(backgroundColor)
                    .cornerRadius(cornerRadius)
            )

        case .card, .cardElevated:
            let hasBorder = spec.borderWidth > 0 || showTappableHint
            let borderWidth = (showTappableHint && role == .cardElevated) ? 1.0 : CGFloat(spec.borderWidth)
            let hasShadow = spec.shadowRadius > 0
            let shadowOpacity = colorScheme == .dark ? spec.shadowOpacity * 3.5 : spec.shadowOpacity

            return AnyView(
                insetContent
                    .background(backgroundColor)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        Group {
                            if hasBorder {
                                let insetAmount: CGFloat = showTappableHint ? 0.5 : 0.0
                                RoundedRectangle(cornerRadius: cornerRadius - insetAmount)
                                    .strokeBorder(borderColor, lineWidth: borderWidth)
                                    .padding(insetAmount)
                            }
                        }
                    )
                    .shadow(
                        color: hasShadow ? Color.black.opacity(shadowOpacity) : Color.clear,
                        radius: CGFloat(spec.shadowRadius),
                        x: CGFloat(spec.shadowOffsetX),
                        y: CGFloat(spec.shadowOffsetY)
                    )
            )
        }
    }
}

public struct GentleBackgroundModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    let role: GentleColorRole
    let ignoresSafeArea: Bool

    public func body(content: Content) -> some View {
        let c = theme.color(for: role, scheme: colorScheme)
        return content.background(
            Group {
                if ignoresSafeArea { c.ignoresSafeArea() } else { c }
            }
        )
    }
}

public struct GentleInsetModifier: ViewModifier {
    @Environment(\.gentleTheme) private var theme
    private let edges: Edge.Set
    private let role: GentleInsetRole
    private let variant: GentleInsetVariant

    public init(edges: Edge.Set = .all, role: GentleInsetRole, variant: GentleInsetVariant = .regular) {
        self.edges = edges
        self.role = role
        self.variant = variant
    }

    public func body(content: Content) -> some View {
        let axis = theme.activeSpec.layout.inset.axisTokens(for: role, variant: variant)
        let h = CGFloat(theme.activeSpec.layout.scale.value(for: axis.horizontal))
        let v = CGFloat(theme.activeSpec.layout.scale.value(for: axis.vertical))

        return content
            .padding(.leading, edges.contains(.leading) || edges == .all || edges.contains(.horizontal) ? h : 0)
            .padding(.trailing, edges.contains(.trailing) || edges == .all || edges.contains(.horizontal) ? h : 0)
            .padding(.top, edges.contains(.top) || edges == .all || edges.contains(.vertical) ? v : 0)
            .padding(.bottom, edges.contains(.bottom) || edges == .all || edges.contains(.vertical) ? v : 0)
    }
}

// MARK: - View extensions (ergonomic API)

public extension View {
    func gentleText(_ role: GentleTextRole, colorRole: GentleColorRole? = nil) -> some View {
        modifier(GentleTextModifier(role: role, overrideColorRole: colorRole))
    }

    func gentleTextField(_ role: GentleTextRole,
                         colorRole: GentleColorRole? = nil,
                         chrome: GentleTextChrome = .standalone(shape: .rounded)) -> some View {
        modifier(GentleTextFieldModifier(role: role, overrideColorRole: colorRole, chrome: chrome))
    }

    func gentleSurface(_ role: GentleSurfaceRole, inset: GentleInsetRole? = nil, insetVariant: GentleInsetVariant = .regular, showTappableHint: Bool = false) -> some View {
        modifier(GentleSurfaceModifier(role: role, inset: inset, insetVariant: insetVariant, showTappableHint: showTappableHint))
    }

    func gentleButton(_ role: GentleButtonRole, expandsHorizontally: Bool = false, contentAlignment: Alignment = .center) -> some View {
        buttonStyle(GentleButtonStyle(role: role, expandsHorizontally: expandsHorizontally, contentAlignment: contentAlignment))
    }

    func gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape, expandsHorizontally: Bool = false, contentAlignment: Alignment = .center) -> some View {
        buttonStyle(GentleButtonStyle(role: role, shape: shape, expandsHorizontally: expandsHorizontally, contentAlignment: contentAlignment))
    }

    func gentleButton(_ role: GentleButtonRole, textRole: GentleTextRole, expandsHorizontally: Bool = false, contentAlignment: Alignment = .center) -> some View {
        buttonStyle(GentleButtonStyle(role: role, textRole: textRole, expandsHorizontally: expandsHorizontally, contentAlignment: contentAlignment))
    }

    func gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape, textRole: GentleTextRole, expandsHorizontally: Bool = false, contentAlignment: Alignment = .center) -> some View {
        buttonStyle(GentleButtonStyle(role: role, shape: shape, textRole: textRole, expandsHorizontally: expandsHorizontally, contentAlignment: contentAlignment))
    }

    @ViewBuilder
    func gentleFontWidth(_ width: GentleFontWidthToken?) -> some View {
        if let width {
            if #available(iOS 17.0, *) {
                self.fontWidth(width.swiftUIWidth)
            } else {
                self
            }
        } else {
            self
        }
    }

    func gentleBackground(_ role: GentleColorRole, ignoresSafeArea: Bool = false) -> some View {
        modifier(GentleBackgroundModifier(role: role, ignoresSafeArea: ignoresSafeArea))
    }

    func gentleInset(_ role: GentleInsetRole, variant: GentleInsetVariant = .regular) -> some View {
        modifier(GentleInsetModifier(edges: .all, role: role, variant: variant))
    }

    func gentleInset(_ edges: Edge.Set, _ role: GentleInsetRole, variant: GentleInsetVariant = .regular) -> some View {
        modifier(GentleInsetModifier(edges: edges, role: role, variant: variant))
    }
}

// MARK: - Color helper (hex → Color)

public extension Color {
    init(gentleHex hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hexString)

        let r, g, b, a: Double
        if scanner.scanHexInt64(&hexNumber) {
            switch hexString.count {
            case 6:
                r = Double((hexNumber & 0xFF0000) >> 16) / 255.0
                g = Double((hexNumber & 0x00FF00) >> 8) / 255.0
                b = Double(hexNumber & 0x0000FF) / 255.0
                a = 1.0
            case 8:
                r = Double((hexNumber & 0xFF000000) >> 24) / 255.0
                g = Double((hexNumber & 0x00FF0000) >> 16) / 255.0
                b = Double((hexNumber & 0x0000FF00) >> 8) / 255.0
                a = Double(hexNumber & 0x000000FF) / 255.0
            default:
                r = 0; g = 0; b = 0; a = 1
            }
        } else {
            r = 0; g = 0; b = 0; a = 1
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
