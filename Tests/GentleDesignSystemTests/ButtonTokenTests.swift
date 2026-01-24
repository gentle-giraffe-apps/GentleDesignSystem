//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - Button Token Tests

@Suite("GentleButtonAnimationSpec Tests")
struct GentleButtonAnimationSpecTests {

    @Test("Button animation spec has correct defaults")
    func testButtonAnimationSpecDefaults() {
        let spec = GentleButtonAnimationSpec()

        #expect(spec.pressedScale == 0.97)
        #expect(spec.pressedOpacity == 0.92)
        #expect(spec.duration == 0.12)
        #expect(spec.springResponse == 0.22)
        #expect(spec.springDamping == 0.85)
        #expect(spec.springBlend == 0.0)
    }

    @Test("Button animation spec custom values")
    func testButtonAnimationSpecCustomValues() {
        let spec = GentleButtonAnimationSpec(
            pressedScale: 0.95,
            pressedOpacity: 0.8,
            duration: 0.2,
            springResponse: 0.3,
            springDamping: 0.7,
            springBlend: 0.1
        )

        #expect(spec.pressedScale == 0.95)
        #expect(spec.pressedOpacity == 0.8)
        #expect(spec.duration == 0.2)
        #expect(spec.springResponse == 0.3)
        #expect(spec.springDamping == 0.7)
        #expect(spec.springBlend == 0.1)
    }

    @Test("Button animation spec is codable")
    func testButtonAnimationSpecCodable() throws {
        let original = GentleButtonAnimationSpec(
            pressedScale: 0.8,
            pressedOpacity: 0.7,
            duration: 0.2,
            springResponse: 0.3,
            springDamping: 0.6,
            springBlend: 0.1
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleButtonAnimationSpec.self, from: data)

        #expect(decoded.pressedScale == 0.8)
        #expect(decoded.pressedOpacity == 0.7)
        #expect(decoded.duration == 0.2)
        #expect(decoded.springResponse == 0.3)
        #expect(decoded.springDamping == 0.6)
        #expect(decoded.springBlend == 0.1)
    }
}

@Suite("GentleButtonRoleSpec Tests")
struct GentleButtonRoleSpecTests {

    @Test("Button role spec stores all properties")
    func testButtonRoleSpecProperties() {
        let spec = GentleButtonRoleSpec(
            shape: .pill,
            materialRole: .solidFillPrimaryCTA,
            borderRole: .subtle,
            animationRole: .bouncy,
            pressedScale: 0.95,
            pressedOpacity: 0.85
        )

        #expect(spec.shape == .pill)
        #expect(spec.materialRole == .solidFillPrimaryCTA)
        #expect(spec.borderRole == .subtle)
        #expect(spec.animationRole == .bouncy)
        #expect(spec.pressedScale == 0.95)
        #expect(spec.pressedOpacity == 0.85)
    }

    @Test("Button role spec is codable")
    func testButtonRoleSpecCodable() throws {
        let original = GentleButtonRoleSpec(
            shape: .pill,
            materialRole: .solidFillPrimaryCTA,
            borderRole: .subtle,
            animationRole: .bouncy,
            pressedScale: 0.9,
            pressedOpacity: 0.8
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(GentleButtonRoleSpec.self, from: data)

        #expect(decoded.shape == .pill)
        #expect(decoded.materialRole == .solidFillPrimaryCTA)
        #expect(decoded.borderRole == .subtle)
        #expect(decoded.animationRole == .bouncy)
        #expect(decoded.pressedScale == 0.9)
        #expect(decoded.pressedOpacity == 0.8)
    }

    @Test("Button role spec default values")
    func testButtonRoleSpecDefaults() {
        let spec = GentleButtonRoleSpec(
            materialRole: .hollow
        )

        #expect(spec.shape == .rounded)
        #expect(spec.borderRole == .hidden)
        #expect(spec.animationRole == .squish)
        #expect(spec.pressedScale == 0.97)
        #expect(spec.pressedOpacity == 0.9)
    }
}

@Suite("GentleButtonTokens Tests")
struct GentleButtonTokensTests {

    @Test("Default button tokens contain all roles")
    func testDefaultButtonTokensContainAllRoles() {
        let tokens = GentleButtonTokens.gentleDefault

        let primary = tokens.roleSpec(for: .primary)
        #expect(primary.materialRole == .solidFillPrimaryCTA)

        let secondary = tokens.roleSpec(for: .secondary)
        #expect(secondary.borderRole == .accent)

        let tertiary = tokens.roleSpec(for: .tertiary)
        #expect(tertiary.materialRole == .hollow)

        let destructive = tokens.roleSpec(for: .destructive)
        #expect(destructive.materialRole == .solidFillDestructive)
    }

