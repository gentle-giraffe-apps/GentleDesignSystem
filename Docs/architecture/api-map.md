# Public API Map

Complete listing of all public types, properties, and methods grouped by file.

---

## GentleDesignSystem.swift

### GentleDesignSystemSpecVersion (enum)
```
static let current: String
```

### GentleTextRole (enum: String, Identifiable, Codable, Sendable, CaseIterable)
```
Cases: largeTitle_xxl, title_xl, title2_l, title3_ml, headline_m, body_m,
       bodySecondary_m, monoCode_m, callout_ms, subheadline_ms, footnote_s,
       caption_s, caption2_s, primaryButtonTitle_m, secondaryButtonTitle_m,
       tertiaryButtonTitle_m, quaternaryButtonTitle_m

var id: String
var ramp: GentleTextRamp
var displayName: String
```

### GentleTextRamp (enum: String, Codable, Sendable)
```
Cases: xxl, xl, l, ml, m, ms, s
```

### GentleColorRole (enum: String, Codable, Sendable, CaseIterable, Identifiable)
```
Cases: textPrimary, textSecondary, textTertiary, textOnPrimaryCTA, textOnDestructive,
       background, surfaceBase, surfaceCardSecondary, surfaceTint, surfaceSpecular,
       surfaceOverlay, textOnOverlay, textOnOverlaySecondary, borderSubtle,
       destructive, primaryCTA, themePrimary, themeSecondary

var id: String
var displayName: String
var isTextRole: Bool
var isSurfaceRole: Bool
var isActionRole: Bool
var isThemeRole: Bool
var isSurfaceBackgroundRole: Bool

static let textRoles: [GentleColorRole]
static let surfaceRoles: [GentleColorRole]
static let actionRoles: [GentleColorRole]
static let themeRoles: [GentleColorRole]
static let surfaceBackgroundRoles: [GentleColorRole]
```

### GentleButtonRole (enum: String, Codable, Sendable, Identifiable)
```
Cases: primary, secondary, tertiary, quaternary, destructive

var id: String
var defaultTextRole: GentleTextRole
```

### GentleButtonFillRole (enum: String, Codable, Sendable, CaseIterable, Identifiable)
```
Cases: solidFillPrimaryCTA, solidFillDestructive, hollow

var id: String
var displayName: String
```

### GentleButtonBorderRole (enum: String, Codable, Sendable, CaseIterable, Identifiable)
```
Cases: hidden, accent, subtle

var id: String
var displayName: String
```

### GentleButtonShape (enum: String, Codable, Sendable)
```
Cases: rounded, pill
```

### GentleButtonAnimationRole (enum: String, Codable, Sendable, CaseIterable)
```
Cases: unknown, subtlePress, squish, pop, bouncy, springBack
```

### GentleButtonAnimationSpec (struct: Codable, Sendable)
```
var pressedScale: Double
var pressedOpacity: Double
var duration: Double
var springResponse: Double
var springDamping: Double
var springBlend: Double

init(pressedScale:pressedOpacity:duration:springResponse:springDamping:springBlend:)
```

### GentleTextFieldShape (enum: String, Codable, Sendable)
```
Cases: rounded, pill
```

### GentleTextChrome (enum: Sendable)
```
Cases: standalone(shape: GentleTextFieldShape), formRow, borderless
```

### GentleGapIntent (enum: String, Codable, Sendable, CaseIterable)
```
Cases: unknown, micro, tight, regular, ample, loose, expansive
```

### GentleFontTextStyle (enum: String, Codable, Sendable)
```
Cases: largeTitle, title, title2, title3, headline, body, callout,
       subheadline, footnote, caption, caption2

var uiKitTextStyle: UIFont.TextStyle
```

### GentleDesignSystemSpec (struct: Codable, Sendable)
```
var specVersion: String
var colors: GentleColorTokens
var typography: GentleTypographyTokens
var layout: GentleLayoutTokens
var visual: GentleVisualTokens
var buttons: GentleButtonTokens
var surfaces: GentleSurfaceTokens

init(specVersion:colors:typography:layout:visual:buttons:surfaces:)

static let gentleDefault: GentleDesignSystemSpec
```

### GentleColorPair (struct: Codable, Sendable, Equatable)
```
var lightHex: String
var darkHex: String

init(lightHex:darkHex:)
func hex(for scheme: ColorScheme) -> String
```

