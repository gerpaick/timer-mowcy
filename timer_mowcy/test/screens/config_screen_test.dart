// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_mowcy/l10n/app_localizations.dart';
import 'package:timer_mowcy/models/timer_tile.dart';
import 'package:timer_mowcy/screens/config_screen.dart';
import 'package:timer_mowcy/services/storage_service.dart';

/// Wraps [home] in a MaterialApp configured with the app's localization
/// delegates and forced to Polish (the template/native locale) so the screen
/// text is deterministic in tests.
Widget _localizedApp(Widget home) {
  return MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  /// Seed SharedPreferences with raw tiles JSON.
  void seedStorage(List<TimerTile> tiles) {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'timer_tiles': jsonEncode(tiles.map((t) => t.toJson()).toList()),
    });
  }

  TimerTile tile({
    String id = '1',
    String name = 'A',
    int durationSeconds = 60,
    int colorValue = 0xFF2196F3,
  }) => TimerTile(
    id: id,
    name: name,
    durationSeconds: durationSeconds,
    colorValue: colorValue,
  );

  /// Builds ten distinct tiles (1..10 minutes) for the 10-tile-limit scenario.
  List<TimerTile> tenTiles() {
    return List.generate(10, (i) {
      final minutes = i + 1;
      return tile(
        id: 'id-$minutes',
        name: '$minutes MIN',
        durationSeconds: minutes * 60,
      );
    });
  }

  group('ConfigScreen add tile', () {
    testWidgets(
      'submitting the form with valid name + minutes persists a tile',
      (tester) async {
        await tester.pumpWidget(_localizedApp(const ConfigScreen()));
        await tester.pumpAndSettle();

        // Two TextFormField widgets: name (index 0) and minutes (index 1).
        final fields = find.byType(TextFormField);
        expect(fields, findsNWidgets(2));

        await tester.enterText(fields.at(0), 'MOJ KAFELEK');
        await tester.enterText(fields.at(1), '5');
        await tester.pump();

        // The config screen scrolls; bring the button into view before tapping.
        final addButton = find.widgetWithText(ElevatedButton, 'Dodaj kafelek');
        await tester.ensureVisible(addButton);
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        // Verify the side effect via storage.
        final persisted = await StorageService.loadTiles();
        final added = persisted.firstWhere((t) => t.name == 'MOJ KAFELEK');
        expect(added.durationSeconds, 300);
      },
    );

    testWidgets('empty name is rejected by the validator', (tester) async {
      await tester.pumpWidget(_localizedApp(const ConfigScreen()));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      // Only minutes; leave name empty.
      await tester.enterText(fields.at(1), '5');
      await tester.pump();

      final addButton = find.widgetWithText(ElevatedButton, 'Dodaj kafelek');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('Podaj nazwę kafelka'), findsOneWidget);
      final persisted = await StorageService.loadTiles();
      expect(persisted, isEmpty);
    });
  });

  group('ConfigScreen 10-tile limit', () {
    testWidgets('blocks adding an 11th tile when 10 already exist', (
      tester,
    ) async {
      seedStorage(tenTiles());

      await tester.pumpWidget(_localizedApp(const ConfigScreen()));
      await tester.pumpAndSettle();

      // The header should report 10/10.
      expect(find.text('Lista kafelków (10/10)'), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'EXTRA');
      // Use a duration that does NOT collide with an existing tile (e.g. 30 min)
      // to avoid the duplicate-time guard short-circuiting the limit guard.
      await tester.enterText(fields.at(1), '45');
      await tester.pump();

      final addButton = find.widgetWithText(ElevatedButton, 'Dodaj kafelek');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Blocked: storage must still contain exactly the 10 original tiles.
      final persisted = await StorageService.loadTiles();
      expect(persisted.length, 10);
      expect(persisted.any((t) => t.name == 'EXTRA'), isFalse);
    });
  });

  group('ConfigScreen delete tile', () {
    testWidgets('tapping the delete icon then confirming removes the tile', (
      tester,
    ) async {
      seedStorage([
        tile(id: 'keep', name: 'KEEP', durationSeconds: 60),
        tile(id: 'drop', name: 'DROP', durationSeconds: 120),
      ]);

      await tester.pumpWidget(_localizedApp(const ConfigScreen()));
      await tester.pumpAndSettle();

      // Two delete icons, one per tile row.
      final deleteIcons = find.byIcon(Icons.delete);
      expect(deleteIcons, findsNWidgets(2));

      // Tap the delete icon on the row showing "DROP".
      final dropRow = find.ancestor(
        of: find.text('DROP'),
        matching: find.byType(ListTile),
      );
      final dropDelete = find.descendant(
        of: dropRow,
        matching: find.byIcon(Icons.delete),
      );
      await tester.ensureVisible(dropDelete);
      await tester.tap(dropDelete);
      await tester.pumpAndSettle();

      // Confirmation dialog appears.
      expect(find.text('Usuń kafelek?'), findsOneWidget);
      await tester.tap(find.text('Usuń'));
      await tester.pumpAndSettle();

      // The tile is gone from storage (the service re-adds the stopwatch if it
      // existed; here we seeded none, so the deleted tile simply disappears).
      final persisted = await StorageService.loadTiles();
      expect(persisted.any((t) => t.id == 'drop'), isFalse);
      expect(persisted.any((t) => t.id == 'keep'), isTrue);
    });

    testWidgets('cancelling the delete dialog keeps the tile', (tester) async {
      seedStorage([tile(id: 'keep', name: 'KEEP', durationSeconds: 60)]);

      await tester.pumpWidget(_localizedApp(const ConfigScreen()));
      await tester.pumpAndSettle();

      final deleteIcon = find.byIcon(Icons.delete).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Usuń kafelek?'), findsOneWidget);
      await tester.tap(find.text('Anuluj'));
      await tester.pumpAndSettle();

      final persisted = await StorageService.loadTiles();
      expect(persisted.any((t) => t.id == 'keep'), isTrue);
    });
  });
}
