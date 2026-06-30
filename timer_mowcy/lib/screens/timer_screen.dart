// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/timer_tile.dart';
import '../services/timer_controller.dart';
import '../services/storage_service.dart';
import '../widgets/time_display.dart';
import '../widgets/action_buttons.dart';

// Ekran minutnika z layoutem: przyciski po lewej, czas po prawej
class TimerScreen extends StatefulWidget {
  final TimerTile tile;

  const TimerScreen({
    super.key,
    required this.tile,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late TimerController _controller;
  Color? _tileColor;
  bool _vibrationEnabled = true;
  bool _showResetButton = true;
  bool _showPauseButton = true;

  @override
  void initState() {
    super.initState();
    // Utwórz kontroler i rozpocznij odliczanie
    _controller = TimerController();
    
    // Konwertuj colorValue na Color
    _tileColor = Color(widget.tile.colorValue);
    
    // Włącz keep screen on (ekran nie gaśnie)
    WakelockPlus.enable();
    
    // Załaduj ustawienia
    _loadSettings();
  }

  // Załaduj ustawienia
  Future<void> _loadSettings() async {
    final results = await Future.wait([
      StorageService.loadVibrationEnabled(),
      StorageService.loadShowResetButton(),
      StorageService.loadShowPauseButton(),
    ]);
    if (!mounted) return;
    setState(() {
      _vibrationEnabled = results[0];
      _showResetButton = results[1];
      _showPauseButton = results[2];
    });

    // Automatycznie rozpocznij odliczanie z ustawieniem wibracji
    _controller.start(widget.tile.durationSeconds, vibrationEnabled: _vibrationEnabled);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Wymuszaj full screen za każdym razem gdy ekran się wyświetla
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
      overlays: [],
    );
  }

  @override
  void dispose() {
    // Wyłącz keep screen on przed opuszczeniem ekranu
    WakelockPlus.disable();
    _controller.dispose();
    super.dispose();
  }

  // Obsługa Reset
  void _handleReset() {
    _controller.reset(vibrationEnabled: _vibrationEnabled);
    _controller.start(widget.tile.durationSeconds, vibrationEnabled: _vibrationEnabled);
  }

  // Obsługa Pauza/Wznów
  void _handlePauseResume() {
    _controller.pauseResume();
  }

  // Obsługa Stop - wróć do ekranu głównego
  void _handleStop() {
    _controller.stop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usuń AppBar dla prawdziwego full screen
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsywny layout dla landscape
          final isWide = constraints.maxWidth > 800;
          
          return Row(
            children: [
              // Lewa strona - Przyciski (35% szerokości na małych ekranach)
              Expanded(
                flex: isWide ? 1 : 2,
                child: Container(
                  padding: EdgeInsets.all(isWide ? 32 : 16),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return ActionButtons(
                        isRunning: _controller.isRunning,
                        isPaused: _controller.isPaused,
                        onReset: _handleReset,
                        onPauseResume: _handlePauseResume,
                        onStop: _handleStop,
                        showResetButton: _showResetButton,
                        showPauseButton: _showPauseButton,
                      );
                    },
                  ),
                ),
              ),
              
              // Prawa strona - Wyświetlacz czasu (65% szerokości na małych ekranach)
              Expanded(
                flex: isWide ? 3 : 3,
                child: Container(
                  padding: EdgeInsets.all(isWide ? 32 : 24),
                  alignment: Alignment.center,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return TimeDisplay(
                        totalSeconds: _controller.remainingSeconds,
                        isOverdue: _controller.isOverdue,
                        textColor: _tileColor,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

