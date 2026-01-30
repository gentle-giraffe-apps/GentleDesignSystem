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

    // MARK: - Label Color

    /// Gentle dark blue at 70% opacity for all role/token labels
    private static let labelColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 0.7)

    /// Returns the appropriate primary text color for displaying text on a given surface
    private static func textColor(for surfaceRole: GentleSurfaceRole, spec: GentleDesignSystemSpec, scheme: ColorScheme) -> UIColor {
        let colorRole: GentleColorRole
        switch surfaceRole {
        case .overlayScrim:
            colorRole = .textOnScrim
        case .overlaySheet, .overlayPopover:
            colorRole = .textOnOverlay
        default:
            return labelColor
        }
        let hex = scheme == .dark
            ? spec.colors.pairByRole[colorRole.rawValue]?.darkHex
            : spec.colors.pairByRole[colorRole.rawValue]?.lightHex
        return hex.map { uiColorFromHex($0) } ?? labelColor
    }

    /// Returns the appropriate secondary text color for displaying text on a given surface
    private static func secondaryTextColor(for surfaceRole: GentleSurfaceRole, spec: GentleDesignSystemSpec, scheme: ColorScheme) -> UIColor {
        let colorRole: GentleColorRole
        switch surfaceRole {
        case .overlayScrim:
            colorRole = .textOnScrimSecondary
        case .overlaySheet, .overlayPopover:
            colorRole = .textOnOverlaySecondary
        default:
            return labelColor
        }
        let hex = scheme == .dark
            ? spec.colors.pairByRole[colorRole.rawValue]?.darkHex
            : spec.colors.pairByRole[colorRole.rawValue]?.lightHex
        return hex.map { uiColorFromHex($0) } ?? labelColor
    }

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

        // Typography: 4 columns, rows sized for large fonts
        let typographyRows = ceil(Double(GentleTextRole.allCases.count) / 4.0)
        height += sectionTitleFontSize + 12 + (CGFloat(typographyRows) * 62) + 14  // 58 cell + 4 gap
        height += sectionSpacing

        // Buttons: 3 rows of buttons sized for 17pt text
        height += sectionTitleFontSize + 12 + 40 + gridGap + 40 + gridGap + 40 + 20
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
        let cellHeight: CGFloat = 58  // Accommodate large fonts like largeTitle_xxl (34pt)
        let rowGap: CGFloat = 4

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

        // Role name label - with minimum scale factor
        let baseLabelFontSize: CGFloat = 12
        let minScaleFactor: CGFloat = 0.5

        // Try full size first, then scale down if needed
        var labelFontSize = baseLabelFontSize
        var labelFont = UIFont.systemFont(ofSize: labelFontSize, weight: .regular)
        var labelAttrs: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: Self.labelColor
        ]
        var labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
        var labelSize = labelString.size()

        // Scale down if needed, respecting minimum scale factor
        if labelSize.width > width {
            let scaleFactor = max(width / labelSize.width, minScaleFactor)
            labelFontSize = baseLabelFontSize * scaleFactor
            labelFont = UIFont.systemFont(ofSize: labelFontSize, weight: .regular)
            labelAttrs[.font] = labelFont
            labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
        }

        labelString.draw(at: point)

        // Sample "Aa Bb" in actual font style using the theme's point size, design, and width
        let sampleFont = buildUIFont(from: roleSpec)
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

        // Container card - sized for 17pt button text
        let containerHeight: CGFloat = 40 + gridGap + 40 + gridGap + 40 + 20
        let containerRect = CGRect(x: margin, y: y, width: contentWidth, height: containerHeight)
        drawContainerCard(in: cgContext, rect: containerRect, spec: spec)

        let columns = 4
        let buttonGap: CGFloat = 10
        let containerPadding: CGFloat = 10
        let buttonWidth = (contentWidth - containerPadding * 2 - CGFloat(columns - 1) * buttonGap) / CGFloat(columns)
        let buttonHeight: CGFloat = 36
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

        // Button label - use the typography spec for this button role's text role
        let textRole = role.defaultTextRole
        let typographySpec = spec.typography.roleSpec(for: textRole)
        let labelFont = buildUIFont(from: typographySpec)
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
        // Use actual corner radius, capped to half the smallest dimension
        let maxRadius = min(rect.width, rect.height) / 2
        let cornerRadius = min(CGFloat(roleSpec.cornerRadius), maxRadius)

        // Check if this is a material or glass surface that needs SwiftUI rendering
        let needsSwiftUIRendering: Bool
        switch roleSpec.backgroundStyle {
        case .solid:
            needsSwiftUIRendering = false
        case .material, .glass:
            needsSwiftUIRendering = true
        }

        if needsSwiftUIRendering {
            // Render using SwiftUI with actual materials
            if let surfaceImage = renderSurfaceWithSwiftUI(spec: spec, role: role, size: rect.size) {
                // Draw shadow first if needed
                if roleSpec.shadowRadius > 0 && roleSpec.shadowOpacity > 0 {
                    cgContext.saveGState()
                    let shadowColor = UIColor.black.withAlphaComponent(CGFloat(roleSpec.shadowOpacity))
                    cgContext.setShadow(
                        offset: CGSize(width: CGFloat(roleSpec.shadowOffsetX), height: CGFloat(roleSpec.shadowOffsetY)),
                        blur: CGFloat(roleSpec.shadowRadius),
                        color: shadowColor.cgColor
                    )
                    // Draw a filled shape to cast the shadow
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
                    cgContext.setFillColor(UIColor.white.cgColor)
                    cgContext.addPath(path.cgPath)
                    cgContext.fillPath()
                    cgContext.restoreGState()
                }

                // Draw the rendered SwiftUI image
                surfaceImage.draw(in: rect)
            } else {
                // Fallback to simple rendering if SwiftUI rendering fails
                drawSolidSurface(in: cgContext, spec: spec, role: role, roleSpec: roleSpec, rect: rect, cornerRadius: cornerRadius)
            }
        } else {
            // Use simple Core Graphics rendering for solid surfaces
            drawSolidSurface(in: cgContext, spec: spec, role: role, roleSpec: roleSpec, rect: rect, cornerRadius: cornerRadius)
        }

        // Role name - with minimum scale factor
        // Use appropriate text color based on surface type (overlay surfaces need special colors)
        let primaryTextColor = textColor(for: role, spec: spec, scheme: .light)
        let secondaryTextColor = secondaryTextColor(for: role, spec: spec, scheme: .light)

        let labelInset: CGFloat = 16
        let availableWidth = rect.width - labelInset * 2
        let baseLabelFontSize: CGFloat = 12
        let minScaleFactor: CGFloat = 0.5

        var labelFontSize = baseLabelFontSize
        var labelFont = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        var labelAttrs: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: primaryTextColor
        ]
        var labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
        var labelSize = labelString.size()

        // Scale down if needed
        if labelSize.width > availableWidth {
            let scaleFactor = max(availableWidth / labelSize.width, minScaleFactor)
            labelFontSize = baseLabelFontSize * scaleFactor
            labelFont = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
            labelAttrs[.font] = labelFont
            labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
        }

        labelString.draw(at: CGPoint(x: rect.minX + labelInset, y: rect.minY + 10))

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

        let subtitleFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        let subtitleAttrs: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: secondaryTextColor
        ]
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttrs)
        subtitleString.draw(at: CGPoint(x: rect.minX + labelInset, y: rect.minY + 10 + labelFont.lineHeight + 1))
    }

    /// Draws a solid surface using Core Graphics (for non-material/glass surfaces)
    private static func drawSolidSurface(in cgContext: CGContext, spec: GentleDesignSystemSpec, role: GentleSurfaceRole, roleSpec: GentleSurfaceRoleSpec, rect: CGRect, cornerRadius: CGFloat) {
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
    }

    /// Renders a surface using SwiftUI and captures it as a UIImage
    /// Note: This must be called from the main thread since ImageRenderer requires it
    private static func renderSurfaceWithSwiftUI(spec: GentleDesignSystemSpec, role: GentleSurfaceRole, size: CGSize) -> UIImage? {
        // Use assumeIsolated since PDF rendering happens on main thread via UIGraphicsPDFRenderer
        return MainActor.assumeIsolated {
            let theme = GentleTheme(defaultSpec: spec, editableSpec: spec)

            // Create a SwiftUI view that renders the surface with a gradient background to show the blur
            let surfaceView = SurfacePreviewView(role: role, size: size)

            // Use ImageRenderer to capture the view
            let renderer = ImageRenderer(content:
                GentleThemeRoot(theme: theme) {
                    surfaceView
                }
                .environment(\.colorScheme, .light)
            )

            renderer.scale = 8.0 // 8x scale for crisp PDF output

            return renderer.uiImage
        }
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

            // Role name (after both swatches) - with minimum scale factor
            let labelX = cellX + swatchSize * 2 + swatchGap + 6
            let availableWidth = cellWidth - (swatchSize * 2 + swatchGap + 6)
            let baseFontSize: CGFloat = 10
            let minScaleFactor: CGFloat = 0.7

            // Try full size first, then scale down if needed
            var fontSize = baseFontSize
            var labelFont = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            var labelAttrs: [NSAttributedString.Key: Any] = [
                .font: labelFont,
                .foregroundColor: Self.labelColor
            ]
            var labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
            var labelSize = labelString.size()

            // Scale down if needed, respecting minimum scale factor
            if labelSize.width > availableWidth {
                let scaleFactor = max(availableWidth / labelSize.width, minScaleFactor)
                fontSize = baseFontSize * scaleFactor
                labelFont = UIFont.systemFont(ofSize: fontSize, weight: .regular)
                labelAttrs[.font] = labelFont
                labelString = NSAttributedString(string: role.rawValue, attributes: labelAttrs)
            }

            labelString.draw(at: CGPoint(x: labelX, y: cellY + 2))
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

// MARK: - SwiftUI Surface Preview View

/// A SwiftUI view that renders a surface preview with colorful stripes background
/// to make material/glass effects visible.
/// Matches the pattern used in ThemePickerView's surfacePreview method.
private struct SurfacePreviewView: View {
    @Environment(\.gentleTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    let role: GentleSurfaceRole
    let size: CGSize

    private var isGlass: Bool {
        switch theme.surfaces.roleSpec(for: role).backgroundStyle {
        case .glass:
            return true
        case .material, .solid:
            return false
        }
    }

    var body: some View {
        let roleSpec = theme.surfaces.roleSpec(for: role)
        let cornerRadius = roleSpec.cornerRadius

        ZStack {
            // Background - orbs for materials, stripes for glass
            if isGlass {
                PDFColorfulStripesBackground(
                    baseColor: theme.color(for: .themePrimary, scheme: colorScheme),
                    stripeWidth: 8
                )
            } else {
                PDFGradientOrbsBackground(
                    primaryColor: theme.color(for: .themePrimary, scheme: colorScheme),
                    secondaryColor: theme.color(for: .themeSecondary, scheme: colorScheme)
                )
            }

            // The surface on top
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.clear)
                .gentleSurface(role)
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

/// Colorful diagonal stripes background for glass surfaces
private struct PDFColorfulStripesBackground: View {
    let baseColor: Color
    var stripeWidth: CGFloat = 10

    private var shades: [Color] {
        [
            baseColor.opacity(1.0),
            baseColor.opacity(0.85),
            baseColor.opacity(0.7),
            baseColor.opacity(0.9),
            baseColor.opacity(0.75)
        ]
    }

    var body: some View {
        Canvas { context, size in
            let stripeWidth = self.stripeWidth
            let totalWidth = size.width + size.height

            var x: CGFloat = -size.height
            var colorIndex = 0
            var isColoredStripe = true

            while x < totalWidth {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x + size.height, y: size.height))
                path.addLine(to: CGPoint(x: x + size.height + stripeWidth, y: size.height))
                path.addLine(to: CGPoint(x: x + stripeWidth, y: 0))
                path.closeSubpath()

                if isColoredStripe {
                    let color1 = shades[colorIndex % shades.count]
                    let color2 = shades[(colorIndex + 1) % shades.count]
                    let gradient = Gradient(colors: [color1, color2])

                    context.fill(
                        path,
                        with: .linearGradient(
                            gradient,
                            startPoint: CGPoint(x: x, y: 0),
                            endPoint: CGPoint(x: x + stripeWidth + size.height, y: size.height)
                        )
                    )
                    colorIndex += 1
                } else {
                    context.fill(path, with: .color(baseColor.opacity(0.2)))
                }

                isColoredStripe.toggle()
                x += stripeWidth
            }
        }
    }
}

/// High-contrast gradient orbs background for PDF surface previews
/// Creates overlapping soft circles to demonstrate material blur effects
private struct PDFGradientOrbsBackground: View {
    let primaryColor: Color
    let secondaryColor: Color

    // Dark, high-contrast orb colors derived from theme
    private var orbColors: [Color] {
        [
            primaryColor,
            secondaryColor,
            Color(red: 0.8, green: 0.3, blue: 0.1),   // Deep orange
            Color(red: 0.7, green: 0.1, blue: 0.4),   // Deep magenta
            Color(red: 0.1, green: 0.5, blue: 0.6),   // Dark teal
            Color(red: 0.4, green: 0.2, blue: 0.7)    // Deep purple
        ]
    }

    var body: some View {
        Canvas { context, size in
            // Define orb positions and sizes for an interesting composition
            let orbs: [(x: CGFloat, y: CGFloat, radius: CGFloat, colorIndex: Int)] = [
                // Large background orbs
                (0.1, 0.2, 0.7, 0),      // Primary - top left
                (0.9, 0.8, 0.6, 1),      // Secondary - bottom right
                (0.8, 0.1, 0.5, 2),      // Orange - top right
                // Medium orbs
                (0.3, 0.9, 0.45, 3),     // Pink - bottom left
                (0.6, 0.4, 0.4, 4),      // Cyan - center
                // Smaller accent orbs
                (0.15, 0.7, 0.3, 5),     // Yellow - left
                (0.75, 0.5, 0.35, 0),    // Primary - right
                (0.5, 0.15, 0.25, 1),    // Secondary - top center
            ]

            for orb in orbs {
                let centerX = orb.x * size.width
                let centerY = orb.y * size.height
                let radius = orb.radius * max(size.width, size.height)
                let color = orbColors[orb.colorIndex % orbColors.count]

                // Create radial gradient for soft orb effect
                let gradient = Gradient(colors: [
                    color.opacity(0.9),
                    color.opacity(0.6),
                    color.opacity(0.0)
                ])

                let center = CGPoint(x: centerX, y: centerY)
                let orbRect = CGRect(
                    x: centerX - radius,
                    y: centerY - radius,
                    width: radius * 2,
                    height: radius * 2
                )

                context.fill(
                    Path(ellipseIn: orbRect),
                    with: .radialGradient(
                        gradient,
                        center: center,
                        startRadius: 0,
                        endRadius: radius
                    )
                )
            }
        }
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