### GentleColorTokens (struct: Codable, Sendable)
```
var pairByRole: [String: GentleColorPair]

init(pairByRole:)
func pair(for role: GentleColorRole) -> GentleColorPair?

static let gentleDefault: GentleColorTokens
```

### GentleButtonRoleSpec (struct: Codable, Sendable)
```
var shape: GentleButtonShape
var fillRole: GentleButtonFillRole
var borderRole: GentleButtonBorderRole
var animationRole: GentleButtonAnimationRole
var pressedScale: Double
var pressedOpacity: Double
var usesNativeStyle: Bool

init(shape:fillRole:borderRole:animationRole:pressedScale:pressedOpacity:usesNativeStyle:)
```

### GentleButtonTokens (struct: Codable, Sendable)
```
var roles: [String: GentleButtonRoleSpec]
var animations: [String: GentleButtonAnimationSpec]

init(roles:animations:)
func roleSpec(for role: GentleButtonRole) -> GentleButtonRoleSpec
func animationSpec(for role: GentleButtonAnimationRole) -> GentleButtonAnimationSpec

static let gentleDefault: GentleButtonTokens
```

### GentleFontDesignToken (enum: String, Codable, Sendable, CaseIterable)
```
Cases: default, serif, rounded, monospaced
```

### GentleFontWidthToken (enum: String, Codable, Sendable, CaseIterable)
```
Cases: compressed, condensed, standard, expanded

var displayName: String
var swiftUIWidth: Font.Width  // iOS 17+
```

### GentleFontWeightToken (enum: String, Codable, Sendable, CaseIterable)
```
Cases: ultraLight, thin, light, regular, medium, semibold, bold, heavy, black

var displayName: String
```

### GentleTypographyRoleSpec (struct: Codable, Sendable)
```
var pointSize: Double
var weight: GentleFontWeightToken
var design: GentleFontDesignToken
var width: GentleFontWidthToken?
var relativeTo: GentleFontTextStyle
var lineSpacing: Double
var letterSpacing: Double
var isUppercased: Bool
var colorRole: GentleColorRole

init(pointSize:weight:design:width:relativeTo:lineSpacing:letterSpacing:isUppercased:colorRole:)
```

### GentleTypographyTokens (struct: Codable, Sendable)
```
var roles: [String: GentleTypographyRoleSpec]

init(roles:)
func roleSpec(for role: GentleTextRole) -> GentleTypographyRoleSpec

static let gentleDefault: GentleTypographyTokens
```

### GentleSpacingScaleTokens (struct: Codable, Sendable)
```
var xs: Double
var s: Double
var m: Double
var l: Double
var xl: Double
var xxl: Double

init(xs:s:m:l:xl:xxl:)
func value(for token: GentleSpacingToken) -> Double

static let gentleDefault: GentleSpacingScaleTokens
```

### GentleSpacingToken (enum: String, Codable, Sendable, CaseIterable)
```
Cases: xs, s, m, l, xl, xxl
```

### GentleInsetRole (enum: String, Codable, Sendable)
```
Cases: screen, card, control, listRow
```

### GentleInsetVariant (enum: String, Codable, Sendable, CaseIterable)
```
Cases: tight, regular, roomy
```

### GentleAxisInsetTokens (struct: Codable, Sendable, Hashable)
```
var horizontal: GentleSpacingToken
var vertical: GentleSpacingToken

init(horizontal:vertical:)
```

### GentleInsetTokens (struct: Codable, Sendable)
```
var tokensByRoleVariant: [String: [String: GentleAxisInsetTokens]]

init(tokensByRoleVariant:)
func axisTokens(for role: GentleInsetRole, variant: GentleInsetVariant) -> GentleAxisInsetTokens

static let gentleDefault: GentleInsetTokens
```

### GentleLayoutTokens (struct: Codable, Sendable)
```
var scale: GentleSpacingScaleTokens
var gap: GentleGapTokens
var grid: GentleGridSpacingTokens
var touch: GentleTouchTokens
var inset: GentleInsetTokens

init(scale:gap:grid:touch:inset:)

static let gentleDefault: GentleLayoutTokens
```

### GentleRadiusTokens (struct: Codable, Sendable)
```
var small: Double
var medium: Double
var large: Double
var pill: Double

init(small:medium:large:pill:)

static let gentleDefault: GentleRadiusTokens
```

