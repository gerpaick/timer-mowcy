// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timer_mowcy/models/timer_tile.dart';

void main() {
  group('TimerTile JSON', () {
    test('fromJson(toJson(tile)) round-trips all fields', () {
      final tile = TimerTile(
        id: 'abc-123',
        name: '5 MIN',
        durationSeconds: 300,
        colorValue: Colors.blue.toARGB32(),
      );
      final restored = TimerTile.fromJson(tile.toJson());
      expect(restored.id, tile.id);
      expect(restored.name, tile.name);
      expect(restored.durationSeconds, tile.durationSeconds);
      expect(restored.colorValue, tile.colorValue);
    });

    test('toJson() emits the four expected keys', () {
      final tile = TimerTile(
        id: 'x',
        name: 'A',
        durationSeconds: 60,
        colorValue: 0xFF0000FF,
      );
      final json = tile.toJson();
      expect(json.keys.toSet(), {'id', 'name', 'durationSeconds', 'colorValue'});
      expect(json['id'], 'x');
      expect(json['durationSeconds'], 60);
    });
  });

  group('TimerTile.formattedTime', () {
    test('formats seconds as MM:SS with zero-padding', () {
      TimerTile tile({
        required int durationSeconds,
      }) =>
          TimerTile(
            id: '0',
            name: 'x',
            durationSeconds: durationSeconds,
            colorValue: 0,
          );

      expect(tile(durationSeconds: 0).formattedTime, '00:00');
      expect(tile(durationSeconds: 1).formattedTime, '00:01');
      expect(tile(durationSeconds: 59).formattedTime, '00:59');
      expect(tile(durationSeconds: 60).formattedTime, '01:00');
      expect(tile(durationSeconds: 125).formattedTime, '02:05');
      expect(tile(durationSeconds: 300).formattedTime, '05:00');
      expect(tile(durationSeconds: 600).formattedTime, '10:00');
      expect(tile(durationSeconds: 3599).formattedTime, '59:59');
    });
  });

  group('TimerTile.copyWith', () {
    test('overrides only provided fields and keeps the rest', () {
      final tile = TimerTile(
        id: '1',
        name: 'A',
        durationSeconds: 60,
        colorValue: 0xFF112233,
      );

      final onlyName = tile.copyWith(name: 'B');
      expect(onlyName.name, 'B');
      expect(onlyName.id, '1');
      expect(onlyName.durationSeconds, 60);
      expect(onlyName.colorValue, 0xFF112233);

      final onlyDurationAndColor = tile.copyWith(
        durationSeconds: 120,
        colorValue: 0xFFAABBCC,
      );
      expect(onlyDurationAndColor.durationSeconds, 120);
      expect(onlyDurationAndColor.colorValue, 0xFFAABBCC);
      expect(onlyDurationAndColor.name, 'A');
    });
  });

  group('TimerTile sorting', () {
    test('list.sort by durationSeconds ascending orders correctly', () {
      final tiles = <TimerTile>[
        TimerTile(id: '3', name: 'C', durationSeconds: 300, colorValue: 0),
        TimerTile(id: '1', name: 'A', durationSeconds: 60, colorValue: 0),
        TimerTile(id: '2', name: 'B', durationSeconds: 120, colorValue: 0),
        TimerTile(id: '4', name: 'D', durationSeconds: 60, colorValue: 0),
      ];

      tiles.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));

      expect(tiles.map((t) => t.durationSeconds).toList(), [60, 60, 120, 300]);
    });
  });
}
