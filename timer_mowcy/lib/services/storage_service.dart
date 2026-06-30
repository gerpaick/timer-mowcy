// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_tile.dart';

// Serwis do zapisu i odczytu konfiguracji kafelków
class StorageService {
  static const String _tilesKey = 'timer_tiles';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _themeModeKey = 'theme_mode';
  static const String _showResetButtonKey = 'show_reset_button';
  static const String _showPauseButtonKey = 'show_pause_button';

  // Zapisz listę kafelków
  static Future<void> saveTiles(List<TimerTile> tiles) async {
    final prefs = await SharedPreferences.getInstance();
    final tilesJson = tiles.map((tile) => tile.toJson()).toList();
    await prefs.setString(_tilesKey, jsonEncode(tilesJson));
  }

  // Odczytaj listę kafelków
  static Future<List<TimerTile>> loadTiles() async {
    final prefs = await SharedPreferences.getInstance();
    final tilesJsonString = prefs.getString(_tilesKey);

    if (tilesJsonString == null) {
      return [];
    }

    try {
      final List<dynamic> tilesJson = jsonDecode(tilesJsonString);
      return tilesJson
          .map((json) => TimerTile.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Jeśli wystąpi błąd podczas parsowania, zwróć pustą listę
      return [];
    }
  }

  // Zapisz stan wibracji
  static Future<void> saveVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationEnabledKey, enabled);
  }

  // Odczytaj stan wibracji
  static Future<bool> loadVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationEnabledKey) ?? true; // domyślnie włączone
  }

  // Zapisz motyw
  static Future<void> saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, themeMode);
  }

  // Odczytaj motyw
  static Future<String> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey) ?? 'system'; // domyślnie systemowy
  }

  // Zapisz widoczność przycisku Reset
  static Future<void> saveShowResetButton(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showResetButtonKey, show);
  }

  // Odczytaj widoczność przycisku Reset
  static Future<bool> loadShowResetButton() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showResetButtonKey) ?? true; // domyślnie widoczny
  }

  // Zapisz widoczność przycisku Pauza
  static Future<void> saveShowPauseButton(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showPauseButtonKey, show);
  }

  // Odczytaj widoczność przycisku Pauza
  static Future<bool> loadShowPauseButton() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showPauseButtonKey) ?? true; // domyślnie widoczny
  }

  // Usuń kafelek
  static Future<void> deleteTile(String tileId) async {
    final tiles = await loadTiles();
    tiles.removeWhere((tile) => tile.id == tileId);
    await saveTiles(tiles);
  }
}
