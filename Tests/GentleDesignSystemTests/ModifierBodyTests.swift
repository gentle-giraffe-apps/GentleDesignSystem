//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// Helper to actually render views and trigger body evaluation for coverage
@MainActor
private func renderForCoverage<V: View>(_ view: V) {
    let renderer = ImageRenderer(content: view)
    renderer.proposedSize = .init(width: 375, height: 667)
    _ = renderer.cgImage
}

// MARK: - View Modifier Body Evaluation Tests

@Suite("GentleTextModifier Body Tests")
@MainActor
struct GentleTextModifierBodyTests {

    @Test("GentleTextModifier applies font and color")
    func testGentleTextModifierApplies() {
        let manager = GentleThemeManager()
        let view = GentleThemeRoot(theme: manager.theme) {
            Text("Hello")
                .gentleText(.body_m)
        }

        renderForCoverage(view)
    }

    @Test("GentleTextModifier with all typography roles")
    func testGentleTextModifierAllRoles() {
        let manager = GentleThemeManager()

        for role in GentleTextRole.allCases {
            let view = GentleThemeRoot(theme: manager.theme) {
                Text("Test")
                    .gentleText(role)
            }
            renderForCoverage(view)
        }
    }

    @Test("GentleTextModifier with color override for all roles")
    func testGentleTextModifierColorOverride() {
        let manager = GentleThemeManager()
        let colorRoles: [GentleColorRole] = [.textPrimary, .textSecondary, .textTertiary, .destructive]

        for colorRole in colorRoles {
            let view = GentleThemeRoot(theme: manager.theme) {
                Text("Test")
                    .gentleText(.body_m, colorRole: colorRole)
            }
            renderForCoverage(view)
        }
    }

    @Test("GentleTextModifier with uppercase text role")
    func testGentleTextModifierUppercase() {
        var spec = GentleDesignSystemSpec.gentleDefault
        spec.typography.roles[GentleTextRole.caption_s.rawValue] = GentleTypographyRoleSpec(
            pointSize: 12,
            weight: .regular,
            design: .default,
            relativeTo: .caption,
            isUppercased: true,
            colorRole: .textTertiary
        )

        let theme = GentleTheme(defaultSpec: spec)
        let view = GentleThemeRoot(theme: theme) {
            Text("test")
                .gentleText(.caption_s)
        }
        renderForCoverage(view)
    }
}

// MARK: - GentleSurfaceModifier Body Tests

@Suite("GentleSurfaceModifier Body Tests")
@MainActor
struct GentleSurfaceModifierBodyTests {

    @Test("GentleSurfaceModifier with solid background")
    func testGentleSurfaceModifierSolid() {
        let manager = GentleThemeManager()
        let view = GentleThemeRoot(theme: manager.theme) {
            Text("Card content")
                .gentleSurface(.card)
        }
        renderForCoverage(view)
    }

    @Test("GentleSurfaceModifier with material background")
    func testGentleSurfaceModifierMaterial() {
        let manager = GentleThemeManager()
        let view = GentleThemeRoot(theme: manager.theme) {
            Text("Chrome content")
                .gentleSurface(.chrome)
        }
        renderForCoverage(view)
    }

    @Test("GentleSurfaceModifier with glass background")
    func testGentleSurfaceModifierGlass() {
        let manager = GentleThemeManager()
        let view = GentleThemeRoot(theme: manager.theme) {
            Text("Floating content")
                .gentleSurface(.floatingPanel)
        }
        renderForCoverage(view)
    }

    @Test("GentleSurfaceModifier with inset")
    func testGentleSurfaceModifierWithInset() {
        let manager = GentleThemeManager()
        let view = GentleThemeRoot(theme: manager.theme) {
            Text("Content")
                .gentleSurface(.card, inset: .card)
        }
        renderForCoverage(view)
    }

    @Test("GentleSurfaceModifier with inset variant")
    func testGentleSurfaceModifierWithInsetVariant() {
        let manager = GentleThemeManager()
        let variants: [GentleInsetVariant] = [.tight, .regular, .roomy]

        for variant in variants {
            let view = GentleThemeRoot(theme: manager.theme) {
                Text("Content")
                    .gentleSurface(.card, inset: .card, insetVariant: variant)
            }
            renderForCoverage(view)
        }
    }

    @Test("GentleSurfaceModifier with tappable hint")
    func testGentleSurfaceModifierTappableHint() {
        let manager = GentleThemeManager()
        let view = GentleThemeRoot(theme: manager.theme) {
            Text("Tappable")
                .gentleSurface(.card, showTappableHint: true)
        }
        renderForCoverage(view)
    }

    @Test("GentleSurfaceModifier for all surface roles")
    func testGentleSurfaceModifierAllRoles() {
        let manager = GentleThemeManager()

        for role in GentleSurfaceRole.allCases {
            let view = GentleThemeRoot(theme: manager.theme) {
                Text("Test")
                    .gentleSurface(role)
            }
            renderForCoverage(view)
        }
    }

