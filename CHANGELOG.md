# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_No unreleased changes yet._

## [1.0.0] - 2026-XX-XX

First public release.

### Added

- Configurable timer tiles (up to 10) with custom name, duration, and color
- Countdown timer with overdue indication (pulsing red counter past zero)
- Stopwatch counting up to 60:00 with auto-stop
- Color picker dialog for tile customization (`flutter_colorpicker`)
- Optional vibration on time-up (`vibration`)
- Keep-screen-on while timer is active (`wakelock_plus`)
- True fullscreen landscape mode with hidden system bars
- Light / Dark / System theme toggle
- Configurable visibility for Reset/Pause buttons (Stop always visible)
- 100% offline operation — no internet permission, no accounts, no telemetry
- Polish (PL) localization (native)
- English (EN) localization (complete)
- Comprehensive test suite: 52 tests covering controllers, storage, models,
  widgets, and screens
- Apache License 2.0 with SPDX-License-Identifier headers on all source files
- Root `.gitignore` for Flutter/Dart projects
- Custom app icon generated via `flutter_launcher_icons`
- Issue/PR templates, dependabot, CI workflow under `.github/`
- CONTRIBUTING.md, CODE_OF_CONDUCT.md (Contributor Covenant 2.1)

### Changed

- Application ID: `app.timermowcy` (replaces default `com.example.*`)
- UI architecture: `config_screen` god class (591 LOC) split into 3 focused
  widgets (`ConfigSettingsSection`, `ConfigTileForm`, `ConfigTileList`)

### Known issues

- App icon is a single PNG (no adaptive-foreground/background layers). Some
  launchers may crop the icon edge. Fix planned for v1.1.
- No automated screenshots in README — manual capture pending.
- `flutter build apk --release` uses debug signing keys; dedicated signing
  config required before any store submission.

[Unreleased]: TODO-add-URL-when-published/compare/v1.0.0...HEAD
[1.0.0]: TODO-add-URL-when-published/releases/tag/v1.0.0
