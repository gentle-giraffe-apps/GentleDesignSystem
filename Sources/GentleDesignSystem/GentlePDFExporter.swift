//  Jonathan Ritchey

import UIKit
import SwiftUI

// MARK: - PDF Export Error

public enum GentlePDFExportError: Error, LocalizedError {
    case failedToCreatePDF
    case failedToWriteFile(Error)

    public var errorDescription: String? {
        switch self {
        case .failedToCreatePDF:
            return "Failed to create PDF document"
        case .failedToWriteFile(let error):
            return "Failed to write PDF file: \(error.localizedDescription)"
        }
    }
}

// MARK: - PDF Exporter

public enum GentlePDFExporter {

    // MARK: - Layout Constants

    private static let pageWidth: CGFloat = 620
    private static let margin: CGFloat = 24
    private static var contentWidth: CGFloat { pageWidth - (margin * 2) }

    private static let sectionSpacing: CGFloat = 24
    private static let itemSpacing: CGFloat = 10
    private static let gridGap: CGFloat = 10

    // MARK: - Typography Constants

    private static let sectionTitleFontSize: CGFloat = 18
    private static let labelFontSize: CGFloat = 10
    private static let buttonLabelFontSize: CGFloat = 11

    // MARK: - Public API

    /// Generates PDF data for the given design system spec on a single sheet.
    public static func generatePDFData(for spec: GentleDesignSystemSpec, themeName: String? = nil) throws -> Data {
        // Calculate required height
        let totalHeight = calculateTotalHeight(for: spec)
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: totalHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        let data = renderer.pdfData { context in
            context.beginPage()

            var currentY: CGFloat = margin

            // Draw Typography section
            currentY = drawTypographySection(in: context.cgContext, spec: spec, startY: currentY)
            currentY += sectionSpacing

            // Draw Buttons section
            currentY = drawButtonsSection(in: context.cgContext, spec: spec, startY: currentY)
            currentY += sectionSpacing

            // Draw Surfaces section
            currentY = drawSurfacesSection(in: context.cgContext, spec: spec, startY: currentY)
            currentY += sectionSpacing

            // Draw Colors section
            _ = drawColorsSection(in: context.cgContext, spec: spec, startY: currentY)
        }

        return data
    }

    /// Exports the PDF to a temporary file and returns its URL.
    public static func exportPDFURL(for spec: GentleDesignSystemSpec, themeName: String? = nil) throws -> URL {
        let data = try generatePDFData(for: spec, themeName: themeName)

        let tempDir = FileManager.default.temporaryDirectory
        let timestamp = formattedTimestamp()
        let fileName = "GentleDesignSystem_\(timestamp).pdf"
        let url = tempDir.appendingPathComponent(fileName)

        do {
            try data.write(to: url, options: [.atomic])
            return url
        } catch {
            throw GentlePDFExportError.failedToWriteFile(error)
        }
    }

    // MARK: - Height Calculation

    private static func calculateTotalHeight(for spec: GentleDesignSystemSpec) -> CGFloat {
        var height: CGFloat = margin

        // Typography: 4 columns, tight rows
        let typographyRows = ceil(Double(GentleTextRole.allCases.count) / 4.0)
        height += sectionTitleFontSize + 12 + (CGFloat(typographyRows) * 46) + 14
        height += sectionSpacing

        // Buttons: 3 rows of buttons
        height += sectionTitleFontSize + 12 + 36 + gridGap + 36 + gridGap + 36 + 20
        height += sectionSpacing

        // Surfaces: 3 columns
        let surfaceCount = GentleSurfaceRole.allCases.filter { $0 != .appBackground }.count
        let surfaceRows = ceil(Double(surfaceCount) / 3.0)
        height += sectionTitleFontSize + 12 + (CGFloat(surfaceRows) * 75)
        height += sectionSpacing

        // Colors: 4 columns
        let colorRows = ceil(Double(GentleColorRole.allCases.count) / 4.0)
        height += sectionTitleFontSize + 12 + (CGFloat(colorRows) * 32)
        height += margin

        return height
    }