### GentleShadowTokens (struct: Codable, Sendable)
```
var none: Double
var small: Double
var medium: Double

init(none:small:medium:)

static let gentleDefault: GentleShadowTokens
```

### GentleVisualTokens (struct: Codable, Sendable)
```
var radii: GentleRadiusTokens
var shadows: GentleShadowTokens

init(radii:shadows:)

static let gentleDefault: GentleVisualTokens
```

### GentleTheme (struct: Sendable)
```
var id: Int
var defaultSpec: GentleDesignSystemSpec
var editableSpec: GentleDesignSystemSpec
var activeSpec: GentleDesignSystemSpec { get }
var spec: GentleDesignSystemSpec { get }
var layout: GentleLayoutTokens { get }
var visual: GentleVisualTokens { get }
var buttons: GentleButtonTokens { get }
var surfaces: GentleSurfaceTokens { get }
var gap: GentleGapTokens { get }
var grid: GentleGridSpacingTokens { get }
var touch: GentleTouchTokens { get }
var inset: GentleInsetTokens { get }
var radii: GentleRadiusTokens { get }
var shadows: GentleShadowTokens { get }

init(defaultSpec:editableSpec:)
func color(for role: GentleColorRole, scheme: ColorScheme) -> Color
func visualEffectRecipe(for effect: GentleVisualEffect) -> GentleVisualEffectRecipe
func textStyle(for role: GentleTextRole, sizeCategory: ContentSizeCategory) -> GentleResolvedTextStyle
func insetValue(_ role: GentleInsetRole, variant: GentleInsetVariant, edges: Edge.Set) -> (horizontal: CGFloat?, vertical: CGFloat?)

static let `default`: GentleTheme
```

### GentleResolvedTextStyle (struct)
```
let font: Font
let design: GentleFontDesignToken
let colorRole: GentleColorRole
let lineSpacing: CGFloat
let letterSpacing: CGFloat
let isUppercased: Bool
```

### GentleGapScaleFacade (struct: Sendable)
```
var xs: CGFloat { get }
var s: CGFloat { get }
var m: CGFloat { get }
var l: CGFloat { get }
var xl: CGFloat { get }
var xxl: CGFloat { get }
var none: CGFloat { get }
var micro: CGFloat { get }
var tight: CGFloat { get }
var regular: CGFloat { get }
var ample: CGFloat { get }
var loose: CGFloat { get }
var expansive: CGFloat { get }

init(scale:)
func value(_ token: GentleSpacingToken) -> CGFloat
func value(_ intent: GentleGapIntent) -> CGFloat
```

### GentleLayoutFacade (struct: Sendable)
```
var gap: GentleGapScaleFacade { get }
var stack: GentleGapScaleFacade { get }
var list: GentleGapScaleFacade { get }
var grid: GentleGapScaleFacade { get }
var touch: GentleGapScaleFacade { get }
var inset: GentleInsetTokens { get }

init(tokens:)
```

### GentleThemeRoot<Content: View> (View)
```
init(theme:content:)
var body: some View
```

### GentleButtonAnimations (enum, @MainActor)
```
static func resolve(reduceMotion:role:spec:) -> Animation?
```

### GentleButtonStyle (ButtonStyle)
```
init(role:shape:textRole:expandsHorizontally:contentAlignment:)
func makeBody(configuration:) -> some View
```

### GentleDesignRuntime (@propertyWrapper, DynamicProperty)
```
init()
var wrappedValue: Resolver
```

### GentleDesignRuntime.Resolver (struct)
```
let theme: GentleTheme
var layout: GentleLayoutFacade { get }
var visual: GentleVisualTokens { get }
var buttons: GentleButtonTokens { get }
var surfaces: GentleSurfaceTokens { get }
var radii: GentleRadiusTokens { get }
var shadows: GentleShadowTokens { get }
var surfaceBase: Color { get }
var background: Color { get }
var borderSubtle: Color { get }
var textPrimary: Color { get }
var themePrimary: Color { get }

func color(_ role: GentleColorRole) -> Color
```

