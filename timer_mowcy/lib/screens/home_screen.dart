// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/timer_tile.dart';
import '../services/storage_service.dart';
import '../widgets/tile_widget.dart';
import 'timer_screen.dart';
import 'stopwatch_screen.dart';
import 'config_screen.dart';

// Ekran główny z siatką kafelków minutników
class HomeScreen extends StatefulWidget {
  final VoidCallback? onThemeChanged;

  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TimerTile> _tiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Załaduj kafelki po pierwszym renderze, aby nie blokować UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTiles();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Wymuszaj full screen za każdym razem gdy ekran się wyświetla
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  // Załaduj kafelki z pamięci
  Future<void> _loadTiles() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final tiles = await StorageService.loadTiles();

      if (!mounted) return;

      setState(() {
        // Dodaj domyślny kafelek "STOPER" jeśli lista jest pusta
        if (tiles.isEmpty) {
          _tiles = [
            TimerTile(
              id: 'stopwatch',
              name: 'STOPER',
              durationSeconds: 0, // stoper nie ma limitu czasu
              colorValue: Colors.blue.toARGB32(),
            ),
          ];
        } else {
          // Sortuj kafelki rosnąco według czasu
          _tiles = List.from(tiles);
          _tiles.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
        }
        _isLoading = false;
      });
    } catch (e) {
      // W razie błędu, pokaż domyślny kafelek STOPER
      if (!mounted) return;
      setState(() {
        _tiles = [
          TimerTile(
            id: 'stopwatch',
            name: 'STOPER',
            durationSeconds: 0,
            colorValue: Colors.blue.toARGB32(),
          ),
        ];
        _isLoading = false;
      });
    }
  }

  // Odśwież listę kafelków (np. po powrocie z konfiguracji)
  Future<void> _refreshTiles() async {
    await _loadTiles();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          // Przycisk konfiguracji w prawym górnym rogu z podpowiedzią
          Tooltip(
            message: l10n.settingsHint,
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: l10n.settingsTooltip,
              onPressed: () async {
                // Nawigacja do ekranu konfiguracji
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ConfigScreen(onThemeChanged: widget.onThemeChanged),
                  ),
                );
                // Odśwież listę kafelków po powrocie z konfiguracji
                if (result == true) {
                  _refreshTiles();
                }
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.noTiles, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ConfigScreen(
                            onThemeChanged: widget.onThemeChanged,
                          ),
                        ),
                      );
                      // Odśwież listę kafelków po powrocie z konfiguracji
                      if (result == true) {
                        _refreshTiles();
                      }
                    },
                    child: Text(l10n.addTilesButton),
                  ),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                // Określ liczbę kolumn na podstawie orientacji i szerokości ekranu
                // Małe ekrany (<500px): 4 kolumny
                // Średnie/duże ekrany landscape: 5 kolumn
                // Portrait: 4 kolumny
                final isSmallScreen = constraints.maxWidth < 500;
                final isLandscape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                final crossAxisCount = isSmallScreen
                    ? 4
                    : (isLandscape ? 5 : 4);

                // Dostosuj spacing i aspectRatio do rozmiaru ekranu
                final spacing = isSmallScreen ? 8.0 : 12.0;
                final aspectRatio = isSmallScreen ? 1.0 : 1.2;
                final padding = isSmallScreen ? 12.0 : 16.0;

                return GridView.builder(
                  padding: EdgeInsets.all(padding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: _tiles.length,
                  itemBuilder: (context, index) {
                    final tile = _tiles[index];
                    return TileWidget(
                      tile: tile,
                      onTap: () {
                        // Jeśli to STOPER (durationSeconds == 0), nawiguj do ekranu stopera
                        if (tile.id == 'stopwatch' ||
                            tile.durationSeconds == 0) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const StopwatchScreen(),
                            ),
                          );
                        } else {
                          // Nawigacja do ekranu minutnika
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TimerScreen(tile: tile),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
