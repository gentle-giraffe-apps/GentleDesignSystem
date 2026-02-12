<img align="right" src="README_assets/typography_light.gif#gh-light-mode-only" width="360" />
<img align="right" src="README_assets/typography_dark.gif#gh-dark-mode-only" width="360" />

<img src="README_assets/GentleDesignSystem.png" width="400" />

[![CI](https://github.com/gentle-giraffe-apps/GentleDesignSystem/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/gentle-giraffe-apps/GentleDesignSystem/actions/workflows/ci.yml)
[![Coverage](https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem/branch/main/graph/badge.svg)](https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem)
[![Swift](https://img.shields.io/badge/Swift-6.1+-orange.svg)](https://swift.org)
![iOS](https://img.shields.io/badge/iOS-18.0+-blue?logo=apple)
![SPM](https://img.shields.io/badge/SPM-Compatible-success)
[![DeepSource Static Analysis](https://img.shields.io/badge/DeepSource-Static%20Analysis-0A2540?logo=deepsource&logoColor=white)](https://deepsource.io/)
[![DeepSource](https://app.deepsource.com/gh/gentle-giraffe-apps/GentleDesignSystem.svg/?label=active+issues&show_trend=true)](https://app.deepsource.com/gh/gentle-giraffe-apps/GentleDesignSystem/)
![Commit activity](https://img.shields.io/github/commit-activity/y/gentle-giraffe-apps/GentleDesignSystem)
![Last commit](https://img.shields.io/github/last-commit/gentle-giraffe-apps/GentleDesignSystem)

> 🌍 **Idioma** · Documentação canônica em inglês · [English](../README.md) · [Español](README.es.md) · [日本語](README.ja.md) · [简体中文](README.zh-CN.md) · [한국어](README.ko.md) · [Русский](README.ru.md)

### Resumo

Padronize rapidamente textos, botões e superfícies com um sistema de design unificado.

```swift
Text("Modificadores simples")
    .gentleText(.title_xl)

Button("Em todo o seu app") { }
    .gentleButton(.primary)

VStack {
    Text("Economize muito tempo")
}
.gentleSurface(.card)
```

### Desenvolvido para

Apps que desejam uma base sólida em SwiftUI com evolução temática a longo prazo.

💬 **[Participe da discussão. Feedback e perguntas são bem-vindos](https://github.com/gentle-giraffe-apps/GentleDesignSystem/discussions)**

<img src="README_assets/Typography1.png" width="500" />

**Veja em ação:** Abra `Demo/GentleDesignSystemDemo.xcodeproj` para explorar os componentes. O app de demonstração também permite editar e compartilhar especificações JSON através da folha de compartilhamento do sistema.

---

## Início Rápido

### 1. Adicione o Pacote

```swift
.package(url: "https://github.com/gentle-giraffe-apps/GentleDesignSystem.git", from: "0.1.7")
```

### 2. Envolva a Raiz do Seu App

```swift
import GentleDesignSystem

@main
struct MeuApp: App {
    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: .default) {
                ContentView()
            }
        }
    }
}
```

### 3. Use os Componentes

#### Tipografia
```swift
Text("Bem-vindo")
    .gentleText(.title_xl)

Text("Descrição")
    .gentleText(.body_m, colorRole: .textSecondary)
```

#### Botões
```swift
Button("Continuar") { }
    .gentleButton(.primary)

Button("Cancelar") { }
    .gentleButton(.secondary)
```

#### Superfícies
```swift
VStack {
    Text("Conteúdo do cartão")
}
.gentleSurface(.card)
```

---

## Qualidade e Ferramentas

<details>
  <summary><strong>Detalhes de CI, análise estática e cobertura</strong></summary>

  Este projeto aplica controles de qualidade via CI e análise estática:

  - **CI:** Todos os commits em `main` devem passar nas verificações do GitHub Actions
  - **Análise estática:** DeepSource é executado em cada commit
  - **Cobertura de testes:** Codecov reporta a cobertura de linhas

  <sub><strong>Snapshot do Codecov</strong></sub><br/>
  <a href="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem">
    <img src="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem/graphs/icicle.svg" height="72" />
  </a>

</details>

---

## Visão Geral da Arquitetura

O GentleDesignSystem é intencionalmente estruturado em torno de **três camadas**:

1. **Definições de Tokens (Codable, compatível com JSON)**
2. **Resolução em Tempo de Execução (Tema + Environment)**
3. **Ergonomia do SwiftUI (Modificadores e Extensões)**

Essa separação mantém a intenção do design clara, o comportamento em tempo de execução previsível e a evolução futura segura.

<details>
  <summary><strong>Arquitetura do Sistema (diagrama)</strong></summary>

  ```mermaid
  flowchart TB
      subgraph Tokens["Camada de Tokens (Tempo de Design)"]
          Spec[GentleDesignSystemSpec]
          Spec --> Colors[GentleColorTokens]
          Spec --> Typography[GentleTypographyTokens]
          Spec --> Layout[GentleLayoutTokens]
          Spec --> Visual[GentleVisualTokens]
          Spec --> Buttons[GentleButtonTokens]
          Spec --> Surfaces[GentleSurfaceTokens]
      end

      subgraph Runtime["Camada de Tempo de Execução"]
          Theme[GentleTheme]
          Manager[GentleThemeManager]
          Store[GentleFileThemeSpecStore]
          Manager --> Theme
          Store -.->|carregar/salvar| Manager
      end

      subgraph SwiftUI["Camada SwiftUI"]
          Root[GentleThemeRoot]
          Env[Environment Values .gentleTheme]
          Modifiers[Modificadores de View]
          Root --> Env
          Env --> Modifiers
      end

      Tokens --> Runtime
      Runtime --> SwiftUI
  ```
</details>

<details>
  <summary><strong>Fluxo de Dados (diagrama)</strong></summary>

  ```mermaid
  flowchart TB
      JSON[(Arquivo JSON)] -->|carregar| Store[GentleFileThemeSpecStore]
      Store --> Manager[GentleThemeManager]
      Manager --> Theme[GentleTheme]
      Theme --> Resolve{Resolução}

      Resolve -->|ColorScheme| ResolvedColor[Cor]
      Resolve -->|ContentSizeCategory| ResolvedFont[Fonte]

      ResolvedColor --> View[View SwiftUI]
      ResolvedFont --> View

      View -->|.gentleText| Text
      View -->|.gentleButton| Button
      View -->|.gentleSurface| Surface
  ```
</details>

<details>
  <summary><strong>Modelo de Dados (estrutura da especificação)</strong></summary>

  O sistema de design é definido por uma única especificação compatível com JSON
  (`GentleDesignSystemSpec`).

  ```text
  GentleDesignSystemSpec
│
├── colors: GentleColorTokens
│       │
│       └── pairByRole: [String: GentleColorPair]
│               │
│               ├── chave = GentleColorRole.rawValue
│               └── valor = GentleColorPair
│                       ├── lightHex: String
│                       └── darkHex:  String
│
├── typography: GentleTypographyTokens
│       │
│       └── roles: [String: GentleTypographyRoleSpec]
│               │
│               ├── chave = GentleTextRole.rawValue
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
│                       ├── chave = GentleInsetRole.rawValue
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
│       │       ├── chave = GentleButtonRole.rawValue
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
│               ├── chave = GentleButtonAnimationRole.rawValue
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
                ├── chave = GentleSurfaceRole.rawValue
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

> **Por que roles em vez de valores diretos?**
> Os roles fornecem identificadores estáveis que permitem que os temas evoluam com segurança ao longo do tempo.
> As especificações podem mudar, os presets podem ser trocados e os valores podem ser sobrescritos sem
> quebrar os pontos de chamada ou os temas serializados.

---

## 1. Camada de Tokens (Tempo de Design)

A camada de tokens define *o que* seu sistema de design significa — não como ele é renderizado.

### Categorias de Tokens

| Categoria | Tipos |
|-----------|-------|
| **Tipografia** | `GentleTextRole`, `GentleTypographyRoleSpec`, `GentleTypographyTokens` |
| **Cores** | `GentleColorRole`, `GentleColorPair`, `GentleColorTokens` |
| **Layout** | `GentleLayoutTokens`, `GentleSpacingToken`, `GentleGapTokens`, `GentleInsetTokens` |
| **Visual** | `GentleVisualTokens`, `GentleRadiusTokens`, `GentleShadowTokens` |
| **Botões** | `GentleButtonRole`, `GentleButtonRoleSpec`, `GentleButtonTokens`, `GentleButtonAnimationRole` |
| **Superfícies** | `GentleSurfaceRole`, `GentleSurfaceRoleSpec`, `GentleSurfaceTokens` |

<details>
  <summary><strong>Garantias de tokens e especificação base</strong></summary>

  Todos os tokens são:
  - `Codable`
  - `Sendable`
  - Compatíveis com JSON

  Isso facilita:
  - Persistir temas
  - Carregar temas remotamente
  - Compartilhar tokens entre plataformas posteriormente

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

O tema padrão (`.default`) é simplesmente uma especificação concreta.

---

## 2. Camada de Tempo de Execução (Resolução de Tema)

Em tempo de execução, os tokens são resolvidos em **valores reais do SwiftUI**.

### GentleTheme

`GentleTheme`:
- Possui um `GentleDesignSystemSpec`
- Resolve:
  - Cores por `ColorScheme`
  - Fontes por `ContentSizeCategory` (Tipo Dinâmico)

```swift
@Environment(\.gentleTheme) var theme
```

A resolução de tipografia usa `UIFontMetrics` para escalar corretamente os tamanhos de fonte personalizados enquanto permanecem ancorados aos estilos de texto semânticos da Apple.

Isso garante:
- O escalonamento de acessibilidade funciona corretamente
- Os tamanhos de ponto personalizados permanecem proporcionais
- Mudanças futuras no Tipo Dinâmico permanecem seguras

### Property Wrappers

<details>
  <summary><strong>Auxiliares de acesso em tempo de execução</strong></summary>

  ```swift
// Acessar valores de tema resolvidos
@GentleDesignRuntime private var design

// Usar na view
design.color(.textPrimary)    // Cor para o esquema atual
design.layout.stack.regular   // Valor CGFloat de espaçamento
design.buttons                // Tokens de botões
  ```
</details>

---

## 3. Injeção de Environment

### Por que `GentleThemeRoot` Existe

Os environments do SwiftUI fluem **de cima para baixo**.

Ao envolver a raiz do seu app com:

```swift
GentleThemeRoot {
    ContentView()
}
```

você garante que:

- Todas as views filhas recebem o mesmo tema
- As previews se comportam consistentemente
- As sobrescritas de tema são fáceis depois (por cena, por funcionalidade, por preview)

`GentleThemeRoot` é intencionalmente leve — ele apenas injeta um único valor de environment.

Isso evita:
- Singletons globais
- Estado estático
- Mágica implícita

---

## 4. Modificadores e Extensões de View

O GentleDesignSystem expõe APIs ergonômicas enquanto mantém a lógica centralizada.

<details>
  <summary><strong>Modificadores de texto</strong></summary>

  ```swift
Text("Olá")
    .gentleText(.headline_m)
  ```

  Internamente:
  - Resolve a tipografia via `GentleTheme`
  - Aplica fonte, largura, design, espaçamento, cor
  - Respeita o Tipo Dinâmico automaticamente

</details>

<details>
  <summary><strong>Superfícies</strong></summary>

  ```swift
  VStack { ... }
    .gentleSurface(.card)
  ```

  As superfícies aplicam:
  - Cor de fundo
  - Padding (quando apropriado)
  - Raio de cantos
  - Bordas ou sombras

  A API baseada em roles evita que "números mágicos" vazem para as views.

</details>

<details>
  <summary><strong>Botões</strong></summary>

  ```swift
Button("Salvar") { }
    .gentleButton(.primary)
  ```

  Os botões são:
  - Estilizados via `ButtonStyle`
  - Completamente controlados pelo tema
  - Suportam animações configuráveis
  - Facilmente extensíveis para novos roles

</details>

---

## 5. Gerenciamento e Persistência de Temas

<details>
  <summary><strong>Edição em tempo de execução, persistência e stores</strong></summary>

  **GentleThemeManager**

  ```swift
@main
struct MeuApp: App {
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

  **Usando o Manager**

  ```swift
@GentleThemeManagerRuntime private var manager

// Salvar o tema atual no disco
try manager.save()

// Carregar tema persistido
try manager.load()

// Obter bindings para edição
manager.typographyBinding(for: .body_m)
manager.colorBinding(for: .primaryCTA)
  ```

  **Persistência**

  `GentleFileThemeSpecStore` gerencia a persistência JSON no Application Support:

  ```swift
let store = GentleFileThemeSpecStore(fileName: "meu-tema.json")
let manager = GentleThemeManager(theme: .default, store: store)
  ```

</details>

---

## 6. Presets de Temas

O GentleDesignSystem inclui 9 presets de temas integrados, cada um projetado para diferentes casos de uso e estéticas.

<details>
  <summary><strong>Presets de temas disponíveis</strong></summary>

  ```swift
// Obter todos os presets disponíveis
let presets = GentleDesignSystemSpec.allPresets

// Cada preset fornece:
// - name: Nome de exibição (ex., "Gentle Default")
// - summary: Slogan breve
// - description: Explicação detalhada
// - purpose: Quando usar este preset
// - systemImageString: Nome do SF Symbol para a UI
// - spec: O GentleDesignSystemSpec real
  ```

| Preset | Resumo | Melhor Para |
|--------|--------|-------------|
| **Gentle Default** | Base calma e equilibrada | Ponto de partida versátil com hierarquia limpa |
| **Classic Tan** | Quente, atemporal com tons terrosos | Apps que se beneficiam de calor e tradição |
| **Modern Gray** | Elegante, minimalista com bases neutras | Apps de negócios onde clareza é primordial |
| **Soft Green** | Fresco, natural com acentos calmantes | Bem-estar, produtividade, foco tranquilo |
| **Editorial Paper** | Refinado, inspirado em impressão para leitura | Apps com muito conteúdo, leitura de formato longo |
| **Technical Blue** | Preciso, confiável com toques azuis | Ferramentas de desenvolvimento, dashboards |
| **Bold Orange** | Vibrante, energético com forte presença | Apps que motivam ação |
| **Elegant Purple** | Sofisticado, luxuoso com tons ricos | Apps de estilo de vida, criatividade, premium |
| **Compact Mint** | Denso, eficiente com acentos frescos | Interfaces ricas em dados |

</details>

### Usando Presets

```swift
// Aplicar um preset ao seu theme manager
@GentleThemeManagerRuntime private var manager

// Encontrar e aplicar um preset
if let editorialPreset = GentleDesignSystemSpec.allPresets.first(where: { $0.name == "Editorial Paper" }) {
    manager.theme.editableSpec = editorialPreset.spec
}
```

### Construindo um Seletor de Temas

O app de demonstração inclui um `ThemePickerView` que exibe todos os presets como cartões interativos. Cada cartão pré-visualiza a tipografia e cores do preset usando o próprio tema do preset:

<details>
  <summary><strong>Construindo um seletor de temas</strong></summary>

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
            // O conteúdo do cartão é renderizado com o estilo próprio do preset
            ThemePresetCard(preset: preset)
        }
    }
}
  ```

</details>


---

## Tokens Disponíveis

<details>
  <summary><strong>Roles de tipografia</strong></summary>

  <br/>
  17 roles de texto semânticos organizados por rampa de tamanho (xxl > xl > l > ml > m > ms > s):
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

  Cada role resolve para um `GentleTypographyRoleSpec` contendo: `pointSize`, `weight`, `design`, `width`, `relativeTo`, `lineSpacing`, `letterSpacing`, `isUppercased` e `colorRole`.

</details>


<details>
  <summary><strong>Roles de botões e animações</strong></summary>

  **Roles de Botões**

  `primary` · `secondary` · `tertiary` · `quaternary` · `destructive`

  **Animações de Botões**

| Animação | Descrição |
|----------|-----------|
| `unknown` | Sem animação |
| `subtlePress` | Feedback sutil ao pressionar |
| `squish` | Efeito de esmagamento ao pressionar |
| `pop` | Efeito de salto |
| `bouncy` | Animação de mola saltitante |
| `springBack` | Encolhe ao pressionar, salta além do tamanho original antes de estabilizar |

</details>

<details>
  <summary><strong>Roles de superfícies</strong></summary>
  `appBackground` · `card` · `cardElevated` · `cardSecondary` · `chrome` · `overlaySheet` · `overlayPopover` · `overlayScrim` · `floatingPanel` · `floatingWidget`
</details>


<details>
  <summary><strong>Roles de cores</strong></summary>

| Categoria | Roles |
|-----------|-------|
| Texto (9) | `textPrimary`, `textSecondary`, `textTertiary`, `textOnPrimaryCTA`, `textOnDestructive`, `textOnOverlay`, `textOnOverlaySecondary`, `textOnScrim`, `textOnScrimSecondary` |
| Superfícies (6) | `background`, `surfaceBase`, `surfaceCardSecondary`, `surfaceTint`, `surfaceScrim`, `borderSubtle` |
| Ações (2) | `primaryCTA`, `destructive` |
| Tema (2) | `themePrimary`, `themeSecondary` |

Use agrupamentos semânticos: `GentleColorRole.textRoles`, `.surfaceRoles`, `.actionRoles`, `.themeRoles`
Use verificações de pertencimento: `role.isTextRole`, `.isSurfaceRole`, `.isActionRole`, `.isThemeRole`

</details>

<details>
  <summary><strong>Tokens de espaçamento e raio</strong></summary>

  **Tokens de Espaçamento**
  `xs` (4) · `s` (8) · `m` (12) · `l` (16) · `xl` (24) · `xxl` (32)


  **Tokens de Raio**
  `small` (8) · `medium` (12) · `large` (20) · `pill` (999)

</details>

---

## Requisitos

- iOS 18.0+
- Swift 6.1+

---

## Nota sobre Ferramentas

Partes da redação e refinamento editorial neste repositório foram aceleradas usando modelos de linguagem de grande escala (incluindo ChatGPT, Claude e Gemini) sob design humano direto, validação e aprovação final. Todas as decisões técnicas, código e conclusões arquiteturais são de autoria e verificação do mantenedor do repositório.

![Visitantes](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fgentle-giraffe-apps%2FGentleDesignSystem)