### GentleThemeManager (@Observable, @MainActor, class)
```
var theme: GentleTheme
let store: GentleThemeSpecStore
var hasUnsavedChanges: Bool { get }
var currentPresetName: String? { get }

init(theme:store:)
func load() throws
func save() throws
func reset() throws
func selectPreset(name:defaultSpec:) throws
func hasEditableSpec(forPreset name: String) -> Bool
func renamePreset(to newName: String)
func bindingForTypographyRole(_ role: GentleTextRole) -> Binding<GentleTypographyRoleSpec>
func bindingForButtonRole(_ role: GentleButtonRole) -> Binding<GentleButtonRoleSpec>
func bindingForSurfaceRole(_ role: GentleSurfaceRole) -> Binding<GentleSurfaceRoleSpec>
func bindingForColorRole(_ role: GentleColorRole) -> Binding<GentleColorPair>
func exportURL() throws -> URL
func exportPDFURL() throws -> URL
```

### GentleThemeManagerRuntime (@propertyWrapper, DynamicProperty)
```
init()
var wrappedValue: GentleThemeManager
```

### EnvironmentValues Extensions
```
var gentleTheme: GentleTheme { get set }
var gentleThemeManager: GentleThemeManager? { get set }
```

### Type Aliases
```
typealias GentleGapTokens = GentleSpacingScaleTokens
typealias GentleGridSpacingTokens = GentleSpacingScaleTokens
typealias GentleTouchTokens = GentleSpacingScaleTokens
```

---

## GentleSurfaceRole.swift

### GentleSurfaceRole (enum: String, Codable, Sendable, CaseIterable)
```
Cases: appBackground, card, cardElevated, cardSecondary, chrome,
       overlaySheet, overlayPopover, floatingPanel, floatingWidget

var displayName: String
var subtitle: String
var category: SurfaceCategory

static var groupedByCategory: [(category: SurfaceCategory, roles: [GentleSurfaceRole])]
```

### GentleSurfaceRole.SurfaceCategory (enum: String, CaseIterable)
```
Cases: structure, chrome, overlay, floating
```

### GentleAppleMaterial (enum: String, Codable, Sendable, CaseIterable, Identifiable)
```
Cases: noMaterial, ultraThin, thin, regular, thick, ultraThick, bar

var id: String
var displayName: String
var swiftUIMaterial: Material?  // iOS 15+
```

### GentleSurfaceDepthEffect (enum: Codable, Sendable, Equatable)
```
Cases: noEffect, highlightAndIndent(strength: CGFloat)

var displayName: String
var strength: CGFloat
var hasEffect: Bool
```

### GentleSurfaceBackgroundStyle (enum: Codable, Sendable, Equatable)
```
Cases: solid(colorRole: GentleColorRole)
       material(material: GentleAppleMaterial, tintColorRole: GentleColorRole?, tintOpacity: Double)
       glass(fallbackMaterial: GentleAppleMaterial?, fallbackColorRole: GentleColorRole)

var displayName: String
var isGlass: Bool
var isSolid: Bool
```

### GentleSurfaceRoleSpec (struct: Codable, Sendable, Equatable)
```
var backgroundStyle: GentleSurfaceBackgroundStyle
var surfaceDepthEffect: GentleSurfaceDepthEffect
var border: GentleColorPair
var cornerRadius: Double
var borderWidth: Double
var shadowRadius: Double
var shadowOpacity: Double
var shadowOffsetX: Double
var shadowOffsetY: Double

init(backgroundStyle:surfaceDepthEffect:border:cornerRadius:borderWidth:shadowRadius:shadowOpacity:shadowOffsetX:shadowOffsetY:)
```

### GentleSurfaceTokens (struct: Codable, Sendable)
```
var roles: [String: GentleSurfaceRoleSpec]

init(roles:)
func roleSpec(for role: GentleSurfaceRole) -> GentleSurfaceRoleSpec

static let gentleDefault: GentleSurfaceTokens
static let classic: GentleSurfaceTokens
static let modern: GentleSurfaceTokens
```

---

## GentleDesignModifiers.swift

### GentleTextModifier (ViewModifier)
```
init(role:overrideColorRole:)
func body(content:) -> some View
```

### GentleTextFieldModifier (ViewModifier)
```
init(role:overrideColorRole:chrome:)
func body(content:) -> some View
```

### GentleVisualEffectView (View)
```
init(recipe:colorScheme:)
var body: some View
```

### GentleSurfaceModifier (ViewModifier)
```
init(role:inset:insetVariant:showTappableHint:)
func body(content:) -> some View
```

### GentleBackgroundModifier (ViewModifier)
```
func body(content:) -> some View
```

### GentleInsetModifier (ViewModifier)
```
init(edges:role:variant:)
func body(content:) -> some View
```

