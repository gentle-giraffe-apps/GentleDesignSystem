<img align="right" src="README_assets/typography_light.gif#gh-light-mode-only" width="360" />
<img align="right" src="README_assets/typography_dark.gif#gh-dark-mode-only" width="360" />

<img src="README_assets/GentleDesignSystem.png" width="400" />

[![CI](https://github.com/gentle-giraffe-apps/GentleDesignSystem/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/gentle-giraffe-apps/GentleDesignSystem/actions/workflows/ci.yml)
[![Coverage](https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem/branch/main/graph/badge.svg)](https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem)
[![Swift](https://img.shields.io/badge/Swift-6.1+-orange.svg)](https://swift.org)
![iOS](https://img.shields.io/badge/iOS-18.0+-blue?logo=apple)
![Platform](https://img.shields.io/badge/Platform-iPhone%20%7C%20iPad-lightgrey)
![SPM](https://img.shields.io/badge/SPM-Compatible-success)
[![DeepSource Static Analysis](https://img.shields.io/badge/DeepSource-Static%20Analysis-0A2540?logo=deepsource&logoColor=white)](https://deepsource.io/)
[![DeepSource](https://app.deepsource.com/gh/gentle-giraffe-apps/GentleDesignSystem.svg/?label=active+issues&show_trend=true)](https://app.deepsource.com/gh/gentle-giraffe-apps/GentleDesignSystem/)
![Commit activity](https://img.shields.io/github/commit-activity/y/gentle-giraffe-apps/GentleDesignSystem)
![Last commit](https://img.shields.io/github/last-commit/gentle-giraffe-apps/GentleDesignSystem)

> 🌍 **Idioma** · Documentación canónica en inglés · [English](../README.md) · [Português (Brasil)](README.pt-BR.md) · [日本語](README.ja.md)

### Resumen

Estandariza rápidamente texto, botones y superficies con un sistema de diseño unificado.

```swift
Text("Modificadores simples")
    .gentleText(.title_xl)

Button("En toda tu aplicación") { }
    .gentleButton(.primary)

VStack {
    Text("Ahorra mucho tiempo")
}
.gentleSurface(.card)
```

### Diseñado para

Aplicaciones que desean una base sólida en SwiftUI con evolución temática a largo plazo.

💬 **[Únete a la discusión. Comentarios y preguntas son bienvenidos](https://github.com/gentle-giraffe-apps/GentleDesignSystem/discussions)**

<img src="README_assets/Typography1.png" width="500" />

**Véalo en acción:** Abre `Demo/GentleDesignSystemDemo.xcodeproj` para explorar los componentes. La aplicación de demostración también permite editar y compartir especificaciones JSON mediante la hoja de compartir del sistema.

---

## Inicio Rápido

### 1. Agrega el Paquete

```swift
.package(url: "https://github.com/gentle-giraffe-apps/GentleDesignSystem.git", from: "0.1.7")
```

### 2. Envuelve la Raíz de tu Aplicación

```swift
import GentleDesignSystem

@main
struct MiApp: App {
    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: .default) {
                ContentView()
            }
        }
    }
}
```

### 3. Usa los Componentes

#### Tipografía
```swift
Text("Bienvenido")
    .gentleText(.title_xl)

Text("Descripción")
    .gentleText(.body_m, colorRole: .textSecondary)
```

#### Botones
```swift
Button("Continuar") { }
    .gentleButton(.primary)

Button("Cancelar") { }
    .gentleButton(.secondary)
```

#### Superficies
```swift
VStack {
    Text("Contenido de la tarjeta")
}
.gentleSurface(.card)
```

---

## Calidad y Herramientas

<details>
  <summary><strong>Detalles de CI, análisis estático y cobertura</strong></summary>

  Este proyecto aplica controles de calidad mediante CI y análisis estático:

  - **CI:** Todos los commits a `main` deben pasar las verificaciones de GitHub Actions
  - **Análisis estático:** DeepSource se ejecuta en cada commit
  - **Cobertura de pruebas:** Codecov reporta la cobertura de líneas

  <sub><strong>Captura de Codecov</strong></sub><br/>
  <a href="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem">
    <img src="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem/graphs/icicle.svg" height="72" />
  </a>

</details>

---

## Descripción General de la Arquitectura

GentleDesignSystem está estructurado intencionalmente alrededor de **tres capas**:

1. **Definiciones de Tokens (Codable, compatible con JSON)**
2. **Resolución en Tiempo de Ejecución (Tema + Environment)**
3. **Ergonomía de SwiftUI (Modificadores y Extensiones)**

Esta separación mantiene la intención de diseño clara, el comportamiento en tiempo de ejecución predecible y la evolución futura segura.

<details>
  <summary><strong>Arquitectura del Sistema (diagrama)</strong></summary>

  ```mermaid
  flowchart TB
      subgraph Tokens["Capa de Tokens (Tiempo de Diseño)"]
          Spec[GentleDesignSystemSpec]
          Spec --> Colors[GentleColorTokens]
          Spec --> Typography[GentleTypographyTokens]
          Spec --> Layout[GentleLayoutTokens]
          Spec --> Visual[GentleVisualTokens]
          Spec --> Buttons[GentleButtonTokens]
          Spec --> Surfaces[GentleSurfaceTokens]
      end

      subgraph Runtime["Capa de Tiempo de Ejecución"]
          Theme[GentleTheme]
          Manager[GentleThemeManager]
          Store[GentleFileThemeSpecStore]
          Manager --> Theme
          Store -.->|cargar/guardar| Manager
      end

      subgraph SwiftUI["Capa de SwiftUI"]
          Root[GentleThemeRoot]
          Env[Environment Values .gentleTheme]
          Modifiers[Modificadores de Vista]
          Root --> Env
          Env --> Modifiers
      end

      Tokens --> Runtime
      Runtime --> SwiftUI
  ```
</details>

<details>
  <summary><strong>Flujo de Datos (diagrama)</strong></summary>

  ```mermaid
  flowchart TB
      JSON[(Archivo JSON)] -->|cargar| Store[GentleFileThemeSpecStore]
      Store --> Manager[GentleThemeManager]
      Manager --> Theme[GentleTheme]
      Theme --> Resolve{Resolución}

      Resolve -->|ColorScheme| ResolvedColor[Color]
      Resolve -->|ContentSizeCategory| ResolvedFont[Fuente]

      ResolvedColor --> View[Vista SwiftUI]
      ResolvedFont --> View

      View -->|.gentleText| Text
      View -->|.gentleButton| Button
      View -->|.gentleSurface| Surface
  ```
</details>

<details>
  <summary><strong>Modelo de Datos (estructura de la especificación)</strong></summary>

  El sistema de diseño está definido por una única especificación compatible con JSON
  (`GentleDesignSystemSpec`).

  ```text
  GentleDesignSystemSpec
│
├── colors: GentleColorTokens
│       │
│       └── pairByRole: [String: GentleColorPair]
│               │
│               ├── clave = GentleColorRole.rawValue
│               └── valor = GentleColorPair
│                       ├── lightHex: String
│                       └── darkHex:  String
│
├── typography: GentleTypographyTokens
│       │
│       └── roles: [String: GentleTypographyRoleSpec]
│               │
│               ├── clave = GentleTextRole.rawValue
│               └── valor = GentleTypographyRoleSpec
│                       ├── pointSize: Double
│                       ├── weight: GentleFontWeightToken
│                       ├── design: GentleFontDesignToken
│                       ├── width:  GentleFontWidthToken?
│                       ├── relativeTo: GentleFontTextStyle
│                       ├── lineSpacing: Double
│                       ├── letterSpacing: Double
│                       ├── isUppercased: Bool
│                       └── colorRole: GentleColorRole
│
├── layout: GentleLayoutTokens
│       │
│       ├── scale: GentleSpacingScaleTokens
│       │       ├── xs / s / m / l / xl / xxl : Double
│       │       └── value(for: GentleSpacingToken) -> Double
│       │
│       ├── gap:   GentleGapTokens
│       ├── grid:  GentleGridSpacingTokens
│       ├── touch: GentleTouchTokens
│       │
│       └── inset: GentleInsetTokens
│               │
│               └── tokensByRole: [String: GentleAxisInsetTokens]
│                       │
│                       ├── clave = GentleInsetRole.rawValue
│                       └── valor = GentleAxisInsetTokens
│                               ├── horizontal: GentleSpacingToken
│                               └── vertical:   GentleSpacingToken
│
├── visual: GentleVisualTokens
│       │
│       ├── radii: GentleRadiusTokens
│       │       ├── small:  Double
│       │       ├── medium: Double
│       │       ├── large:  Double
│       │       └── pill:   Double
│       │
│       └── shadows: GentleShadowTokens
│               ├── none:   Double
│               ├── small:  Double
│               └── medium: Double
│
├── buttons: GentleButtonTokens
│       │
│       ├── roles: [String: GentleButtonRoleSpec]
│       │       │
│       │       ├── clave = GentleButtonRole.rawValue
│       │       └── valor = GentleButtonRoleSpec
│       │               ├── shape: GentleButtonShape
│       │               ├── fillRole: GentleButtonFillRole
│       │               ├── borderRole: GentleButtonBorderRole
│       │               ├── animationRole: GentleButtonAnimationRole
│       │               ├── pressedScale: Double
│       │               ├── pressedOpacity: Double
│       │               └── usesNativeStyle: Bool
│       │
│       └── animations: [String: GentleButtonAnimationSpec]
│               │
│               ├── clave = GentleButtonAnimationRole.rawValue
│               └── valor = GentleButtonAnimationSpec
│                       ├── pressedScale: Double
│                       ├── pressedOpacity: Double
│                       ├── duration: Double
│                       ├── springResponse: Double
│                       ├── springDamping: Double
│                       └── springBlend: Double
│
└── surfaces: GentleSurfaceTokens
        │
        └── roles: [String: GentleSurfaceRoleSpec]
                │
                ├── clave = GentleSurfaceRole.rawValue
                └── valor = GentleSurfaceRoleSpec
                        ├── backgroundStyle: GentleSurfaceBackgroundStyle
                        │       ├── .solid(colorRole: GentleColorRole)
                        │       ├── .material(material:, tintColorRole:, tintOpacity:)
                        │       └── .glass(fallbackMaterial:, fallbackColorRole:)
                        ├── surfaceDepthEffect: GentleSurfaceDepthEffect
                        ├── border: GentleColorPair
                        ├── cornerRadius: Double
                        ├── borderWidth: Double
                        ├── shadowRadius: Double
                        ├── shadowOpacity: Double
                        ├── shadowOffsetX: Double
                        └── shadowOffsetY: Double
  ```
</details>

> **¿Por qué roles en lugar de valores directos?**
> Los roles proporcionan identificadores estables que permiten que los temas evolucionen de manera segura con el tiempo.
> Las especificaciones pueden cambiar, los presets pueden intercambiarse y los valores pueden sobrescribirse sin
> romper los sitios de llamada o los temas serializados.

---

## 1. Capa de Tokens (Tiempo de Diseño)

La capa de tokens define *qué* significa tu sistema de diseño — no cómo se renderiza.

### Categorías de Tokens

| Categoría | Tipos |
|-----------|-------|
| **Tipografía** | `GentleTextRole`, `GentleTypographyRoleSpec`, `GentleTypographyTokens` |
| **Colores** | `GentleColorRole`, `GentleColorPair`, `GentleColorTokens` |
| **Layout** | `GentleLayoutTokens`, `GentleSpacingToken`, `GentleGapTokens`, `GentleInsetTokens` |
| **Visual** | `GentleVisualTokens`, `GentleRadiusTokens`, `GentleShadowTokens` |
| **Botones** | `GentleButtonRole`, `GentleButtonRoleSpec`, `GentleButtonTokens`, `GentleButtonAnimationRole` |
| **Superficies** | `GentleSurfaceRole`, `GentleSurfaceRoleSpec`, `GentleSurfaceTokens` |

<details>
  <summary><strong>Garantías de tokens y especificación base</strong></summary>

  Todos los tokens son:
  - `Codable`
  - `Sendable`
  - Compatibles con JSON

  Esto facilita:
  - Persistir temas
  - Cargar temas remotamente
  - Compartir tokens entre plataformas más adelante

  ```swift
public struct GentleDesignSystemSpec: Codable, Sendable {
    public var specVersion: String
    public var colors: GentleColorTokens
    public var typography: GentleTypographyTokens
    public var layout: GentleLayoutTokens
    public var visual: GentleVisualTokens
    public var buttons: GentleButtonTokens
    public var surfaces: GentleSurfaceTokens
}
  ```
</details>

El tema predeterminado (`.default`) es simplemente una especificación concreta.

---

## 2. Capa de Tiempo de Ejecución (Resolución de Tema)

En tiempo de ejecución, los tokens se resuelven en **valores reales de SwiftUI**.

### GentleTheme

`GentleTheme`:
- Posee un `GentleDesignSystemSpec`
- Resuelve:
  - Colores según `ColorScheme`
  - Fuentes según `ContentSizeCategory` (Tipo Dinámico)

```swift
@Environment(\.gentleTheme) var theme
```

La resolución de tipografía usa `UIFontMetrics` para escalar correctamente los tamaños de fuente personalizados mientras permanecen anclados a los estilos de texto semánticos de Apple.

Esto asegura:
- El escalado de accesibilidad funciona correctamente
- Los tamaños de punto personalizados permanecen proporcionales
- Los cambios futuros de Tipo Dinámico permanecen seguros

### Property Wrappers

<details>
  <summary><strong>Ayudantes de acceso en tiempo de ejecución</strong></summary>

  ```swift
// Acceder a valores de tema resueltos
@GentleDesignRuntime private var design

// Usar en la vista
design.color(.textPrimary)    // Color para el esquema actual
design.layout.stack.regular   // Valor CGFloat de espaciado
design.buttons                // Tokens de botones
  ```
</details>

---

## 3. Inyección de Environment

### Por qué Existe `GentleThemeRoot`

Los environments de SwiftUI fluyen **de arriba hacia abajo**.

Al envolver la raíz de tu aplicación con:

```swift
GentleThemeRoot {
    ContentView()
}
```

aseguras que:

- Todas las vistas hijas reciben el mismo tema
- Las previsualizaciones se comportan consistentemente
- Las sobrescrituras de tema son fáciles después (por escena, por funcionalidad, por previsualización)

`GentleThemeRoot` es intencionalmente ligero — solo inyecta un único valor de environment.

Esto evita:
- Singletons globales
- Estado estático
- Magia implícita

---

## 4. Modificadores y Extensiones de Vista

GentleDesignSystem expone APIs ergonómicas mientras mantiene la lógica centralizada.

<details>
  <summary><strong>Modificadores de texto</strong></summary>

  ```swift
Text("Hola")
    .gentleText(.headline_m)
  ```

  Internamente:
  - Resuelve la tipografía mediante `GentleTheme`
  - Aplica fuente, ancho, diseño, espaciado, color
  - Respeta el Tipo Dinámico automáticamente

</details>

<details>
  <summary><strong>Superficies</strong></summary>

  ```swift
  VStack { ... }
    .gentleSurface(.card)
  ```

  Las superficies aplican:
  - Color de fondo
  - Padding (cuando es apropiado)
  - Radio de esquinas
  - Bordes o sombras

  La API basada en roles evita que los "números mágicos" se filtren en las vistas.

</details>

<details>
  <summary><strong>Botones</strong></summary>

  ```swift
Button("Guardar") { }
    .gentleButton(.primary)
  ```

  Los botones son:
  - Estilizados mediante `ButtonStyle`
  - Completamente controlados por el tema
  - Soportan animaciones configurables
  - Fácilmente extensibles para nuevos roles

</details>

---

## 5. Gestión y Persistencia de Temas

<details>
  <summary><strong>Edición en tiempo de ejecución, persistencia y almacenes</strong></summary>

  **GentleThemeManager**

  ```swift
@main
struct MiApp: App {
    @State private var manager = GentleThemeManager(theme: .default)

    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: manager.theme) {
                ContentView()
            }
            .environment(\.gentleThemeManager, manager)
        }
    }
}
  ```

  **Usando el Manager**

  ```swift
@GentleThemeManagerRuntime private var manager

// Guardar el tema actual en disco
try manager.save()

// Cargar tema persistido
try manager.load()

// Obtener bindings para edición
manager.typographyBinding(for: .body_m)
manager.colorBinding(for: .primaryCTA)
  ```

  **Persistencia**

  `GentleFileThemeSpecStore` maneja la persistencia JSON en Application Support:

  ```swift
let store = GentleFileThemeSpecStore(fileName: "mi-tema.json")
let manager = GentleThemeManager(theme: .default, store: store)
  ```

</details>

---

## 6. Presets de Temas

GentleDesignSystem incluye 9 presets de temas integrados, cada uno diseñado para diferentes casos de uso y estéticas.

<details>
  <summary><strong>Presets de temas disponibles</strong></summary>

  ```swift
// Obtener todos los presets disponibles
let presets = GentleDesignSystemSpec.allPresets

// Cada preset proporciona:
// - name: Nombre para mostrar (ej., "Gentle Default")
// - summary: Eslogan breve
// - description: Explicación detallada
// - purpose: Cuándo usar este preset
// - systemImageString: Nombre del SF Symbol para la UI
// - spec: El GentleDesignSystemSpec real
  ```

| Preset | Resumen | Mejor Para |
|--------|---------|------------|
| **Gentle Default** | Base calmada y equilibrada | Punto de partida versátil con jerarquía limpia |
| **Classic Tan** | Cálido, atemporal con tonos terrosos | Apps que se benefician de calidez y herencia |
| **Modern Gray** | Elegante, minimalista con bases neutras | Apps de negocios donde la claridad es primordial |
| **Soft Green** | Fresco, natural con acentos calmantes | Bienestar, productividad, enfoque tranquilo |
| **Editorial Paper** | Refinado, inspirado en imprenta para lectura | Apps con mucho contenido, lectura de formato largo |
| **Technical Blue** | Preciso, confiable con toques azules | Herramientas de desarrollo, dashboards |
| **Bold Orange** | Vibrante, energético con fuerte presencia | Apps que motivan a la acción |
| **Elegant Purple** | Sofisticado, lujoso con tonos ricos | Apps de estilo de vida, creatividad, premium |
| **Compact Mint** | Denso, eficiente con acentos frescos | Interfaces ricas en datos |

</details>

### Usando Presets

```swift
// Aplicar un preset a tu theme manager
@GentleThemeManagerRuntime private var manager

// Encontrar y aplicar un preset
if let editorialPreset = GentleDesignSystemSpec.allPresets.first(where: { $0.name == "Editorial Paper" }) {
    manager.theme.editableSpec = editorialPreset.spec
}
```

### Construyendo un Selector de Temas

La aplicación de demostración incluye un `ThemePickerView` que muestra todos los presets como tarjetas interactivas. Cada tarjeta previsualiza la tipografía y colores del preset usando el propio tema del preset:

<details>
  <summary><strong>Construyendo un selector de temas</strong></summary>

  ```swift
ForEach(presets, id: \.name) { preset in
    let previewTheme = GentleTheme(
        defaultSpec: preset.spec,
        editableSpec: preset.spec
    )

    Button {
        themeManager.theme.editableSpec = preset.spec
    } label: {
        GentleThemeRoot(theme: previewTheme) {
            // El contenido de la tarjeta se renderiza con el estilo propio del preset
            ThemePresetCard(preset: preset)
        }
    }
}
  ```

</details>


---

## Tokens Disponibles

<details>
  <summary><strong>Roles de tipografía</strong></summary>

  <br/>
  17 roles de texto semánticos organizados por rampa de tamaño (xxl > xl > l > ml > m > ms > s):
  <br/>

| Rampa | Roles |
|-------|-------|
| XXL | `largeTitle_xxl` |
| XL | `title_xl` |
| L | `title2_l` |
| ML | `title3_ml` |
| M | `headline_m`, `body_m`, `bodySecondary_m`, `monoCode_m`, `primaryButtonTitle_m`, `secondaryButtonTitle_m`, `tertiaryButtonTitle_m`, `quaternaryButtonTitle_m` |
| MS | `callout_ms`, `subheadline_ms` |
| S | `footnote_s`, `caption_s`, `caption2_s` |

  Cada rol se resuelve a un `GentleTypographyRoleSpec` que contiene: `pointSize`, `weight`, `design`, `width`, `relativeTo`, `lineSpacing`, `letterSpacing`, `isUppercased` y `colorRole`.

</details>


<details>
  <summary><strong>Roles de botones y animaciones</strong></summary>

  **Roles de Botones**

  `primary` · `secondary` · `tertiary` · `quaternary` · `destructive`

  **Animaciones de Botones**

| Animación | Descripción |
|-----------|-------------|
| `unknown` | Sin animación |
| `subtlePress` | Retroalimentación sutil al presionar |
| `squish` | Efecto de aplastamiento al presionar |
| `pop` | Efecto de salto |
| `bouncy` | Animación de resorte rebotante |
| `springBack` | Se encoge al presionar, rebota más allá del tamaño original antes de estabilizarse |

</details>

<details>
  <summary><strong>Roles de superficies</strong></summary>
  `appBackground` · `card` · `cardElevated` · `cardSecondary` · `chrome` · `overlaySheet` · `overlayPopover` · `overlayScrim` · `floatingPanel` · `floatingWidget`
</details>


<details>
  <summary><strong>Roles de colores</strong></summary>

| Categoría | Roles |
|-----------|-------|
| Texto (9) | `textPrimary`, `textSecondary`, `textTertiary`, `textOnPrimaryCTA`, `textOnDestructive`, `textOnOverlay`, `textOnOverlaySecondary`, `textOnScrim`, `textOnScrimSecondary` |
| Superficies (6) | `background`, `surfaceBase`, `surfaceCardSecondary`, `surfaceTint`, `surfaceScrim`, `borderSubtle` |
| Acciones (2) | `primaryCTA`, `destructive` |
| Tema (2) | `themePrimary`, `themeSecondary` |

Usa agrupaciones semánticas: `GentleColorRole.textRoles`, `.surfaceRoles`, `.actionRoles`, `.themeRoles`
Usa verificaciones de membresía: `role.isTextRole`, `.isSurfaceRole`, `.isActionRole`, `.isThemeRole`

</details>

<details>
  <summary><strong>Tokens de espaciado y radio</strong></summary>

  **Tokens de Espaciado**
  `xs` (4) · `s` (8) · `m` (12) · `l` (16) · `xl` (24) · `xxl` (32)


  **Tokens de Radio**
  `small` (8) · `medium` (12) · `large` (20) · `pill` (999)

</details>

---

## Requisitos

- iOS 18.0+
- Swift 6.1+

---

## Nota sobre Herramientas

Partes de la redacción y refinamiento editorial en este repositorio fueron aceleradas usando modelos de lenguaje grandes (incluyendo ChatGPT, Claude y Gemini) bajo diseño humano directo, validación y aprobación final. Todas las decisiones técnicas, código y conclusiones arquitectónicas son autoría y verificación del mantenedor del repositorio.

![Visitantes](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fgentle-giraffe-apps%2FGentleDesignSystem)
