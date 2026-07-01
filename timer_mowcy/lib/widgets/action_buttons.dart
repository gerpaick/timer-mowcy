// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

// Widget z przyciskami akcji dla minutnika/stopera
class ActionButtons extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onReset;
  final VoidCallback onPauseResume;
  final VoidCallback onStop;
  final bool showResetButton;
  final bool showPauseButton;

  const ActionButtons({
    super.key,
    required this.isRunning,
    required this.isPaused,
    required this.onReset,
    required this.onPauseResume,
    required this.onStop,
    this.showResetButton = true,
    this.showPauseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Dostosuj szerokość przycisków i rozmiar czcionki do dostępnej przestrzeni
        final buttonWidth = (constraints.maxWidth * 0.85).clamp(120.0, 200.0);
        final buttonHeight = (constraints.maxHeight * 0.12).clamp(56.0, 64.0);
        final fontSize = (constraints.maxWidth * 0.08).clamp(14.0, 18.0);
        final iconSize = (constraints.maxWidth * 0.10).clamp(20.0, 24.0);
        final spacing = (constraints.maxHeight * 0.04).clamp(12.0, 20.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Przycisk Reset - warunkowo widoczny
            if (showResetButton) ...[
              Tooltip(
                message: l10n.resetTooltip,
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: onReset,
                    icon: Icon(Icons.refresh, size: iconSize),
                    label: Text(
                      l10n.reset,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.blue.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
            ],
            // Przycisk Pauza/Wznów - warunkowo widoczny
            if (showPauseButton) ...[
              Tooltip(
                message: isPaused ? l10n.resumeTooltip : l10n.pauseTooltip,
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: onPauseResume,
                    icon: Icon(
                      isPaused ? Icons.play_arrow : Icons.pause,
                      size: iconSize,
                    ),
                    label: Text(
                      isPaused ? l10n.resume : l10n.pause,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPaused ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: (isPaused ? Colors.green : Colors.orange)
                          .withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
            ],
            // Przycisk Stop z efektem wciśnięcia i podpowiedzią
            Tooltip(
              message: l10n.stopTooltip,
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: onStop,
                  icon: Icon(Icons.stop, size: iconSize),
                  label: Text(
                    l10n.stop,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.red.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
