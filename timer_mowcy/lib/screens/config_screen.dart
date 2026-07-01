// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/timer_tile.dart';
import '../services/storage_service.dart';
import '../widgets/config_settings_section.dart';
import '../widgets/config_tile_form.dart';
import '../widgets/config_tile_list.dart';

// Ekran konfiguracji kafelków minutnika.
//
// Po refaktoryzacji ekran jest orchestratorem: przechowuje stan ustawień
// i listy kafelków oraz deleguje renderowanie do wyspecjalizowanych widgetów
// (ConfigSettingsSection, ConfigTileForm, ConfigTileList).
class ConfigScreen extends StatefulWidget {
  final VoidCallback? onThemeChanged;

  const ConfigScreen({super.key, this.onThemeChanged});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  List<TimerTile> _tiles = [];
  bool _vibrationEnabled = true;
  bool _isLoading = true;
  String _themeMode = 'system';
  bool _showResetButton = true;
  bool _showPauseButton = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Wyświetl SnackBar (zabezpieczony sprawdzaniem `mounted`).
  void _snackbar(
    String message, {
    Duration duration = const Duration(seconds: 1),
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), duration: duration));
  }

  // Załaduj kafelki i ustawienia
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final results = await Future.wait([
      StorageService.loadTiles(),
      StorageService.loadVibrationEnabled(),
      StorageService.loadThemeMode(),
      StorageService.loadShowResetButton(),
      StorageService.loadShowPauseButton(),
    ]);

    if (!mounted) return;
    setState(() {
      // Filtr kafelków - wyklucz STOPER (id: 'stopwatch')
      _tiles = (results[0] as List<TimerTile>)
          .where((tile) => tile.id != 'stopwatch')
          .toList();
      _tiles.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
      _vibrationEnabled = results[1] as bool;
      _themeMode = results[2] as String;
      _showResetButton = results[3] as bool;
      _showPauseButton = results[4] as bool;
      _isLoading = false;
    });
  }

  // Zapisz ustawienie widoczności przycisku Reset
  Future<void> _saveShowResetButton(bool show) async {
    final msg = AppLocalizations.of(context)!;
    await StorageService.saveShowResetButton(show);
    setState(() => _showResetButton = show);
    _snackbar(show ? msg.resetButtonVisible : msg.resetButtonHidden);
  }

  // Zapisz ustawienie widoczności przycisku Pauza
  Future<void> _saveShowPauseButton(bool show) async {
    final msg = AppLocalizations.of(context)!;
    await StorageService.saveShowPauseButton(show);
    setState(() => _showPauseButton = show);
    _snackbar(show ? msg.pauseButtonVisible : msg.pauseButtonHidden);
  }

  // Zapisz zmiany i odśwież listę
  Future<void> _saveAndRefresh() async {
    // Pobierz wszystkie kafelki (w tym STOPER jeśli istnieje)
    final allTiles = await StorageService.loadTiles();
    final stopwatchTile = allTiles.firstWhere(
      (tile) => tile.id == 'stopwatch',
      orElse: () => TimerTile(
        id: 'stopwatch',
        name: 'STOPER',
        durationSeconds: 0,
        colorValue: Colors.blue.toARGB32(),
      ),
    );

    // Połącz STOPER z nowymi kafelkami
    final tilesToSave = [stopwatchTile, ..._tiles];
    await StorageService.saveTiles(tilesToSave);
    await _loadData();
  }

  // Adapter: formularz przekazuje zwalidowane dane, rodzic realizuje logikę
  // dodawania (limit 10 kafelków, duplikaty, zapis, powiadomienie).
  Future<void> _addTileFromForm({
    required String name,
    required int durationSeconds,
    required int colorValue,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    if (_tiles.length >= 10) {
      _snackbar(l10n.maxTilesError);
      return;
    }

    // Sprawdź czy kafelek z tym samym czasem już istnieje
    if (_tiles.any((tile) => tile.durationSeconds == durationSeconds)) {
      _snackbar(l10n.duplicateTimeError);
      return;
    }

    final newTile = TimerTile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      durationSeconds: durationSeconds,
      colorValue: colorValue,
    );

    setState(() {
      _tiles.add(newTile);
      _tiles.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
    });

    await _saveAndRefresh();
    _snackbar(l10n.tileAdded);
  }

  // Usuń kafelek (z potwierdzeniem)
  Future<void> _deleteTile(String tileId) async {
    final l10n = AppLocalizations.of(context)!;
    final tile = _tiles.firstWhere((t) => t.id == tileId);

    // Potwierdzenie usunięcia
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final loc = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(loc.deleteTileTitle),
          content: Text(loc.deleteTileConfirm(tile.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(loc.delete),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() => _tiles.removeWhere((t) => t.id == tileId));
      await _saveAndRefresh();
      _snackbar(l10n.tileDeleted);
    }
  }

  // Zapisz ustawienie wibracji
  Future<void> _saveVibrationSetting(bool enabled) async {
    final msg = AppLocalizations.of(context)!;
    await StorageService.saveVibrationEnabled(enabled);
    setState(() => _vibrationEnabled = enabled);
    _snackbar(enabled ? msg.vibrationEnabled : msg.vibrationDisabled);
  }

  // Zapisz ustawienie motywu
  Future<void> _saveThemeSetting(String themeMode) async {
    final msg = AppLocalizations.of(context)!;
    await StorageService.saveThemeMode(themeMode);
    setState(() => _themeMode = themeMode);
    widget.onThemeChanged?.call(); // Odśwież motyw w całej aplikacji
    _snackbar(msg.themeSaved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.config),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(
              context,
            ).pop(true); // Zwróć true aby odświeżyć home screen
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConfigSettingsSection(
                    vibrationEnabled: _vibrationEnabled,
                    onVibrationChanged: _saveVibrationSetting,
                    themeMode: _themeMode,
                    onThemeModeChanged: _saveThemeSetting,
                    showResetButton: _showResetButton,
                    onShowResetButtonChanged: _saveShowResetButton,
                    showPauseButton: _showPauseButton,
                    onShowPauseButtonChanged: _saveShowPauseButton,
                  ),
                  const SizedBox(height: 24),
                  ConfigTileForm(
                    currentTileCount: _tiles.length,
                    onAddTile: _addTileFromForm,
                  ),
                  const SizedBox(height: 24),
                  ConfigTileList(tiles: _tiles, onDeleteTile: _deleteTile),
                ],
              ),
            ),
    );
  }
}
