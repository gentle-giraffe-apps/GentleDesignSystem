# Common Tasks

Step-by-step guides for common modifications.

---

## Adding Tokens

### Add a New Color Role

**Files to modify:** `GentleDesignSystem.swift`

1. Add case to `GentleColorRole` enum:
   ```swift
   public enum GentleColorRole: String, Codable, Sendable, CaseIterable, Identifiable {
       // ... existing cases ...
       case myNewColor  // ← add here
   }
   ```

2. Add `displayName` in the extension:
   ```swift
   public var displayName: String {
       switch self {
       // ... existing cases ...
       case .myNewColor: return "My New Color"
       }
   }
   ```

3. Add default value in `GentleColorTokens.gentleDefault`:
   ```swift
   GentleColorRole.myNewColor.rawValue: .init(lightHex: "#000000", darkHex: "#FFFFFF"),
   ```

4. Bump `GentleDesignSystemSpecVersion.current` if this is a breaking change.

---

### Add a New Typography Role

**Files to modify:** `GentleDesignSystem.swift`

1. Add case to `GentleTextRole` enum:
   ```swift
   public enum GentleTextRole: String, Identifiable, Codable, Sendable, CaseIterable {
       // ... existing cases ...
       case myNewRole_m  // ← follow naming convention: {semantic}_{ramp}
   }
   ```

2. Add ramp mapping in extension:
   ```swift
   public var ramp: GentleTextRamp {
       switch self {
       // ... existing cases ...
       case .myNewRole_m: return .m
       }
   }
   ```

3. Add `displayName` in extension:
   ```swift
   public var displayName: String {
       switch self {
       // ... existing cases ...
       case .myNewRole_m: return "My New Role"
       }
   }
   ```

4. Add spec in `GentleTypographyTokens.gentleDefault`:
   ```swift
   dict[GentleTextRole.myNewRole_m.rawValue] = .init(
       pointSize: 17, weight: .regular, design: .default, width: nil,
       relativeTo: .body, lineSpacing: 2, colorRole: .textPrimary
   )
   ```

5. Bump spec version if breaking.

---

### Add a New Button Role

**Files to modify:** `GentleDesignSystem.swift`

1. Add case to `GentleButtonRole` enum:
   ```swift
   public enum GentleButtonRole: String, Codable, Sendable, Identifiable {
       case primary, secondary, tertiary, quaternary, destructive
       case myNewButton  // ← add here
   }
   ```

2. Add `defaultTextRole` mapping:
   ```swift
   public var defaultTextRole: GentleTextRole {
       switch self {
       // ... existing cases ...
       case .myNewButton: return .primaryButtonTitle_m
       }
   }
   ```

3. Add spec in `GentleButtonTokens.gentleDefault.roles`:
   ```swift
   GentleButtonRole.myNewButton.rawValue: .init(
       shape: .rounded,
       materialRole: .hollow,
       borderRole: .subtle,
       animationRole: .squish,
       pressedScale: 0.97,
       pressedOpacity: 0.9
   ),
   ```

---

### Add a New Surface Role

**Files to modify:** `GentleSurfaceRole.swift`

1. Add case to `GentleSurfaceRole` enum:
   ```swift
   public enum GentleSurfaceRole: String, Codable, Sendable {
       case appBackground, card, cardElevated, surfaceOverlay
       case myNewSurface  // ← add here
   }
   ```

2. Add spec in `GentleSurfaceTokens.gentleDefault.roles`:
   ```swift
   GentleSurfaceRole.myNewSurface.rawValue: .init(
       materialRole: .surface,
       border: GentleColorPair(lightHex: "#E5E7EB", darkHex: "#374151"),
       cornerRadius: 12,
       borderWidth: 1,
       shadowRadius: 4,
       shadowOpacity: 0.1,
       shadowOffsetX: 0,
       shadowOffsetY: 2
   ),
   ```

---

### Add a New Animation Role

