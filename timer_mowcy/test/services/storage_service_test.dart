// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_mowcy/models/timer_tile.dart';
import 'package:timer_mowcy/services/storage_service.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Provide a clean SharedPreferences store for every test.
    SharedPreferences.setMockInitialValues({});
  });

  TimerTile makeTile({
    String id = '1',
    String name = 'A',
    int durationSeconds = 60,
    int colorValue = 0xFF0000FF,
  }) => TimerTile(
    id: id,
    name: name,
    durationSeconds: durationSeconds,
    colorValue: colorValue,
  );

  group('StorageService tiles', () {
    test('saveTiles then loadTiles round-trips data', () async {
      final tiles = [
        makeTile(id: '1', name: 'Short', durationSeconds: 60),
        makeTile(
          id: '2',
          name: 'Long',
          durationSeconds: 600,
          colorValue: 0xFFFF0000,
        ),
      ];

      await StorageService.saveTiles(tiles);
      final loaded = await StorageService.loadTiles();

      expect(loaded.length, 2);
      expect(loaded[0].id, '1');
      expect(loaded[0].name, 'Short');
      expect(loaded[0].durationSeconds, 60);
      expect(loaded[0].colorValue, 0xFF0000FF);
      expect(loaded[1].id, '2');
      expect(loaded[1].durationSeconds, 600);
      expect(loaded[1].colorValue, 0xFFFF0000);
    });

    test('empty storage returns an empty list', () async {
      final loaded = await StorageService.loadTiles();
      expect(loaded, isEmpty);
    });

    test(
      'corrupted JSON in timer_tiles key returns empty list gracefully',
      () async {
        // Inject a corrupt JSON string directly into the mock store.
        SharedPreferences.setMockInitialValues(<String, Object>{
          'timer_tiles': 'this is {not valid] json',
        });

        final loaded = await StorageService.loadTiles();
        expect(loaded, isEmpty);
      },
    );

    test('deleteTile removes the matching id and keeps the rest', () async {
      await StorageService.saveTiles([
        makeTile(id: 'keep', name: 'Keep', durationSeconds: 60),
        makeTile(id: 'drop', name: 'Drop', durationSeconds: 120),
      ]);

      await StorageService.deleteTile('drop');

      final loaded = await StorageService.loadTiles();
      expect(loaded.length, 1);
      expect(loaded.first.id, 'keep');
    });
  });

  group('StorageService themeMode', () {
    test('saveThemeMode then loadThemeMode round-trips "dark"', () async {
      await StorageService.saveThemeMode('dark');
      expect(await StorageService.loadThemeMode(), 'dark');
    });

    test('loadThemeMode defaults to "system" when unset', () async {
      expect(await StorageService.loadThemeMode(), 'system');
    });
  });

  group('StorageService vibrationEnabled', () {
    test(
      'saveVibrationEnabled(false) then loadVibrationEnabled is false',
      () async {
        await StorageService.saveVibrationEnabled(false);
        expect(await StorageService.loadVibrationEnabled(), isFalse);
      },
    );

    test('loadVibrationEnabled defaults to true when unset', () async {
      expect(await StorageService.loadVibrationEnabled(), isTrue);
    });
  });

  group('StorageService showResetButton', () {
    test(
      'saveShowResetButton(false) then loadShowResetButton is false',
      () async {
        await StorageService.saveShowResetButton(false);
        expect(await StorageService.loadShowResetButton(), isFalse);
      },
    );

    test('loadShowResetButton defaults to true when unset', () async {
      expect(await StorageService.loadShowResetButton(), isTrue);
    });
  });

  group('StorageService showPauseButton', () {
    test(
      'saveShowPauseButton(false) then loadShowPauseButton is false',
      () async {
        await StorageService.saveShowPauseButton(false);
        expect(await StorageService.loadShowPauseButton(), isFalse);
      },
    );

    test('loadShowPauseButton defaults to true when unset', () async {
      expect(await StorageService.loadShowPauseButton(), isTrue);
    });
  });

  // Sanity check that the corrupted-JSON path is really exercised against the
  // same key the service uses.
  test('storage key used for tiles is "timer_tiles"', () async {
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('timer_tiles'), isNull);
    await StorageService.saveTiles([makeTile()]);
    expect(prefs.getString('timer_tiles'), isNotNull);
    // The stored value is a JSON array.
    expect(jsonDecode(prefs.getString('timer_tiles')!), isA<List>());
  });
}
