//  Jonathan Ritchey


import SwiftUI

// MARK: - GentleMaterialSurface
// A shader-free, composited material surface built from SwiftUI layers.
// Uses base color + lighting gradient + microtexture + subtle depth cues.

public struct GentleMaterialSurface: View {

    // MARK: Recipe

    public struct Recipe: Sendable {
        public var lighting: Lighting
        public var texture: Texture
        public var depth: Depth

        public init(
            lighting: Lighting,
            texture: Texture,
            depth: Depth
        ) {
            self.lighting = lighting
            self.texture = texture
            self.depth = depth
        }
    }

    // MARK: Lighting

    public struct Lighting: Sendable {
        public enum Style: Sendable {
            case none
            case softTop
            case directional(angle: Angle)
        }

        public var style: Style
        public var intensity: Double // 0...0.25

        public init(style: Style, intensity: Double) {
            self.style = style
            self.intensity = intensity
        }
    }

    // MARK: Texture

    public struct Texture: Sendable {
        public enum Pattern: Sendable {
            case none
            case noise
            case weave
            case brushed
        }

        public var pattern: Pattern
        public var intensity: Double // 0...0.20
        public var scale: Double     // 0.5...3.0

        public init(
            pattern: Pattern,
            intensity: Double,
            scale: Double
        ) {
            self.pattern = pattern
            self.intensity = intensity
            self.scale = scale
        }
    }

    // MARK: Depth

    public struct Depth: Sendable {
        public var innerHighlight: Double     // 0...0.25
        public var ambientOcclusion: Double  // 0...0.25

        public init(
            innerHighlight: Double,
            ambientOcclusion: Double
        ) {
            self.innerHighlight = innerHighlight
            self.ambientOcclusion = ambientOcclusion
        }
    }

    // MARK: Properties

    private let baseColor: Color
    private let cornerRadius: CGFloat
    private let recipe: Recipe

    public init(
        baseColor: Color,
        cornerRadius: CGFloat = 20,
        recipe: Recipe
    ) {
        self.baseColor = baseColor
        self.cornerRadius = cornerRadius
        self.recipe = recipe
    }

    // MARK: Body

    public var body: some View {
        let shape = RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )

