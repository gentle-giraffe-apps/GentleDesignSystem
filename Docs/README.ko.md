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

> 🌍 **언어** · 정식 문서는 영어 · [English](../README.md) · [Español](README.es.md) · [Português (Brasil)](README.pt-BR.md) · [日本語](README.ja.md) · [简体中文](README.zh-CN.md) · [Русский](README.ru.md)

### 요약

텍스트, 버튼, 표면을 통합 디자인 시스템으로 빠르게 표준화하세요.

```swift
Text("간단한 수정자")
    .gentleText(.title_xl)

Button("앱 전체에 적용") { }
    .gentleButton(.primary)

VStack {
    Text("많은 시간을 절약하세요")
}
.gentleSurface(.card)
```

### 대상

장기적인 테마 발전과 함께 견고한 SwiftUI 기반을 원하는 앱.

💬 **[토론에 참여하세요. 피드백과 질문을 환영합니다](https://github.com/gentle-giraffe-apps/GentleDesignSystem/discussions)**

<img src="README_assets/Typography1.png" width="500" />

**직접 확인해 보세요:** `Demo/GentleDesignSystemDemo.xcodeproj`를 열어 컴포넌트를 탐색해 보세요. 데모 앱은 시스템 공유 시트를 통해 JSON 사양을 편집하고 공유하는 기능도 지원합니다.

---

## 빠른 시작

### 1. 패키지 추가

```swift
.package(url: "https://github.com/gentle-giraffe-apps/GentleDesignSystem.git", from: "0.1.7")
```

### 2. 앱 루트 감싸기

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

### 3. 컴포넌트 사용

#### 타이포그래피
```swift
Text("환영합니다")
    .gentleText(.title_xl)

Text("설명")
    .gentleText(.body_m, colorRole: .textSecondary)
```

#### 버튼
```swift
Button("계속") { }
    .gentleButton(.primary)

Button("취소") { }
    .gentleButton(.secondary)
```

#### 표면
```swift
VStack {
    Text("카드 콘텐츠")
}
.gentleSurface(.card)
```

---

## 품질 및 도구

<details>
  <summary><strong>CI, 정적 분석, 커버리지 세부 정보</strong></summary>

  이 프로젝트는 CI와 정적 분석을 통해 품질 게이트를 적용합니다:

  - **CI:** `main`에 대한 모든 커밋은 GitHub Actions 검사를 통과해야 합니다
  - **정적 분석:** DeepSource가 매 커밋마다 실행됩니다
  - **테스트 커버리지:** Codecov가 라인 커버리지를 보고합니다

  <sub><strong>Codecov 스냅샷</strong></sub><br/>
  <a href="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem">
    <img src="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem/graphs/icicle.svg" height="72" />
  </a>

</details>

---

## 아키텍처 개요

GentleDesignSystem은 **세 개의 레이어**를 중심으로 의도적으로 설계되었습니다:

1. **토큰 정의 (Codable, JSON 호환)**
2. **런타임 해석 (테마 + Environment)**
3. **SwiftUI 사용성 (수정자 및 확장)**

이러한 분리는 디자인 의도를 명확하게, 런타임 동작을 예측 가능하게, 그리고 미래의 발전을 안전하게 유지합니다.

<details>
  <summary><strong>시스템 아키텍처 (다이어그램)</strong></summary>

  ```mermaid
  flowchart TB
      subgraph Tokens["토큰 레이어 (디자인 타임)"]
          Spec[GentleDesignSystemSpec]
          Spec --> Colors[GentleColorTokens]
          Spec --> Typography[GentleTypographyTokens]
          Spec --> Layout[GentleLayoutTokens]
          Spec --> Visual[GentleVisualTokens]
          Spec --> Buttons[GentleButtonTokens]
          Spec --> Surfaces[GentleSurfaceTokens]
      end

      subgraph Runtime["런타임 레이어"]
          Theme[GentleTheme]
          Manager[GentleThemeManager]
          Store[GentleFileThemeSpecStore]
          Manager --> Theme
          Store -.->|로드/저장| Manager
      end

      subgraph SwiftUI["SwiftUI 레이어"]
          Root[GentleThemeRoot]
          Env[Environment Values .gentleTheme]
          Modifiers[뷰 수정자]
          Root --> Env
          Env --> Modifiers
      end

      Tokens --> Runtime
      Runtime --> SwiftUI
  ```
</details>

<details>
  <summary><strong>데이터 흐름 (다이어그램)</strong></summary>

  ```mermaid
  flowchart TB
      JSON[(JSON 파일)] -->|로드| Store[GentleFileThemeSpecStore]
      Store --> Manager[GentleThemeManager]
      Manager --> Theme[GentleTheme]
      Theme --> Resolve{해석}

      Resolve -->|ColorScheme| ResolvedColor[색상]
      Resolve -->|ContentSizeCategory| ResolvedFont[폰트]

      ResolvedColor --> View[SwiftUI 뷰]
      ResolvedFont --> View

      View -->|.gentleText| Text
      View -->|.gentleButton| Button
      View -->|.gentleSurface| Surface
  ```
</details>

<details>
  <summary><strong>데이터 모델 (사양 구조)</strong></summary>

  디자인 시스템은 하나의 JSON 호환 사양으로 정의됩니다
  (`GentleDesignSystemSpec`).

  ```text
  GentleDesignSystemSpec
│
├── colors: GentleColorTokens
│       │
│       └── pairByRole: [String: GentleColorPair]
│               │
│               ├── 키 = GentleColorRole.rawValue
│               └── 값 = GentleColorPair
│                       ├── lightHex: String
│                       └── darkHex:  String
│
├── typography: GentleTypographyTokens
│       │
│       └── roles: [String: GentleTypographyRoleSpec]
│               │
│               ├── 키 = GentleTextRole.rawValue
│               └── 값 = GentleTypographyRoleSpec
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
│                       ├── 키 = GentleInsetRole.rawValue
│                       └── 값 = GentleAxisInsetTokens
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
│       │       ├── 키 = GentleButtonRole.rawValue
│       │       └── 값 = GentleButtonRoleSpec
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
│               ├── 키 = GentleButtonAnimationRole.rawValue
│               └── 값 = GentleButtonAnimationSpec
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
                ├── 키 = GentleSurfaceRole.rawValue
                └── 값 = GentleSurfaceRoleSpec
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

> **왜 직접 값이 아닌 역할을 사용하나요?**
> 역할은 안정적인 식별자를 제공하여 테마가 시간이 지나도 안전하게 발전할 수 있게 합니다.
> 사양은 변경될 수 있고, 프리셋은 교체될 수 있으며, 값은 오버라이드될 수 있습니다.
> 호출 지점이나 직렬화된 테마를 깨뜨리지 않고 말이죠.

---

## 1. 토큰 레이어 (디자인 타임)

토큰 레이어는 디자인 시스템이 *무엇을 의미하는지* 정의합니다 — 어떻게 렌더링되는지가 아닙니다.

### 토큰 카테고리

| 카테고리 | 타입 |
|----------|------|
| **타이포그래피** | `GentleTextRole`, `GentleTypographyRoleSpec`, `GentleTypographyTokens` |
| **색상** | `GentleColorRole`, `GentleColorPair`, `GentleColorTokens` |
| **레이아웃** | `GentleLayoutTokens`, `GentleSpacingToken`, `GentleGapTokens`, `GentleInsetTokens` |
| **비주얼** | `GentleVisualTokens`, `GentleRadiusTokens`, `GentleShadowTokens` |
| **버튼** | `GentleButtonRole`, `GentleButtonRoleSpec`, `GentleButtonTokens`, `GentleButtonAnimationRole` |
| **표면** | `GentleSurfaceRole`, `GentleSurfaceRoleSpec`, `GentleSurfaceTokens` |

<details>
  <summary><strong>토큰 보장 및 기본 사양</strong></summary>

  모든 토큰은:
  - `Codable`
  - `Sendable`
  - JSON 호환

  이를 통해 다음이 쉬워집니다:
  - 테마 영구 저장
  - 원격 테마 로드
  - 향후 플랫폼 간 토큰 공유

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

기본 테마(`.default`)는 단순히 하나의 구체적인 사양입니다.

---

## 2. 런타임 레이어 (테마 해석)

런타임에서 토큰은 **실제 SwiftUI 값**으로 해석됩니다.

### GentleTheme

`GentleTheme`:
- `GentleDesignSystemSpec`을 소유합니다
- 해석:
  - `ColorScheme`에 따른 색상
  - `ContentSizeCategory`(다이나믹 타입)에 따른 폰트

```swift
@Environment(\.gentleTheme) var theme
```

타이포그래피 해석은 `UIFontMetrics`를 사용하여 Apple의 시맨틱 텍스트 스타일에 고정된 상태에서 커스텀 폰트 크기를 올바르게 스케일링합니다.

이를 통해 보장되는 것:
- 접근성 스케일링이 올바르게 작동
- 커스텀 포인트 크기가 비례를 유지
- 향후 다이나믹 타입 변경이 안전

### Property Wrappers

<details>
  <summary><strong>런타임 접근 헬퍼</strong></summary>

  ```swift
// 해석된 테마 값에 접근
@GentleDesignRuntime private var design

// 뷰에서 사용
design.color(.textPrimary)    // 현재 색상 스킴의 색상
design.layout.stack.regular   // CGFloat 간격 값
design.buttons                // 버튼 토큰
  ```
</details>

---

## 3. Environment 주입

### `GentleThemeRoot`가 존재하는 이유

SwiftUI의 environment는 **위에서 아래로** 흐릅니다.

앱 루트를 다음과 같이 감싸면:

```swift
GentleThemeRoot {
    ContentView()
}
```

다음을 보장합니다:

- 모든 하위 뷰가 동일한 테마를 받음
- 프리뷰가 일관되게 동작
- 나중에 테마 오버라이드가 쉬움 (씬별, 기능별, 프리뷰별)

`GentleThemeRoot`는 의도적으로 경량입니다 — 단 하나의 environment 값만 주입합니다.

이를 통해 다음을 방지합니다:
- 전역 싱글톤
- 정적 상태
- 암묵적 매직

---

## 4. 수정자 및 뷰 확장

GentleDesignSystem은 로직을 중앙화하면서 인체공학적 API를 제공합니다.

<details>
  <summary><strong>텍스트 수정자</strong></summary>

  ```swift
Text("안녕하세요")
    .gentleText(.headline_m)
  ```

  내부적으로:
  - `GentleTheme`을 통해 타이포그래피 해석
  - 폰트, 너비, 디자인, 간격, 색상 적용
  - 다이나믹 타입 자동 적용

</details>

<details>
  <summary><strong>표면</strong></summary>

  ```swift
  VStack { ... }
    .gentleSurface(.card)
  ```

  표면이 적용하는 것:
  - 배경색
  - 패딩 (적절한 경우)
  - 모서리 반경
  - 테두리 또는 그림자

  역할 기반 API는 "매직 넘버"가 뷰에 누출되는 것을 방지합니다.

</details>

<details>
  <summary><strong>버튼</strong></summary>

  ```swift
Button("저장") { }
    .gentleButton(.primary)
  ```

  버튼의 특징:
  - `ButtonStyle`을 통한 스타일링
  - 완전한 테마 기반
  - 구성 가능한 애니메이션 지원
  - 새로운 역할로 쉽게 확장 가능

</details>

---

## 5. 테마 관리 및 영구 저장

<details>
  <summary><strong>런타임 편집, 영구 저장, 스토어</strong></summary>

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

  **Manager 사용**

  ```swift
@GentleThemeManagerRuntime private var manager

// 현재 테마를 디스크에 저장
try manager.save()

// 영구 저장된 테마 로드
try manager.load()

// 편집용 바인딩 가져오기
manager.typographyBinding(for: .body_m)
manager.colorBinding(for: .primaryCTA)
  ```

  **영구 저장**

  `GentleFileThemeSpecStore`는 Application Support에 JSON 영구 저장을 처리합니다:

  ```swift
let store = GentleFileThemeSpecStore(fileName: "my-theme.json")
let manager = GentleThemeManager(theme: .default, store: store)
  ```

</details>

---

## 6. 테마 프리셋

GentleDesignSystem은 다양한 사용 사례와 미학을 위해 설계된 9개의 내장 테마 프리셋을 포함합니다.

<details>
  <summary><strong>사용 가능한 테마 프리셋</strong></summary>

  ```swift
// 모든 사용 가능한 프리셋 가져오기
let presets = GentleDesignSystemSpec.allPresets

// 각 프리셋이 제공하는 것:
// - name: 표시 이름 (예: "Gentle Default")
// - summary: 간단한 태그라인
// - description: 상세 설명
// - purpose: 이 프리셋을 사용할 때
// - systemImageString: UI용 SF Symbol 이름
// - spec: 실제 GentleDesignSystemSpec
  ```

| 프리셋 | 요약 | 최적 용도 |
|--------|------|-----------|
| **Gentle Default** | 차분하고 균형 잡힌 기반 | 깔끔한 계층 구조의 범용 시작점 |
| **Classic Tan** | 따뜻하고 클래식한 어스 톤 | 따뜻함과 전통이 어울리는 앱 |
| **Modern Gray** | 세련되고 미니멀한 중립 기반 | 명확성이 핵심인 비즈니스 앱 |
| **Soft Green** | 신선하고 자연스러운 차분한 액센트 | 웰빙, 생산성, 집중 앱 |
| **Editorial Paper** | 인쇄 감성의 세련된 독서 경험 | 콘텐츠 중심 앱, 장문 독서 |
| **Technical Blue** | 정밀하고 신뢰할 수 있는 블루 하이라이트 | 개발자 도구, 대시보드 |
| **Bold Orange** | 활기차고 에너지 넘치는 강한 존재감 | 행동을 유도하는 앱 |
| **Elegant Purple** | 세련되고 고급스러운 풍부한 톤 | 라이프스타일, 크리에이티브, 프리미엄 앱 |
| **Compact Mint** | 밀도 높고 효율적인 신선한 액센트 | 데이터 집약적 인터페이스 |

</details>

### 프리셋 사용

```swift
// 테마 매니저에 프리셋 적용
@GentleThemeManagerRuntime private var manager

// 프리셋 찾기 및 적용
if let editorialPreset = GentleDesignSystemSpec.allPresets.first(where: { $0.name == "Editorial Paper" }) {
    manager.theme.editableSpec = editorialPreset.spec
}
```

### 테마 선택기 구축

데모 앱에는 모든 프리셋을 인터랙티브 카드로 표시하는 `ThemePickerView`가 포함되어 있습니다. 각 카드는 프리셋 자체의 테마를 사용하여 타이포그래피와 색상을 미리 봅니다:

<details>
  <summary><strong>테마 선택기 구축</strong></summary>

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
            // 카드 콘텐츠가 프리셋 자체의 스타일로 렌더링됩니다
            ThemePresetCard(preset: preset)
        }
    }
}
  ```

</details>


---

## 사용 가능한 토큰

<details>
  <summary><strong>타이포그래피 역할</strong></summary>

  <br/>
  크기 램프별로 구성된 17개의 시맨틱 텍스트 역할 (xxl > xl > l > ml > m > ms > s):
  <br/>

| 램프 | 역할 |
|------|------|
| XXL | `largeTitle_xxl` |
| XL | `title_xl` |
| L | `title2_l` |
| ML | `title3_ml` |
| M | `headline_m`, `body_m`, `bodySecondary_m`, `monoCode_m`, `primaryButtonTitle_m`, `secondaryButtonTitle_m`, `tertiaryButtonTitle_m`, `quaternaryButtonTitle_m` |
| MS | `callout_ms`, `subheadline_ms` |
| S | `footnote_s`, `caption_s`, `caption2_s` |

  각 역할은 `GentleTypographyRoleSpec`으로 해석되며 다음을 포함합니다: `pointSize`, `weight`, `design`, `width`, `relativeTo`, `lineSpacing`, `letterSpacing`, `isUppercased`, `colorRole`.

</details>


<details>
  <summary><strong>버튼 역할 및 애니메이션</strong></summary>

  **버튼 역할**

  `primary` · `secondary` · `tertiary` · `quaternary` · `destructive`

  **버튼 애니메이션**

| 애니메이션 | 설명 |
|------------|------|
| `unknown` | 애니메이션 없음 |
| `subtlePress` | 미묘한 누름 피드백 |
| `squish` | 누를 때 찌그러지는 효과 |
| `pop` | 팝 효과 |
| `bouncy` | 탄성 스프링 애니메이션 |
| `springBack` | 누르면 줄어들었다가 원래 크기를 넘어 튀어오른 뒤 안정됨 |

</details>

<details>
  <summary><strong>표면 역할</strong></summary>
  `appBackground` · `card` · `cardElevated` · `cardSecondary` · `chrome` · `overlaySheet` · `overlayPopover` · `overlayScrim` · `floatingPanel` · `floatingWidget`
</details>


<details>
  <summary><strong>색상 역할</strong></summary>

| 카테고리 | 역할 |
|----------|------|
| 텍스트 (9) | `textPrimary`, `textSecondary`, `textTertiary`, `textOnPrimaryCTA`, `textOnDestructive`, `textOnOverlay`, `textOnOverlaySecondary`, `textOnScrim`, `textOnScrimSecondary` |
| 표면 (6) | `background`, `surfaceBase`, `surfaceCardSecondary`, `surfaceTint`, `surfaceScrim`, `borderSubtle` |
| 액션 (2) | `primaryCTA`, `destructive` |
| 테마 (2) | `themePrimary`, `themeSecondary` |

시맨틱 그룹 사용: `GentleColorRole.textRoles`, `.surfaceRoles`, `.actionRoles`, `.themeRoles`
멤버십 확인 사용: `role.isTextRole`, `.isSurfaceRole`, `.isActionRole`, `.isThemeRole`

</details>

<details>
  <summary><strong>간격 및 반경 토큰</strong></summary>

  **간격 토큰**
  `xs` (4) · `s` (8) · `m` (12) · `l` (16) · `xl` (24) · `xxl` (32)


  **반경 토큰**
  `small` (8) · `medium` (12) · `large` (20) · `pill` (999)

</details>

---

## 요구 사항

- iOS 18.0+
- Swift 6.1+

---

## 도구 참고 사항

이 저장소의 초안 작성과 편집 다듬기 일부는 대규모 언어 모델(ChatGPT, Claude, Gemini 포함)을 활용하여 가속화되었으며, 인간의 직접적인 설계, 검증 및 최종 승인 하에 진행되었습니다. 모든 기술적 결정, 코드 및 아키텍처 결론은 저장소 관리자가 직접 작성하고 검증했습니다.

![방문자](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fgentle-giraffe-apps%2FGentleDesignSystem)
