# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- English (EN) localization
- Comprehensive test suite covering controllers, storage, models, and widgets (>50% line coverage)

### Changed

- Upgraded to Flutter 3.35 / Dart 3.9
- Replaced deprecated `wakelock` with `wakelock_plus`
- Bumped `vibration`, `shared_preferences`, `flutter_colorpicker`, `cupertino_icons`, `flutter_lints`

### Removed

- Duplicate `timer_mowcy_v2/` project directory
- Android 5.0 (API 21) support — minimum is now Android 7.0 (API 24) per Flutter 3.35 requirements
- Broken default `widget_test.dart` referring to non-existent `MyApp`

## [1.0.0] - 2026-XX-XX

### Added

- Configurable timer tiles (up to 10) with custom name, duration, and color
- Countdown timer with overdue indication (pulsing red counter past zero)
- Stopwatch counting up to 60:00 with auto-stop
- Color picker dialog for tile customization (`flutter_colorpicker`)
- Optional vibration on time-up (`vibration`)
- Keep-screen-on while timer is active (`wakelock_plus`)
- True fullscreen landscape mode with hidden system bars
- Light / Dark / System theme toggle
- 100% offline operation — no internet permission, no accounts, no telemetry
- Polish (PL) localization
- Apache License 2.0
- Root `.gitignore` for Flutter/Dart projects
- SPDX-License-Identifier headers on all source files

[Unreleased]: TODO-add-URL-when-published/compare/v1.0.0...HEAD
[1.0.0]: TODO-add-URL-when-published/releases/tag/v1.0.0