    // MARK: - Typography Section

    private static func drawTypographySection(in cgContext: CGContext, spec: GentleDesignSystemSpec, startY: CGFloat) -> CGFloat {
        var y = startY

        // Section title
        y = drawSectionTitle("Typography", in: cgContext, at: y)
        y += 12

        // Draw container card
        let roles = GentleTextRole.allCases
        let columns = 4
        let rows = Int(ceil(Double(roles.count) / Double(columns)))
        let cellWidth = (contentWidth - CGFloat(columns - 1) * gridGap - 20) / CGFloat(columns)
        let cellHeight: CGFloat = 44
        let rowGap: CGFloat = 2

        let containerHeight = CGFloat(rows) * cellHeight + CGFloat(rows - 1) * rowGap + 14
        let containerRect = CGRect(x: margin, y: y, width: contentWidth, height: containerHeight)
        drawContainerCard(in: cgContext, rect: containerRect, spec: spec)

        // Draw typography items in grid
        for (index, role) in roles.enumerated() {
            let col = index % columns
            let row = index / columns

            let cellX = margin + 10 + CGFloat(col) * (cellWidth + gridGap)
            let cellY = y + 8 + CGFloat(row) * (cellHeight + rowGap)

            drawTypographyItem(in: cgContext, spec: spec, role: role, at: CGPoint(x: cellX, y: cellY), width: cellWidth)
        }

        return y + containerHeight
    }

    private static func drawTypographyItem(in cgContext: CGContext, spec: GentleDesignSystemSpec, role: GentleTextRole, at point: CGPoint, width: CGFloat) {
        let roleSpec = spec.typography.roleSpec(for: role)

        // Role name (small label)
        let labelFont = UIFont.systemFont(ofSize: 8, weight: .regular)
        let labelColor = colorFromSpec(spec, role: .textSecondary)
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: labelColor
        ]
        let labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
        labelString.draw(at: point)