    @Test("GentleSurfaceModifier with overlay scrim")
    func testGentleSurfaceModifierOverlayScrim() {
        let manager = GentleThemeManager()
        let view = GentleThemeRoot(theme: manager.theme) {
            Text("Scrim content")
                .gentleSurface(.overlayScrim)
        }
        renderForCoverage(view)
    }
}

// MARK: - GentleTextFieldModifier Body Tests

@Suite("GentleTextFieldModifier Body Tests")
@MainActor
struct GentleTextFieldModifierBodyTests {

    @Test("GentleTextFieldModifier with standalone rounded chrome")
    func testGentleTextFieldModifierStandaloneRounded() {
        let view = GentleThemeRoot {
            TextField("Placeholder", text: .constant(""))
                .gentleTextField(.body_m, chrome: .standalone(shape: .rounded))
        }
        renderForCoverage(view)
    }

    @Test("GentleTextFieldModifier with standalone pill chrome")
    func testGentleTextFieldModifierStandalonePill() {
        let view = GentleThemeRoot {
            TextField("Placeholder", text: .constant(""))
                .gentleTextField(.body_m, chrome: .standalone(shape: .pill))
        }
        renderForCoverage(view)
    }

    @Test("GentleTextFieldModifier with formRow chrome")
    func testGentleTextFieldModifierFormRow() {
        let view = GentleThemeRoot {
            TextField("Placeholder", text: .constant(""))
                .gentleTextField(.body_m, chrome: .formRow)
        }
        renderForCoverage(view)
    }

    @Test("GentleTextFieldModifier with borderless chrome")
    func testGentleTextFieldModifierBorderless() {
        let view = GentleThemeRoot {
            TextField("Placeholder", text: .constant(""))
                .gentleTextField(.body_m, chrome: .borderless)
        }
        renderForCoverage(view)
    }

    @Test("GentleTextFieldModifier with color override")
    func testGentleTextFieldModifierColorOverride() {
        let view = GentleThemeRoot {
            TextField("Placeholder", text: .constant(""))
                .gentleTextField(.body_m, colorRole: .textSecondary)
        }
        renderForCoverage(view)
    }
}

// MARK: - GentleBackgroundModifier Body Tests

@Suite("GentleBackgroundModifier Body Tests")
@MainActor
struct GentleBackgroundModifierBodyTests {

    @Test("GentleBackgroundModifier applies color")
    func testGentleBackgroundModifierApplies() {
        let view = GentleThemeRoot {
            VStack {}
                .gentleBackground(.background)
        }
        renderForCoverage(view)
    }

    @Test("GentleBackgroundModifier with ignoresSafeArea true")
    func testGentleBackgroundModifierIgnoresSafeArea() {
        let view = GentleThemeRoot {
            VStack {}
                .gentleBackground(.background, ignoresSafeArea: true)
        }
        renderForCoverage(view)
    }

    @Test("GentleBackgroundModifier with ignoresSafeArea false")
    func testGentleBackgroundModifierNoIgnoresSafeArea() {
        let view = GentleThemeRoot {
            VStack {}
                .gentleBackground(.surfaceBase, ignoresSafeArea: false)
        }
        renderForCoverage(view)
    }

    @Test("GentleBackgroundModifier with all color roles")
    func testGentleBackgroundModifierAllColorRoles() {
        for role in GentleColorRole.allCases {
            let view = GentleThemeRoot {
                VStack {}
                    .gentleBackground(role)
            }
            renderForCoverage(view)
        }
    }
}

// MARK: - GentleInsetModifier Body Tests

@Suite("GentleInsetModifier Body Tests")
@MainActor
struct GentleInsetModifierBodyTests {

    @Test("GentleInsetModifier with all roles")
    func testGentleInsetModifierAllRoles() {
        let roles: [GentleInsetRole] = [.screen, .card, .control, .listRow]

        for role in roles {
            let view = GentleThemeRoot {
                Text("Content")
                    .gentleInset(role)
            }
            renderForCoverage(view)
        }
    }

    @Test("GentleInsetModifier with all variants")
    func testGentleInsetModifierAllVariants() {
        let variants: [GentleInsetVariant] = [.tight, .regular, .roomy]

        for variant in variants {
            let view = GentleThemeRoot {
                Text("Content")
                    .gentleInset(.card, variant: variant)
            }
            renderForCoverage(view)
        }
    }

    @Test("GentleInsetModifier with specific edges")
    func testGentleInsetModifierWithEdges() {
        let edgeSets: [Edge.Set] = [.horizontal, .vertical, .top, .bottom, .leading, .trailing, .all]

        for edges in edgeSets {
            let view = GentleThemeRoot {
                Text("Content")
                    .gentleInset(edges, .screen)
            }
            renderForCoverage(view)
        }
    }
}