    @Test("Button tokens fallback to primary for missing role")
    func testButtonTokensFallback() {
        let primarySpec = GentleButtonRoleSpec(
            materialRole: .solidFillPrimaryCTA
        )

        let tokens = GentleButtonTokens(
            roles: [GentleButtonRole.primary.rawValue: primarySpec],
            animations: [:]
        )

        let spec = tokens.roleSpec(for: .destructive)
        #expect(spec.materialRole == .solidFillPrimaryCTA)
    }

    @Test("Default button tokens contain animation specs")
    func testDefaultButtonTokensContainAnimationSpecs() {
        let tokens = GentleButtonTokens.gentleDefault

        for role in GentleButtonAnimationRole.allCases {
            let spec = tokens.animationSpec(for: role)
            #expect(spec.pressedScale > 0)
        }
    }

    @Test("Button tokens hardcoded fallback when empty")
    func testButtonTokensHardcodedFallback() {
        let tokens = GentleButtonTokens(roles: [:], animations: [:])

        let spec = tokens.roleSpec(for: .primary)

        // Should return hardcoded defaults
        #expect(spec.shape == .rounded)
        #expect(spec.materialRole == .solidFillPrimaryCTA)
    }

    @Test("Animation spec fallback for missing role")
    func testAnimationSpecFallback() {
        let tokens = GentleButtonTokens(roles: [:], animations: [:])

        let spec = tokens.animationSpec(for: .bouncy)

        // Should return default spec
        #expect(spec.pressedScale == 0.97)
    }
}

@Suite("GentleButtonTokens Animation Tests")
struct GentleButtonTokensAnimationTests {

    @Test("All default animation roles have specs")
    func testAllDefaultAnimationRolesHaveSpecs() {
        let tokens = GentleButtonTokens.gentleDefault

        for role in GentleButtonAnimationRole.allCases {
            let spec = tokens.animationSpec(for: role)
            // All should have valid specs
            #expect(spec.pressedScale >= 0 && spec.pressedScale <= 1.5)
        }
    }

    @Test("Animation spec fallback to squish")
    func testAnimationSpecFallbackToSquish() {
        let squishSpec = GentleButtonAnimationSpec(
            pressedScale: 0.5,
            pressedOpacity: 0.5
        )

        let tokens = GentleButtonTokens(
            roles: [:],
            animations: [GentleButtonAnimationRole.squish.rawValue: squishSpec]
        )

        // Unknown role should fallback to squish
        let spec = tokens.animationSpec(for: .unknown)
        #expect(spec.pressedScale == 0.5)
    }
}

@Suite("GentleButtonAnimations Tests")
@MainActor
struct GentleButtonAnimationsTests {

    @Test("Resolve returns nil when reduce motion is true")
    func testResolveWithReduceMotion() {
        let spec = GentleButtonAnimationSpec()
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: true,
            role: .squish,
            spec: spec
        )
        #expect(animation == nil)
    }

    @Test("Resolve returns nil for unknown role")
    func testResolveUnknownRole() {
        let spec = GentleButtonAnimationSpec()
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: false,
            role: .unknown,
            spec: spec
        )
        #expect(animation == nil)
    }

    @Test("Resolve returns easeOut for subtlePress")
    func testResolveSubtlePress() {
        let spec = GentleButtonAnimationSpec(duration: 0.15)
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: false,
            role: .subtlePress,
            spec: spec
        )
        #expect(animation != nil)
    }

    @Test("Resolve returns spring for squish")
    func testResolveSquish() {
        let spec = GentleButtonAnimationSpec(
            springResponse: 0.22,
            springDamping: 0.85,
            springBlend: 0.0
        )
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: false,
            role: .squish,
            spec: spec
        )
        #expect(animation != nil)
    }

    @Test("Resolve returns spring for pop")
    func testResolvePop() {
        let spec = GentleButtonAnimationSpec(
            springResponse: 0.18,
            springDamping: 0.78,
            springBlend: 0.0
        )
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: false,
            role: .pop,
            spec: spec
        )
        #expect(animation != nil)
    }

    @Test("Resolve returns spring for bouncy")
    func testResolveBouncy() {
        let spec = GentleButtonAnimationSpec(
            springResponse: 0.28,
            springDamping: 0.70,
            springBlend: 0.0
        )
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: false,
            role: .bouncy,
            spec: spec
        )
        #expect(animation != nil)
    }

    @Test("Resolve returns spring for springBack")
    func testResolveSpringBack() {
        let spec = GentleButtonAnimationSpec(
            springResponse: 0.45,
            springDamping: 0.45,
            springBlend: 0.0
        )
        let animation = GentleButtonAnimations.resolve(
            reduceMotion: false,
            role: .springBack,
            spec: spec
        )
        #expect(animation != nil)
    }

    @Test("All animation roles can be resolved")
    func testAllAnimationRolesResolve() {
        let spec = GentleButtonAnimationSpec()

        for role in GentleButtonAnimationRole.allCases {
            // Should not crash
            _ = GentleButtonAnimations.resolve(
                reduceMotion: false,
                role: role,
                spec: spec
            )
        }
    }
}
