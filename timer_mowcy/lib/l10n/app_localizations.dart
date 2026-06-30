import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// App name displayed in MaterialApp title
  ///
  /// In pl, this message translates to:
  /// **'TimerMówcy'**
  String get appTitle;

  /// No description provided for @stopwatch.
  ///
  /// In pl, this message translates to:
  /// **'STOPER'**
  String get stopwatch;

  /// No description provided for @config.
  ///
  /// In pl, this message translates to:
  /// **'Konfiguracja'**
  String get config;

  /// No description provided for @back.
  ///
  /// In pl, this message translates to:
  /// **'Wróć'**
  String get back;

  /// No description provided for @settingsTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Konfiguracja'**
  String get settingsTooltip;

  /// No description provided for @settingsHint.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj lub usuń kafelki minutników'**
  String get settingsHint;

  /// No description provided for @noTiles.
  ///
  /// In pl, this message translates to:
  /// **'Brak kafelków'**
  String get noTiles;

  /// No description provided for @addTilesButton.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kafelki'**
  String get addTilesButton;

  /// No description provided for @settingsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get settingsTitle;

  /// No description provided for @vibrationToggleTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wibracje przy przekroczeniu czasu'**
  String get vibrationToggleTitle;

  /// No description provided for @vibrationToggleSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wibracja przy osiągnięciu 00:00'**
  String get vibrationToggleSubtitle;

  /// No description provided for @themeModeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Motyw aplikacji'**
  String get themeModeLabel;

  /// No description provided for @themeLight.
  ///
  /// In pl, this message translates to:
  /// **'Jasny'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In pl, this message translates to:
  /// **'Ciemny'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In pl, this message translates to:
  /// **'Systemowy'**
  String get themeSystem;

  /// No description provided for @buttonVisibilityTitle.
  ///
  /// In pl, this message translates to:
  /// **'Widoczność przycisków'**
  String get buttonVisibilityTitle;

  /// No description provided for @buttonVisibilitySubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Kontroluj, które przyciski są widoczne w ekranach stopera i minutnika'**
  String get buttonVisibilitySubtitle;

  /// No description provided for @showResetButton.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż przycisk Reset'**
  String get showResetButton;

  /// No description provided for @showResetButtonSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Przycisk rozpoczęcia odliczania od nowa'**
  String get showResetButtonSubtitle;

  /// No description provided for @showPauseButton.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż przycisk Pauza'**
  String get showPauseButton;

  /// No description provided for @showPauseButtonSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Przycisk wstrzymania/wznowienia odliczania'**
  String get showPauseButtonSubtitle;

  /// No description provided for @stopAlwaysVisible.
  ///
  /// In pl, this message translates to:
  /// **'Przycisk Stop jest zawsze widoczny'**
  String get stopAlwaysVisible;

  /// No description provided for @addNewTileTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj nowy kafelek'**
  String get addNewTileTitle;

  /// No description provided for @tileName.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa'**
  String get tileName;

  /// No description provided for @tileNameHint.
  ///
  /// In pl, this message translates to:
  /// **'np. 5 MIN'**
  String get tileNameHint;

  /// No description provided for @tileDuration.
  ///
  /// In pl, this message translates to:
  /// **'Czas (w minutach)'**
  String get tileDuration;

  /// No description provided for @tileDurationHint.
  ///
  /// In pl, this message translates to:
  /// **'np. 5'**
  String get tileDurationHint;

  /// No description provided for @colorLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kolor'**
  String get colorLabel;

  /// No description provided for @addTileButton.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kafelek'**
  String get addTileButton;

  /// No description provided for @tileNameRequired.
  ///
  /// In pl, this message translates to:
  /// **'Podaj nazwę kafelka'**
  String get tileNameRequired;

  /// No description provided for @tileDurationRequired.
  ///
  /// In pl, this message translates to:
  /// **'Podaj czas w minutach'**
  String get tileDurationRequired;

  /// No description provided for @tileDurationRange.
  ///
  /// In pl, this message translates to:
  /// **'Czas musi być między 1 a 60 minut'**
  String get tileDurationRange;

  /// No description provided for @maxTilesReached.
  ///
  /// In pl, this message translates to:
  /// **'Osiągnięto maksymalną liczbę kafelków (10)'**
  String get maxTilesReached;

  /// No description provided for @tileListTitle.
  ///
  /// In pl, this message translates to:
  /// **'Lista kafelków ({count}/10)'**
  String tileListTitle(int count);

  /// No description provided for @tileListEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak kafelków minutników'**
  String get tileListEmpty;

  /// No description provided for @maxTilesError.
  ///
  /// In pl, this message translates to:
  /// **'Maksymalnie 10 kafelków minutników'**
  String get maxTilesError;

  /// No description provided for @duplicateTimeError.
  ///
  /// In pl, this message translates to:
  /// **'Kafelek z tym czasem już istnieje'**
  String get duplicateTimeError;

  /// No description provided for @tileAdded.
  ///
  /// In pl, this message translates to:
  /// **'Kafelek dodany'**
  String get tileAdded;

  /// No description provided for @tileDeleted.
  ///
  /// In pl, this message translates to:
  /// **'Kafelek usunięty'**
  String get tileDeleted;

  /// No description provided for @vibrationEnabled.
  ///
  /// In pl, this message translates to:
  /// **'Wibracje włączone'**
  String get vibrationEnabled;

  /// No description provided for @vibrationDisabled.
  ///
  /// In pl, this message translates to:
  /// **'Wibracje wyłączone'**
  String get vibrationDisabled;

  /// No description provided for @themeSaved.
  ///
  /// In pl, this message translates to:
  /// **'Motyw zapisany'**
  String get themeSaved;

  /// No description provided for @resetButtonVisible.
  ///
  /// In pl, this message translates to:
  /// **'Przycisk Reset widoczny'**
  String get resetButtonVisible;

  /// No description provided for @resetButtonHidden.
  ///
  /// In pl, this message translates to:
  /// **'Przycisk Reset ukryty'**
  String get resetButtonHidden;

  /// No description provided for @pauseButtonVisible.
  ///
  /// In pl, this message translates to:
  /// **'Przycisk Pauza widoczny'**
  String get pauseButtonVisible;

  /// No description provided for @pauseButtonHidden.
  ///
  /// In pl, this message translates to:
  /// **'Przycisk Pauza ukryty'**
  String get pauseButtonHidden;

  /// No description provided for @deleteTileTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuń kafelek?'**
  String get deleteTileTitle;

  /// No description provided for @deleteTileConfirm.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć kafelek \"{name}\"?'**
  String deleteTileConfirm(String name);

  /// No description provided for @cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get delete;

  /// No description provided for @pickColorTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz kolor'**
  String get pickColorTitle;

  /// No description provided for @done.
  ///
  /// In pl, this message translates to:
  /// **'Gotowe'**
  String get done;

  /// No description provided for @reset.
  ///
  /// In pl, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @pause.
  ///
  /// In pl, this message translates to:
  /// **'Pauza'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In pl, this message translates to:
  /// **'Wznów'**
  String get resume;

  /// No description provided for @stop.
  ///
  /// In pl, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @resetTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij odliczanie od nowa'**
  String get resetTooltip;

  /// No description provided for @pauseTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Zatrzymaj odliczanie'**
  String get pauseTooltip;

  /// No description provided for @resumeTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Wznów odliczanie'**
  String get resumeTooltip;

  /// No description provided for @stopTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Zatrzymaj i wróć do menu głównego'**
  String get stopTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
