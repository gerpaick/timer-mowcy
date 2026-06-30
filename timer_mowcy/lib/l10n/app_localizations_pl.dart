// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'TimerMówcy';

  @override
  String get stopwatch => 'STOPER';

  @override
  String get config => 'Konfiguracja';

  @override
  String get back => 'Wróć';

  @override
  String get settingsTooltip => 'Konfiguracja';

  @override
  String get settingsHint => 'Dodaj lub usuń kafelki minutników';

  @override
  String get noTiles => 'Brak kafelków';

  @override
  String get addTilesButton => 'Dodaj kafelki';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get vibrationToggleTitle => 'Wibracje przy przekroczeniu czasu';

  @override
  String get vibrationToggleSubtitle => 'Wibracja przy osiągnięciu 00:00';

  @override
  String get themeModeLabel => 'Motyw aplikacji';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get buttonVisibilityTitle => 'Widoczność przycisków';

  @override
  String get buttonVisibilitySubtitle =>
      'Kontroluj, które przyciski są widoczne w ekranach stopera i minutnika';

  @override
  String get showResetButton => 'Pokaż przycisk Reset';

  @override
  String get showResetButtonSubtitle =>
      'Przycisk rozpoczęcia odliczania od nowa';

  @override
  String get showPauseButton => 'Pokaż przycisk Pauza';

  @override
  String get showPauseButtonSubtitle =>
      'Przycisk wstrzymania/wznowienia odliczania';

  @override
  String get stopAlwaysVisible => 'Przycisk Stop jest zawsze widoczny';

  @override
  String get addNewTileTitle => 'Dodaj nowy kafelek';

  @override
  String get tileName => 'Nazwa';

  @override
  String get tileNameHint => 'np. 5 MIN';

  @override
  String get tileDuration => 'Czas (w minutach)';

  @override
  String get tileDurationHint => 'np. 5';

  @override
  String get colorLabel => 'Kolor';

  @override
  String get addTileButton => 'Dodaj kafelek';

  @override
  String get tileNameRequired => 'Podaj nazwę kafelka';

  @override
  String get tileDurationRequired => 'Podaj czas w minutach';

  @override
  String get tileDurationRange => 'Czas musi być między 1 a 60 minut';

  @override
  String get maxTilesReached => 'Osiągnięto maksymalną liczbę kafelków (10)';

  @override
  String tileListTitle(int count) {
    return 'Lista kafelków ($count/10)';
  }

  @override
  String get tileListEmpty => 'Brak kafelków minutników';

  @override
  String get maxTilesError => 'Maksymalnie 10 kafelków minutników';

  @override
  String get duplicateTimeError => 'Kafelek z tym czasem już istnieje';

  @override
  String get tileAdded => 'Kafelek dodany';

  @override
  String get tileDeleted => 'Kafelek usunięty';

  @override
  String get vibrationEnabled => 'Wibracje włączone';

  @override
  String get vibrationDisabled => 'Wibracje wyłączone';

  @override
  String get themeSaved => 'Motyw zapisany';

  @override
  String get resetButtonVisible => 'Przycisk Reset widoczny';

  @override
  String get resetButtonHidden => 'Przycisk Reset ukryty';

  @override
  String get pauseButtonVisible => 'Przycisk Pauza widoczny';

  @override
  String get pauseButtonHidden => 'Przycisk Pauza ukryty';

  @override
  String get deleteTileTitle => 'Usuń kafelek?';

  @override
  String deleteTileConfirm(String name) {
    return 'Czy na pewno chcesz usunąć kafelek \"$name\"?';
  }

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get pickColorTitle => 'Wybierz kolor';

  @override
  String get done => 'Gotowe';

  @override
  String get reset => 'Reset';

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Wznów';

  @override
  String get stop => 'Stop';

  @override
  String get resetTooltip => 'Rozpocznij odliczanie od nowa';

  @override
  String get pauseTooltip => 'Zatrzymaj odliczanie';

  @override
  String get resumeTooltip => 'Wznów odliczanie';

  @override
  String get stopTooltip => 'Zatrzymaj i wróć do menu głównego';
}
