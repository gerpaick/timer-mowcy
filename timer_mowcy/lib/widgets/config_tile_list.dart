// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/timer_tile.dart';

// Lista istniejących kafelków minutnika z przyciskami usunięcia.
//
// Samo usunięcie (wraz z dialogiem potwierdzenia) jest obsługiwane
// przez rodzica za pośrednictwem wywołania [onDeleteTile].
class ConfigTileList extends StatelessWidget {
  final List<TimerTile> tiles;
  final Future<void> Function(String tileId) onDeleteTile;
  final int maxTiles;

  const ConfigTileList({
    super.key,
    required this.tiles,
    required this.onDeleteTile,
    this.maxTiles = 10,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.tileListTitle(tiles.length),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (tiles.isEmpty)
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
                itemCount: tiles.length,
                itemBuilder: (context, index) {
                  final tile = tiles[index];
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
                      onPressed: () => onDeleteTile(tile.id),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
