// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SpeakerTimer';

  @override
  String get stopwatch => 'STOPWATCH';

  @override
  String get config => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get settingsHint => 'Add or remove timer tiles';

  @override
  String get noTiles => 'No tiles';

  @override
  String get addTilesButton => 'Add tiles';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get vibrationToggleTitle => 'Vibrate when time is up';

  @override
  String get vibrationToggleSubtitle => 'Vibrate when timer reaches 00:00';

  @override
  String get themeModeLabel => 'App theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get buttonVisibilityTitle => 'Button visibility';

  @override
  String get buttonVisibilitySubtitle =>
      'Control which buttons are visible on the timer and stopwatch screens';

  @override
  String get showResetButton => 'Show Reset button';

  @override
  String get showResetButtonSubtitle => 'Restart the countdown';

  @override
  String get showPauseButton => 'Show Pause button';

  @override
  String get showPauseButtonSubtitle => 'Pause/resume the countdown';

  @override
  String get stopAlwaysVisible => 'Stop button is always visible';

  @override
  String get addNewTileTitle => 'Add new tile';

  @override
  String get tileName => 'Name';

  @override
  String get tileNameHint => 'e.g. 5 MIN';

  @override
  String get tileDuration => 'Duration (minutes)';

  @override
  String get tileDurationHint => 'e.g. 5';

  @override
  String get colorLabel => 'Color';

  @override
  String get addTileButton => 'Add tile';

  @override
  String get tileNameRequired => 'Enter a tile name';

  @override
  String get tileDurationRequired => 'Enter duration in minutes';

  @override
  String get tileDurationRange => 'Duration must be between 1 and 60 minutes';

  @override
  String get maxTilesReached => 'Maximum number of tiles reached (10)';

  @override
  String tileListTitle(int count) {
    return 'Tile list ($count/10)';
  }

  @override
  String get tileListEmpty => 'No timer tiles';

  @override
  String get maxTilesError => 'Maximum 10 timer tiles';

  @override
  String get duplicateTimeError => 'Tile with this duration already exists';

  @override
  String get tileAdded => 'Tile added';

  @override
  String get tileDeleted => 'Tile deleted';

  @override
  String get vibrationEnabled => 'Vibration enabled';

  @override
  String get vibrationDisabled => 'Vibration disabled';

  @override
  String get themeSaved => 'Theme saved';

  @override
  String get resetButtonVisible => 'Reset button visible';

  @override
  String get resetButtonHidden => 'Reset button hidden';

  @override
  String get pauseButtonVisible => 'Pause button visible';

  @override
  String get pauseButtonHidden => 'Pause button hidden';

  @override
  String get deleteTileTitle => 'Delete tile?';

  @override
  String deleteTileConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get pickColorTitle => 'Pick a color';

  @override
  String get done => 'Done';

  @override
  String get reset => 'Reset';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get stop => 'Stop';

  @override
  String get resetTooltip => 'Restart the countdown';

  @override
  String get pauseTooltip => 'Pause the countdown';

  @override
  String get resumeTooltip => 'Resume the countdown';

  @override
  String get stopTooltip => 'Stop and return to main menu';
}