        shape
            .fill(baseColor)
            .overlay(lightingLayer.mask(shape))
            .overlay(textureLayer.mask(shape))
            .overlay(depthLayer.mask(shape))
    }

    // MARK: Layers

    @ViewBuilder
    private var lightingLayer: some View {
        switch recipe.lighting.style {
        case .none:
            EmptyView()

        case .softTop:
            LinearGradient(
                colors: [
                    Color.white.opacity(recipe.lighting.intensity),
                    Color.white.opacity(0.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

        case .directional(let angle):
            let (start, end) = unitPoints(for: angle)
            LinearGradient(
                colors: [
                    Color.white.opacity(recipe.lighting.intensity),
                    Color.white.opacity(0.0)
                ],
                startPoint: start,
                endPoint: end
            )
        }
    }

    @ViewBuilder
    private var textureLayer: some View {
        if recipe.texture.pattern != .none,
           recipe.texture.intensity > 0,
           let texture = proceduralTexture(for: recipe.texture.pattern) {
            texture
                .resizable(resizingMode: .tile)
                .scaleEffect(recipe.texture.scale)
                .opacity(recipe.texture.intensity)
                .blendMode(.softLight)
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private var depthLayer: some View {
        ZStack {
            if recipe.depth.ambientOcclusion > 0 {
                RadialGradient(
                    colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(recipe.depth.ambientOcclusion)
                    ],
                    center: .center,
                    startRadius: 32,
                    endRadius: 260
                )
                .blendMode(.multiply)
            }

            if recipe.depth.innerHighlight > 0 {
                RadialGradient(
                    colors: [
                        Color.white.opacity(recipe.depth.innerHighlight),
                        Color.white.opacity(0.0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 240
                )
                .blendMode(.overlay)
            }
        }
    }

    // MARK: Helpers

    private func proceduralTexture(
        for pattern: Texture.Pattern
    ) -> Image? {
        switch pattern {
        case .none:
            return nil
        case .noise:
            return ProceduralTexture.noise
        case .weave:
            return ProceduralTexture.weave
        case .brushed:
            return ProceduralTexture.brushed
        }
    }

    private func unitPoints(
        for angle: Angle
    ) -> (UnitPoint, UnitPoint) {
        let radians = angle.radians
        let dx = cos(radians)
        let dy = sin(radians)

        let start = UnitPoint(
            x: 0.5 - dx * 0.5,
            y: 0.5 - dy * 0.5
        )
        let end = UnitPoint(
            x: 0.5 + dx * 0.5,
            y: 0.5 + dy * 0.5
        )

        return (start, end)
    }
}

// MARK: - Procedural Textures

enum ProceduralTexture {

    // MARK: Cached Textures (generated once)

    static let noise: Image = generateNoise()
    static let weave: Image = generateWeave()
    static let brushed: Image = generateBrushed()

    // MARK: Noise (128×128)

    private static func generateNoise() -> Image {
        let size = 128
        let edgeFade = 16

        var randomValues = [[UInt8]](
            repeating: [UInt8](repeating: 0, count: size),
            count: size
        )
        for y in 0..<size {
            for x in 0..<size {
                // High contrast: push toward extremes (0 or 255)
                let raw = Double.random(in: 0...1)
                let contrasted = pow(raw - 0.5, 3) * 4 + 0.5 // S-curve for contrast
                randomValues[y][x] = UInt8(clamping: Int(contrasted * 255))
            }
        }

        var pixels = [UInt8](repeating: 0, count: size * size * 4)

        for y in 0..<size {
            for x in 0..<size {
                var value = Double(randomValues[y][x])

                // Blend X edges for seamless horizontal tiling
                if x < edgeFade {
                    let blend = Double(x) / Double(edgeFade)
                    let oppositeX = size - edgeFade + x
                    value = value * blend + Double(randomValues[y][oppositeX]) * (1 - blend)
                } else if x >= size - edgeFade {
                    let blend = Double(size - 1 - x) / Double(edgeFade)
                    let oppositeX = x - (size - edgeFade)
                    value = value * blend + Double(randomValues[y][oppositeX]) * (1 - blend)
                }

                // Blend Y edges for seamless vertical tiling
                if y < edgeFade {
                    let blend = Double(y) / Double(edgeFade)
                    let oppositeY = size - edgeFade + y
                    value = value * blend + Double(randomValues[oppositeY][x]) * (1 - blend)
                } else if y >= size - edgeFade {
                    let blend = Double(size - 1 - y) / Double(edgeFade)
                    let oppositeY = y - (size - edgeFade)
                    value = value * blend + Double(randomValues[oppositeY][x]) * (1 - blend)
                }

                let gray = UInt8(clamping: Int(value))
                let index = (y * size + x) * 4
                pixels[index] = gray
                pixels[index + 1] = gray
                pixels[index + 2] = gray
                pixels[index + 3] = 255
            }
        }

        return imageFromPixels(pixels, size: size)
    }

    // MARK: Weave (64×64)
    //
    // Creates a soft linen-like weave pattern using overlapping sine waves
    // with noise jitter. This reads as "organic threads" rather than a
    // hard-edged checker/grid pattern.
    //
    // The pattern uses:
    // - Horizontal and vertical sine wave "threads" with varying intensity
    // - Random jitter to break up regularity
    // - Soft transitions between over/under crossings
    // - Lower contrast than a literal weave for subtlety

    private static func generateWeave() -> Image {
        let size = 64
        let threadSpacing: Double = 6.0  // Distance between thread centers
        let threadSoftness: Double = 2.5 // Controls falloff width

        var pixels = [UInt8](repeating: 0, count: size * size * 4)

        for y in 0..<size {
            for x in 0..<size {
                let fx = Double(x)
                let fy = Double(y)

                // Horizontal threads: sine-based intensity with slight y-jitter
                let hPhase = (fy + sin(fx * 0.3) * 1.5) / threadSpacing
                let hThread = pow(abs(sin(hPhase * .pi)), threadSoftness)

                // Vertical threads: sine-based intensity with slight x-jitter
                let vPhase = (fx + sin(fy * 0.25) * 1.2) / threadSpacing
                let vThread = pow(abs(sin(vPhase * .pi)), threadSoftness)

                // Over/under pattern: alternate which thread is "on top"
                let cellX = Int(fx / threadSpacing)
                let cellY = Int(fy / threadSpacing)
                let horizontalOnTop = (cellX + cellY) % 2 == 0

                // Combine threads with over/under priority
                var value: Double
                if horizontalOnTop {
                    value = 128 + (hThread * 50) - (vThread * 40)
                } else {
                    value = 128 - (hThread * 40) + (vThread * 50)
                }

                // Add subtle noise for organic feel
                value += Double.random(in: -8...8)

                let gray = UInt8(clamping: Int(value))
                let index = (y * size + x) * 4
                pixels[index] = gray
                pixels[index + 1] = gray
                pixels[index + 2] = gray
                pixels[index + 3] = 255
            }
        }

        return imageFromPixels(pixels, size: size)
    }

    // MARK: Brushed (128×128)

    private static func generateBrushed() -> Image {
        let size = 128
        let edgeFade = 12

        // High contrast: 128 ± 90 = range of 38-218 instead of 93-163
        var lineIntensities = [Double](repeating: 128, count: size)
        for y in 0..<size {
            lineIntensities[y] = 128 + Double.random(in: -90...90)
        }

        // Blend vertical edges for seamless tiling
        for y in 0..<edgeFade {
            let blend = Double(y) / Double(edgeFade)
            let oppositeY = size - edgeFade + y
            lineIntensities[y] = lineIntensities[y] * blend + lineIntensities[oppositeY] * (1 - blend)
        }
        for y in (size - edgeFade)..<size {
            let blend = Double(size - 1 - y) / Double(edgeFade)
            let oppositeY = y - (size - edgeFade)
            lineIntensities[y] = lineIntensities[y] * blend + lineIntensities[oppositeY] * (1 - blend)
        }

        var pixels = [UInt8](repeating: 0, count: size * size * 4)

        for y in 0..<size {
            for x in 0..<size {
                // Add per-pixel variation along each line
                let value = lineIntensities[y] + Double.random(in: -15...15)
                let gray = UInt8(clamping: Int(value))

                let index = (y * size + x) * 4
                pixels[index] = gray
                pixels[index + 1] = gray
                pixels[index + 2] = gray
                pixels[index + 3] = 255
            }
        }

        return imageFromPixels(pixels, size: size)
    }

    // MARK: Helper

    private static func imageFromPixels(_ pixels: [UInt8], size: Int) -> Image {
        let data = Data(pixels)
        let provider = CGDataProvider(data: data as CFData)!

        let cgImage = CGImage(
            width: size,
            height: size,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: size * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )!

        return Image(decorative: cgImage, scale: 1.0, orientation: .up)
    }
}

// MARK: - Material Presets
//
// DESIGN PRINCIPLE: "Perceptual Material" vs "Literal Pattern"
// ─────────────────────────────────────────────────────────────
// These presets aim for a *perceptual* feel of the material, NOT a literal
// representation. For example:
//
// • Cloth should feel "soft, organic, fiber-like" via coarse noise grain,
//   NOT show a visible woven grid. A literal weave pattern competes with
//   UI content and reads as "patterned fabric" rather than "cloth surface."
//
// • Silk should feel "smooth with subtle shimmer" via lighting gradients,
//   with only the faintest fine noise to avoid looking like flat plastic.
//
// • Plastic should feel "clean, uniform, manufactured" via very fine noise
//   at near-invisible intensity—just enough to avoid dead-flat digital feel.
//
// • Aluminum should feel "precise, directional, machined" via brushed lines.
//
// The `.weave` pattern is kept for diagnostic/debug purposes and as an
// optional "linen/fabric" variant, but is NOT the default for cloth.

public extension GentleMaterialSurface.Recipe {

    // MARK: - Cloth (soft, human, organic)
    // Uses NOISE (not weave) at larger scale for coarse fiber feel

    /// Soft, human, forgiving — perceptual cloth via coarse noise grain
    static let cloth = Self(
        lighting: .init(
            style: .softTop,
            intensity: 0.08
        ),
        texture: .init(
            pattern: .noise,        // Noise for organic micro-variation
            intensity: 0.08,        // Subtle but present
            scale: 1.8              // Larger scale = coarse fiber feel
        ),
        depth: .init(
            innerHighlight: 0.04,
            ambientOcclusion: 0.08
        )
    )

    // MARK: - Plastic (clean, manufactured, uniform)
    // Uses very fine noise at minimal intensity

    /// Clean, consumer-tech, neutral — smooth with imperceptible grain
    static let plastic = Self(
        lighting: .init(
            style: .softTop,
            intensity: 0.12
        ),
        texture: .init(
            pattern: .noise,
            intensity: 0.03,        // Very low — just breaks up flatness
            scale: 0.8              // Smaller scale = fine uniform grain
        ),
        depth: .init(
            innerHighlight: 0.08,
            ambientOcclusion: 0.05
        )
    )

    // MARK: - Silk (warm, premium, shimmer)
    // Lighting-driven with finest noise at lowest intensity

    /// Warm, premium, subtle shimmer — lighting gradient with whisper of grain
    static let silk = Self(
        lighting: .init(
            style: .directional(angle: .degrees(-35)),
            intensity: 0.14
        ),
        texture: .init(
            pattern: .noise,
            intensity: 0.04,        // Barely visible
            scale: 0.6              // Finest scale = smooth silk feel
        ),
        depth: .init(
            innerHighlight: 0.10,
            ambientOcclusion: 0.04
        )
    )

    // MARK: - Aluminum (precise, engineered, directional)
    // Uses brushed texture for machined metal feel

    /// Precise, engineered, cool — directional brushed grain
    static let aluminum = Self(
        lighting: .init(
            style: .directional(angle: .degrees(15)),
            intensity: 0.16
        ),
        texture: .init(
            pattern: .brushed,
            intensity: 0.07,
            scale: 1.0
        ),
        depth: .init(
            innerHighlight: 0.05,
            ambientOcclusion: 0.06
        )
    )

    // MARK: - Linen (optional fabric variant with actual weave)
    // This is the "literal weave" option for when you want visible fabric texture

    /// Visible woven fabric pattern — use sparingly, competes with UI content
    static let linen = Self(
        lighting: .init(
            style: .softTop,
            intensity: 0.06
        ),
        texture: .init(
            pattern: .weave,
            intensity: 0.12,
            scale: 1.0
        ),
        depth: .init(
            innerHighlight: 0.03,
            ambientOcclusion: 0.06
        )
    )
}

// MARK: - Previews

#Preview("Material Collection") {
    ScrollView {
        VStack(spacing: 24) {
            // Cloth variants
            Text("Cloth")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                MaterialCard(color: Color(red: 0.96, green: 0.94, blue: 0.92), recipe: .cloth, label: "Linen")
                MaterialCard(color: Color(red: 0.92, green: 0.94, blue: 0.96), recipe: .cloth, label: "Denim")
                MaterialCard(color: Color(red: 0.94, green: 0.92, blue: 0.95), recipe: .cloth, label: "Velvet")
            }

            // Plastic variants
            Text("Plastic")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                MaterialCard(color: Color(red: 0.98, green: 0.98, blue: 0.98), recipe: .plastic, label: "White")
                MaterialCard(color: Color(red: 0.2, green: 0.2, blue: 0.22), recipe: .plastic, label: "Charcoal")
                MaterialCard(color: Color(red: 0.95, green: 0.85, blue: 0.75), recipe: .plastic, label: "Sand")
            }

            // Silk variants
            Text("Silk")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                MaterialCard(color: Color(red: 0.98, green: 0.95, blue: 0.90), recipe: .silk, label: "Cream")
                MaterialCard(color: Color(red: 0.85, green: 0.75, blue: 0.80), recipe: .silk, label: "Rose")
                MaterialCard(color: Color(red: 0.70, green: 0.78, blue: 0.85), recipe: .silk, label: "Sky")
            }

            // Aluminum variants
            Text("Aluminum")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                MaterialCard(color: Color(red: 0.88, green: 0.89, blue: 0.90), recipe: .aluminum, label: "Silver")
                MaterialCard(color: Color(red: 0.25, green: 0.27, blue: 0.30), recipe: .aluminum, label: "Space Gray")
                MaterialCard(color: Color(red: 0.95, green: 0.90, blue: 0.82), recipe: .aluminum, label: "Gold")
            }
        }
        .padding(20)
    }
    .background(Color(white: 0.12))
}

