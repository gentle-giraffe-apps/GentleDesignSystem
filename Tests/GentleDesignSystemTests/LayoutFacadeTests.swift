//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - Layout Facade Tests

@Suite("GentleGapScaleFacade Tests")
struct GentleGapScaleFacadeTests {

    @Test("Gap facade provides raw values")
    func testGapFacadeRawValues() {
        let facade = GentleGapScaleFacade(scale: .gentleDefault)

        #expect(facade.xs == 4)
        #expect(facade.s == 8)
        #expect(facade.m == 12)
        #expect(facade.l == 16)
        #expect(facade.xl == 24)
        #expect(facade.xxl == 32)
    }

    @Test("Gap facade provides intent values")
    func testGapFacadeIntentValues() {
        let facade = GentleGapScaleFacade(scale: .gentleDefault)

        #expect(facade.none == 0)
        #expect(facade.micro == 4)  // xs
        #expect(facade.tight == 8)  // s
        #expect(facade.regular == 12)  // m
        #expect(facade.ample == 16)  // l
        #expect(facade.loose == 24)  // xl
        #expect(facade.expansive == 32)  // xxl
    }

    @Test("Gap facade value(token:) works")
    func testGapFacadeValueToken() {
        let facade = GentleGapScaleFacade(scale: .gentleDefault)

        #expect(facade.value(.xs) == 4)
        #expect(facade.value(.m) == 12)
        #expect(facade.value(.xxl) == 32)
    }

    @Test("Gap facade value(intent:) works")
    func testGapFacadeValueIntent() {
        let facade = GentleGapScaleFacade(scale: .gentleDefault)

        #expect(facade.value(.unknown) == 0)
        #expect(facade.value(.regular) == 12)
        #expect(facade.value(.expansive) == 32)
    }
}

@Suite("GentleLayoutFacade Tests")
struct GentleLayoutFacadeTests {

    @Test("Layout facade provides all accessors")
    func testLayoutFacadeAccessors() {
        let facade = GentleLayoutFacade(tokens: .gentleDefault)

        #expect(facade.gap.regular == 12)
        #expect(facade.stack.regular == 12)
        #expect(facade.list.regular == 12)
        #expect(facade.grid.regular == 12)
        #expect(facade.touch.regular == 12)
    }

    @Test("Layout facade inset accessor works")
    func testLayoutFacadeInset() {
        let facade = GentleLayoutFacade(tokens: .gentleDefault)

        let screenInset = facade.inset.axisTokens(for: .screen)
        #expect(screenInset.horizontal == .m)
        #expect(screenInset.vertical == .l)
    }

    @Test("Layout facade stack accessor equals gap")
    func testLayoutFacadeStackEqualsGap() {
        let facade = GentleLayoutFacade(tokens: .gentleDefault)

        #expect(facade.stack.regular == facade.gap.regular)
        #expect(facade.stack.tight == facade.gap.tight)
    }

    @Test("Layout facade list accessor equals gap")
    func testLayoutFacadeListEqualsGap() {
        let facade = GentleLayoutFacade(tokens: .gentleDefault)

        #expect(facade.list.regular == facade.gap.regular)
        #expect(facade.list.ample == facade.gap.ample)
    }
}
