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

> 🌍 **语言** · 规范文档为英文 · [English](../README.md) · [Español](README.es.md) · [Português (Brasil)](README.pt-BR.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Русский](README.ru.md)

### 概述

快速统一文本、按钮和表面样式，构建一致的设计系统。

```swift
Text("简洁的修饰符")
    .gentleText(.title_xl)

Button("贯穿整个应用") { }
    .gentleButton(.primary)

VStack {
    Text("节省大量时间")
}
.gentleSurface(.card)
```

### 适用场景

希望在 SwiftUI 上建立坚实基础并支持长期主题演进的应用。

💬 **[加入讨论，欢迎反馈和提问](https://github.com/gentle-giraffe-apps/GentleDesignSystem/discussions)**

<img src="README_assets/Typography1.png" width="500" />

**实际体验：** 打开 `Demo/GentleDesignSystemDemo.xcodeproj` 来探索各个组件。示例应用还支持通过系统共享面板编辑和共享 JSON 规格。

---

## 快速开始

### 1. 添加包

```swift
.package(url: "https://github.com/gentle-giraffe-apps/GentleDesignSystem.git", from: "0.1.7")
```

### 2. 包装应用根视图

```swift
import GentleDesignSystem

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            GentleThemeRoot(theme: .default) {
                ContentView()
            }
        }
    }
}
```

### 3. 使用组件

#### 排版
```swift
Text("欢迎")
    .gentleText(.title_xl)

Text("描述")
    .gentleText(.body_m, colorRole: .textSecondary)
```

#### 按钮
```swift
Button("继续") { }
    .gentleButton(.primary)

Button("取消") { }
    .gentleButton(.secondary)
```

#### 表面
```swift
VStack {
    Text("卡片内容")
}
.gentleSurface(.card)
```

---

## 质量与工具

<details>
  <summary><strong>CI、静态分析和覆盖率详情</strong></summary>

  本项目通过 CI 和静态分析实施质量管控：

  - **CI：** 所有提交到 `main` 的代码必须通过 GitHub Actions 检查
  - **静态分析：** DeepSource 在每次提交时运行
  - **测试覆盖率：** Codecov 报告行覆盖率

  <sub><strong>Codecov 快照</strong></sub><br/>
  <a href="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem">
    <img src="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem/graphs/icicle.svg" height="72" />
  </a>

</details>

---

## 架构概览

GentleDesignSystem 围绕**三个层次**精心设计：

1. **令牌定义（Codable，兼容 JSON）**
2. **运行时解析（主题 + Environment）**
3. **SwiftUI 易用性（修饰符与扩展）**

这种分层保持了设计意图的清晰、运行时行为的可预测以及未来演进的安全。

<details>
  <summary><strong>系统架构（图表）</strong></summary>

  ```mermaid
  flowchart TB
      subgraph Tokens["令牌层（设计时）"]
          Spec[GentleDesignSystemSpec]
          Spec --> Colors[GentleColorTokens]
          Spec --> Typography[GentleTypographyTokens]
          Spec --> Layout[GentleLayoutTokens]
          Spec --> Visual[GentleVisualTokens]
          Spec --> Buttons[GentleButtonTokens]
          Spec --> Surfaces[GentleSurfaceTokens]
      end

      subgraph Runtime["运行时层"]
          Theme[GentleTheme]
          Manager[GentleThemeManager]
          Store[GentleFileThemeSpecStore]
          Manager --> Theme
          Store -.->|加载/保存| Manager
      end

      subgraph SwiftUI["SwiftUI 层"]
          Root[GentleThemeRoot]
          Env[Environment Values .gentleTheme]
          Modifiers[视图修饰符]
          Root --> Env
          Env --> Modifiers
      end

      Tokens --> Runtime
      Runtime --> SwiftUI
  ```
</details>

<details>
  <summary><strong>数据流（图表）</strong></summary>

  ```mermaid
  flowchart TB
      JSON[(JSON 文件)] -->|加载| Store[GentleFileThemeSpecStore]
      Store --> Manager[GentleThemeManager]
      Manager --> Theme[GentleTheme]
      Theme --> Resolve{解析}

      Resolve -->|ColorScheme| ResolvedColor[颜色]
      Resolve -->|ContentSizeCategory| ResolvedFont[字体]

      ResolvedColor --> View[SwiftUI 视图]
      ResolvedFont --> View

      View -->|.gentleText| Text
      View -->|.gentleButton| Button
      View -->|.gentleSurface| Surface
  ```
</details>

<details>
  <summary><strong>数据模型（规格结构）</strong></summary>

  设计系统由单一的 JSON 兼容规格定义
  （`GentleDesignSystemSpec`）。

  ```text
  GentleDesignSystemSpec
│
├── colors: GentleColorTokens
│       │
│       └── pairByRole: [String: GentleColorPair]
│               │
│               ├── 键 = GentleColorRole.rawValue
│               └── 值 = GentleColorPair
│                       ├── lightHex: String
│                       └── darkHex:  String
│
├── typography: GentleTypographyTokens
│       │
│       └── roles: [String: GentleTypographyRoleSpec]
│               │
│               ├── 键 = GentleTextRole.rawValue
│               └── 值 = GentleTypographyRoleSpec
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
│                       ├── 键 = GentleInsetRole.rawValue
│                       └── 值 = GentleAxisInsetTokens
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
│       │       ├── 键 = GentleButtonRole.rawValue
│       │       └── 值 = GentleButtonRoleSpec
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
│               ├── 键 = GentleButtonAnimationRole.rawValue
│               └── 值 = GentleButtonAnimationSpec
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
                ├── 键 = GentleSurfaceRole.rawValue
                └── 值 = GentleSurfaceRoleSpec
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

> **为什么使用角色而非直接值？**
> 角色提供稳定的标识符，使主题可以安全地随时间演进。
> 规格可以更改，预设可以替换，值可以覆盖，而不会
> 破坏调用位置或序列化的主题。

---

## 1. 令牌层（设计时）

令牌层定义了你的设计系统*意味着什么*——而不是如何渲染。

### 令牌类别

| 类别 | 类型 |
|------|------|
| **排版** | `GentleTextRole`, `GentleTypographyRoleSpec`, `GentleTypographyTokens` |
| **颜色** | `GentleColorRole`, `GentleColorPair`, `GentleColorTokens` |
| **布局** | `GentleLayoutTokens`, `GentleSpacingToken`, `GentleGapTokens`, `GentleInsetTokens` |
| **视觉** | `GentleVisualTokens`, `GentleRadiusTokens`, `GentleShadowTokens` |
| **按钮** | `GentleButtonRole`, `GentleButtonRoleSpec`, `GentleButtonTokens`, `GentleButtonAnimationRole` |
| **表面** | `GentleSurfaceRole`, `GentleSurfaceRoleSpec`, `GentleSurfaceTokens` |

<details>
  <summary><strong>令牌保证与基础规格</strong></summary>

  所有令牌都是：
  - `Codable`
  - `Sendable`
  - 兼容 JSON

  这使得以下操作变得容易：
  - 持久化主题
  - 远程加载主题
  - 日后跨平台共享令牌

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

默认主题（`.default`）只是一个具体的规格。

---

## 2. 运行时层（主题解析）

在运行时，令牌被解析为**实际的 SwiftUI 值**。

### GentleTheme

`GentleTheme`：
- 拥有一个 `GentleDesignSystemSpec`
- 解析：
  - 根据 `ColorScheme` 解析颜色
  - 根据 `ContentSizeCategory`（动态字体）解析字体

```swift
@Environment(\.gentleTheme) var theme
```

排版解析使用 `UIFontMetrics` 来正确缩放自定义字体大小，同时保持与 Apple 语义文本样式的锚定。

这确保了：
- 辅助功能缩放正常工作
- 自定义点大小保持比例
- 未来的动态字体更改保持安全

### Property Wrappers

<details>
  <summary><strong>运行时访问辅助工具</strong></summary>

  ```swift
// 访问已解析的主题值
@GentleDesignRuntime private var design

// 在视图中使用
design.color(.textPrimary)    // 当前配色方案的颜色
design.layout.stack.regular   // CGFloat 间距值
design.buttons                // 按钮令牌
  ```
</details>

---

## 3. Environment 注入

### 为什么需要 `GentleThemeRoot`

SwiftUI 的 environment 是**自上而下**流动的。

通过用以下方式包装应用根视图：

```swift
GentleThemeRoot {
    ContentView()
}
```

你可以确保：

- 所有子视图接收相同的主题
- 预览行为一致
- 后续主题覆盖很容易（按场景、按功能、按预览）

`GentleThemeRoot` 被设计得非常轻量——它只注入一个 environment 值。

这避免了：
- 全局单例
- 静态状态
- 隐式的魔法

---

## 4. 修饰符与视图扩展

GentleDesignSystem 提供符合人体工程学的 API，同时保持逻辑集中。

<details>
  <summary><strong>文本修饰符</strong></summary>

  ```swift
Text("你好")
    .gentleText(.headline_m)
  ```

  内部实现：
  - 通过 `GentleTheme` 解析排版
  - 应用字体、宽度、设计、间距、颜色
  - 自动适配动态字体

</details>

<details>
  <summary><strong>表面</strong></summary>

  ```swift
  VStack { ... }
    .gentleSurface(.card)
  ```

  表面应用：
  - 背景颜色
  - 内边距（适当时）
  - 圆角
  - 边框或阴影

  基于角色的 API 避免了"魔法数字"渗透到视图中。

</details>

<details>
  <summary><strong>按钮</strong></summary>

  ```swift
Button("保存") { }
    .gentleButton(.primary)
  ```

  按钮具有以下特点：
  - 通过 `ButtonStyle` 设置样式
  - 完全由主题驱动
  - 支持可配置的动画
  - 易于扩展新角色

</details>

---

## 5. 主题管理与持久化

<details>
  <summary><strong>运行时编辑、持久化和存储</strong></summary>

  **GentleThemeManager**

  ```swift
@main
struct MyApp: App {
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

  **使用 Manager**

  ```swift
@GentleThemeManagerRuntime private var manager

// 将当前主题保存到磁盘
try manager.save()

// 加载已持久化的主题
try manager.load()

// 获取用于编辑的绑定
manager.typographyBinding(for: .body_m)
manager.colorBinding(for: .primaryCTA)
  ```

  **持久化**

  `GentleFileThemeSpecStore` 处理 JSON 到 Application Support 的持久化：

  ```swift
let store = GentleFileThemeSpecStore(fileName: "my-theme.json")
let manager = GentleThemeManager(theme: .default, store: store)
  ```

</details>

---

## 6. 主题预设

GentleDesignSystem 包含 9 个内置主题预设，每个都针对不同的使用场景和审美风格设计。

<details>
  <summary><strong>可用的主题预设</strong></summary>

  ```swift
// 获取所有可用预设
let presets = GentleDesignSystemSpec.allPresets

// 每个预设提供：
// - name：显示名称（如 "Gentle Default"）
// - summary：简短标语
// - description：详细说明
// - purpose：何时使用此预设
// - systemImageString：用于 UI 的 SF Symbol 名称
// - spec：实际的 GentleDesignSystemSpec
  ```

| 预设 | 摘要 | 最适用于 |
|------|------|----------|
| **Gentle Default** | 平静、均衡的基础 | 层次清晰的通用起点 |
| **Classic Tan** | 温暖、经典的大地色调 | 需要温馨感和传统感的应用 |
| **Modern Gray** | 简约、现代的中性基底 | 以清晰度为核心的商务应用 |
| **Soft Green** | 清新、自然的舒缓色调 | 健康、效率、专注类应用 |
| **Editorial Paper** | 精致的印刷风格阅读体验 | 内容密集型应用、长文阅读 |
| **Technical Blue** | 精确、可信赖的蓝色调 | 开发者工具、仪表盘 |
| **Bold Orange** | 充满活力、能量满满 | 激发行动力的应用 |
| **Elegant Purple** | 优雅、奢华的丰富色调 | 生活方式、创意、高端应用 |
| **Compact Mint** | 紧凑、高效的清新色调 | 数据密集型界面 |

</details>

### 使用预设

```swift
// 将预设应用到主题管理器
@GentleThemeManagerRuntime private var manager

// 查找并应用预设
if let editorialPreset = GentleDesignSystemSpec.allPresets.first(where: { $0.name == "Editorial Paper" }) {
    manager.theme.editableSpec = editorialPreset.spec
}
```

### 构建主题选择器

示例应用包含一个 `ThemePickerView`，将所有预设显示为可交互的卡片。每张卡片使用预设自身的主题来预览其排版和颜色：

<details>
  <summary><strong>构建主题选择器</strong></summary>

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
            // 卡片内容使用预设自身的样式渲染
            ThemePresetCard(preset: preset)
        }
    }
}
  ```

</details>


---

## 可用令牌

<details>
  <summary><strong>排版角色</strong></summary>

  <br/>
  17 个语义化文本角色，按大小梯度排列（xxl > xl > l > ml > m > ms > s）：
  <br/>

| 梯度 | 角色 |
|------|------|
| XXL | `largeTitle_xxl` |
| XL | `title_xl` |
| L | `title2_l` |
| ML | `title3_ml` |
| M | `headline_m`, `body_m`, `bodySecondary_m`, `monoCode_m`, `primaryButtonTitle_m`, `secondaryButtonTitle_m`, `tertiaryButtonTitle_m`, `quaternaryButtonTitle_m` |
| MS | `callout_ms`, `subheadline_ms` |
| S | `footnote_s`, `caption_s`, `caption2_s` |

  每个角色解析为 `GentleTypographyRoleSpec`，包含：`pointSize`、`weight`、`design`、`width`、`relativeTo`、`lineSpacing`、`letterSpacing`、`isUppercased` 和 `colorRole`。

</details>


<details>
  <summary><strong>按钮角色与动画</strong></summary>

  **按钮角色**

  `primary` · `secondary` · `tertiary` · `quaternary` · `destructive`

  **按钮动画**

| 动画 | 描述 |
|------|------|
| `unknown` | 无动画 |
| `subtlePress` | 微妙的按压反馈 |
| `squish` | 按压时的挤压效果 |
| `pop` | 弹跳效果 |
| `bouncy` | 弹性弹簧动画 |
| `springBack` | 按压时缩小，回弹超过原始大小后稳定 |

</details>

<details>
  <summary><strong>表面角色</strong></summary>
  `appBackground` · `card` · `cardElevated` · `cardSecondary` · `chrome` · `overlaySheet` · `overlayPopover` · `overlayScrim` · `floatingPanel` · `floatingWidget`
</details>


<details>
  <summary><strong>颜色角色</strong></summary>

| 类别 | 角色 |
|------|------|
| 文本 (9) | `textPrimary`, `textSecondary`, `textTertiary`, `textOnPrimaryCTA`, `textOnDestructive`, `textOnOverlay`, `textOnOverlaySecondary`, `textOnScrim`, `textOnScrimSecondary` |
| 表面 (6) | `background`, `surfaceBase`, `surfaceCardSecondary`, `surfaceTint`, `surfaceScrim`, `borderSubtle` |
| 操作 (2) | `primaryCTA`, `destructive` |
| 主题 (2) | `themePrimary`, `themeSecondary` |

使用语义分组：`GentleColorRole.textRoles`、`.surfaceRoles`、`.actionRoles`、`.themeRoles`
使用成员检查：`role.isTextRole`、`.isSurfaceRole`、`.isActionRole`、`.isThemeRole`

</details>

<details>
  <summary><strong>间距与圆角令牌</strong></summary>

  **间距令牌**
  `xs` (4) · `s` (8) · `m` (12) · `l` (16) · `xl` (24) · `xxl` (32)


  **圆角令牌**
  `small` (8) · `medium` (12) · `large` (20) · `pill` (999)

</details>

---

## 要求

- iOS 18.0+
- Swift 6.1+

---

## 工具说明

本仓库中的部分起草和编辑润色工作借助了大语言模型（包括 ChatGPT、Claude 和 Gemini）进行加速，所有工作均在人工直接设计、验证和最终审批下完成。所有技术决策、代码和架构结论均由仓库维护者编写和验证。

![访客](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fgentle-giraffe-apps%2FGentleDesignSystem)
