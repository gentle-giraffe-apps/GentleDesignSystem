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

public struct GentlePDFExporter {

    // MARK: - Page Constants

    private static let pageWidth: CGFloat = 612   // Letter width in points
    private static let pageHeight: CGFloat = 792  // Letter height in points
    private static let margin: CGFloat = 54       // 0.75 inch margins

    private static var contentWidth: CGFloat { pageWidth - (margin * 2) }
    private static var contentHeight: CGFloat { pageHeight - (margin * 2) }

    // MARK: - Typography Constants

    private static let titleFontSize: CGFloat = 24
    private static let sectionTitleFontSize: CGFloat = 18
    private static let subsectionTitleFontSize: CGFloat = 14
    private static let bodyFontSize: CGFloat = 11
    private static let captionFontSize: CGFloat = 9

    private static let sectionSpacing: CGFloat = 32
    private static let itemSpacing: CGFloat = 16
    private static let lineSpacing: CGFloat = 6

    // MARK: - Public API

    /// Generates PDF data for the given design system spec.
    public static func generatePDFData(for spec: GentleDesignSystemSpec, themeName: String? = nil) throws -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        let data = renderer.pdfData { context in
            var currentY: CGFloat = margin

            // Start first page
            context.beginPage()

            // Draw header
            currentY = drawHeader(in: context.cgContext, spec: spec, themeName: themeName, startY: currentY)
            currentY += sectionSpacing

            // Draw Colors section
            currentY = drawColorsSection(in: context.cgContext, spec: spec, startY: currentY, context: context)
            currentY += sectionSpacing

            // Check if we need a new page for Typography
            if currentY > pageHeight - margin - 200 {
                context.beginPage()
                currentY = margin
            }

            // Draw Typography section
            currentY = drawTypographySection(in: context.cgContext, spec: spec, startY: currentY, context: context)
            currentY += sectionSpacing

            // Check if we need a new page for Buttons
            if currentY > pageHeight - margin - 200 {
                context.beginPage()
                currentY = margin
            }

            // Draw Buttons section
            currentY = drawButtonsSection(in: context.cgContext, spec: spec, startY: currentY, context: context)
            currentY += sectionSpacing

            // Check if we need a new page for Surfaces
            if currentY > pageHeight - margin - 200 {
                context.beginPage()
                currentY = margin
            }

            // Draw Surfaces section
            _ = drawSurfacesSection(in: context.cgContext, spec: spec, startY: currentY, context: context)
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

    // MARK: - Header

    private static func drawHeader(in cgContext: CGContext, spec: GentleDesignSystemSpec, themeName: String?, startY: CGFloat) -> CGFloat {
        var y = startY

        // Theme name or "Design System Specification"
        let title = themeName ?? "Design System Specification"
        let titleFont = UIFont.systemFont(ofSize: titleFontSize, weight: .bold)
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: title, attributes: titleAttrs)
        titleString.draw(at: CGPoint(x: margin, y: y))
        y += titleFont.lineHeight + lineSpacing

        // Date and version
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let dateString = dateFormatter.string(from: Date())

        let subtitleFont = UIFont.systemFont(ofSize: bodyFontSize, weight: .regular)
        let subtitleAttrs: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.darkGray
        ]
        let subtitleString = NSAttributedString(
            string: "Generated: \(dateString)  •  Spec Version: \(spec.specVersion)",
            attributes: subtitleAttrs
        )
        subtitleString.draw(at: CGPoint(x: margin, y: y))
        y += subtitleFont.lineHeight + lineSpacing

        // Horizontal rule
        y += 8
        cgContext.setStrokeColor(UIColor.lightGray.cgColor)
        cgContext.setLineWidth(0.5)
        cgContext.move(to: CGPoint(x: margin, y: y))
        cgContext.addLine(to: CGPoint(x: pageWidth - margin, y: y))
        cgContext.strokePath()
        y += 8

