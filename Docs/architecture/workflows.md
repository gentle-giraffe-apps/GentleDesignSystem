# Workflows

## Build Commands

> **Always build for the iOS Simulator.** This package depends on UIKit, so bare `swift build` will fail on macOS. Use `xcodebuild` with a simulator destination for all build and test commands.

### Package
```bash
# Build package (iOS Simulator)
xcodebuild build -scheme GentleDesignSystem -destination 'platform=iOS Simulator,name=iPhone 16' -quiet

# Clean build
xcodebuild clean build -scheme GentleDesignSystem -destination 'platform=iOS Simulator,name=iPhone 16' -quiet
```

### Tests
```bash
# Run all tests
swift test

# Run specific test
swift test --filter GentleDesignSystemTests

# Run snapshot tests only
swift test --filter SnapshotTests
```

### Snapshot Tests

Snapshot tests verify that token values and UI rendering remain consistent. They use [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) with HEIC image support.

**Snapshot types:**
- **JSON snapshots** - Verify preset spec serialization (`.txt` files)
- **Image snapshots** - Verify UI rendering in light/dark mode (`.heic` files)

**Recording new snapshots:**
Snapshots are configured with `.snapshots(record: .missing)`, so new tests automatically record baselines on first run. To re-record all snapshots:

```bash
# Delete existing snapshots and re-run tests
rm -rf Tests/GentleDesignSystemTests/__Snapshots__
swift test --filter SnapshotTests
```

**When to update snapshots:**
- After intentionally changing default token values
- After adding new presets
- After modifying view modifiers that affect rendering

**Snapshot location:** `Tests/GentleDesignSystemTests/__Snapshots__/SnapshotTests/`

### Demo App (Fastlane)
```bash
cd Demo

# Install Ruby dependencies (first time)
bundle install

# Build demo app (simulator)
bundle exec fastlane ios build
```

### Demo App (xcodebuild)
```bash
cd Demo

xcodebuild -project GentleDesignSystemDemo.xcodeproj \
  -scheme GentleDesignSystemDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build
```

## CI

**Location:** `.github/workflows/ci.yml`

**Trigger:** Push to `main` or any PR

**Runner:** `macos-26` (Xcode 26)

**Steps:**
1. Checkout
2. Setup Ruby 3.3 with Bundler
3. Install xcresultparser (for coverage conversion)
4. Build demo app (`bundle exec fastlane ios build`)
5. Run package tests (`bundle exec fastlane ios package_tests`)
6. Convert coverage to XML (`bundle exec fastlane coverage_xml`)
7. Upload coverage to Codecov

## Local Development

### Opening in Xcode
```bash
# Package
open Package.swift

# Demo app
open Demo/GentleDesignSystemDemo.xcodeproj
```

### Previews
Demo app has previews in `ThemeStudioView.swift`:
- Light mode preview
- Dark mode preview

### Testing Theme Changes
1. Build and run demo app
2. Tap gear icon for settings
3. Edit tokens live
4. Tap "Update and Save" to persist

### Verifying JSON Output
To inspect the current theme spec as JSON, use the share/export feature in `GentleDesignStudioView`, or call `spec.encodedJSONString()` programmatically:
```swift
let jsonString = try themeManager.theme.spec.encodedJSONString()
print(jsonString)
```

## Release Process

1. Update `GentleDesignSystemSpecVersion.current` if schema changed
2. Update README.md if needed
3. Create PR to main
4. CI must pass
5. Merge and tag (e.g., `0.1.0`)

## Troubleshooting

### "Missing module GentleDesignSystem"
Demo app needs the package. Xcode should resolve automatically. If not:
```bash
cd Demo
xcodebuild -resolvePackageDependencies
```

### Fastlane issues
```bash
cd Demo
bundle update
bundle exec fastlane ios build
```

### CI failures
Check runner has Xcode 26 (`macos-26`). Verify scheme name matches.
