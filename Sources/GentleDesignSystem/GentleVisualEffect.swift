//  Jonathan Ritchey


//  Jonathan Ritchey
// GentleVisualEffect.swift
//
// Core visual effect model for GentleDesignSystem.
// This file defines reusable optical "effect recipes" that surfaces reference.
// - Supports: solid color, Apple Materials, explicit blur, future glass
// - Includes: specular edge cues + inner edge cues
// - Excludes: surface geometry, surface roles, rendering code, noise/grain

import Foundation

// MARK: - Visual Effects

/// Role-based visual effect identifiers used by surfaces.
public enum GentleVisualEffect: String, Codable, Sendable, CaseIterable, Identifiable {
    case appBackground
    case surface
    case surfaceOverlay

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .appBackground: return "App Background"
        case .surface: return "Surface"
        case .surfaceOverlay: return "Surface Overlay"
        }
    }
}

// MARK: - GentleVisualEffectRecipe

/// A reusable visual "recipe" describing optical behavior and edge cues.
/// Surfaces (cards, panels, chrome, etc.) should reference these by id.
public struct GentleVisualEffectRecipe: Codable, Sendable, Equatable, Identifiable {

    /// Stable identifier (e.g. "cardRegular", "chromeUltraThin").
    public var id: String

    /// Base optical behavior.
    public var base: GentleVisualEffectBase

    /// Optional subtle wash above the base (keep opacity low).
    public var tint: GentleColorPair?

    /// Optional specular cues: rim highlight + directional corner highlights/shadows.
    public var specular: GentleSpecularSpec?

    /// Optional inner edge cues (plastic vs glass differentiation).
    public var innerEdges: GentleInnerEdgeSpec?

    public init(
        id: String,
        base: GentleVisualEffectBase,
        tint: GentleColorPair? = nil,
        specular: GentleSpecularSpec? = nil,
        innerEdges: GentleInnerEdgeSpec? = nil
    ) {
        self.id = id
        self.base = base
        self.tint = tint
        self.specular = specular
        self.innerEdges = innerEdges
    }
}

// MARK: - Visual Effect Base

/// Base optical behavior for a visual effect recipe.
public enum GentleVisualEffectBase: Codable, Sendable, Equatable {

    /// Solid fill color (light/dark pair).
    case solid(GentleColorPair)

    /// SwiftUI system materials (ultraThin, thin, regular, etc.).
    case appleMaterial(GentleAppleMaterialSpec)

    /// Explicit blur recipe (non-Material blur).
    case blur(GentleBlurSpec)

    /// Future-facing Liquid Glass (iOS 26+).
    /// Decode everywhere; apply only when available.
    case glass(GentleGlassSpec)
}

// MARK: - Apple Material Spec

/// Specification for SwiftUI's built-in `Material` backgrounds.
public struct GentleAppleMaterialSpec: Codable, Sendable, Equatable {

    public enum Kind: String, Codable, Sendable {
        case ultraThin
        case thin
        case regular
        case thick
        case ultraThick
        case bar
    }

    /// Which system material thickness to use.
    public var kind: Kind

    /// Strength dial applied to the material layer (0...1).
    /// This is the only safe tuning knob Apple exposes.
    public var opacity: Double

    public init(kind: Kind, opacity: Double = 1.0) {
        self.kind = kind
        self.opacity = opacity
    }
}

// MARK: - Blur Spec

/// Explicit blur recipe (implementation-defined).
///
/// Intended implementations:
/// - UIVisualEffectView wrapper (recommended)
/// - Other platform-specific blur solutions
public struct GentleBlurSpec: Codable, Sendable, Equatable {

    /// Blur radius in points (typical range: 4...30).
    public var radius: Double

    /// Whether blur samples behind the view (true)
    /// or blurs a local snapshot/content (false).
    public var isBackgroundOnly: Bool

    /// Strength dial for the blur overlay (0...1).
    public var opacity: Double

    public init(
        radius: Double,
        isBackgroundOnly: Bool = true,
        opacity: Double = 1.0
    ) {
        self.radius = radius
        self.isBackgroundOnly = isBackgroundOnly
        self.opacity = opacity
    }
}

// MARK: - Glass Spec (iOS 26+)

/// Future-facing Liquid Glass specification.
///
/// Renderer responsibility:
/// - Apply `.glassEffect(...)` only when available
/// - Provide fallback behavior on older OS versions
public struct GentleGlassSpec: Codable, Sendable, Equatable {

    public enum Style: String, Codable, Sendable {
        case regular
        case clear
        /// Useful for runtime toggling.
        case identity
    }

    public var style: Style

    /// Whether glass responds interactively (e.g. `.interactive()`).
    public var isInteractive: Bool

    /// Optional subtle tint above the glass.
    public var tint: GentleColorPair?

    public init(
        style: Style = .regular,
        isInteractive: Bool = false,
        tint: GentleColorPair? = nil
    ) {
        self.style = style
        self.isInteractive = isInteractive
        self.tint = tint
    }
}

// MARK: - Specular Edges

/// Specular and rim cues that make materials read as glass or plastic
/// without custom shaders.
public struct GentleSpecularSpec: Codable, Sendable, Equatable {

    /// A directional corner highlight or shadow.
    public struct Corner: Codable, Sendable, Equatable {

        /// Opacity (0...1).
        public var opacity: Double

        /// Spread/radius in points (e.g. 24...80).
        public var radius: Double

        /// Softness of the cue (e.g. 6...20).
        public var blur: Double

        /// Color pair for light/dark schemes.
        public var color: GentleColorPair

        public init(
            opacity: Double,
            radius: Double,
            blur: Double,
            color: GentleColorPair
        ) {
            self.opacity = opacity
            self.radius = radius
            self.blur = blur
            self.color = color
        }
    }

    /// Directional cues.
    /// Common convention: light from above-left.
    public var topLeft: Corner?
    public var topRight: Corner?
    public var bottomLeft: Corner?
    public var bottomRight: Corner?

    /// Outer rim highlight.
    public var rimStrokeOpacity: Double
    public var rimStrokeWidth: Double

    public init(
        topLeft: Corner? = nil,
        topRight: Corner? = nil,
        bottomLeft: Corner? = nil,
        bottomRight: Corner? = nil,
        rimStrokeOpacity: Double = 0.18,
        rimStrokeWidth: Double = 1.0
    ) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
        self.rimStrokeOpacity = rimStrokeOpacity
        self.rimStrokeWidth = rimStrokeWidth
    }
}

// MARK: - Inner Edge Cues

/// Inner edge highlights and shadows used to sell tactility
/// (plastic buttons, inset surfaces).
public struct GentleInnerEdgeSpec: Codable, Sendable, Equatable {

    /// Top inner highlight opacity (0...1).
    public var highlightOpacity: Double

    /// Bottom inner shadow opacity (0...1).
    public var shadowOpacity: Double

    /// Inset distance for inner overlays.
    public var inset: Double

    /// Softness of the inner cues.
    public var blur: Double

    public init(
        highlightOpacity: Double = 0.10,
        shadowOpacity: Double = 0.06,
        inset: Double = 1.0,
        blur: Double = 6.0
    ) {
        self.highlightOpacity = highlightOpacity
        self.shadowOpacity = shadowOpacity
        self.inset = inset
        self.blur = blur
    }
}

