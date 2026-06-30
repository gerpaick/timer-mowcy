// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_mowcy/l10n/app_localizations.dart';
import 'package:timer_mowcy/models/timer_tile.dart';
import 'package:timer_mowcy/screens/home_screen.dart';
import 'package:timer_mowcy/widgets/tile_widget.dart';

/// Wraps [child] in a MaterialApp configured with the app's localization
/// delegates and forced to Polish (the template/native locale) so the screen
/// text is deterministic in tests.
Widget _localizedApp({required Widget home, List<NavigatorObserver>? observers}) {
  return MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    navigatorObservers: observers ?? const [],
    home: home,
  );
}

/// A [NavigatorObserver] that records the number of routes pushed so the home
/// screen navigation can be verified without needing the destination screens to
/// fully settle (which would spin up periodic timers and platform channels).
class _PushCountingObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount++;
  }
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  /// Mocks the platform channels that the home/destination screens talk to so
  /// that the unawaited platform calls (SystemChrome, the Title widget,
  /// WakelockPlus) do not surface as errors in the test. Each channel is mocked
  /// with its OWN codec: `flutter/platform` uses the JSONMethodCodec carried by
  /// [SystemChannels.platform], while wakelock uses the standard codec.
  void mockSystemChannels(WidgetTester tester) {
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall call) async => null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('wakelock_plus_macos'),
      (MethodCall call) async => null,
    );
  }

  /// Seeds SharedPreferences with a stopwatch tile plus [userTiles].
  void seedStorage(List<TimerTile> userTiles) {
    final stopwatch = TimerTile(
      id: 'stopwatch',
      name: 'STOPER',
      durationSeconds: 0,
      colorValue: Colors.blue.toARGB32(),
    );
    SharedPreferences.setMockInitialValues(<String, Object>{
      'timer_tiles': jsonEncode(
        [stopwatch, ...userTiles].map((t) => t.toJson()).toList(),
      ),
    });
  }

  TimerTile userTile({
    String id = 't1',
    String name = 'TEST',
    int durationSeconds = 300,
  }) =>
      TimerTile(
        id: id,
        name: name,
        durationSeconds: durationSeconds,
        colorValue: Colors.green.toARGB32(),
      );

  group('HomeScreen tile rendering', () {
    testWidgets('renders the stopwatch tile plus user tiles from storage',
        (tester) async {
      mockSystemChannels(tester);
      seedStorage([
        userTile(id: 't1', name: 'A', durationSeconds: 60),
        userTile(id: 't2', name: 'B', durationSeconds: 300),
      ]);

      final observer = _PushCountingObserver();
      await tester.pumpWidget(
        _localizedApp(home: const HomeScreen(), observers: [observer]),
      );
      await tester.pumpAndSettle();

      // 2 user tiles + 1 STOPER = 3 TileWidgets.
      expect(find.byType(TileWidget), findsNWidgets(3));
      expect(find.text('STOPER'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      // Only the initial home route was pushed (no navigation away).
      expect(observer.pushCount, 1);
    });

    testWidgets('with empty storage shows a single STOPER tile', (tester) async {
      mockSystemChannels(tester);

      await tester.pumpWidget(
        _localizedApp(home: const HomeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('STOPER'), findsOneWidget);
      expect(find.byType(TileWidget), findsOneWidget);
    });
  });

  group('HomeScreen navigation', () {
    testWidgets('tapping a user tile triggers navigation', (tester) async {
      mockSystemChannels(tester);
      seedStorage([userTile(id: 't1', name: 'TARGET', durationSeconds: 120)]);

      final observer = _PushCountingObserver();
      await tester.pumpWidget(
        _localizedApp(home: const HomeScreen(), observers: [observer]),
      );
      await tester.pumpAndSettle();

      // 1 = initial home route; no navigation yet beyond it.
      expect(observer.pushCount, 1);
      await tester.tap(find.text('TARGET'));
      await tester.pump();

      // A new route was pushed onto the navigator.
      expect(observer.pushCount, 2);
    });

    testWidgets('tapping the gear icon triggers config navigation',
        (tester) async {
      mockSystemChannels(tester);

      final observer = _PushCountingObserver();
      await tester.pumpWidget(
        _localizedApp(home: const HomeScreen(), observers: [observer]),
      );
      await tester.pumpAndSettle();

      final gearFinder = find.byIcon(Icons.settings);
      expect(gearFinder, findsOneWidget);
      expect(observer.pushCount, 1);

      await tester.tap(gearFinder);
      await tester.pump();

      // A new route was pushed (config screen).
      expect(observer.pushCount, 2);
    });
  });
}
