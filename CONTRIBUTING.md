# Contributing to TimerMówcy

Thanks for your interest in improving TimerMówcy! This is a small, focused project — the simpler we keep it, the more useful it stays.

## Code of Conduct

By participating you agree to uphold the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). Please be kind.

## Ways to contribute

- 🐛 **Report bugs** — open an issue with the bug template
- 💡 **Suggest features** — open an issue describing the use case first, before writing code
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

## Workflow

1. **Fork** the repository and create a branch:
   ```bash
   git checkout -b feat/short-description
   ```
2. **Make your changes.** Keep PRs focused — one feature or fix per PR.
3. **Verify locally** before pushing:
   ```bash
   flutter analyze    # must report "No issues found!"
   flutter test       # all tests must pass
   ```
4. **Commit** using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat: add dark-tile outline option`
   - `fix: prevent stopwatch auto-stop on app pause`
   - `docs: clarify README build instructions`
   - `refactor: extract color picker dialog`
   - `test: add tile sorting edge cases`
   - `chore: bump dependencies`
5. **Open a Pull Request** against `main` with a clear description and link to any related issue.

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

## Localization

TimerMówcy ships with Polish (native) and English. To add a new locale:

1. Copy `timer_mowcy/lib/l10n/app_en.arb` to `app_<locale>.arb`
2. Translate every value
3. Add the locale to `timer_mowcy/lib/main.dart` `supportedLocales`
4. Run `flutter gen-l10n` from the `timer_mowcy/` directory
5. Open a PR — please include a native speaker review note in the description

## Reporting security issues

Do not open public issues for security vulnerabilities. Instead, contact the maintainer directly at the email listed in the Git commit log.

## License

By contributing you agree that your contributions will be licensed under the [Apache License 2.0](LICENSE).
