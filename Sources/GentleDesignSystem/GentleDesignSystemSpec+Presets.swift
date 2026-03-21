//  Jonathan Ritchey
import SwiftUI

// MARK: - Surface Preset Tokens

public extension GentleSurfaceTokens {

    // MARK: Classic - Traditional warmth, subtle depth
    /// Warm, traditional surfaces with gentle highlight effects and classic proportions
    static let classic: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#D4C8B4", darkHex: "#4A4030"),
                cornerRadius: 16,
                borderWidth: 1
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#D4C8B450", darkHex: "#4A403050"),
                cornerRadius: 16,
                borderWidth: 0.5,
                shadowRadius: 12,
                shadowOpacity: 0.12,
                shadowOffsetY: 6
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceCardSecondary),

                border: GentleColorPair(lightHex: "#D4C8B4", darkHex: "#4A4030"),
                cornerRadius: 14,
                borderWidth: 1
            ),
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .material(material: .thin, tintColorRole: .surfaceBase, tintOpacity: 0.05),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceBase, tintOpacity: 0.15),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .material(material: .thick, tintColorRole: .surfaceBase, tintOpacity: 0.2),
                border: GentleColorPair(lightHex: "#D4C8B440", darkHex: "#4A403040"),
                cornerRadius: 12,
                borderWidth: 0.5,
                shadowRadius: 16,
                shadowOpacity: 0.15,
                shadowOffsetY: 8
            ),
            GentleSurfaceRole.overlayScrim.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceScrim),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .thick, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#FFFFFF30", darkHex: "#FFFFFF15"),
                cornerRadius: 16,
                borderWidth: 0.5,
                shadowRadius: 20,
                shadowOpacity: 0.18,
                shadowOffsetY: 10
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .thick, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 20,
                borderWidth: 0,
                shadowRadius: 10,
                shadowOpacity: 0.1,
                shadowOffsetY: 4
            )
        ]
    )

    // MARK: Modern - Clean, minimal, precise
    /// Crisp surfaces with subtle shadows and precise geometry
    static let modern: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#E0E0E8", darkHex: "#3A3A4E"),
                cornerRadius: 12,
                borderWidth: 1
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#E0E0E840", darkHex: "#3A3A4E40"),
                cornerRadius: 12,
                borderWidth: 0.5,
                shadowRadius: 6,
                shadowOpacity: 0.06,
                shadowOffsetY: 4
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceCardSecondary),
                border: GentleColorPair(lightHex: "#E0E0E8", darkHex: "#3A3A4E"),
                cornerRadius: 10,
                borderWidth: 1
            ),
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .material(material: .ultraThin, tintColorRole: nil, tintOpacity: 0),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceTint, tintOpacity: 0.08),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceBase, tintOpacity: 0.12),
                border: GentleColorPair(lightHex: "#E0E0E825", darkHex: "#3A3A4E25"),
                cornerRadius: 10,
                borderWidth: 0.5,
                shadowRadius: 12,
                shadowOpacity: 0.1,
                shadowOffsetY: 6
            ),
            GentleSurfaceRole.overlayScrim.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceScrim),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#FFFFFF18", darkHex: "#FFFFFF0C"),
                cornerRadius: 12,
                borderWidth: 0.5,
                shadowRadius: 16,
                shadowOpacity: 0.12,
                shadowOffsetY: 8
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 16,
                borderWidth: 0,
                shadowRadius: 6,
                shadowOpacity: 0.08,
                shadowOffsetY: 3
            )
        ]
    )

    // MARK: Soft - Rounded, friendly, gentle
    /// Very rounded corners with soft shadows for a friendly, approachable feel
    static let soft: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#C5E0D4", darkHex: "#2A4D3D"),
                cornerRadius: 24,
                borderWidth: 1
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#C5E0D450", darkHex: "#2A4D3D50"),
                cornerRadius: 24,
                borderWidth: 0.5,
                shadowRadius: 16,
                shadowOpacity: 0.08,
                shadowOffsetY: 8
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceCardSecondary),

                border: GentleColorPair(lightHex: "#C5E0D4", darkHex: "#2A4D3D"),
                cornerRadius: 20,
                borderWidth: 1
            ),
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .material(material: .thin, tintColorRole: .surfaceBase, tintOpacity: 0.03),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceTint, tintOpacity: 0.1),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceBase, tintOpacity: 0.12),
                border: GentleColorPair(lightHex: "#C5E0D425", darkHex: "#2A4D3D25"),
                cornerRadius: 18,
                borderWidth: 0.5,
                shadowRadius: 20,
                shadowOpacity: 0.1,
                shadowOffsetY: 10
            ),
            GentleSurfaceRole.overlayScrim.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceScrim),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#FFFFFF25", darkHex: "#FFFFFF12"),
                cornerRadius: 28,
                borderWidth: 0.5,
                shadowRadius: 24,
                shadowOpacity: 0.12,
                shadowOffsetY: 12
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .thick, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 28,
                borderWidth: 0,
                shadowRadius: 10,
                shadowOpacity: 0.08,
                shadowOffsetY: 5
            )
        ]
    )

    // MARK: Editorial - Sharp, print-inspired, high contrast
    /// Magazine-like surfaces with sharp corners and strong contrast
    static let editorial: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#000000", darkHex: "#404040"),
                cornerRadius: 0,
                borderWidth: 1
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#000000", darkHex: "#404040"),
                cornerRadius: 0,
                borderWidth: 1,
                shadowRadius: 0,
                shadowOpacity: 0,
                shadowOffsetX: 4,
                shadowOffsetY: 4
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceCardSecondary),
                border: GentleColorPair(lightHex: "#000000", darkHex: "#404040"),
                cornerRadius: 0,
                borderWidth: 1
            ),
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#E0E0E0", darkHex: "#404040"),
                cornerRadius: 0,
                borderWidth: 1
            ),
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#000000", darkHex: "#FFFFFF"),
                cornerRadius: 0,
                borderWidth: 2
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#000000", darkHex: "#FFFFFF"),
                cornerRadius: 0,
                borderWidth: 1,
                shadowRadius: 0,
                shadowOpacity: 0.2,
                shadowOffsetX: 4,
                shadowOffsetY: 4
            ),
            GentleSurfaceRole.overlayScrim.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceScrim),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#000000", darkHex: "#FFFFFF"),
                cornerRadius: 0,
                borderWidth: 2,
                shadowRadius: 0,
                shadowOpacity: 0.3,
                shadowOffsetX: 8,
                shadowOffsetY: 8
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#000000", darkHex: "#FFFFFF"),
                cornerRadius: 0,
                borderWidth: 1,
                shadowRadius: 0,
                shadowOpacity: 0.2,
                shadowOffsetX: 3,
                shadowOffsetY: 3
            )
        ]
    )

    // MARK: Technical - Precise, developer-focused
    /// Sharp, precise surfaces with defined borders for data-focused interfaces
    static let technical: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#C4DCF0", darkHex: "#1E4060"),
                cornerRadius: 6,
                borderWidth: 1
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#C4DCF0", darkHex: "#1E4060"),
                cornerRadius: 6,
                borderWidth: 1,
                shadowRadius: 4,
                shadowOpacity: 0.08,
                shadowOffsetY: 2
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceCardSecondary),

                border: GentleColorPair(lightHex: "#C4DCF0", darkHex: "#1E4060"),
                cornerRadius: 5,
                borderWidth: 1
            ),
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .material(material: .ultraThin, tintColorRole: .surfaceBase, tintOpacity: 0.05),
                border: GentleColorPair(lightHex: "#C4DCF0", darkHex: "#1E4060"),
                cornerRadius: 0,
                borderWidth: 1
            ),
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceTint, tintOpacity: 0.1),
                border: GentleColorPair(lightHex: "#C4DCF0", darkHex: "#1E4060"),
                cornerRadius: 0,
                borderWidth: 1
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceBase, tintOpacity: 0.15),
                border: GentleColorPair(lightHex: "#C4DCF0", darkHex: "#1E4060"),
                cornerRadius: 6,
                borderWidth: 1,
                shadowRadius: 8,
                shadowOpacity: 0.12,
                shadowOffsetY: 4
            ),
            GentleSurfaceRole.overlayScrim.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceScrim),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#C4DCF0", darkHex: "#1E4060"),
                cornerRadius: 8,
                borderWidth: 1,
                shadowRadius: 12,
                shadowOpacity: 0.15,
                shadowOffsetY: 6
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#C4DCF080", darkHex: "#1E406080"),
                cornerRadius: 6,
                borderWidth: 1,
                shadowRadius: 4,
                shadowOpacity: 0.1,
                shadowOffsetY: 2
            )
        ]
    )

    // MARK: Bold - Strong presence, pronounced shadows
    /// High-impact surfaces with bold shadows and strong specular effects
    static let bold: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#F0D4C0", darkHex: "#4D3020"),
                cornerRadius: 16,
                borderWidth: 2
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#F0D4C080", darkHex: "#4D302080"),
                cornerRadius: 16,
                borderWidth: 2,
                shadowRadius: 16,
                shadowOpacity: 0.2,
                shadowOffsetY: 8
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceCardSecondary),

                border: GentleColorPair(lightHex: "#F0D4C0", darkHex: "#4D3020"),
                cornerRadius: 14,
                borderWidth: 2
            ),
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .material(material: .thin, tintColorRole: .surfaceBase, tintOpacity: 0.1),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .material(material: .thick, tintColorRole: .surfaceTint, tintOpacity: 0.15),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .material(material: .thick, tintColorRole: .surfaceBase, tintOpacity: 0.2),
                border: GentleColorPair(lightHex: "#F0D4C060", darkHex: "#4D302060"),
                cornerRadius: 14,
                borderWidth: 1.5,
                shadowRadius: 20,
                shadowOpacity: 0.25,
                shadowOffsetY: 10
            ),
            GentleSurfaceRole.overlayScrim.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceScrim),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .thick, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#FFFFFF40", darkHex: "#FFFFFF20"),
                cornerRadius: 20,
                borderWidth: 1,
                shadowRadius: 32,
                shadowOpacity: 0.3,
                shadowOffsetY: 16
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .thick, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 20,
                borderWidth: 0,
                shadowRadius: 12,
                shadowOpacity: 0.18,
                shadowOffsetY: 6
            )
        ]
    )

    // MARK: Elegant - Light, airy, refined
    /// Delicate surfaces with subtle shadows and refined borders
    static let elegant: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#E0D0F0", darkHex: "#3D2D60"),
                cornerRadius: 20,
                borderWidth: 0.5
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#E0D0F040", darkHex: "#3D2D6040"),
                cornerRadius: 20,
                borderWidth: 0.5,
                shadowRadius: 20,
                shadowOpacity: 0.06,
                shadowOffsetY: 10
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceCardSecondary),

                border: GentleColorPair(lightHex: "#E0D0F0", darkHex: "#3D2D60"),
                cornerRadius: 16,
                borderWidth: 0.5
            ),
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .material(material: .ultraThin, tintColorRole: nil, tintOpacity: 0),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .material(material: .thin, tintColorRole: .surfaceTint, tintOpacity: 0.05),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .material(material: .thin, tintColorRole: .surfaceBase, tintOpacity: 0.08),
                border: GentleColorPair(lightHex: "#E0D0F020", darkHex: "#3D2D6020"),
                cornerRadius: 16,
                borderWidth: 0.5,
                shadowRadius: 24,
                shadowOpacity: 0.08,
                shadowOffsetY: 12
            ),
            GentleSurfaceRole.overlayScrim.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceScrim),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .thin, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#FFFFFF15", darkHex: "#FFFFFF08"),
                cornerRadius: 24,
                borderWidth: 0.5,
                shadowRadius: 32,
                shadowOpacity: 0.1,
                shadowOffsetY: 16
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .thin, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 24,
                borderWidth: 0,
                shadowRadius: 12,
                shadowOpacity: 0.06,
                shadowOffsetY: 6
            )
        ]
    )

    // MARK: Compact - Dense, efficient, tight
    /// Tight corners and minimal shadows for information-dense interfaces
    static let compact: GentleSurfaceTokens = .init(
        roles: [
            GentleSurfaceRole.appBackground.rawValue: .init(
                backgroundStyle: .solid(colorRole: .background),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.card.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#C4DCD0", darkHex: "#2D4D3D"),
                cornerRadius: 8,
                borderWidth: 1
            ),
            GentleSurfaceRole.cardElevated.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceBase),

                border: GentleColorPair(lightHex: "#C4DCD060", darkHex: "#2D4D3D60"),
                cornerRadius: 8,
                borderWidth: 0.5,
                shadowRadius: 4,
                shadowOpacity: 0.06,
                shadowOffsetY: 2
            ),
            GentleSurfaceRole.cardSecondary.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceCardSecondary),

                border: GentleColorPair(lightHex: "#C4DCD0", darkHex: "#2D4D3D"),
                cornerRadius: 7,
                borderWidth: 1
            ),
            GentleSurfaceRole.chrome.rawValue: .init(
                backgroundStyle: .material(material: .ultraThin, tintColorRole: nil, tintOpacity: 0),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlaySheet.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceTint, tintOpacity: 0.1),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.overlayPopover.rawValue: .init(
                backgroundStyle: .material(material: .regular, tintColorRole: .surfaceBase, tintOpacity: 0.12),
                border: GentleColorPair(lightHex: "#C4DCD030", darkHex: "#2D4D3D30"),
                cornerRadius: 8,
                borderWidth: 0.5,
                shadowRadius: 8,
                shadowOpacity: 0.1,
                shadowOffsetY: 4
            ),
            GentleSurfaceRole.overlayScrim.rawValue: .init(
                backgroundStyle: .solid(colorRole: .surfaceScrim),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 0,
                borderWidth: 0
            ),
            GentleSurfaceRole.floatingPanel.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#FFFFFF18", darkHex: "#FFFFFF0C"),
                cornerRadius: 10,
                borderWidth: 0.5,
                shadowRadius: 12,
                shadowOpacity: 0.12,
                shadowOffsetY: 6
            ),
            GentleSurfaceRole.floatingWidget.rawValue: .init(
                backgroundStyle: .glass(fallbackMaterial: .regular, fallbackColorRole: .surfaceBase),
                border: GentleColorPair(lightHex: "#00000000", darkHex: "#00000000"),
                cornerRadius: 10,
                borderWidth: 0,
                shadowRadius: 4,
                shadowOpacity: 0.08,
                shadowOffsetY: 2
            )
        ]
    )
}