### View Extensions
```
func gentleText(_ role: GentleTextRole, colorRole: GentleColorRole?) -> some View
func gentleTextField(_ role: GentleTextRole, colorRole: GentleColorRole?, chrome: GentleTextChrome) -> some View
func gentleSurface(_ role: GentleSurfaceRole, inset: GentleInsetRole?, insetVariant: GentleInsetVariant, showTappableHint: Bool) -> some View
func gentleButton(_ role: GentleButtonRole, expandsHorizontally: Bool, contentAlignment: Alignment) -> some View
func gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape, expandsHorizontally: Bool, contentAlignment: Alignment) -> some View
func gentleButton(_ role: GentleButtonRole, textRole: GentleTextRole, expandsHorizontally: Bool, contentAlignment: Alignment) -> some View
func gentleButton(_ role: GentleButtonRole, shape: GentleButtonShape, textRole: GentleTextRole, expandsHorizontally: Bool, contentAlignment: Alignment) -> some View
func gentleFontWidth(_ width: GentleFontWidthToken?) -> some View
func gentleBackground(_ role: GentleColorRole, ignoresSafeArea: Bool) -> some View
func gentleInset(_ role: GentleInsetRole, variant: GentleInsetVariant) -> some View
func gentleInset(_ edges: Edge.Set, _ role: GentleInsetRole, variant: GentleInsetVariant) -> some View
```

### Color Extensions
```
init(gentleHex hex: String)
```

---

## GentleDesignPersistence.swift

### GentleJSONEncodable (protocol: Encodable)
```
static func makeJSONEncoder() -> JSONEncoder
func encodedJSONData(encoder:) throws -> Data
func encodedJSONString(encoder:) throws -> String
```

### GentleJSONDecodable (protocol: Decodable)
```
static func makeJSONDecoder() -> JSONDecoder
static func fromJSONData(_ data: Data, decoder:) throws -> Self
static func fromJSONString(_ string: String, decoder:) throws -> Self
```

### GentleThemeSpecStore (protocol: Sendable)
```
func loadEditableSpec() throws -> GentleDesignSystemSpec?
func saveEditableSpec(_ spec: GentleDesignSystemSpec) throws
func clearEditableSpec() throws
func loadEditableSpec(forPreset name: String) throws -> GentleDesignSystemSpec?
func saveEditableSpec(_ spec: GentleDesignSystemSpec, forPreset name: String) throws
func clearEditableSpec(forPreset name: String) throws
func hasEditableSpec(forPreset name: String) throws -> Bool
func listSavedPresetNames() throws -> [String]
```

### GentleFileThemeSpecStore (struct: GentleThemeSpecStore, Sendable)
```
let fileName: String
let subdirectory: String?

init(fileName:subdirectory:)
func loadEditableSpec() throws -> GentleDesignSystemSpec?
func saveEditableSpec(_ spec: GentleDesignSystemSpec) throws
func clearEditableSpec() throws
func loadEditableSpec(forPreset name: String) throws -> GentleDesignSystemSpec?
func saveEditableSpec(_ spec: GentleDesignSystemSpec, forPreset name: String) throws
func clearEditableSpec(forPreset name: String) throws
func hasEditableSpec(forPreset name: String) throws -> Bool
func listSavedPresetNames() throws -> [String]
```

### GentleFileThemeSpecStore.StoreError (enum: Error, Sendable)
```
Cases: applicationSupportUnavailable
```

---

## GentleVisualEffect.swift

### GentleVisualEffect (enum: String, Codable, Sendable, CaseIterable, Identifiable)
```
Cases: appBackground, surface, surfaceOverlay

var id: String
var displayName: String
```

### GentleVisualEffectRecipe (struct: Codable, Sendable, Equatable, Identifiable)
```
var id: String
var base: GentleVisualEffectBase
var tint: GentleColorPair?
var specular: GentleSpecularSpec?
var innerEdges: GentleInnerEdgeSpec?

init(id:base:tint:specular:innerEdges:)
```

### GentleVisualEffectBase (enum: Codable, Sendable, Equatable)
```
Cases: solid(GentleColorPair)
       appleMaterial(GentleAppleMaterialSpec)
       blur(GentleBlurSpec)
       glass(GentleGlassSpec)
```

