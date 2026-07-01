// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

// Sekcja ustawień: wibracja + motyw oraz widoczność przycisków akcji.
class ConfigSettingsSection extends StatelessWidget {
  final bool vibrationEnabled;
  final ValueChanged<bool> onVibrationChanged;
  final String themeMode;
  final ValueChanged<String> onThemeModeChanged;
  final bool showResetButton;
  final ValueChanged<bool> onShowResetButtonChanged;
  final bool showPauseButton;
  final ValueChanged<bool> onShowPauseButtonChanged;

  const ConfigSettingsSection({
    super.key,
    required this.vibrationEnabled,
    required this.onVibrationChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.showResetButton,
    required this.onShowResetButtonChanged,
    required this.showPauseButton,
    required this.onShowPauseButtonChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Karta: Ustawienia (wibracja + motyw)
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
                  value: vibrationEnabled,
                  onChanged: onVibrationChanged,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: themeMode,
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
                      onThemeModeChanged(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Karta: Widoczność przycisków
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
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(l10n.showResetButton),
                  subtitle: Text(l10n.showResetButtonSubtitle),
                  value: showResetButton,
                  onChanged: onShowResetButtonChanged,
                ),
                SwitchListTile(
                  title: Text(l10n.showPauseButton),
                  subtitle: Text(l10n.showPauseButtonSubtitle),
                  value: showPauseButton,
                  onChanged: onShowPauseButtonChanged,
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
      ],
    );
  }
}