// MARK: - GentleButtonStyle Body Tests

@Suite("GentleButtonStyle Body Tests")
@MainActor
struct GentleButtonStyleBodyTests {

    @Test("GentleButtonStyle renders for all roles")
    func testGentleButtonStyleAllRoles() {
        let roles: [GentleButtonRole] = [.primary, .secondary, .tertiary, .quaternary, .destructive]

        for role in roles {
            let view = GentleThemeRoot {
                Button("Tap") {}
                    .gentleButton(role)
            }
            renderForCoverage(view)
        }
    }

    @Test("GentleButtonStyle with pill shape")
    func testGentleButtonStylePillShape() {
        let view = GentleThemeRoot {
            Button("Tap") {}
                .gentleButton(.primary, shape: .pill)
        }
        renderForCoverage(view)
    }

    @Test("GentleButtonStyle with rounded shape")
    func testGentleButtonStyleRoundedShape() {
        let view = GentleThemeRoot {
            Button("Tap") {}
                .gentleButton(.primary, shape: .rounded)
        }
        renderForCoverage(view)
    }

    @Test("GentleButtonStyle with custom text role")
    func testGentleButtonStyleCustomTextRole() {
        let view = GentleThemeRoot {
            Button("Tap") {}
                .gentleButton(.secondary, textRole: .caption_s)
        }
        renderForCoverage(view)
    }

    @Test("GentleButtonStyle with expand horizontally")
    func testGentleButtonStyleExpandHorizontally() {
        let view = GentleThemeRoot {
            Button("Tap") {}
                .gentleButton(.primary, expandsHorizontally: true)
        }
        renderForCoverage(view)
    }

    @Test("GentleButtonStyle with content alignment")
    func testGentleButtonStyleContentAlignment() {
        let alignments: [Alignment] = [.leading, .center, .trailing]

        for alignment in alignments {
            let view = GentleThemeRoot {
                Button("Tap") {}
                    .gentleButton(.primary, expandsHorizontally: true, contentAlignment: alignment)
            }
            renderForCoverage(view)
        }
    }

    @Test("GentleButtonStyle with all parameters")
    func testGentleButtonStyleAllParams() {
        let view = GentleThemeRoot {
            Button("Tap") {}
                .gentleButton(
                    .destructive,
                    shape: .rounded,
                    textRole: .headline_m,
                    expandsHorizontally: true,
                    contentAlignment: .center
                )
        }
        renderForCoverage(view)
    }
}

// MARK: - GentleVisualEffectView Tests

@Suite("GentleVisualEffectView Body Tests")
@MainActor
struct GentleVisualEffectViewBodyTests {

    @Test("GentleVisualEffectView with solid recipe")
    func testGentleVisualEffectViewSolid() {
        let recipe = GentleVisualEffectRecipe(
            id: "test",
            base: .solid(GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000"))
        )
        let view = GentleVisualEffectView(recipe: recipe, colorScheme: .light)
        renderForCoverage(view)
    }

    @Test("GentleVisualEffectView with appleMaterial recipe")
    func testGentleVisualEffectViewAppleMaterial() {
        let recipe = GentleVisualEffectRecipe(
            id: "test",
            base: .appleMaterial(GentleAppleMaterialSpec(kind: .regular, opacity: 1.0))
        )
        let view = GentleVisualEffectView(recipe: recipe, colorScheme: .dark)
        renderForCoverage(view)
    }

    @Test("GentleVisualEffectView with blur recipe")
    func testGentleVisualEffectViewBlur() {
        let recipe = GentleVisualEffectRecipe(
            id: "test",
            base: .blur(GentleBlurSpec(radius: 10))
        )
        let view = GentleVisualEffectView(recipe: recipe, colorScheme: .light)
        renderForCoverage(view)
    }

    @Test("GentleVisualEffectView with glass recipe")
    func testGentleVisualEffectViewGlass() {
        let recipe = GentleVisualEffectRecipe(
            id: "test",
            base: .glass(GentleGlassSpec())
        )
        let view = GentleVisualEffectView(recipe: recipe, colorScheme: .dark)
        renderForCoverage(view)
    }

    @Test("GentleVisualEffectView with all material kinds")
    func testGentleVisualEffectViewAllMaterialKinds() {
        let materialKinds: [GentleAppleMaterialSpec.Kind] = [.ultraThin, .thin, .regular, .thick, .ultraThick, .bar]

        for kind in materialKinds {
            let recipe = GentleVisualEffectRecipe(
                id: "test-\(kind)",
                base: .appleMaterial(GentleAppleMaterialSpec(kind: kind, opacity: 1.0))
            )
            let view = GentleVisualEffectView(recipe: recipe, colorScheme: .light)
            renderForCoverage(view)
        }
    }
}