### GentleAppleMaterialSpec (struct: Codable, Sendable, Equatable)
```
var kind: Kind
var opacity: Double

init(kind:opacity:)
```

### GentleAppleMaterialSpec.Kind (enum: String, Codable, Sendable)
```
Cases: ultraThin, thin, regular, thick, ultraThick, bar
```

### GentleBlurSpec (struct: Codable, Sendable, Equatable)
```
var radius: Double
var isBackgroundOnly: Bool
var opacity: Double

init(radius:isBackgroundOnly:opacity:)
```

### GentleGlassSpec (struct: Codable, Sendable, Equatable)
```
var style: Style
var isInteractive: Bool
var tint: GentleColorPair?

init(style:isInteractive:tint:)
```

### GentleGlassSpec.Style (enum: String, Codable, Sendable)
```
Cases: regular, clear, identity
```

### GentleSpecularSpec (struct: Codable, Sendable, Equatable)
```
var topLeft: Corner?
var topRight: Corner?
var bottomLeft: Corner?
var bottomRight: Corner?
var rimStrokeOpacity: Double
var rimStrokeWidth: Double

init(topLeft:topRight:bottomLeft:bottomRight:rimStrokeOpacity:rimStrokeWidth:)
```

### GentleSpecularSpec.Corner (struct: Codable, Sendable, Equatable)
```
var opacity: Double
var radius: Double
var blur: Double
var color: GentleColorPair

init(opacity:radius:blur:color:)
```

### GentleInnerEdgeSpec (struct: Codable, Sendable, Equatable)
```
var highlightOpacity: Double
var shadowOpacity: Double
var inset: Double
var blur: Double

init(highlightOpacity:shadowOpacity:inset:blur:)
```

---

## GentleDesignSystemSpec+Presets.swift

### GentleThemePreset (struct)
```
let name: String
let summary: String
let description: String
let purpose: String
let systemImageString: String
let spec: GentleDesignSystemSpec
```

### GentleDesignSystemSpec Extensions
```
static let allPresets: [GentleThemePreset]
```

---

## GentleThemeEditor.swift

### GentleThemeEditor (View)
```
init(isTitleEditable:)
var body: some View
```

### GentleDesignColorsSection (View)
```
init()
var body: some View
```

### GentleDesignTypographySection (View)
```
var body: some View
```

### GentleDesignButtonsSection (View)
```
var body: some View
```

### GentleDesignSurfacesSection (View)
```
var body: some View
```

---

## ColorRoleEditor.swift

### ColorRoleCell (View)
```
init(role:isEditing:)
var body: some View
```

### ColorRoleEditorSheet (View)
```
init(role:isPresented:)
var body: some View
```

---

## TypographyRoleEditor.swift

### TypographyRoleCell (View)
```
init(role:isEditing:)
var body: some View
```

### TypographyRoleEditorSheet (View)
```
init(role:isPresented:)
var body: some View
```

---

## GentleDesignStudioView.swift

### GentleDesignStudioView (View)
```
init(isTitleEditable:embedInNavigationStack:)
var body: some View
```

---

## GentleDesignCustomizeView.swift

### GentleCustomizeSection (enum: String, CaseIterable)
```
Cases: colors, typography, buttons, surfaces

var title: String
```

### GentleDesignCustomizeView (View)
```
init(section:isInsideNavigationStack:onSave:)
var body: some View
```

---

## GentleDesignShareSheet.swift

### GentleDesignShareSheet (UIViewControllerRepresentable)
```
let items: [Any]

init(items:)
func makeUIViewController(context:) -> UIActivityViewController
func updateUIViewController(_:context:)
```

---

## GentleUIKitTheming.swift

### GentleUIKitTheming (enum)
```
@MainActor static func applyNavigationBarTitleStyle(theme:textRole:colorRole:)
```

### GentleNavigationBarStyler (View)
```
init()
var body: some View
```

---

## GentlePDFExporter.swift

### GentlePDFExportError (enum: Error, LocalizedError)
```
Cases: failedToCreatePDF, failedToWriteFile(Error)

var errorDescription: String?
```

### GentlePDFExporter (enum)
```
static func generatePDFData(for spec: GentleDesignSystemSpec, themeName: String?) throws -> Data
static func exportPDFURL(for spec: GentleDesignSystemSpec, themeName: String?) throws -> URL
```

---

## String+camelCaseBreakable.swift

### String Extensions
```
var camelCaseBreakable: String
```