#Preview("Raw Textures") {
    VStack(spacing: 20) {
        Text("Procedural Textures (Raw)")
            .font(.headline)

        HStack(spacing: 16) {
            VStack {
                ProceduralTexture.noise
                    .resizable(resizingMode: .tile)
                    .frame(width: 120, height: 120)
                    .border(Color.gray)
                Text("Noise 128×128").font(.caption)
            }

            VStack {
                ProceduralTexture.weave
                    .resizable(resizingMode: .tile)
                    .frame(width: 120, height: 120)
                    .border(Color.gray)
                Text("Weave 64×64").font(.caption)
            }

            VStack {
                ProceduralTexture.brushed
                    .resizable(resizingMode: .tile)
                    .frame(width: 120, height: 120)
                    .border(Color.gray)
                Text("Brushed 128×128").font(.caption)
            }
        }
    }
    .padding(24)
    .background(Color.white)
}

#Preview("Textures DEBUG (High Intensity)") {
    let debugRecipes: [(String, GentleMaterialSurface.Recipe)] = [
        ("Noise 50%", .init(
            lighting: .init(style: .none, intensity: 0),
            texture: .init(pattern: .noise, intensity: 0.5, scale: 1.0),
            depth: .init(innerHighlight: 0, ambientOcclusion: 0)
        )),
        ("Weave 50%", .init(
            lighting: .init(style: .none, intensity: 0),
            texture: .init(pattern: .weave, intensity: 0.5, scale: 1.0),
            depth: .init(innerHighlight: 0, ambientOcclusion: 0)
        )),
        ("Brushed 50%", .init(
            lighting: .init(style: .none, intensity: 0),
            texture: .init(pattern: .brushed, intensity: 0.5, scale: 1.0),
            depth: .init(innerHighlight: 0, ambientOcclusion: 0)
        )),
    ]

    VStack(spacing: 16) {
        Text("Textures at 50% (no lighting/depth)")
            .font(.headline)

        HStack(spacing: 12) {
            ForEach(debugRecipes, id: \.0) { name, recipe in
                VStack {
                    GentleMaterialSurface(
                        baseColor: Color(white: 0.85),
                        cornerRadius: 12,
                        recipe: recipe
                    )
                    .frame(width: 110, height: 110)
                    Text(name).font(.caption2)
                }
            }
        }
    }
    .padding(20)
    .background(Color(white: 0.95))
}

// MARK: - Preview Helpers

private struct MaterialCard: View {
    let color: Color
    let recipe: GentleMaterialSurface.Recipe
    let label: String

    var body: some View {
        GentleMaterialSurface(
            baseColor: color,
            cornerRadius: 16,
            recipe: recipe
        )
        .frame(height: 100)
        .overlay(alignment: .bottomLeading) {
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(color.isDark ? .white : .black)
                .padding(12)
        }
    }
}

private extension Color {
    var isDark: Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        #if canImport(UIKit)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: nil)
        #elseif canImport(AppKit)
        NSColor(self).usingColorSpace(.deviceRGB)?.getRed(&r, green: &g, blue: &b, alpha: nil)
        #endif
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance < 0.5
    }
}