        // Sample "Aa Bb" in actual font style
        let sampleFont = buildUIFont(from: roleSpec, maxSize: 24)
        let sampleColor = colorFromSpec(spec, role: .textPrimary)
        let sampleAttrs: [NSAttributedString.Key: Any] = [
            .font: sampleFont,
            .foregroundColor: sampleColor
        ]
        let sampleString = NSAttributedString(string: "Aa Bb", attributes: sampleAttrs)
        sampleString.draw(at: CGPoint(x: point.x, y: point.y + labelFont.lineHeight))
    }

    // MARK: - Buttons Section

    private static func drawButtonsSection(in cgContext: CGContext, spec: GentleDesignSystemSpec, startY: CGFloat) -> CGFloat {
        var y = startY

        // Section title
        y = drawSectionTitle("Buttons", in: cgContext, at: y)
        y += 12

        // Container card
        let containerHeight: CGFloat = 32 + gridGap + 32 + gridGap + 32 + 20
        let containerRect = CGRect(x: margin, y: y, width: contentWidth, height: containerHeight)
        drawContainerCard(in: cgContext, rect: containerRect, spec: spec)

        let columns = 4
        let buttonGap: CGFloat = 10
        let containerPadding: CGFloat = 10
        let buttonWidth = (contentWidth - containerPadding * 2 - CGFloat(columns - 1) * buttonGap) / CGFloat(columns)
        let buttonHeight: CGFloat = 28
        let startX = margin + containerPadding

        // Row 1: Primary, Secondary (light/dark variants)
        var rowY = y + 12
        let row1Buttons: [(GentleButtonRole, Bool)] = [
            (.primary, false),
            (.primary, true),
            (.secondary, false),
            (.secondary, true)
        ]

        for (index, (role, isDark)) in row1Buttons.enumerated() {
            let buttonX = startX + CGFloat(index) * (buttonWidth + buttonGap)
            let buttonRect = CGRect(x: buttonX, y: rowY, width: buttonWidth, height: buttonHeight)
            drawButtonPreview(in: cgContext, rect: buttonRect, role: role, spec: spec, isDarkMode: isDark)
        }

        // Row 2: Tertiary, Quaternary (light/dark variants)
        rowY += buttonHeight + gridGap
        let row2Buttons: [(GentleButtonRole, Bool)] = [
            (.tertiary, false),
            (.tertiary, true),
            (.quaternary, false),
            (.quaternary, true)
        ]

        for (index, (role, isDark)) in row2Buttons.enumerated() {
            let buttonX = startX + CGFloat(index) * (buttonWidth + buttonGap)
            let buttonRect = CGRect(x: buttonX, y: rowY, width: buttonWidth, height: buttonHeight)
            drawButtonPreview(in: cgContext, rect: buttonRect, role: role, spec: spec, isDarkMode: isDark)
        }

        // Row 3: Destructive (light/dark)
        rowY += buttonHeight + gridGap
        let destructiveLightRect = CGRect(x: startX, y: rowY, width: buttonWidth, height: buttonHeight)
        drawButtonPreview(in: cgContext, rect: destructiveLightRect, role: .destructive, spec: spec, isDarkMode: false)
        let destructiveDarkRect = CGRect(x: startX + buttonWidth + buttonGap, y: rowY, width: buttonWidth, height: buttonHeight)
        drawButtonPreview(in: cgContext, rect: destructiveDarkRect, role: .destructive, spec: spec, isDarkMode: true)

        return y + containerHeight
    }

    private static func drawButtonPreview(in cgContext: CGContext, rect: CGRect, role: GentleButtonRole, spec: GentleDesignSystemSpec, isDarkMode: Bool) {
        let roleSpec = spec.buttons.roleSpec(for: role)
        let cornerRadius: CGFloat = roleSpec.shape == .pill ? rect.height / 2 : 8
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

        // Get colors
        let primaryCTA = spec.colors.pair(for: .primaryCTA)
        let destructive = spec.colors.pair(for: .destructive)
        let borderSubtle = spec.colors.pair(for: .borderSubtle)

        // Fill
        let fillColor: UIColor
        switch roleSpec.fillRole {
        case .solidFillPrimaryCTA:
            let hex = isDarkMode ? (primaryCTA?.darkHex ?? "#3B82F6") : (primaryCTA?.lightHex ?? "#4A6EF5")
            fillColor = uiColorFromHex(hex)
        case .solidFillDestructive:
            let hex = isDarkMode ? (destructive?.darkHex ?? "#F87171") : (destructive?.lightHex ?? "#E35D5B")
            fillColor = uiColorFromHex(hex)
        case .hollow:
            fillColor = UIColor.clear
        }

        cgContext.setFillColor(fillColor.cgColor)
        cgContext.addPath(path.cgPath)
        cgContext.fillPath()

        // Border
        if roleSpec.borderRole != .hidden {
            let borderColor: UIColor
            switch roleSpec.borderRole {
            case .accent:
                let hex = isDarkMode ? (primaryCTA?.darkHex ?? "#3B82F6") : (primaryCTA?.lightHex ?? "#4A6EF5")
                borderColor = uiColorFromHex(hex)
            case .subtle:
                let hex = isDarkMode ? (borderSubtle?.darkHex ?? "#374151") : (borderSubtle?.lightHex ?? "#E5E7EB")
                borderColor = uiColorFromHex(hex)
            case .hidden:
                borderColor = UIColor.clear
            }

            cgContext.setStrokeColor(borderColor.cgColor)
            cgContext.setLineWidth(1)
            cgContext.addPath(path.cgPath)
            cgContext.strokePath()
        }

        // Button label
        let labelFont = UIFont.systemFont(ofSize: buttonLabelFontSize, weight: .semibold)
        let labelColor: UIColor
        switch roleSpec.fillRole {
        case .solidFillPrimaryCTA, .solidFillDestructive:
            labelColor = UIColor.white
        case .hollow:
            let hex = isDarkMode ? (primaryCTA?.darkHex ?? "#3B82F6") : (primaryCTA?.lightHex ?? "#4A6EF5")
            labelColor = uiColorFromHex(hex)
        }

        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: labelColor
        ]
        let labelText = role.rawValue.capitalized
        let labelString = NSAttributedString(string: labelText, attributes: labelAttrs)
        let labelSize = labelString.size()
        let labelX = rect.midX - labelSize.width / 2
        let labelY = rect.midY - labelSize.height / 2
        labelString.draw(at: CGPoint(x: labelX, y: labelY))
    }

    // MARK: - Surfaces Section

    private static func drawSurfacesSection(in cgContext: CGContext, spec: GentleDesignSystemSpec, startY: CGFloat) -> CGFloat {
        var y = startY

        // Section title
        y = drawSectionTitle("Surfaces", in: cgContext, at: y)
        y += 12

        // Filter out appBackground since it's not really a card-style surface
        let surfaceRoles = GentleSurfaceRole.allCases.filter { $0 != .appBackground }

        let columns = 3
        let rows = Int(ceil(Double(surfaceRoles.count) / Double(columns)))
        let cellWidth = (contentWidth - CGFloat(columns - 1) * gridGap - 20) / CGFloat(columns)
        let cellHeight: CGFloat = 55

        let containerHeight = CGFloat(rows) * (cellHeight + gridGap) - gridGap + 20
        let containerRect = CGRect(x: margin, y: y, width: contentWidth, height: containerHeight)
        drawContainerCard(in: cgContext, rect: containerRect, spec: spec)

        for (index, role) in surfaceRoles.enumerated() {
            let col = index % columns
            let row = index / columns

            let cellX = margin + 10 + CGFloat(col) * (cellWidth + gridGap)
            let cellY = y + 10 + CGFloat(row) * (cellHeight + gridGap)

            drawSurfaceItem(in: cgContext, spec: spec, role: role, rect: CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight))
        }

        return y + containerHeight
    }

    private static func drawSurfaceItem(in cgContext: CGContext, spec: GentleDesignSystemSpec, role: GentleSurfaceRole, rect: CGRect) {
        let roleSpec = spec.surfaces.roleSpec(for: role)

        // Draw the surface preview
        let cornerRadius = min(CGFloat(roleSpec.cornerRadius), 12)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

        // Background
        let fillColor: UIColor
        switch roleSpec.backgroundStyle {
        case .solid(let colorRole):
            fillColor = colorFromSpec(spec, role: colorRole)
        case .material(_, let tintColorRole, _):
            if let tintRole = tintColorRole {
                fillColor = colorFromSpec(spec, role: tintRole).withAlphaComponent(0.15)
            } else {
                fillColor = UIColor(white: 0.96, alpha: 1.0)
            }
        case .glass(_, let fallbackColorRole):
            fillColor = colorFromSpec(spec, role: fallbackColorRole).withAlphaComponent(0.3)
        }

        // Draw shadow if specified
        if roleSpec.shadowRadius > 0 && roleSpec.shadowOpacity > 0 {
            cgContext.saveGState()
            let shadowColor = UIColor.black.withAlphaComponent(CGFloat(roleSpec.shadowOpacity))
            cgContext.setShadow(
                offset: CGSize(width: CGFloat(roleSpec.shadowOffsetX), height: CGFloat(roleSpec.shadowOffsetY)),
                blur: CGFloat(roleSpec.shadowRadius),
                color: shadowColor.cgColor
            )
            cgContext.setFillColor(fillColor.cgColor)
            cgContext.addPath(path.cgPath)
            cgContext.fillPath()
            cgContext.restoreGState()
        } else {
            cgContext.setFillColor(fillColor.cgColor)
            cgContext.addPath(path.cgPath)
            cgContext.fillPath()
        }

        // Border
        if roleSpec.borderWidth > 0 {
            let borderColor = uiColorFromHex(roleSpec.border.lightHex)
            cgContext.setStrokeColor(borderColor.cgColor)
            cgContext.setLineWidth(CGFloat(roleSpec.borderWidth))
            cgContext.addPath(path.cgPath)
            cgContext.strokePath()
        }

        // Role name
        let labelFont = UIFont.systemFont(ofSize: 9, weight: .medium)
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: colorFromSpec(spec, role: .textPrimary)
        ]
        let labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
        labelString.draw(at: CGPoint(x: rect.minX + 8, y: rect.minY + 8))

        // Subtitle based on type
        let subtitle: String
        switch roleSpec.backgroundStyle {
        case .solid:
            subtitle = roleSpec.borderWidth > 0 ? "Subtle border" : "Solid"
        case .material:
            subtitle = "Material blur"
        case .glass:
            subtitle = "Glass effect"
        }

        let subtitleFont = UIFont.systemFont(ofSize: 8, weight: .regular)
        let subtitleAttrs: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: colorFromSpec(spec, role: .textSecondary)
        ]
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttrs)
        subtitleString.draw(at: CGPoint(x: rect.minX + 8, y: rect.minY + 8 + labelFont.lineHeight + 1))
    }

    // MARK: - Colors Section

    private static func drawColorsSection(in cgContext: CGContext, spec: GentleDesignSystemSpec, startY: CGFloat) -> CGFloat {
        var y = startY

        // Section title
        y = drawSectionTitle("Colors", in: cgContext, at: y)
        y += 12

        let roles = GentleColorRole.allCases
        let columns = 4
        let rows = Int(ceil(Double(roles.count) / Double(columns)))
        let cellWidth = (contentWidth - CGFloat(columns - 1) * gridGap - 20) / CGFloat(columns)
        let cellHeight: CGFloat = 24

        let containerHeight = CGFloat(rows) * (cellHeight + 6) + 14
        let containerRect = CGRect(x: margin, y: y, width: contentWidth, height: containerHeight)
        drawContainerCard(in: cgContext, rect: containerRect, spec: spec)

        let swatchSize: CGFloat = 18
        let swatchGap: CGFloat = 2

        for (index, role) in roles.enumerated() {
            let col = index % columns
            let row = index / columns

            let cellX = margin + 10 + CGFloat(col) * (cellWidth + gridGap)
            let cellY = y + 10 + CGFloat(row) * (cellHeight + 6)

            guard let pair = spec.colors.pair(for: role) else { continue }

            // Light mode swatch (left, with top-left and bottom-left corners rounded)
            let lightSwatchRect = CGRect(x: cellX, y: cellY, width: swatchSize, height: swatchSize)
            let lightColor = uiColorFromHex(pair.lightHex)
            let lightPath = UIBezierPath(
                roundedRect: lightSwatchRect,
                byRoundingCorners: [.topLeft, .bottomLeft],
                cornerRadii: CGSize(width: 3, height: 3)
            )
            cgContext.setFillColor(lightColor.cgColor)
            cgContext.addPath(lightPath.cgPath)
            cgContext.fillPath()

            // Border for light swatch
            cgContext.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.3).cgColor)
            cgContext.setLineWidth(0.5)
            cgContext.addPath(lightPath.cgPath)
            cgContext.strokePath()

            // Dark mode swatch (right, with top-right and bottom-right corners rounded)
            let darkSwatchRect = CGRect(x: cellX + swatchSize + swatchGap, y: cellY, width: swatchSize, height: swatchSize)
            let darkColor = uiColorFromHex(pair.darkHex)
            let darkPath = UIBezierPath(
                roundedRect: darkSwatchRect,
                byRoundingCorners: [.topRight, .bottomRight],
                cornerRadii: CGSize(width: 3, height: 3)
            )
            cgContext.setFillColor(darkColor.cgColor)
            cgContext.addPath(darkPath.cgPath)
            cgContext.fillPath()

            // Border for dark swatch
            cgContext.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.3).cgColor)
            cgContext.setLineWidth(0.5)
            cgContext.addPath(darkPath.cgPath)
            cgContext.strokePath()

            // Role name (after both swatches)
            let labelFont = UIFont.systemFont(ofSize: 9, weight: .regular)
            let labelAttrs: [NSAttributedString.Key: Any] = [
                .font: labelFont,
                .foregroundColor: colorFromSpec(spec, role: .textPrimary)
            ]
            let labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
            labelString.draw(at: CGPoint(x: cellX + swatchSize * 2 + swatchGap + 6, y: cellY + 2))
        }

        return y + containerHeight
    }

    // MARK: - Helpers

    private static func drawSectionTitle(_ title: String, in cgContext: CGContext, at y: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: sectionTitleFontSize, weight: .bold)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        let attrString = NSAttributedString(string: title, attributes: attrs)
        attrString.draw(at: CGPoint(x: margin, y: y))

        return y + font.lineHeight
    }

    private static func drawContainerCard(in cgContext: CGContext, rect: CGRect, spec: GentleDesignSystemSpec) {
        let cornerRadius: CGFloat = 12
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

        // Fill with surface color
        let fillColor = colorFromSpec(spec, role: .surfaceBase)
        cgContext.setFillColor(fillColor.cgColor)
        cgContext.addPath(path.cgPath)
        cgContext.fillPath()

        // Border
        let borderColor = colorFromSpec(spec, role: .borderSubtle)
        cgContext.setStrokeColor(borderColor.cgColor)
        cgContext.setLineWidth(1)
        cgContext.addPath(path.cgPath)
        cgContext.strokePath()
    }

    private static func colorFromSpec(_ spec: GentleDesignSystemSpec, role: GentleColorRole) -> UIColor {
        guard let pair = spec.colors.pair(for: role) else {
            return UIColor.black
        }
        return uiColorFromHex(pair.lightHex)
    }

    private static func uiColorFromHex(_ hex: String) -> UIColor {
        let (r, g, b, a) = parseHexToRGBA(hex)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    private static func parseHexToRGBA(_ hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hexString)

        if scanner.scanHexInt64(&hexNumber) {
            switch hexString.count {
            case 6:
                let r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                let g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                let b = CGFloat(hexNumber & 0x0000FF) / 255.0
                return (r, g, b, 1.0)
            case 8:
                let r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255.0
                let g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255.0
                let b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255.0
                let a = CGFloat(hexNumber & 0x000000FF) / 255.0
                return (r, g, b, a)
            default:
                return (0, 0, 0, 1)
            }
        }
        return (0, 0, 0, 1)
    }

    private static func buildUIFont(from spec: GentleTypographyRoleSpec, maxSize: CGFloat? = nil) -> UIFont {
        let size = maxSize.map { min(CGFloat(spec.pointSize), $0) } ?? CGFloat(spec.pointSize)
        var font = UIFont.systemFont(ofSize: size, weight: spec.weight.swiftUIWeight.uiKitWeight)

        // Apply design
        if let designed = font.fontDescriptor.withDesign(spec.design.uiKitDesign) {
            font = UIFont(descriptor: designed, size: size)
        }

        // Apply width if available
        if let width = spec.width {
            let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] ?? [:]
            var newTraits = traits
            newTraits[.width] = width.uiKitWidthTrait
            let widenedDescriptor = font.fontDescriptor.addingAttributes([.traits: newTraits])
            font = UIFont(descriptor: widenedDescriptor, size: size)
        }

        return font
    }

    private static func formattedTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HHmmss"
        return formatter.string(from: Date())
    }
}

// MARK: - UIKit Extensions (internal to this file)

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

private extension Font.Weight {
    var uiKitWeight: UIFont.Weight {
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
