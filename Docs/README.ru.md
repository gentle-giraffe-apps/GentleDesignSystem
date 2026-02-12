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

> 🌍 **Язык** · Каноническая документация на английском · [English](../README.md) · [Español](README.es.md) · [Português (Brasil)](README.pt-BR.md) · [日本語](README.ja.md) · [简体中文](README.zh-CN.md) · [한국어](README.ko.md)

### Кратко

Быстро стандартизируйте текст, кнопки и поверхности с помощью единой дизайн-системы.

```swift
Text("Простые модификаторы")
    .gentleText(.title_xl)

Button("По всему приложению") { }
    .gentleButton(.primary)

VStack {
    Text("Экономьте массу времени")
}
.gentleSurface(.card)
```

### Для кого

Приложения, которым нужна надёжная основа на SwiftUI с долгосрочным развитием тем.

💬 **[Присоединяйтесь к обсуждению. Отзывы и вопросы приветствуются](https://github.com/gentle-giraffe-apps/GentleDesignSystem/discussions)**

<img src="README_assets/Typography1.png" width="500" />

**Посмотрите в действии:** Откройте `Demo/GentleDesignSystemDemo.xcodeproj` для изучения компонентов. Демо-приложение также поддерживает редактирование и обмен JSON-спецификациями через системный лист общего доступа.

---

## Быстрый старт

### 1. Добавьте пакет

```swift
.package(url: "https://github.com/gentle-giraffe-apps/GentleDesignSystem.git", from: "0.1.7")
```

### 2. Оберните корень приложения

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

### 3. Используйте компоненты

#### Типографика
```swift
Text("Добро пожаловать")
    .gentleText(.title_xl)

Text("Описание")
    .gentleText(.body_m, colorRole: .textSecondary)
```

#### Кнопки
```swift
Button("Продолжить") { }
    .gentleButton(.primary)

Button("Отмена") { }
    .gentleButton(.secondary)
```

#### Поверхности
```swift
VStack {
    Text("Содержимое карточки")
}
.gentleSurface(.card)
```

---

## Качество и инструменты

<details>
  <summary><strong>Подробности CI, статического анализа и покрытия</strong></summary>

  Проект обеспечивает контроль качества через CI и статический анализ:

  - **CI:** Все коммиты в `main` должны пройти проверки GitHub Actions
  - **Статический анализ:** DeepSource запускается при каждом коммите
  - **Покрытие тестами:** Codecov отчитывается о покрытии строк

  <sub><strong>Снимок Codecov</strong></sub><br/>
  <a href="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem">
    <img src="https://codecov.io/gh/gentle-giraffe-apps/GentleDesignSystem/graphs/icicle.svg" height="72" />
  </a>

</details>

---

## Обзор архитектуры

GentleDesignSystem намеренно построен вокруг **трёх слоёв**:

1. **Определения токенов (Codable, совместимые с JSON)**
2. **Разрешение в рантайме (Тема + Environment)**
3. **Эргономика SwiftUI (Модификаторы и расширения)**

Такое разделение сохраняет ясность дизайн-замысла, предсказуемость поведения во время выполнения и безопасность будущего развития.

<details>
  <summary><strong>Архитектура системы (диаграмма)</strong></summary>

  ```mermaid
  flowchart TB
      subgraph Tokens["Слой токенов (время проектирования)"]
          Spec[GentleDesignSystemSpec]
          Spec --> Colors[GentleColorTokens]
          Spec --> Typography[GentleTypographyTokens]
          Spec --> Layout[GentleLayoutTokens]
          Spec --> Visual[GentleVisualTokens]
          Spec --> Buttons[GentleButtonTokens]
          Spec --> Surfaces[GentleSurfaceTokens]
      end

      subgraph Runtime["Слой рантайма"]
          Theme[GentleTheme]
          Manager[GentleThemeManager]
          Store[GentleFileThemeSpecStore]
          Manager --> Theme
          Store -.->|загрузка/сохранение| Manager
      end

      subgraph SwiftUI["Слой SwiftUI"]
          Root[GentleThemeRoot]
          Env[Environment Values .gentleTheme]
          Modifiers[Модификаторы представлений]
          Root --> Env
          Env --> Modifiers
      end

      Tokens --> Runtime
      Runtime --> SwiftUI
  ```
</details>

<details>
  <summary><strong>Поток данных (диаграмма)</strong></summary>

  ```mermaid
  flowchart TB
      JSON[(JSON-файл)] -->|загрузка| Store[GentleFileThemeSpecStore]
      Store --> Manager[GentleThemeManager]
      Manager --> Theme[GentleTheme]
      Theme --> Resolve{Разрешение}

      Resolve -->|ColorScheme| ResolvedColor[Цвет]
      Resolve -->|ContentSizeCategory| ResolvedFont[Шрифт]

      ResolvedColor --> View[Представление SwiftUI]
      ResolvedFont --> View

      View -->|.gentleText| Text
      View -->|.gentleButton| Button
      View -->|.gentleSurface| Surface
  ```
</details>

<details>
  <summary><strong>Модель данных (структура спецификации)</strong></summary>

  Дизайн-система определяется единой JSON-совместимой спецификацией
  (`GentleDesignSystemSpec`).

  ```text
  GentleDesignSystemSpec
│
├── colors: GentleColorTokens
│       │
│       └── pairByRole: [String: GentleColorPair]
│               │
│               ├── ключ = GentleColorRole.rawValue
│               └── значение = GentleColorPair
│                       ├── lightHex: String
│                       └── darkHex:  String
│
├── typography: GentleTypographyTokens
│       │
│       └── roles: [String: GentleTypographyRoleSpec]
│               │
│               ├── ключ = GentleTextRole.rawValue
│               └── значение = GentleTypographyRoleSpec
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
│                       ├── ключ = GentleInsetRole.rawValue
│                       └── значение = GentleAxisInsetTokens
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
│       │       ├── ключ = GentleButtonRole.rawValue
│       │       └── значение = GentleButtonRoleSpec
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
│               ├── ключ = GentleButtonAnimationRole.rawValue
│               └── значение = GentleButtonAnimationSpec
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
                ├── ключ = GentleSurfaceRole.rawValue
                └── значение = GentleSurfaceRoleSpec
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

> **Почему роли, а не прямые значения?**
> Роли предоставляют стабильные идентификаторы, позволяющие темам безопасно развиваться со временем.
> Спецификации могут меняться, пресеты — подменяться, значения — переопределяться,
> не нарушая при этом точки вызова или сериализованные темы.

---

## 1. Слой токенов (время проектирования)

Слой токенов определяет, *что означает* ваша дизайн-система, а не как она отрисовывается.

### Категории токенов

| Категория | Типы |
|-----------|------|
| **Типографика** | `GentleTextRole`, `GentleTypographyRoleSpec`, `GentleTypographyTokens` |
| **Цвета** | `GentleColorRole`, `GentleColorPair`, `GentleColorTokens` |
| **Раскладка** | `GentleLayoutTokens`, `GentleSpacingToken`, `GentleGapTokens`, `GentleInsetTokens` |
| **Визуал** | `GentleVisualTokens`, `GentleRadiusTokens`, `GentleShadowTokens` |
| **Кнопки** | `GentleButtonRole`, `GentleButtonRoleSpec`, `GentleButtonTokens`, `GentleButtonAnimationRole` |
| **Поверхности** | `GentleSurfaceRole`, `GentleSurfaceRoleSpec`, `GentleSurfaceTokens` |

<details>
  <summary><strong>Гарантии токенов и базовая спецификация</strong></summary>

  Все токены:
  - `Codable`
  - `Sendable`
  - Совместимы с JSON

  Это упрощает:
  - Сохранение тем
  - Удалённую загрузку тем
  - Совместное использование токенов на разных платформах в будущем

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

Тема по умолчанию (`.default`) — это просто одна конкретная спецификация.

---

## 2. Слой рантайма (разрешение темы)

Во время выполнения токены разрешаются в **реальные значения SwiftUI**.

### GentleTheme

`GentleTheme`:
- Владеет `GentleDesignSystemSpec`
- Разрешает:
  - Цвета по `ColorScheme`
  - Шрифты по `ContentSizeCategory` (Dynamic Type)

```swift
@Environment(\.gentleTheme) var theme
```

Разрешение типографики использует `UIFontMetrics` для корректного масштабирования пользовательских размеров шрифтов, оставаясь привязанным к семантическим текстовым стилям Apple.

Это гарантирует:
- Корректную работу масштабирования для доступности
- Сохранение пропорциональности пользовательских размеров
- Безопасность при будущих изменениях Dynamic Type

### Property Wrappers

<details>
  <summary><strong>Вспомогательные средства доступа в рантайме</strong></summary>

  ```swift
// Доступ к разрешённым значениям темы
@GentleDesignRuntime private var design

// Использование в представлении
design.color(.textPrimary)    // Цвет для текущей схемы
design.layout.stack.regular   // Значение CGFloat для отступа
design.buttons                // Токены кнопок
  ```
</details>

---

## 3. Внедрение Environment

### Зачем нужен `GentleThemeRoot`

Environment в SwiftUI распространяется **сверху вниз**.

Обернув корень приложения:

```swift
GentleThemeRoot {
    ContentView()
}
```

вы гарантируете, что:

- Все дочерние представления получают одну и ту же тему
- Превью ведут себя единообразно
- Переопределение тем легко (по сцене, по функции, по превью)

`GentleThemeRoot` намеренно легковесен — он внедряет только одно значение environment.

Это исключает:
- Глобальные синглтоны
- Статическое состояние
- Неявную магию

---

## 4. Модификаторы и расширения представлений

GentleDesignSystem предоставляет эргономичные API, сохраняя логику централизованной.

<details>
  <summary><strong>Текстовые модификаторы</strong></summary>

  ```swift
Text("Привет")
    .gentleText(.headline_m)
  ```

  Внутри:
  - Типографика разрешается через `GentleTheme`
  - Применяются шрифт, ширина, дизайн, интервалы, цвет
  - Автоматически поддерживается Dynamic Type

</details>

<details>
  <summary><strong>Поверхности</strong></summary>

  ```swift
  VStack { ... }
    .gentleSurface(.card)
  ```

  Поверхности применяют:
  - Цвет фона
  - Отступы (при необходимости)
  - Скругление углов
  - Рамки или тени

  API на основе ролей предотвращает утечку «магических чисел» в представления.

</details>

<details>
  <summary><strong>Кнопки</strong></summary>

  ```swift
Button("Сохранить") { }
    .gentleButton(.primary)
  ```

  Кнопки:
  - Стилизуются через `ButtonStyle`
  - Полностью управляются темой
  - Поддерживают настраиваемые анимации
  - Легко расширяются новыми ролями

</details>

---

## 5. Управление темами и сохранение

<details>
  <summary><strong>Редактирование в рантайме, сохранение и хранилища</strong></summary>

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

  **Использование Manager**

  ```swift
@GentleThemeManagerRuntime private var manager

// Сохранить текущую тему на диск
try manager.save()

// Загрузить сохранённую тему
try manager.load()

// Получить привязки для редактирования
manager.typographyBinding(for: .body_m)
manager.colorBinding(for: .primaryCTA)
  ```

  **Сохранение**

  `GentleFileThemeSpecStore` обрабатывает JSON-сохранение в Application Support:

  ```swift
let store = GentleFileThemeSpecStore(fileName: "my-theme.json")
let manager = GentleThemeManager(theme: .default, store: store)
  ```

</details>

---

## 6. Пресеты тем

GentleDesignSystem включает 9 встроенных пресетов тем, каждый из которых спроектирован для разных сценариев и эстетики.

<details>
  <summary><strong>Доступные пресеты тем</strong></summary>

  ```swift
// Получить все доступные пресеты
let presets = GentleDesignSystemSpec.allPresets

// Каждый пресет предоставляет:
// - name: Отображаемое имя (например, "Gentle Default")
// - summary: Краткий слоган
// - description: Подробное описание
// - purpose: Когда использовать этот пресет
// - systemImageString: Имя SF Symbol для UI
// - spec: Сам GentleDesignSystemSpec
  ```

| Пресет | Описание | Лучше всего для |
|--------|----------|-----------------|
| **Gentle Default** | Спокойная, сбалансированная основа | Универсальная отправная точка с чёткой иерархией |
| **Classic Tan** | Тёплый, вневременной с земляными тонами | Приложения, выигрывающие от теплоты и традиций |
| **Modern Gray** | Элегантный, минималистичный с нейтральной основой | Бизнес-приложения, где важна ясность |
| **Soft Green** | Свежий, природный с успокаивающими акцентами | Здоровье, продуктивность, спокойный фокус |
| **Editorial Paper** | Изысканный, вдохновлённый печатью | Контентоёмкие приложения, длинные тексты |
| **Technical Blue** | Точный, надёжный с синими акцентами | Инструменты разработчика, дашборды |
| **Bold Orange** | Яркий, энергичный с сильным присутствием | Приложения, мотивирующие к действию |
| **Elegant Purple** | Утончённый, роскошный с насыщенными тонами | Лайфстайл, творчество, премиум-приложения |
| **Compact Mint** | Плотный, эффективный с мятными акцентами | Интерфейсы с большим объёмом данных |

</details>

### Использование пресетов

```swift
// Применить пресет к менеджеру тем
@GentleThemeManagerRuntime private var manager

// Найти и применить пресет
if let editorialPreset = GentleDesignSystemSpec.allPresets.first(where: { $0.name == "Editorial Paper" }) {
    manager.theme.editableSpec = editorialPreset.spec
}
```

### Создание выбора тем

Демо-приложение включает `ThemePickerView`, отображающий все пресеты как интерактивные карточки. Каждая карточка показывает предпросмотр типографики и цветов пресета, используя собственную тему пресета:

<details>
  <summary><strong>Создание выбора тем</strong></summary>

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
            // Содержимое карточки отрисовывается с собственным стилем пресета
            ThemePresetCard(preset: preset)
        }
    }
}
  ```

</details>


---

## Доступные токены

<details>
  <summary><strong>Типографические роли</strong></summary>

  <br/>
  17 семантических текстовых ролей, организованных по размерной шкале (xxl > xl > l > ml > m > ms > s):
  <br/>

| Шкала | Роли |
|-------|------|
| XXL | `largeTitle_xxl` |
| XL | `title_xl` |
| L | `title2_l` |
| ML | `title3_ml` |
| M | `headline_m`, `body_m`, `bodySecondary_m`, `monoCode_m`, `primaryButtonTitle_m`, `secondaryButtonTitle_m`, `tertiaryButtonTitle_m`, `quaternaryButtonTitle_m` |
| MS | `callout_ms`, `subheadline_ms` |
| S | `footnote_s`, `caption_s`, `caption2_s` |

  Каждая роль разрешается в `GentleTypographyRoleSpec`, содержащий: `pointSize`, `weight`, `design`, `width`, `relativeTo`, `lineSpacing`, `letterSpacing`, `isUppercased` и `colorRole`.

</details>


<details>
  <summary><strong>Роли кнопок и анимации</strong></summary>

  **Роли кнопок**

  `primary` · `secondary` · `tertiary` · `quaternary` · `destructive`

  **Анимации кнопок**

| Анимация | Описание |
|----------|----------|
| `unknown` | Без анимации |
| `subtlePress` | Тонкая обратная связь при нажатии |
| `squish` | Эффект сжатия при нажатии |
| `pop` | Эффект выскакивания |
| `bouncy` | Пружинная анимация |
| `springBack` | Сжимается при нажатии, отскакивает за пределы исходного размера, затем стабилизируется |

</details>

<details>
  <summary><strong>Роли поверхностей</strong></summary>
  `appBackground` · `card` · `cardElevated` · `cardSecondary` · `chrome` · `overlaySheet` · `overlayPopover` · `overlayScrim` · `floatingPanel` · `floatingWidget`
</details>


<details>
  <summary><strong>Цветовые роли</strong></summary>

| Категория | Роли |
|-----------|------|
| Текст (9) | `textPrimary`, `textSecondary`, `textTertiary`, `textOnPrimaryCTA`, `textOnDestructive`, `textOnOverlay`, `textOnOverlaySecondary`, `textOnScrim`, `textOnScrimSecondary` |
| Поверхности (6) | `background`, `surfaceBase`, `surfaceCardSecondary`, `surfaceTint`, `surfaceScrim`, `borderSubtle` |
| Действия (2) | `primaryCTA`, `destructive` |
| Тема (2) | `themePrimary`, `themeSecondary` |

Используйте семантические группировки: `GentleColorRole.textRoles`, `.surfaceRoles`, `.actionRoles`, `.themeRoles`
Используйте проверки принадлежности: `role.isTextRole`, `.isSurfaceRole`, `.isActionRole`, `.isThemeRole`

</details>

<details>
  <summary><strong>Токены отступов и скруглений</strong></summary>

  **Токены отступов**
  `xs` (4) · `s` (8) · `m` (12) · `l` (16) · `xl` (24) · `xxl` (32)


  **Токены скруглений**
  `small` (8) · `medium` (12) · `large` (20) · `pill` (999)

</details>

---

## Требования

- iOS 18.0+
- Swift 6.1+

---

## Примечание об инструментах

Часть черновой работы и редакторской доработки в этом репозитории была ускорена с помощью больших языковых моделей (включая ChatGPT, Claude и Gemini) под непосредственным руководством, проверкой и окончательным утверждением человека. Все технические решения, код и архитектурные выводы авторизованы и проверены сопровождающим репозитория.

![Посетители](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fgentle-giraffe-apps%2FGentleDesignSystem)
