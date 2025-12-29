//  Jonathan Ritchey
import SwiftUI

// MARK: - UI Kit Theming

public enum GentleUIKitTheming {
    @MainActor
    public static func applyNavigationBarTitleStyle(
        theme: GentleTheme,
        textRole: GentleTextRole,
        colorRole: GentleColorRole
    ) {
        // Dynamic color from your pair
        guard let pair = theme.spec.colors.pair(for: colorRole) else { return }
        let dark  = UIColor(Color(gentleHex: pair.hex(for: .dark)))
        let light = UIColor(Color(gentleHex: pair.hex(for: .light)))
        let dynamicTitleColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        }

        // Role spec (weight/design/width/letterSpacing/etc)
        let roleSpec = theme.spec.typography.roleSpec(for: textRole)

        // Build fonts WITHOUT forcing size
        let largeFont  = navTitleFont(from: roleSpec, kind: .large)
        let inlineFont = navTitleFont(from: roleSpec, kind: .inline)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        // ✅ This is the “divider line” culprit most of the time
        appearance.shadowColor = .clear

        appearance.largeTitleTextAttributes = [
            .foregroundColor: dynamicTitleColor,
            .font: largeFont,
            .kern: roleSpec.letterSpacing
        ]

        appearance.titleTextAttributes = [
            .foregroundColor: dynamicTitleColor,
            .font: inlineFont,
            .kern: roleSpec.letterSpacing
        ]

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
    }
}

private func navTitleFont(from roleSpec: GentleTypographyRoleSpec, kind: NavTitleKind) -> UIFont {
    let textStyle: UIFont.TextStyle = (kind == .large) ? .largeTitle : .headline
    var font = UIFont.preferredFont(forTextStyle: textStyle)

    if let designed = font.fontDescriptor.withDesign(roleSpec.design.uiKitDesign) {
        font = UIFont(descriptor: designed, size: 0)
    }

    let weightedDescriptor = font.fontDescriptor.addingAttributes([
        .traits: [UIFontDescriptor.TraitKey.weight: roleSpec.weight.uiKitWeight]
    ])
    font = UIFont(descriptor: weightedDescriptor, size: 0)

    if let width = roleSpec.width {
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] ?? [:]
        var newTraits = traits
        newTraits[.width] = width.uiKitWidthTrait

        let widenedDescriptor = font.fontDescriptor.addingAttributes([
            .traits: newTraits
        ])
        font = UIFont(descriptor: widenedDescriptor, size: 0)
    }

    return font
}

public struct GentleNavigationBarStyler: View {
    @Environment(\.gentleTheme) private var theme

    public init() {}

    public var body: some View {
        Color.clear
            .onAppear { apply() }
            .onChange(of: theme.id) { _, _ in
                apply()
            }
    }

    @MainActor
    private func apply() {
        GentleUIKitTheming.applyNavigationBarTitleStyle(
            theme: theme,
            textRole: .largeTitle_xxl,
            colorRole: .textPrimary
        )
    }
}

// MARK: - UIKit - Navigation Title (unchanged)

private enum NavTitleKind { case large, inline }

private extension GentleFontDesignToken {
    var uiKitDesign: UIFontDescriptor.SystemDesign {
        switch self {
        case .default:    return .default
        case .serif:      return .serif
        case .rounded:    return .rounded
        case .monospaced: return .monospaced
        }
    }
}

private extension GentleFontWidthToken {
    var uiKitWidthTrait: CGFloat {
        switch self {
        case .compressed: return -0.5
        case .condensed:  return -0.3
        case .standard:   return 0.0
        case .expanded:   return 0.3
        }
    }
}

private extension GentleFontWeightToken {
    var uiKitWeight: UIFont.Weight { swiftUIWeight.uiKit }
}

private extension Font.Weight {
    var uiKit: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin:       return .thin
        case .light:      return .light
        case .regular:    return .regular
        case .medium:     return .medium
        case .semibold:   return .semibold
        case .bold:       return .bold
        case .heavy:      return .heavy
        case .black:      return .black
        default:          return .regular
        }
    }
}