// MARK: - Theme Presets

public extension GentleDesignSystemSpec {

    // MARK: Preset 1: Classic - Serif titles, traditional feel
    static let classic: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Warm cream/brown colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#2C2416", darkHex: "#F5F0E6"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#5A4D3A", darkHex: "#D4C8B4"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#7A6E5A", darkHex: "#B0A48E"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#FAF8F3", darkHex: "#1A1610"),
            GentleColorRole.surfaceBase.rawValue:       .init(lightHex: "#F5F0E6", darkHex: "#2C2416"),
            GentleColorRole.surfaceCardSecondary.rawValue: .init(lightHex: "#F1E9D7", darkHex: "#3D3117"),
            GentleColorRole.surfaceTint.rawValue:   .init(lightHex: "#2C2416CC", darkHex: "#0D0B08CC"),
            GentleColorRole.surfaceScrim.rawValue: .init(lightHex: "#000000B3", darkHex: "#000000B3"),
            GentleColorRole.textOnOverlay.rawValue:   .init(lightHex: "#2C2416", darkHex: "#F5F0E6"),
            GentleColorRole.textOnOverlaySecondary.rawValue: .init(lightHex: "#5A4D3A", darkHex: "#D4C8B4"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#E0D8C8", darkHex: "#4A4030"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#8B4513", darkHex: "#CD853F"),
            GentleColorRole.textOnPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#1A1610"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#A0522D", darkHex: "#E07850"),
            GentleColorRole.textOnDestructive.rawValue:  .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrim.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrimSecondary.rawValue: .init(lightHex: "#C7CDD4", darkHex: "#C7CDD4"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#8B4513", darkHex: "#CD853F"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#B8860B", darkHex: "#DAA520"),
        ])
        // Use classic surface tokens
        spec.surfaces = .classic
        // Serif titles, traditional typography
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 36, weight: .bold, design: .serif, width: nil,
            relativeTo: .largeTitle, lineSpacing: 4, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 28, weight: .semibold, design: .serif, width: nil,
            relativeTo: .title, lineSpacing: 3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 22, weight: .semibold, design: .serif, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .medium, design: .serif, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .serif, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 3, colorRole: .textPrimary
        )
        // Button titles – use default (not serif) for buttons
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 2: Modern - Clean, minimal default design
    static let modern: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Cool gray/blue colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#1A1A2E", darkHex: "#EAEAF4"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#4A4A5E", darkHex: "#B0B0C4"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#6A6A7E", darkHex: "#8A8A9E"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#FAFAFC", darkHex: "#0D0D14"),
            GentleColorRole.surfaceBase.rawValue:       .init(lightHex: "#F0F0F4", darkHex: "#1A1A28"),
            GentleColorRole.surfaceCardSecondary.rawValue: .init(lightHex: "#E9EBF5", darkHex: "#24263E"),
            GentleColorRole.surfaceTint.rawValue:   .init(lightHex: "#1A1A2ECC", darkHex: "#08080CCC"),
            GentleColorRole.surfaceScrim.rawValue: .init(lightHex: "#000000B3", darkHex: "#000000B3"),
            GentleColorRole.textOnOverlay.rawValue:   .init(lightHex: "#1A1A2E", darkHex: "#EAEAF4"),
            GentleColorRole.textOnOverlaySecondary.rawValue: .init(lightHex: "#4A4A5E", darkHex: "#B0B0C4"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#E0E0E8", darkHex: "#3A3A4E"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#3B5BDB", darkHex: "#5C7CFA"),
            GentleColorRole.textOnPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#0D0D14"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#E03131", darkHex: "#FF6B6B"),
            GentleColorRole.textOnDestructive.rawValue:  .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrim.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrimSecondary.rawValue: .init(lightHex: "#C7CDD4", darkHex: "#C7CDD4"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#3B5BDB", darkHex: "#5C7CFA"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#748FFC", darkHex: "#91A7FF"),
        ])
        // Use modern surface tokens
        spec.surfaces = .modern
        // Clean default design, medium weights
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 32, weight: .semibold, design: .default, width: nil,
            relativeTo: .largeTitle, lineSpacing: 4, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 26, weight: .semibold, design: .default, width: nil,
            relativeTo: .title, lineSpacing: 3, letterSpacing: -0.3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 21, weight: .medium, design: .default, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 19, weight: .medium, design: .default, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 16, weight: .medium, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 3, colorRole: .textPrimary
        )
        // Button titles – clean default design with medium weight
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 16, weight: .medium, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 16, weight: .medium, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 16, weight: .medium, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 3: Soft - Rounded throughout, friendly feel
    static let soft: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Soft mint/teal colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#1A3A2F", darkHex: "#E8F5F0"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#3D5A4F", darkHex: "#B8D4C8"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#5A7A6A", darkHex: "#8AB09E"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#F5FAF8", darkHex: "#0D1F18"),
            GentleColorRole.surfaceBase.rawValue:       .init(lightHex: "#E8F5F0", darkHex: "#142E24"),
            GentleColorRole.surfaceCardSecondary.rawValue: .init(lightHex: "#E0F2EA", darkHex: "#1F4133"),
            GentleColorRole.surfaceTint.rawValue:   .init(lightHex: "#1A3A2FCC", darkHex: "#0A1A14CC"),
            GentleColorRole.surfaceScrim.rawValue: .init(lightHex: "#000000B3", darkHex: "#000000B3"),
            GentleColorRole.textOnOverlay.rawValue:   .init(lightHex: "#1A3A2F", darkHex: "#E8F5F0"),
            GentleColorRole.textOnOverlaySecondary.rawValue: .init(lightHex: "#3D5A4F", darkHex: "#B8D4C8"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#C5E0D4", darkHex: "#2A4D3D"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#2E8B6E", darkHex: "#4ADE9F"),
            GentleColorRole.textOnPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#0D1F18"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#D9534F", darkHex: "#FF6B6B"),
            GentleColorRole.textOnDestructive.rawValue:  .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrim.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrimSecondary.rawValue: .init(lightHex: "#C7CDD4", darkHex: "#C7CDD4"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#2E8B6E", darkHex: "#4ADE9F"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#6FCF97", darkHex: "#7EEAB8"),
        ])
        // Use soft surface tokens
        spec.surfaces = .soft
        // All rounded, soft weights
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 34, weight: .bold, design: .rounded, width: nil,
            relativeTo: .largeTitle, lineSpacing: 6, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 28, weight: .bold, design: .rounded, width: nil,
            relativeTo: .title, lineSpacing: 4, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 22, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .title2, lineSpacing: 3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .title3, lineSpacing: 3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .rounded, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .rounded, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.callout_ms.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .rounded, width: nil,
            relativeTo: .callout, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.subheadline_ms.rawValue] = .init(
            pointSize: 15, weight: .regular, design: .rounded, width: nil,
            relativeTo: .subheadline, colorRole: .textSecondary
        )
        // Button titles – rounded design to match the soft theme
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .rounded, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .rounded, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 4: Editorial - Serif throughout, magazine feel
    static let editorial: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // High contrast black/white
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#000000", darkHex: "#FFFFFF"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#333333", darkHex: "#CCCCCC"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#666666", darkHex: "#999999"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#000000"),
            GentleColorRole.surfaceBase.rawValue:       .init(lightHex: "#F5F5F5", darkHex: "#1A1A1A"),
            GentleColorRole.surfaceCardSecondary.rawValue: .init(lightHex: "#ECECEC", darkHex: "#242424"),
            GentleColorRole.surfaceTint.rawValue:   .init(lightHex: "#000000CC", darkHex: "#000000CC"),
            GentleColorRole.surfaceScrim.rawValue: .init(lightHex: "#000000B3", darkHex: "#000000B3"),
            GentleColorRole.textOnOverlay.rawValue:   .init(lightHex: "#000000", darkHex: "#FFFFFF"),
            GentleColorRole.textOnOverlaySecondary.rawValue: .init(lightHex: "#333333", darkHex: "#CCCCCC"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#E0E0E0", darkHex: "#404040"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#000000", darkHex: "#FFFFFF"),
            GentleColorRole.textOnPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#000000"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#B91C1C", darkHex: "#F87171"),
            GentleColorRole.textOnDestructive.rawValue:  .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrim.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrimSecondary.rawValue: .init(lightHex: "#C7CDD4", darkHex: "#C7CDD4"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#000000", darkHex: "#FFFFFF"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#666666", darkHex: "#999999"),
        ])
        // Use editorial surface tokens
        spec.surfaces = .editorial
        // All serif, editorial typography
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 40, weight: .bold, design: .serif, width: nil,
            relativeTo: .largeTitle, lineSpacing: 2, letterSpacing: -1.0, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 30, weight: .bold, design: .serif, width: nil,
            relativeTo: .title, lineSpacing: 2, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 24, weight: .semibold, design: .serif, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .semibold, design: .serif, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .serif, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 18, weight: .regular, design: .serif, width: nil,
            relativeTo: .body, lineSpacing: 4, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 18, weight: .regular, design: .serif, width: nil,
            relativeTo: .body, lineSpacing: 4, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.callout_ms.rawValue] = .init(
            pointSize: 16, weight: .regular, design: .serif, width: nil,
            relativeTo: .callout, colorRole: .textSecondary
        )
        // Button titles – use default (not serif) for buttons
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .semibold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 5: Technical - Monospace accents, developer feel
    static let technical: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Cool blue/gray tech colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#0A2540", darkHex: "#E6F0FA"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#334E68", darkHex: "#A3C4E0"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#5A7A94", darkHex: "#7BA3C4"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#F0F7FC", darkHex: "#061623"),
            GentleColorRole.surfaceBase.rawValue:       .init(lightHex: "#E1EFF9", darkHex: "#0C2236"),
            GentleColorRole.surfaceCardSecondary.rawValue: .init(lightHex: "#D7E9F7", darkHex: "#18324A"),
            GentleColorRole.surfaceTint.rawValue:   .init(lightHex: "#0A2540CC", darkHex: "#041020CC"),
            GentleColorRole.surfaceScrim.rawValue: .init(lightHex: "#000000B3", darkHex: "#000000B3"),
            GentleColorRole.textOnOverlay.rawValue:   .init(lightHex: "#0A2540", darkHex: "#E6F0FA"),
            GentleColorRole.textOnOverlaySecondary.rawValue: .init(lightHex: "#334E68", darkHex: "#A3C4E0"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#C4DCF0", darkHex: "#1E4060"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#0066CC", darkHex: "#4DA6FF"),
            GentleColorRole.textOnPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#061623"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#D64545", darkHex: "#FF7070"),
            GentleColorRole.textOnDestructive.rawValue:  .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrim.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrimSecondary.rawValue: .init(lightHex: "#C7CDD4", darkHex: "#C7CDD4"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#0066CC", darkHex: "#4DA6FF"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#4D94DB", darkHex: "#80C0FF"),
        ])
        // Use technical surface tokens
        spec.surfaces = .technical
        // Monospace titles, condensed
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 30, weight: .bold, design: .monospaced, width: nil,
            relativeTo: .largeTitle, lineSpacing: 4, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 24, weight: .bold, design: .monospaced, width: nil,
            relativeTo: .title, lineSpacing: 3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 20, weight: .semibold, design: .monospaced, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 18, weight: .semibold, design: .monospaced, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 15, weight: .semibold, design: .monospaced, width: nil,
            relativeTo: .headline, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 15, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.monoCode_m.rawValue] = .init(
            pointSize: 14, weight: .regular, design: .monospaced, width: nil,
            relativeTo: .body, letterSpacing: 0, colorRole: .textPrimary
        )
        // Button titles – condensed default design (monospaced would be too wide for buttons)
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 15, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 15, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 15, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 15, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 6: Bold - Heavy weights, strong presence
    static let bold: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Warm orange/sunset colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#3D1E0A", darkHex: "#FFF0E6"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#664433", darkHex: "#E0C4B0"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#8B6B55", darkHex: "#C4A088"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#FFF8F3", darkHex: "#1A0D06"),
            GentleColorRole.surfaceBase.rawValue:       .init(lightHex: "#FFEFE5", darkHex: "#2D1A0F"),
            GentleColorRole.surfaceCardSecondary.rawValue: .init(lightHex: "#FEEADC", darkHex: "#422A1A"),
            GentleColorRole.surfaceTint.rawValue:   .init(lightHex: "#3D1E0ACC", darkHex: "#140A05CC"),
            GentleColorRole.surfaceScrim.rawValue: .init(lightHex: "#000000B3", darkHex: "#000000B3"),
            GentleColorRole.textOnOverlay.rawValue:   .init(lightHex: "#3D1E0A", darkHex: "#FFF0E6"),
            GentleColorRole.textOnOverlaySecondary.rawValue: .init(lightHex: "#664433", darkHex: "#E0C4B0"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#F0D4C0", darkHex: "#4D3020"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#E85D04", darkHex: "#FF8C42"),
            GentleColorRole.textOnPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#1A0D06"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#CC3300", darkHex: "#FF6644"),
            GentleColorRole.textOnDestructive.rawValue:  .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrim.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrimSecondary.rawValue: .init(lightHex: "#C7CDD4", darkHex: "#C7CDD4"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#E85D04", darkHex: "#FF8C42"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#F5A060", darkHex: "#FFB87A"),
        ])
        // Use bold surface tokens
        spec.surfaces = .bold
        // Heavy weights throughout
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 38, weight: .black, design: .default, width: nil,
            relativeTo: .largeTitle, lineSpacing: 4, letterSpacing: -1.0, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 30, weight: .heavy, design: .default, width: nil,
            relativeTo: .title, lineSpacing: 3, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 24, weight: .bold, design: .default, width: nil,
            relativeTo: .title2, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .bold, design: .default, width: nil,
            relativeTo: .title3, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .medium, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 17, weight: .medium, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 2, colorRole: .textSecondary
        )
        // Button titles – bold/heavy weights to match the bold theme
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .heavy, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .bold, design: .default, width: nil,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .medium, design: .default, width: nil,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 7: Elegant - Light weights, expanded, airy feel
    static let elegant: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Soft lavender/purple colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#2D1B4E", darkHex: "#F0E6FF"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#4D3A6B", darkHex: "#D0C0E8"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#6E5A8A", darkHex: "#B0A0C8"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#F8F5FF", darkHex: "#120D1F"),
            GentleColorRole.surfaceBase.rawValue:       .init(lightHex: "#F0E8FF", darkHex: "#1E1630"),
            GentleColorRole.surfaceCardSecondary.rawValue: .init(lightHex: "#ECE1FF", darkHex: "#2F2445"),
            GentleColorRole.surfaceTint.rawValue:   .init(lightHex: "#2D1B4ECC", darkHex: "#0D0818CC"),
            GentleColorRole.surfaceScrim.rawValue: .init(lightHex: "#000000B3", darkHex: "#000000B3"),
            GentleColorRole.textOnOverlay.rawValue:   .init(lightHex: "#2D1B4E", darkHex: "#F0E6FF"),
            GentleColorRole.textOnOverlaySecondary.rawValue: .init(lightHex: "#4D3A6B", darkHex: "#D0C0E8"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#E0D0F0", darkHex: "#3D2D60"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#7C4DFF", darkHex: "#A580FF"),
            GentleColorRole.textOnPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#120D1F"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#D946EF", darkHex: "#F472B6"),
            GentleColorRole.textOnDestructive.rawValue:  .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrim.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrimSecondary.rawValue: .init(lightHex: "#C7CDD4", darkHex: "#C7CDD4"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#7C4DFF", darkHex: "#A580FF"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#B388FF", darkHex: "#C9A0FF"),
        ])
        // Use elegant surface tokens
        spec.surfaces = .elegant
        // Light weights, expanded, generous spacing
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 36, weight: .light, design: .default, width: .expanded,
            relativeTo: .largeTitle, lineSpacing: 8, letterSpacing: 1.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 28, weight: .light, design: .default, width: .expanded,
            relativeTo: .title, lineSpacing: 6, letterSpacing: 1.0, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 22, weight: .regular, design: .default, width: .expanded,
            relativeTo: .title2, lineSpacing: 4, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 20, weight: .regular, design: .default, width: nil,
            relativeTo: .title3, lineSpacing: 4, letterSpacing: 0.3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .headline, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 17, weight: .light, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 4, letterSpacing: 0.2, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 17, weight: .light, design: .default, width: nil,
            relativeTo: .body, lineSpacing: 4, letterSpacing: 0.2, colorRole: .textSecondary
        )
        // Button titles – light/regular weights with letter spacing for elegance
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .headline, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .headline, letterSpacing: 0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .regular, design: .default, width: nil,
            relativeTo: .headline, letterSpacing: 0.3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 17, weight: .light, design: .default, width: nil,
            relativeTo: .body, letterSpacing: 0.2, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    // MARK: Preset 8: Compact - Condensed, information-dense
    static let compact: GentleDesignSystemSpec = {
        var spec = GentleDesignSystemSpec.gentleDefault
        // Deep forest green colors
        spec.colors = GentleColorTokens(pairByRole: [
            GentleColorRole.textPrimary.rawValue:   .init(lightHex: "#1B3D2F", darkHex: "#E6F2EC"),
            GentleColorRole.textSecondary.rawValue: .init(lightHex: "#3A5A4A", darkHex: "#B8D4C4"),
            GentleColorRole.textTertiary.rawValue:  .init(lightHex: "#5A7A6A", darkHex: "#94B8A4"),
            GentleColorRole.background.rawValue:    .init(lightHex: "#F2F8F5", darkHex: "#0D1A14"),
            GentleColorRole.surfaceBase.rawValue:       .init(lightHex: "#E4F0EA", darkHex: "#1A2D24"),
            GentleColorRole.surfaceCardSecondary.rawValue: .init(lightHex: "#D6EDE0", darkHex: "#254032"),
            GentleColorRole.surfaceTint.rawValue:   .init(lightHex: "#1B3D2FCC", darkHex: "#0A1810CC"),
            GentleColorRole.surfaceScrim.rawValue: .init(lightHex: "#000000B3", darkHex: "#000000B3"),
            GentleColorRole.textOnOverlay.rawValue:   .init(lightHex: "#1B3D2F", darkHex: "#E6F2EC"),
            GentleColorRole.textOnOverlaySecondary.rawValue: .init(lightHex: "#3A5A4A", darkHex: "#B8D4C4"),
            GentleColorRole.borderSubtle.rawValue:   .init(lightHex: "#C4DCD0", darkHex: "#2D4D3D"),
            GentleColorRole.primaryCTA.rawValue:     .init(lightHex: "#166534", darkHex: "#4ADE80"),
            GentleColorRole.textOnPrimaryCTA.rawValue:   .init(lightHex: "#FFFFFF", darkHex: "#0D1A14"),
            GentleColorRole.destructive.rawValue:    .init(lightHex: "#B91C1C", darkHex: "#F87171"),
            GentleColorRole.textOnDestructive.rawValue:  .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrim.rawValue:    .init(lightHex: "#FFFFFF", darkHex: "#FFFFFF"),
            GentleColorRole.textOnScrimSecondary.rawValue: .init(lightHex: "#C7CDD4", darkHex: "#C7CDD4"),
            GentleColorRole.themePrimary.rawValue:   .init(lightHex: "#166534", darkHex: "#4ADE80"),
            GentleColorRole.themeSecondary.rawValue: .init(lightHex: "#22C55E", darkHex: "#86EFAC"),
        ])
        // Use compact surface tokens
        spec.surfaces = .compact
        // Condensed, smaller sizes, tight spacing
        var typo = GentleTypographyTokens.gentleDefault
        typo.roles[GentleTextRole.largeTitle_xxl.rawValue] = .init(
            pointSize: 28, weight: .bold, design: .default, width: .condensed,
            relativeTo: .largeTitle, lineSpacing: 2, letterSpacing: -0.5, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title_xl.rawValue] = .init(
            pointSize: 22, weight: .bold, design: .default, width: .condensed,
            relativeTo: .title, lineSpacing: 2, letterSpacing: -0.3, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title2_l.rawValue] = .init(
            pointSize: 18, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .title2, lineSpacing: 1, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.title3_ml.rawValue] = .init(
            pointSize: 16, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .title3, lineSpacing: 1, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.headline_m.rawValue] = .init(
            pointSize: 14, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.body_m.rawValue] = .init(
            pointSize: 14, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, lineSpacing: 1, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.bodySecondary_m.rawValue] = .init(
            pointSize: 14, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, lineSpacing: 1, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.callout_ms.rawValue] = .init(
            pointSize: 13, weight: .regular, design: .default, width: .condensed,
            relativeTo: .callout, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.subheadline_ms.rawValue] = .init(
            pointSize: 12, weight: .regular, design: .default, width: .condensed,
            relativeTo: .subheadline, colorRole: .textSecondary
        )
        typo.roles[GentleTextRole.footnote_s.rawValue] = .init(
            pointSize: 11, weight: .regular, design: .default, width: .condensed,
            relativeTo: .footnote, colorRole: .textTertiary
        )
        typo.roles[GentleTextRole.caption_s.rawValue] = .init(
            pointSize: 10, weight: .regular, design: .default, width: .condensed,
            relativeTo: .caption, colorRole: .textTertiary
        )
        typo.roles[GentleTextRole.caption2_s.rawValue] = .init(
            pointSize: 9, weight: .regular, design: .default, width: .condensed,
            relativeTo: .caption2, colorRole: .textTertiary
        )
        // Button titles – condensed design to match the compact theme
        typo.roles[GentleTextRole.primaryButtonTitle_m.rawValue] = .init(
            pointSize: 14, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.secondaryButtonTitle_m.rawValue] = .init(
            pointSize: 14, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.tertiaryButtonTitle_m.rawValue] = .init(
            pointSize: 14, weight: .semibold, design: .default, width: .condensed,
            relativeTo: .headline, colorRole: .textPrimary
        )
        typo.roles[GentleTextRole.quaternaryButtonTitle_m.rawValue] = .init(
            pointSize: 14, weight: .regular, design: .default, width: .condensed,
            relativeTo: .body, colorRole: .textPrimary
        )
        spec.typography = typo
        return spec
    }()

    /// All built-in theme presets with display names and descriptions
    static let allPresets: [(name: String, summary: String, description: String, purpose: String, systemImageString: String, spec: GentleDesignSystemSpec)] = [
        ("Gentle Default",
         "Calm, balanced foundation for any app",
         "A neutral theme with soft surfaces and confident accent colors that work across all contexts.",
         "Use when you want a versatile starting point with clean hierarchy and accessible contrast.",
         "circle.hexagongrid",
         .gentleDefault),
        ("Classic Tan",
         "Warm, timeless feel with earthy tones",
         "Rich tan backgrounds paired with warm accents create a cozy, established aesthetic.",
         "Use for apps that benefit from warmth and a sense of heritage or craftsmanship.",
         "book.closed.fill",
         .classic),
        ("Modern Gray",
         "Sleek, minimal with neutral foundations",
         "Cool gray surfaces with sharp accents deliver a contemporary, professional appearance.",
         "Use for business apps or tools where clarity and efficiency are paramount.",
         "cube.fill",
         .modern),
        ("Soft Green",
         "Fresh, natural with calming green accents",
         "Gentle green tones create a refreshing, organic feel that reduces visual fatigue.",
         "Use for wellness, productivity, or any app where calm focus matters.",
         "leaf.fill",
         .soft),
        ("Editorial Paper",
         "Refined, print-inspired reading experience",
         "Paper-like backgrounds and classic typography evoke the quality of fine publications.",
         "Use for content-heavy apps where long-form reading is the primary experience.",
         "newspaper.fill",
         .editorial),
        ("Technical Blue",
         "Precise, trustworthy with blue highlights",
         "Professional blue accents on clean surfaces convey reliability and technical competence.",
         "Use for developer tools, dashboards, or apps requiring user trust.",
         "terminal.fill",
         .technical),
        ("Bold Orange",
         "Vibrant, energetic with strong presence",
         "High-energy orange accents demand attention and create memorable interactions.",
         "Use for apps that need to motivate action or stand out boldly.",
         "bolt.fill",
         .bold),
        ("Elegant Purple",
         "Sophisticated, luxurious with rich tones",
         "Deep purple accents on refined surfaces create a premium, distinguished appearance.",
         "Use for lifestyle, creative, or premium apps where elegance matters.",
         "crown.fill",
         .elegant),
        ("Compact Mint",
         "Dense, efficient with fresh accents",
         "Tighter spacing with mint highlights maximizes information density while staying fresh.",
         "Use for data-rich interfaces where screen real estate is precious.",
         "square.grid.3x3.fill",
         .compact),
    ]
}
