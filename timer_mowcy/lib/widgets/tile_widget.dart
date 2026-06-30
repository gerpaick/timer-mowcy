// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import '../models/timer_tile.dart';

// Widget kafelka minutnika do wyświetlania na ekranie głównym
class TileWidget extends StatelessWidget {
  final TimerTile tile;
  final VoidCallback onTap;

  const TileWidget({
    super.key,
    required this.tile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Color(tile.colorValue).withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Container(
            decoration: BoxDecoration(
              color: Color(tile.colorValue),
              borderRadius: BorderRadius.circular(16),
            ),
            // Użyj LayoutBuilder do responsywnego skalowania tekstu
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Oblicz optymalny rozmiar czcionki bazując na dostępnej przestrzeni
                final nameSize = (constraints.maxWidth * 0.22).clamp(14.0, 28.0);
                final timeSize = (constraints.maxWidth * 0.18).clamp(12.0, 22.0);
                final spacing = (constraints.maxHeight * 0.06).clamp(4.0, 8.0);
                
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.08,
                    vertical: constraints.maxHeight * 0.08,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nazwa kafelka z FittedBox
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tile.name,
                            style: TextStyle(
                              fontSize: nameSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: const [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                      // Wyświetlany czas MM:SS z FittedBox
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tile.formattedTime,
                            style: TextStyle(
                              fontSize: timeSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: const [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
