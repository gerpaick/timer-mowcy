// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../l10n/app_localizations.dart';

// Formularz dodawania nowego kafelka minutnika.
//
// Sam zarządza stanem pól tekstowych (nazwa, czas) oraz wybranym kolorem.
// Walidacja odbywa się lokalnie; po pomyślnym przepchnięciu danych przez
// [onAddTile] formularz czyści pola (o ile nie osiągnięto limitu [maxTiles]).
class ConfigTileForm extends StatefulWidget {
  final int currentTileCount;
  final Future<void> Function({
    required String name,
    required int durationSeconds,
    required int colorValue,
  }) onAddTile;
  final int maxTiles;

  const ConfigTileForm({
    super.key,
    required this.currentTileCount,
    required this.onAddTile,
    this.maxTiles = 10,
  });

  @override
  State<ConfigTileForm> createState() => _ConfigTileFormState();
}

class _ConfigTileFormState extends State<ConfigTileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minutesController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  void dispose() {
    _nameController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  // Pokaż wybór koloru
  Future<void> _showColorPicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.pickColorTitle),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.done),
            ),
          ],
        );
      },
    );
  }

  // Obsłuż kliknięcie przycisku "Dodaj kafelek"
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final durationSeconds = minutes * 60;

    await widget.onAddTile(
      name: name,
      durationSeconds: durationSeconds,
      colorValue: _selectedColor.toARGB32(),
    );

    // Heurystyka: poniżej limitu rodzic faktycznie dodał kafelek — czyść pola.
    // Przy limicie osiągniętym rodzic odrzuca; zachowaj wpisane dane użytkownika.
    if (widget.currentTileCount < widget.maxTiles) {
      _nameController.clear();
      _minutesController.clear();
      setState(() {
        _selectedColor = Colors.blue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.addNewTileTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.tileName,
                  hintText: l10n.tileNameHint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.tileNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _minutesController,
                decoration: InputDecoration(
                  labelText: l10n.tileDuration,
                  hintText: l10n.tileDurationHint,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.tileDurationRequired;
                  }
                  final minutes = int.tryParse(value);
                  if (minutes == null || minutes < 1 || minutes > 60) {
                    return l10n.tileDurationRange;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(l10n.colorLabel),
                trailing: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                onTap: _showColorPicker,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l10n.addTileButton),
                ),
              ),
              if (widget.currentTileCount >= widget.maxTiles)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.maxTilesReached,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
