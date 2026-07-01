# TimerMówcy ⏱️

<p align="center">
  <img src="timer_mowcy/assets/icon_source.png" width="120" alt="TimerMówcy app icon" />
</p>

<p align="center">
  <a href="https://www.apache.org/licenses/LICENSE-2.0"><img alt="License" src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" /></a>
  <a href="https://flutter.dev"><img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.35-02569B?logo=flutter&logoColor=white" /></a>
  <a href="https://developer.android.com/about/versions/nougat"><img alt="Android" src="https://img.shields.io/badge/Android-7.0%2B-3DDC84?logo=android&logoColor=white" /></a>
  <img alt="Tests" src="https://img.shields.io/badge/tests-52%20passing-success" />
  <img alt="Languages" src="https://img.shields.io/badge/i18n-PL%20%2B%20EN-2ea44f" />
</p>

> Open-source timer + stopwatch for speakers, trainers, and debaters.
> Works offline. No ads. No accounts. No internet permission.

## ✨ Features

- ⏱️ **Configurable timer presets** — up to 10 tiles with custom name, duration, and color
- ⏲️ **Stopwatch** counting up to 60:00 with auto-stop
- 🔔 **Time-up alerts** — vibration + pulsing red overdue counter (keeps counting past zero)
- 🎨 **Customizable tile colors** via built-in color picker
- 📳 **Optional vibration** toggle (per device)
- 🔒 **Keep screen on** while a timer or stopwatch is active
- 📱 **True fullscreen landscape** — system bars hidden for maximum visibility
- 🌗 **Light / Dark / System theme** toggle
- 🚫 **100% offline** — no internet permission, no accounts, no telemetry
- 🌍 **PL + EN localization** (Polish native, English complete)

## 📸 Screenshots

<!-- TODO: add screenshots/01-home.png, 02-timer-overdue.png, 03-config.png -->

_Screenshots will be added in a follow-up commit._

## ❓ Why?

Built for debate clubs, Toastmasters meetings, lecture halls, and training sessions where:

- A timer needs to be readable from across the room
- Internet access is unreliable or unwanted
- Multiple preset durations are needed (e.g. 5/7/10-minute speeches)
- A stopwatch is needed for cross-examination or Q&A

Open-sourced because privacy-first tools for speakers should be accessible to everyone — and because a project this focused is a clean Flutter reference for the community.

## 📥 Installation

### From APK (recommended for end users)

Download the latest APK from [GitHub Releases](TODO-add-URL-when-published).

Install with ADB:

```bash
adb install app-arm64-v8a-release.apk
```

Or transfer the APK to your phone and install it (enable "Install unknown apps" first).

> Which APK? Pick `app-arm64-v8a-release.apk` for modern phones (99% of devices sold after 2017). Use `app-armeabi-v7a-release.apk` only for old 32-bit devices. `app-x86_64-release.apk` is for emulators.

### From source

Requirements:

- Flutter 3.35+ (Dart 3.9+)
- Android SDK with `minSdk 24` (Android 7.0+)

```bash
git clone TODO-add-URL-when-published
cd timer-mowcy/timer_mowcy
flutter pub get
flutter run
```

## 🛠️ Building

```bash
# Debug (hot reload)
flutter run

# Release APK (single, larger)
flutter build apk --release

# Split per ABI (smaller files, recommended for distribution)
flutter build apk --release --split-per-abi
```

Output: `timer_mowcy/build/app/outputs/flutter-apk/`.

## 🧪 Testing

```bash
flutter test              # run unit + widget tests (52 tests)
flutter test --coverage   # generate coverage/lcov.info
flutter analyze           # static analysis (should report "No issues found!")
```

## 📦 Dependencies

| Package                                                                  | Purpose                        |
| ------------------------------------------------------------------------ | ------------------------------ |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences)      | Persist tiles + settings       |
| [`flutter_colorpicker`](https://pub.dev/packages/flutter_colorpicker)    | Tile color picker              |
| [`wakelock_plus`](https://pub.dev/packages/wakelock_plus)                | Keep screen awake during timer |
| [`vibration`](https://pub.dev/packages/vibration)                        | Haptic feedback on time-up     |
| [`flutter_localizations`](https://pub.dev/packages/flutter_localizations) | i18n infrastructure            |
| [`intl`](https://pub.dev/packages/intl)                                  | Locale-aware formatting        |

## 🌍 Languages

- **Polski (PL)** — native, complete
- **English (EN)** — complete

To use the app in English, change your device language or pass `--locale=en` to `flutter run`.

## 📁 Project structure

```
timer_mowcy/
├── lib/
│   ├── main.dart                    # Entry point + MaterialApp
│   ├── l10n/                        # PL + EN ARB files + generated code
│   ├── screens/                     # Home, Timer, Stopwatch, Config
│   ├── widgets/                     # TileWidget, TimeDisplay, ActionButtons
│   │                                # + ConfigSettingsSection/Form/TileList
│   ├── models/                      # TimerTile
│   └── services/                    # TimerController, StopwatchController,
│                                    # StorageService
├── test/                            # 52 unit + widget tests
└── assets/                          # Source app icon (1024x1024)
```

## 🗺️ Roadmap

- 📸 Add screenshots + GIF demo to README
- 🎭 Adaptive icon variants (separate foreground + background layers)
- 🔍 More translations (DE, FR, ES — contributions welcome)
- 🤖 GitHub Actions CI (see `.github/workflows/ci.yml`)
- 📋 Optional: F-Droid submission

## 🙏 Acknowledgments

Built with these excellent open-source packages:

- [Flutter](https://flutter.dev) — UI toolkit
- [`shared_preferences`](https://pub.dev/packages/shared_preferences)
- [`flutter_colorpicker`](https://pub.dev/packages/flutter_colorpicker)
- [`wakelock_plus`](https://pub.dev/packages/wakelock_plus)
- [`vibration`](https://pub.dev/packages/vibration)

## 👤 Author

**Gerard Rakoczy** — [GitHub profile](https://github.com/gerpaick)

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md).

## 📄 License

Apache License 2.0 — see [LICENSE](LICENSE).

```
Copyright 2025 Gerard Rakoczy

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
