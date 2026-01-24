//  Jonathan Ritchey
import Testing
import SwiftUI
@testable import GentleDesignSystem

// MARK: - Font Token Tests

@Suite("GentleFontDesignToken Tests")
struct GentleFontDesignTokenTests {

    @Test("Font design tokens map to SwiftUI correctly")
    func testFontDesignMapping() {
        #expect(GentleFontDesignToken.default.swiftUIDesign == .default)
        #expect(GentleFontDesignToken.serif.swiftUIDesign == .serif)
        #expect(GentleFontDesignToken.rounded.swiftUIDesign == .rounded)
        #expect(GentleFontDesignToken.monospaced.swiftUIDesign == .monospaced)
    }

    @Test("All font design tokens are case iterable")
    func testFontDesignCaseIterable() {
        #expect(GentleFontDesignToken.allCases.count == 4)
    }

    @Test("All font design tokens have SwiftUI mappings")
    func testAllFontDesignTokensHaveSwiftUIMappings() {
        for token in GentleFontDesignToken.allCases {
            // Should not crash
            _ = token.swiftUIDesign
        }
    }
}

@Suite("GentleFontWidthToken Tests")
struct GentleFontWidthTokenTests {

    @Test("Font width tokens have display names")
    func testFontWidthDisplayNames() {
        #expect(GentleFontWidthToken.compressed.displayName == "Compressed")
        #expect(GentleFontWidthToken.condensed.displayName == "Condensed")
        #expect(GentleFontWidthToken.standard.displayName == "Standard")
        #expect(GentleFontWidthToken.expanded.displayName == "Expanded")
    }

    @Test("All font width tokens are case iterable")
    func testFontWidthCaseIterable() {
        #expect(GentleFontWidthToken.allCases.count == 4)
    }

    @Test("Font width tokens map to SwiftUI width")
    @available(iOS 17.0, *)
    func testFontWidthSwiftUIMapping() {
        #expect(GentleFontWidthToken.compressed.swiftUIWidth == .compressed)
        #expect(GentleFontWidthToken.condensed.swiftUIWidth == .condensed)
        #expect(GentleFontWidthToken.standard.swiftUIWidth == .standard)
        #expect(GentleFontWidthToken.expanded.swiftUIWidth == .expanded)
    }
}

@Suite("GentleFontWeightToken Tests")
struct GentleFontWeightTokenTests {

    @Test("Font weight tokens map to SwiftUI correctly")
    func testFontWeightMapping() {
        #expect(GentleFontWeightToken.ultraLight.swiftUIWeight == .ultraLight)
        #expect(GentleFontWeightToken.thin.swiftUIWeight == .thin)
        #expect(GentleFontWeightToken.light.swiftUIWeight == .light)
        #expect(GentleFontWeightToken.regular.swiftUIWeight == .regular)
        #expect(GentleFontWeightToken.medium.swiftUIWeight == .medium)
        #expect(GentleFontWeightToken.semibold.swiftUIWeight == .semibold)
        #expect(GentleFontWeightToken.bold.swiftUIWeight == .bold)
        #expect(GentleFontWeightToken.heavy.swiftUIWeight == .heavy)
        #expect(GentleFontWeightToken.black.swiftUIWeight == .black)
    }

    @Test("Font weight tokens have display names")
    func testFontWeightDisplayNames() {
        #expect(GentleFontWeightToken.ultraLight.displayName == "Ultra Light")
        #expect(GentleFontWeightToken.semibold.displayName == "Semibold")
    }

    @Test("All font weight tokens are case iterable")
    func testFontWeightCaseIterable() {
        #expect(GentleFontWeightToken.allCases.count == 9)
    }
}