**Files to modify:** `GentleDesignSystem.swift`

1. Add case to `GentleButtonAnimationRole` enum:
   ```swift
   public enum GentleButtonAnimationRole: String, Codable, Sendable, CaseIterable {
       // ... existing cases ...
       case myNewAnimation
   }
   ```

2. Add spec in `GentleButtonTokens.gentleDefault.animations`:
   ```swift
   GentleButtonAnimationRole.myNewAnimation.rawValue: .init(
       pressedScale: 0.95, pressedOpacity: 0.9,
       duration: 0.15,
       springResponse: 0.3, springDamping: 0.7, springBlend: 0.0
   ),
   ```

3. Handle in `GentleButtonAnimations.resolve()`:
   ```swift
   case .myNewAnimation:
       return .spring(response: spec.springResponse,
                      dampingFraction: spec.springDamping,
                      blendDuration: spec.springBlend)
   ```

---

## Adding View Modifiers

### Add a New View Modifier

**Files to modify:** `GentleDesignModifiers.swift`

1. Create the modifier struct:
   ```swift
   public struct GentleMyModifier: ViewModifier {
       @Environment(\.gentleTheme) private var theme
       @Environment(\.colorScheme) private var colorScheme

       private let param: SomeType

       public init(param: SomeType) {
           self.param = param
       }

       public func body(content: Content) -> some View {
           content
               // Apply modifications using theme
       }
   }
   ```

2. Add View extension:
   ```swift
   public extension View {
       func gentleMy(_ param: SomeType) -> some View {
           modifier(GentleMyModifier(param: param))
       }
   }
   ```

---

## Working with Presets

### Add a New Theme Preset

**Files to modify:** `GentleDesignSystemSpec+Presets.swift`

1. Create the spec:
   ```swift
   static let myPreset: GentleDesignSystemSpec = .init(
       colors: .init(pairByRole: [
           // ... all color roles ...
       ]),
       typography: .gentleDefault,  // or custom
       layout: .gentleDefault,
       visual: .gentleDefault,
       buttons: .gentleDefault,
       surfaces: .gentleDefault
   )
   ```

2. Add to `allPresets` array:
   ```swift
   public static let allPresets: [GentleThemePreset] = [
       // ... existing presets ...
       .init(
           name: "My Preset",
           summary: "Short tagline",
           description: "Detailed description of the preset.",
           purpose: "When to use this preset.",
           systemImageString: "paintbrush",
           spec: myPreset
       )
   ]
   ```

---

## Testing

### Run All Tests
```bash
swift test
```

### Run Specific Test
```bash
swift test --filter GentleDesignSystemTests
```

### Build Demo App
```bash
cd Demo && bundle exec fastlane ios build
```

---

## Debugging

### Inspect Current Theme as JSON
```swift
let jsonString = try themeManager.theme.spec.encodedJSONString()
print(jsonString)
```

### Check Theme Resolution
```swift
@GentleDesignRuntime private var design

// In view body:
let _ = print("textPrimary: \(design.color(.textPrimary))")
let _ = print("radii.medium: \(design.radii.medium)")
```

### Verify Dynamic Type Scaling
```swift
@Environment(\.sizeCategory) var sizeCategory

let style = theme.textStyle(for: .body_m, sizeCategory: sizeCategory)
// style.font is the scaled font
```

---

## Migration

### Handle Spec Version Changes

When loading old JSON that may have different structure:

1. Check `_specVersion` in JSON
2. Implement custom `init(from decoder:)` with fallbacks
3. See `GentleSurfaceRoleSpec.init(from:)` for migration example (materialRole ← legacy material)

### Bump Spec Version

In `GentleDesignSystem.swift`:
```swift
public enum GentleDesignSystemSpecVersion {
    public static let current = "0.5.0"  // ← increment
}
```

Bump when:
- Adding new token types
- Changing token structure
- Removing tokens (breaking)
