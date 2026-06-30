// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../l10n/app_localizations.dart';
import '../models/timer_tile.dart';
import '../services/storage_service.dart';

// Ekran konfiguracji kafelków minutników
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

  // Formularz dodawania nowego kafelka
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minutesController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  // Załaduj kafelki i ustawienia wibracji
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
      _tiles = (results[0] as List<TimerTile>).where((tile) => tile.id != 'stopwatch').toList();
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
    await StorageService.saveShowResetButton(show);
    setState(() {
      _showResetButton = show;
    });

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(show ? l10n.resetButtonVisible : l10n.resetButtonHidden),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  // Zapisz ustawienie widoczności przycisku Pauza
  Future<void> _saveShowPauseButton(bool show) async {
    await StorageService.saveShowPauseButton(show);
    setState(() {
      _showPauseButton = show;
    });

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(show ? l10n.pauseButtonVisible : l10n.pauseButtonHidden),
          duration: const Duration(seconds: 1),
        ),
      );
    }
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

  // Dodaj nowy kafelek
  Future<void> _addTile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_tiles.length >= 10) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.maxTilesError),
          ),
        );
      }
      return;
    }

    final name = _nameController.text.trim();
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final durationSeconds = minutes * 60;

    // Sprawdź czy kafelek z tym samym czasem już istnieje
    if (_tiles.any((tile) => tile.durationSeconds == durationSeconds)) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.duplicateTimeError),
          ),
        );
      }
      return;
    }

    final newTile = TimerTile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      durationSeconds: durationSeconds,
      colorValue: _selectedColor.toARGB32(),
    );

    setState(() {
      _tiles.add(newTile);
      _tiles.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
    });

    await _saveAndRefresh();

    // Wyczyść formularz
    _nameController.clear();
    _minutesController.clear();
    _selectedColor = Colors.blue;

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.tileAdded),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  // Usuń kafelek
  Future<void> _deleteTile(String tileId) async {
    final tile = _tiles.firstWhere((t) => t.id == tileId);

    // Potwierdzenie usunięcia
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.deleteTileTitle),
          content: Text(l10n.deleteTileConfirm(tile.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _tiles.removeWhere((t) => t.id == tileId);
      });
      await _saveAndRefresh();

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.tileDeleted),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  // Pokaż wybór koloru
  Future<void> _showColorPicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.pickColorTitle),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.done),
            ),
          ],
        );
      },
    );
  }

  // Zapisz ustawienie wibracji
  Future<void> _saveVibrationSetting(bool enabled) async {
    await StorageService.saveVibrationEnabled(enabled);
    setState(() {
      _vibrationEnabled = enabled;
    });

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(enabled ? l10n.vibrationEnabled : l10n.vibrationDisabled),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  // Zapisz ustawienie motywu
  Future<void> _saveThemeSetting(String themeMode) async {
    await StorageService.saveThemeMode(themeMode);
    setState(() {
      _themeMode = themeMode;
    });

    // Wywołaj callback do odświeżenia motywu
    if (widget.onThemeChanged != null) {
      widget.onThemeChanged!();
    }

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.themeSaved),
          duration: const Duration(seconds: 1),
        ),
      );
    }
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
            Navigator.of(context).pop(true); // Zwróć true aby odświeżyć home screen
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
                  // Sekcja ustawień
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.settingsTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: Text(l10n.vibrationToggleTitle),
                            subtitle: Text(l10n.vibrationToggleSubtitle),
                            value: _vibrationEnabled,
                            onChanged: _saveVibrationSetting,
                          ),
                          const SizedBox(height: 8),
                          // Wybór motywu
                          DropdownButtonFormField<String>(
                            initialValue: _themeMode,
                            decoration: InputDecoration(
                              labelText: l10n.themeModeLabel,
                              border: const OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'light',
                                child: Text(l10n.themeLight),
                              ),
                              DropdownMenuItem(
                                value: 'dark',
                                child: Text(l10n.themeDark),
                              ),
                              DropdownMenuItem(
                                value: 'system',
                                child: Text(l10n.themeSystem),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                _saveThemeSetting(value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sekcja widoczności przycisków
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.buttonVisibilityTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.buttonVisibilitySubtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: Text(l10n.showResetButton),
                            subtitle: Text(l10n.showResetButtonSubtitle),
                            value: _showResetButton,
                            onChanged: _saveShowResetButton,
                          ),
                          SwitchListTile(
                            title: Text(l10n.showPauseButton),
                            subtitle: Text(l10n.showPauseButtonSubtitle),
                            value: _showPauseButton,
                            onChanged: _saveShowPauseButton,
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.info_outline, color: Colors.blue),
                            title: Text(
                              l10n.stopAlwaysVisible,
                              style: const TextStyle(fontSize: 14),
                            ),
                            dense: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sekcja formularza dodawania kafelka
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.addNewTileTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: l10n.tileName,
                                hintText: l10n.tileNameHint,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.tileNameRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _minutesController,
                              decoration: InputDecoration(
                                labelText: l10n.tileDuration,
                                hintText: l10n.tileDurationHint,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.tileDurationRequired;
                                }
                                final minutes = int.tryParse(value);
                                if (minutes == null || minutes < 1 || minutes > 60) {
                                  return l10n.tileDurationRange;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Wybór koloru
                            ListTile(
                              title: Text(l10n.colorLabel),
                              trailing: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _selectedColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onTap: _showColorPicker,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _addTile,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(l10n.addTileButton),
                              ),
                            ),
                            if (_tiles.length >= 10)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  l10n.maxTilesReached,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lista kafelków
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.tileListTitle(_tiles.length),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_tiles.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: Text(
                                  l10n.tileListEmpty,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _tiles.length,
                              itemBuilder: (context, index) {
                                final tile = _tiles[index];
                                return ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(tile.colorValue),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  title: Text(tile.name),
                                  subtitle: Text(tile.formattedTime),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteTile(tile.id),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
