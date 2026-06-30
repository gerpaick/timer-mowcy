// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

// Kontroler do zarządzania stanem minutnika
class TimerController extends ChangeNotifier {
  // Stan minutnika
  TimerState _state = TimerState.idle;
  int _remainingSeconds = 0;
  int _initialSeconds = 0;
  Timer? _timer;
  bool _hasVibrated = false; // czy już wibrowało przy 00:00
  bool _vibrationEnabled = true; // czy wibracje są włączone
  
  // Getters
  TimerState get state => _state;
  int get remainingSeconds => _remainingSeconds;
  int get initialSeconds => _initialSeconds;
  bool get isRunning => _state == TimerState.running;
  bool get isPaused => _state == TimerState.paused;
  bool get isIdle => _state == TimerState.idle;
  bool get isOverdue => _remainingSeconds < 0;

  // Rozpocznij odliczanie z zadanym czasem (w sekundach)
  void start(int durationSeconds, {bool vibrationEnabled = true}) {
    if (_timer != null) {
      _timer!.cancel();
    }
    
    _initialSeconds = durationSeconds;
    _remainingSeconds = durationSeconds;
    _state = TimerState.running;
    _hasVibrated = false; // Reset flagi wibracji
    _vibrationEnabled = vibrationEnabled; // Ustaw ustawienie wibracji
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      
      // Wibracja dokładnie przy 00:00 (gdy remainingSeconds staje się 0)
      if (_remainingSeconds == 0 && !_hasVibrated) {
        _triggerVibration(_vibrationEnabled);
        _hasVibrated = true;
      }
      
      notifyListeners();
      
      // Po osiągnięciu zera, kontynuuj zliczanie w dół (ujemne wartości)
      // Nie zatrzymuj - minutnik będzie odliczał przekroczenie czasu
    });
    
    notifyListeners();
  }
  
  // Funkcja wywołująca wibrację (tylko jeśli wibracje są włączone)
  void _triggerVibration(bool vibrationEnabled) async {
    // Sprawdź czy wibracje są włączone
    if (!vibrationEnabled) {
      return;
    }
    
    // Sprawdź czy urządzenie obsługuje wibracje
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator) {
      // Wibracja przez 200ms (0.2s)
      Vibration.vibrate(duration: 200);
    }
  }

  // Pauza/Wznów
  void pauseResume() {
    if (_state == TimerState.running) {
      // Pauza
      _timer?.cancel();
      _state = TimerState.paused;
      notifyListeners();
    } else if (_state == TimerState.paused) {
      // Wznów
      _state = TimerState.running;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _remainingSeconds--;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  // Reset - przywróć początkowy czas i zatrzymaj
  void reset({bool vibrationEnabled = true}) {
    _timer?.cancel();
    _remainingSeconds = _initialSeconds;
    _state = TimerState.idle;
    _vibrationEnabled = vibrationEnabled; // Aktualizuj ustawienie wibracji
    notifyListeners();
  }

  // Stop - zatrzymaj i wyczyść
  void stop() {
    _timer?.cancel();
    _timer = null;
    _remainingSeconds = 0;
    _initialSeconds = 0;
    _state = TimerState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Stany minutnika
enum TimerState {
  idle,    // Początkowy stan, nie działa
  running, // Odliczanie w toku
  paused,  // Zatrzymany
}

