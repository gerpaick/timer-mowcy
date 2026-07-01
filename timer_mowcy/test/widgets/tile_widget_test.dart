// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timer_mowcy/models/timer_tile.dart';
import 'package:timer_mowcy/widgets/tile_widget.dart';

void main() {
  TimerTile makeTile({
    String id = '1',
    String name = '5 MIN',
    int durationSeconds = 300,
    int colorValue = 0xFF2196F3,
  }) => TimerTile(
    id: id,
    name: name,
    durationSeconds: durationSeconds,
    colorValue: colorValue,
  );

  Future<void> pumpTile(
    WidgetTester tester,
    TimerTile tile, {
    VoidCallback? onTap,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 200,
            child: TileWidget(tile: tile, onTap: onTap ?? () {}),
          ),
        ),
      ),
    );
  }

  group('TileWidget rendering', () {
    testWidgets('renders the tile name and formatted time', (tester) async {
      final tile = makeTile(name: '5 MIN', durationSeconds: 300);
      await pumpTile(tester, tile);

      expect(find.text('5 MIN'), findsOneWidget);
      expect(find.text('05:00'), findsOneWidget);
    });

    testWidgets('renders name and formattedTime for a 10-minute tile', (
      tester,
    ) async {
      final tile = makeTile(name: 'LONG', durationSeconds: 600);
      await pumpTile(tester, tile);

      expect(find.text('LONG'), findsOneWidget);
      expect(find.text('10:00'), findsOneWidget);
    });

    testWidgets('background color matches Color(tile.colorValue)', (
      tester,
    ) async {
      const argb = 0xFFD32F2F; // a distinct red
      final tile = makeTile(colorValue: argb);
      await pumpTile(tester, tile);

      // The TileWidget paints its colour on a Container via a BoxDecoration.
      final paintedContainer = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == const Color(argb),
        ),
      );
      expect(paintedContainer, isNotNull);
    });
  });

  group('TileWidget interaction', () {
    testWidgets('tap invokes the onTap callback', (tester) async {
      var tapped = false;
      final tile = makeTile();
      await pumpTile(tester, tile, onTap: () => tapped = true);

      expect(tapped, isFalse);
      await tester.tap(find.byType(TileWidget));
      expect(tapped, isTrue);
    });
  });
}
