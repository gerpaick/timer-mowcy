// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/stopwatch_controller.dart';
import '../services/storage_service.dart';
import '../widgets/time_display.dart';
import '../widgets/action_buttons.dart';

// Ekran stopera z layoutem: przyciski po lewej, czas po prawej
class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late StopwatchController _controller;
  final Color _tileColor = Colors.blue; // Kolor domyślny dla stopera
  bool _showResetButton = true;
  bool _showPauseButton = true;

  @override
  void initState() {
    super.initState();
    // Utwórz kontroler i rozpocznij zliczanie
    _controller = StopwatchController();
    
    // Włącz keep screen on (ekran nie gaśnie)
    WakelockPlus.enable();
    
    // Załaduj ustawienia widoczności przycisków i wystartuj stoper
    _loadSettings();
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

  // Załaduj ustawienia widoczności przycisków
  Future<void> _loadSettings() async {
    final showResetButton = await StorageService.loadShowResetButton();
    final showPauseButton = await StorageService.loadShowPauseButton();
    if (!mounted) return;
    setState(() {
      _showResetButton = showResetButton;
      _showPauseButton = showPauseButton;
    });

    // Automatycznie rozpocznij zliczanie po załadowaniu ustawień
    _controller.start();
  }

  // Obsługa Reset
  void _handleReset() {
    _controller.reset();
    _controller.start();
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
                        totalSeconds: _controller.elapsedSeconds,
                        isOverdue: false, // Stoper nie ma przekroczenia czasu
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