        return y
    }

    // MARK: - Colors Section

    private static func drawColorsSection(in cgContext: CGContext, spec: GentleDesignSystemSpec, startY: CGFloat, context: UIGraphicsPDFRendererContext) -> CGFloat {
        var y = startY

        // Section title
        y = drawSectionTitle("Colors", in: cgContext, at: y)
        y += itemSpacing

        // Group colors by category
        let colorGroups: [(title: String, roles: [GentleColorRole])] = [
            ("Text", GentleColorRole.textRoles),
            ("Surface", GentleColorRole.surfaceRoles),
            ("Action", GentleColorRole.actionRoles),
            ("Theme", GentleColorRole.themeRoles)
        ]

        let swatchSize: CGFloat = 24
        let columnWidth: CGFloat = contentWidth / 2
        var columnIndex = 0
        var rowY = y
        var maxRowY = y

        for group in colorGroups {
            // Check if we need a new page
            if rowY > pageHeight - margin - 100 {
                context.beginPage()
                rowY = margin
                maxRowY = margin
                columnIndex = 0
            }

            // Draw group title
            let groupX = margin + CGFloat(columnIndex) * columnWidth
            let groupTitleFont = UIFont.systemFont(ofSize: subsectionTitleFontSize, weight: .semibold)
            let groupTitleAttrs: [NSAttributedString.Key: Any] = [
                .font: groupTitleFont,
                .foregroundColor: UIColor.black
            ]
            let groupTitleString = NSAttributedString(string: group.title, attributes: groupTitleAttrs)
            groupTitleString.draw(at: CGPoint(x: groupX, y: rowY))
            var groupY = rowY + groupTitleFont.lineHeight + 8

            // Draw each color role
            for role in group.roles {
                guard let pair = spec.colors.pair(for: role) else { continue }

                // Check if we need a new page
                if groupY > pageHeight - margin - 40 {
                    context.beginPage()
                    groupY = margin
                }

                let itemX = groupX

                // Color swatch (light mode)
                let swatchRect = CGRect(x: itemX, y: groupY, width: swatchSize, height: swatchSize)
                let (r, g, b, a) = parseHexToRGBA(pair.lightHex)
                let swatchColor = UIColor(red: r, green: g, blue: b, alpha: a)
                cgContext.setFillColor(swatchColor.cgColor)
                cgContext.fill(swatchRect)

                // Border for swatch
                cgContext.setStrokeColor(UIColor.lightGray.cgColor)
                cgContext.setLineWidth(0.5)
                cgContext.stroke(swatchRect)

                // Role name
                let labelFont = UIFont.systemFont(ofSize: bodyFontSize, weight: .medium)
                let labelAttrs: [NSAttributedString.Key: Any] = [
                    .font: labelFont,
                    .foregroundColor: UIColor.black
                ]
                let labelString = NSAttributedString(string: role.displayName, attributes: labelAttrs)
                labelString.draw(at: CGPoint(x: itemX + swatchSize + 8, y: groupY))

                // RGB and Hex values
                let valueFont = UIFont.monospacedSystemFont(ofSize: captionFontSize, weight: .regular)
                let valueAttrs: [NSAttributedString.Key: Any] = [
                    .font: valueFont,
                    .foregroundColor: UIColor.gray
                ]
                let rgbString = String(format: "R: %.2f  G: %.2f  B: %.2f", r, g, b)
                let valueString = NSAttributedString(string: "\(rgbString)  \(pair.lightHex)", attributes: valueAttrs)
                valueString.draw(at: CGPoint(x: itemX + swatchSize + 8, y: groupY + labelFont.lineHeight + 2))

                groupY += swatchSize + itemSpacing
            }

            maxRowY = max(maxRowY, groupY)

            // Move to next column or next row
            columnIndex += 1
            if columnIndex >= 2 {
                columnIndex = 0
                rowY = maxRowY + itemSpacing
            }
        }

        return maxRowY
    }

    // MARK: - Typography Section

    private static func drawTypographySection(in cgContext: CGContext, spec: GentleDesignSystemSpec, startY: CGFloat, context: UIGraphicsPDFRendererContext) -> CGFloat {
        var y = startY

        // Section title
        y = drawSectionTitle("Typography", in: cgContext, at: y)
        y += itemSpacing

        let columnWidth: CGFloat = contentWidth / 2
        var columnIndex = 0
        var rowStartY = y
        var maxRowY = y

        for role in GentleTextRole.allCases {
            let roleSpec = spec.typography.roleSpec(for: role)

            // Check if we need a new page
            if y > pageHeight - margin - 80 {
                context.beginPage()
                y = margin
                rowStartY = y
                maxRowY = y
                columnIndex = 0
            }

            let itemX = margin + CGFloat(columnIndex) * columnWidth
            var itemY = (columnIndex == 0) ? y : rowStartY

            // Sample "Aa" in actual font
            let sampleFont = buildUIFont(from: roleSpec, maxSize: 28)
            let sampleAttrs: [NSAttributedString.Key: Any] = [
                .font: sampleFont,
                .foregroundColor: UIColor.black
            ]
            let sampleString = NSAttributedString(string: "Aa", attributes: sampleAttrs)
            sampleString.draw(at: CGPoint(x: itemX, y: itemY))

            // Role name
            let labelFont = UIFont.systemFont(ofSize: bodyFontSize, weight: .semibold)
            let labelAttrs: [NSAttributedString.Key: Any] = [
                .font: labelFont,
                .foregroundColor: UIColor.black
            ]
            let labelString = NSAttributedString(string: role.displayName, attributes: labelAttrs)
            labelString.draw(at: CGPoint(x: itemX + 48, y: itemY))
            itemY += labelFont.lineHeight + 2

            // Properties
            let propsFont = UIFont.monospacedSystemFont(ofSize: captionFontSize, weight: .regular)
            let propsAttrs: [NSAttributedString.Key: Any] = [
                .font: propsFont,
                .foregroundColor: UIColor.gray
            ]

            let widthStr = roleSpec.width?.rawValue ?? "standard"
            let propsString = String(format: "%.0fpt • %@ • %@ • %@",
                                    roleSpec.pointSize,
                                    roleSpec.weight.rawValue,
                                    roleSpec.design.rawValue,
                                    widthStr)
            let propsAttrString = NSAttributedString(string: propsString, attributes: propsAttrs)
            propsAttrString.draw(at: CGPoint(x: itemX + 48, y: itemY))
            itemY += propsFont.lineHeight + 2

            // Line/letter spacing
            let spacingString = String(format: "lineSpacing: %.1f  letterSpacing: %.2f  color: %@",
                                       roleSpec.lineSpacing,
                                       roleSpec.letterSpacing,
                                       roleSpec.colorRole.rawValue)
            let spacingAttrString = NSAttributedString(string: spacingString, attributes: propsAttrs)
            spacingAttrString.draw(at: CGPoint(x: itemX + 48, y: itemY))
            itemY += propsFont.lineHeight + itemSpacing

            maxRowY = max(maxRowY, itemY)

            // Move to next column or next row
            columnIndex += 1
            if columnIndex >= 2 {
                columnIndex = 0
                y = maxRowY
                rowStartY = y
            }
        }

        return maxRowY
    }

    // MARK: - Buttons Section

    private static func drawButtonsSection(in cgContext: CGContext, spec: GentleDesignSystemSpec, startY: CGFloat, context: UIGraphicsPDFRendererContext) -> CGFloat {
        var y = startY

        // Section title
        y = drawSectionTitle("Buttons", in: cgContext, at: y)
        y += itemSpacing

        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 36

        for role in [GentleButtonRole.primary, .secondary, .tertiary, .quaternary, .destructive] {
            let roleSpec = spec.buttons.roleSpec(for: role)

            // Check if we need a new page
            if y > pageHeight - margin - 80 {
                context.beginPage()
                y = margin
            }

            // Draw button preview
            let buttonRect = CGRect(x: margin, y: y, width: buttonWidth, height: buttonHeight)
            drawButtonPreview(in: cgContext, rect: buttonRect, role: role, spec: roleSpec, colors: spec.colors)

            // Role name
            let labelFont = UIFont.systemFont(ofSize: bodyFontSize, weight: .semibold)
            let labelAttrs: [NSAttributedString.Key: Any] = [
                .font: labelFont,
                .foregroundColor: UIColor.black
            ]
            let labelString = NSAttributedString(string: role.rawValue.capitalized, attributes: labelAttrs)
            labelString.draw(at: CGPoint(x: margin + buttonWidth + 16, y: y))

            // Properties
            let propsFont = UIFont.monospacedSystemFont(ofSize: captionFontSize, weight: .regular)
            let propsAttrs: [NSAttributedString.Key: Any] = [
                .font: propsFont,
                .foregroundColor: UIColor.gray
            ]

            let propsString = String(format: "shape: %@  fill: %@  border: %@",
                                    roleSpec.shape.rawValue,
                                    roleSpec.fillRole.rawValue,
                                    roleSpec.borderRole.rawValue)
            let propsAttrString = NSAttributedString(string: propsString, attributes: propsAttrs)
            propsAttrString.draw(at: CGPoint(x: margin + buttonWidth + 16, y: y + labelFont.lineHeight + 2))

            let animString = String(format: "animation: %@  pressedScale: %.2f  pressedOpacity: %.2f",
                                   roleSpec.animationRole.rawValue,
                                   roleSpec.pressedScale,
                                   roleSpec.pressedOpacity)
            let animAttrString = NSAttributedString(string: animString, attributes: propsAttrs)
            animAttrString.draw(at: CGPoint(x: margin + buttonWidth + 16, y: y + labelFont.lineHeight + propsFont.lineHeight + 4))

            y += buttonHeight + itemSpacing
        }

        return y
    }

    private static func drawButtonPreview(in cgContext: CGContext, rect: CGRect, role: GentleButtonRole, spec: GentleButtonRoleSpec, colors: GentleColorTokens) {
        let cornerRadius: CGFloat = spec.shape == .pill ? rect.height / 2 : 8
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

        // Fill
        let fillColor: UIColor
        switch spec.fillRole {
        case .solidFillPrimaryCTA:
            if let pair = colors.pair(for: .primaryCTA) {
                let (r, g, b, a) = parseHexToRGBA(pair.lightHex)
                fillColor = UIColor(red: r, green: g, blue: b, alpha: a)
            } else {
                fillColor = UIColor.systemBlue
            }
        case .solidFillDestructive:
            if let pair = colors.pair(for: .destructive) {
                let (r, g, b, a) = parseHexToRGBA(pair.lightHex)
                fillColor = UIColor(red: r, green: g, blue: b, alpha: a)
            } else {
                fillColor = UIColor.systemRed
            }
        case .hollow:
            fillColor = UIColor.clear
        }

        cgContext.setFillColor(fillColor.cgColor)
        cgContext.addPath(path.cgPath)
        cgContext.fillPath()

        // Border
        if spec.borderRole != .hidden {
            let borderColor: UIColor
            switch spec.borderRole {
            case .accent:
                if let pair = colors.pair(for: .primaryCTA) {
                    let (r, g, b, a) = parseHexToRGBA(pair.lightHex)
                    borderColor = UIColor(red: r, green: g, blue: b, alpha: a)
                } else {
                    borderColor = UIColor.systemBlue
                }
            case .subtle:
                if let pair = colors.pair(for: .borderSubtle) {
                    let (r, g, b, a) = parseHexToRGBA(pair.lightHex)
                    borderColor = UIColor(red: r, green: g, blue: b, alpha: a)
                } else {
                    borderColor = UIColor.lightGray
                }
            case .hidden:
                borderColor = UIColor.clear
            }

            cgContext.setStrokeColor(borderColor.cgColor)
            cgContext.setLineWidth(1)
            cgContext.addPath(path.cgPath)
            cgContext.strokePath()
        }

        // Button label
        let labelFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        let labelColor: UIColor
        switch spec.fillRole {
        case .solidFillPrimaryCTA, .solidFillDestructive:
            labelColor = UIColor.white
        case .hollow:
            if let pair = colors.pair(for: .primaryCTA) {
                let (r, g, b, a) = parseHexToRGBA(pair.lightHex)
                labelColor = UIColor(red: r, green: g, blue: b, alpha: a)
            } else {
                labelColor = UIColor.systemBlue
            }
        }

        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: labelColor
        ]
        let labelString = NSAttributedString(string: role.rawValue.capitalized, attributes: labelAttrs)
        let labelSize = labelString.size()
        let labelX = rect.midX - labelSize.width / 2
        let labelY = rect.midY - labelSize.height / 2
        labelString.draw(at: CGPoint(x: labelX, y: labelY))
    }

    // MARK: - Surfaces Section

    private static func drawSurfacesSection(in cgContext: CGContext, spec: GentleDesignSystemSpec, startY: CGFloat, context: UIGraphicsPDFRendererContext) -> CGFloat {
        var y = startY

        // Section title
        y = drawSectionTitle("Surfaces", in: cgContext, at: y)
        y += itemSpacing

        let previewWidth: CGFloat = 80
        let previewHeight: CGFloat = 50

        // Group surfaces by category
        for (category, roles) in GentleSurfaceRole.groupedByCategory {
            // Check if we need a new page
            if y > pageHeight - margin - 100 {
                context.beginPage()
                y = margin
            }

            // Category title
            let categoryFont = UIFont.systemFont(ofSize: subsectionTitleFontSize, weight: .semibold)
            let categoryAttrs: [NSAttributedString.Key: Any] = [
                .font: categoryFont,
                .foregroundColor: UIColor.black
            ]
            let categoryString = NSAttributedString(string: category.rawValue, attributes: categoryAttrs)
            categoryString.draw(at: CGPoint(x: margin, y: y))
            y += categoryFont.lineHeight + 8

            for role in roles {
                let roleSpec = spec.surfaces.roleSpec(for: role)

                // Check if we need a new page
                if y > pageHeight - margin - 80 {
                    context.beginPage()
                    y = margin
                }

                // Draw surface preview
                let previewRect = CGRect(x: margin, y: y, width: previewWidth, height: previewHeight)
                drawSurfacePreview(in: cgContext, rect: previewRect, spec: roleSpec, colors: spec.colors)

                // Role name
                let labelFont = UIFont.systemFont(ofSize: bodyFontSize, weight: .semibold)
                let labelAttrs: [NSAttributedString.Key: Any] = [
                    .font: labelFont,
                    .foregroundColor: UIColor.black
                ]
                let labelString = NSAttributedString(string: role.displayName, attributes: labelAttrs)
                labelString.draw(at: CGPoint(x: margin + previewWidth + 12, y: y))

                // Properties
                let propsFont = UIFont.monospacedSystemFont(ofSize: captionFontSize, weight: .regular)
                let propsAttrs: [NSAttributedString.Key: Any] = [
                    .font: propsFont,
                    .foregroundColor: UIColor.gray
                ]

                let backgroundDesc = backgroundStyleDescription(roleSpec.backgroundStyle)
                let propsString = String(format: "background: %@  cornerRadius: %.0f  borderWidth: %.1f",
                                        backgroundDesc,
                                        roleSpec.cornerRadius,
                                        roleSpec.borderWidth)
                let propsAttrString = NSAttributedString(string: propsString, attributes: propsAttrs)
                propsAttrString.draw(at: CGPoint(x: margin + previewWidth + 12, y: y + labelFont.lineHeight + 2))

                // Shadow properties
                let shadowString = String(format: "shadow: radius=%.0f opacity=%.2f offset=(%.0f, %.0f)",
                                         roleSpec.shadowRadius,
                                         roleSpec.shadowOpacity,
                                         roleSpec.shadowOffsetX,
                                         roleSpec.shadowOffsetY)
                let shadowAttrString = NSAttributedString(string: shadowString, attributes: propsAttrs)
                shadowAttrString.draw(at: CGPoint(x: margin + previewWidth + 12, y: y + labelFont.lineHeight + propsFont.lineHeight + 4))

                y += previewHeight + itemSpacing
            }

            y += 8 // Extra space between categories
        }

        return y
    }

    private static func drawSurfacePreview(in cgContext: CGContext, rect: CGRect, spec: GentleSurfaceRoleSpec, colors: GentleColorTokens) {
        let cornerRadius = min(CGFloat(spec.cornerRadius), rect.height / 2)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

        // Background fill - use solid fallback for materials/glass
        let fillColor: UIColor
        switch spec.backgroundStyle {
        case .solid(let colorRole):
            if let pair = colors.pair(for: colorRole) {
                let (r, g, b, a) = parseHexToRGBA(pair.lightHex)
                fillColor = UIColor(red: r, green: g, blue: b, alpha: a)
            } else {
                fillColor = UIColor.systemBackground
            }
        case .material(_, let tintColorRole, _):
            // Show a light gray to indicate material with optional tint
            if let tintRole = tintColorRole, let pair = colors.pair(for: tintRole) {
                let (r, g, b, _) = parseHexToRGBA(pair.lightHex)
                fillColor = UIColor(red: r, green: g, blue: b, alpha: 0.15)
            } else {
                fillColor = UIColor(white: 0.95, alpha: 1.0)
            }
        case .glass(_, let fallbackColorRole):
            // Show semi-transparent to indicate glass
            if let pair = colors.pair(for: fallbackColorRole) {
                let (r, g, b, _) = parseHexToRGBA(pair.lightHex)
                fillColor = UIColor(red: r, green: g, blue: b, alpha: 0.3)
            } else {
                fillColor = UIColor(white: 0.9, alpha: 0.5)
            }
        }

        cgContext.setFillColor(fillColor.cgColor)
        cgContext.addPath(path.cgPath)
        cgContext.fillPath()

        // Border
        if spec.borderWidth > 0 {
            let (r, g, b, a) = parseHexToRGBA(spec.border.lightHex)
            let borderColor = UIColor(red: r, green: g, blue: b, alpha: a)
            cgContext.setStrokeColor(borderColor.cgColor)
            cgContext.setLineWidth(CGFloat(spec.borderWidth))
            cgContext.addPath(path.cgPath)
            cgContext.strokePath()
        }

        // Draw pattern to indicate material/glass
        if case .material = spec.backgroundStyle {
            drawMaterialPattern(in: cgContext, rect: rect.insetBy(dx: 4, dy: 4))
        } else if case .glass = spec.backgroundStyle {
            drawGlassPattern(in: cgContext, rect: rect.insetBy(dx: 4, dy: 4))
        }
    }

    private static func drawMaterialPattern(in cgContext: CGContext, rect: CGRect) {
        // Draw subtle lines to indicate blur material
        cgContext.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.3).cgColor)
        cgContext.setLineWidth(0.5)
        for i in stride(from: 0, to: rect.width, by: 6) {
            cgContext.move(to: CGPoint(x: rect.minX + CGFloat(i), y: rect.minY))
            cgContext.addLine(to: CGPoint(x: rect.minX + CGFloat(i), y: rect.maxY))
        }
        cgContext.strokePath()
    }

    private static func drawGlassPattern(in cgContext: CGContext, rect: CGRect) {
        // Draw diagonal lines to indicate glass effect
        cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.4).cgColor)
        cgContext.setLineWidth(1)
        for i in stride(from: 0, to: rect.width + rect.height, by: 8) {
            let startX = rect.minX + CGFloat(i)
            let startY = rect.minY
            let endX = rect.minX
            let endY = rect.minY + CGFloat(i)
            cgContext.move(to: CGPoint(x: min(startX, rect.maxX), y: max(startY, rect.minY)))
            cgContext.addLine(to: CGPoint(x: max(endX, rect.minX), y: min(endY, rect.maxY)))
        }
        cgContext.strokePath()
    }

    private static func backgroundStyleDescription(_ style: GentleSurfaceBackgroundStyle) -> String {
        switch style {
        case .solid(let colorRole):
            return "solid(\(colorRole.rawValue))"
        case .material(let material, let tintRole, _):
            if let tintRole = tintRole {
                return "material(\(material.rawValue), tint: \(tintRole.rawValue))"
            } else {
                return "material(\(material.rawValue))"
            }
        case .glass(let fallback, _):
            if let fallback = fallback {
                return "glass(fallback: \(fallback.rawValue))"
            } else {
                return "glass"
            }
        }
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

        // Underline
        let lineY = y + font.lineHeight + 4
        cgContext.setStrokeColor(UIColor.black.cgColor)
        cgContext.setLineWidth(1)
        cgContext.move(to: CGPoint(x: margin, y: lineY))
        cgContext.addLine(to: CGPoint(x: margin + attrString.size().width, y: lineY))
        cgContext.strokePath()

        return lineY + 4
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
