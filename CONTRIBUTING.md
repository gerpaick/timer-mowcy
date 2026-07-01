# Contributing to TimerMówcy

Thanks for your interest in improving TimerMówcy! This is a small, focused project — the simpler we keep it, the more useful it stays.

## Code of Conduct

By participating you agree to uphold the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). Please be kind.

## Ways to contribute

- 🐛 **Report bugs** — open an issue using the **Bug report** template
- 💡 **Suggest features** — open an issue using the **Feature request** template (describe the use case first, before writing code)
- 🌍 **Translate** — additional locales are welcome (see _Localization_ below)
- 📱 **Test on devices** — especially Android tablets, foldables, and older API levels (24–28)
- 🧹 **Polish** — small PRs that fix a typo, improve a comment, or remove dead code are always welcome

## Before you start

TimerMówcy is intentionally **scope-limited**. We say **no** to:

- Firebase, Analytics, Crashlytics, or any cloud/telemetry dependency
- Google Play deployment (use F-Droid / GitHub Releases instead)
- Accounts, login, sync, multi-device
- Voice prompts, AI features, "smart" suggestions
- Heavy state management libraries (Riverpod, BLoC, GetX) — `ChangeNotifier` is enough here

If your feature requires any of the above, please open an issue to discuss before investing time in a PR.

## Development setup

Requirements:

- Flutter 3.35+ (Dart 3.9+)
- Android SDK (minSdk 24 / Android 7.0+)

```bash
git clone TODO-add-URL-when-published
cd timer-mowcy/timer_mowcy
flutter pub get
flutter run
```

## Branch naming

Use lowercase kebab-case with a type prefix:

| Prefix     | Use for                                              |
| ---------- | ---------------------------------------------------- |
| `feat/`    | New user-visible feature                             |
| `fix/`     | Bug fix                                              |
| `docs/`    | Documentation only                                   |
| `refactor/`| Code restructure without behavior change             |
| `test/`    | Test additions or fixes                              |
| `chore/`   | Tooling, configs, scripts                            |
| `i18n/`    | Localization changes (translations, ARB files)       |
| `deps/`    | Dependency bumps                                     |
| `perf/`    | Performance improvements                             |

Examples: `feat/dark-tile-outline`, `fix/stopwatch-resume-after-pause`, `i18n/add-de-localization`.

## Workflow

1. **Fork** the repository and create a branch:
   ```bash
   git checkout -b feat/short-description
   ```
2. **Make your changes.** Keep PRs focused — one feature or fix per PR.
3. **Verify locally** before pushing:
   ```bash
   flutter analyze    # must report "No issues found!"
   flutter test       # all 52 tests must pass
   ```
4. **Commit** using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat: add dark-tile outline option`
   - `fix: prevent stopwatch auto-stop on app pause`
   - `docs: clarify README build instructions`
   - `refactor: extract color picker dialog`
   - `test: add tile sorting edge cases`
   - `chore: bump dependencies`
5. **Open a Pull Request** against `main` — the PR template will guide you through the checklist.

### Commit message rules

- Imperative mood: "add", not "added"
- Lowercase first letter
- No trailing period
- No emoji in the subject line
- English only

## Code style

- Follow `flutter_lints` defaults (already configured in `analysis_options.yaml`)
- Add `const` constructors where possible
- Prefer composition over inheritance
- Keep files under ~300 LOC; extract widgets when a screen grows beyond that
- Every new public API should have at least one test
- Tests must stay green — `flutter test` must pass before PR merge
- Coverage target: ≥50% lines in `lib/services/` and `lib/models/`

## Localization

TimerMówcy ships with Polish (native) and English. To add a new locale:

1. Copy `timer_mowcy/lib/l10n/app_en.arb` to `app_<locale>.arb`
2. Translate every value
3. Add the locale to `timer_mowcy/lib/main.dart` `supportedLocales`
4. Run `flutter gen-l10n` from the `timer_mowcy/` directory
5. Open a PR — please include a native speaker review note in the description

## Reporting security issues

Do not open public issues for security vulnerabilities. Instead, contact the maintainer directly at the email listed in the Git commit log.

## Releasing (for maintainers)

TimerMówcy follows [Semantic Versioning](https://semver.org). The release flow:

1. **Update CHANGELOG.md** — move items from `[Unreleased]` to a new `[X.Y.Z] - YYYY-MM-DD` section. Add link references at the bottom.
2. **Update `pubspec.yaml`** version (`version: X.Y.Z+BUILD`) — both `version` and the `+BUILD` number (increment build with each release).
3. **Commit**: `chore: release vX.Y.Z`
4. **Tag**: `git tag -a vX.Y.Z -m "vX.Y.Z"`
5. **Build APKs**: from `timer_mowcy/` run `flutter build apk --release --split-per-abi`
6. **Push tag**: `git push origin vX.Y.Z`
7. **Create GitHub Release** with the 3 APKs attached. Release notes = CHANGELOG entry for that version.
8. **(Optional) Submit to F-Droid**: pull request to [fdroiddata](https://gitlab.com/fdroid/fdroiddata) with metadata YAML. Review time: 2–8 weeks.

### Pre-release verification (must all pass)

- `flutter analyze` → "No issues found!"
- `flutter test` → all green
- `flutter build apk --release --split-per-abi` → success
- Install one APK on a physical device and smoke-test: open the app, add a tile, run a timer, run the stopwatch, change theme, change language

### Signing

Before any Google Play submission (not currently planned), generate a release keystore and configure `signingConfig` in `timer_mowcy/android/app/build.gradle.kts`. Until then, debug keys are used — sufficient for GitHub Releases and F-Droid.

## License

By contributing you agree that your contributions will be licensed under the [Apache License 2.0](LICENSE).
