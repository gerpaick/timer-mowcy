// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';
import 'package:flutter/foundation.dart';

// Kontroler do zarządzania stanem stopera
class StopwatchController extends ChangeNotifier {
  // Stan stopera
  StopwatchState _state = StopwatchState.idle;
  int _elapsedSeconds = 0;
  Timer? _timer;
  
  // Maksymalny czas stopera: 60 minut = 3600 sekund
  static const int maxSeconds = 3600; // 60:00
  
  // Getters
  StopwatchState get state => _state;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _state == StopwatchState.running;
  bool get isPaused => _state == StopwatchState.paused;
  bool get isIdle => _state == StopwatchState.idle;
  bool get isMaxed => _elapsedSeconds >= maxSeconds; // czy osiągnął maksymalny czas

  // Rozpocznij zliczanie od zera
  void start() {
    if (_timer != null) {
      _timer!.cancel();
    }
    
    // Jeśli osiągnął maksimum, nie pozwól ponownie startować bez resetu
    if (_elapsedSeconds >= maxSeconds) {
      return;
    }
    
    _state = StopwatchState.running;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      
      // Zatrzymaj automatycznie przy osiągnięciu 60:00
      if (_elapsedSeconds >= maxSeconds) {
        _elapsedSeconds = maxSeconds; // Upewnij się że nie przekroczy
        _state = StopwatchState.paused; // Zatrzymaj
        timer.cancel();
        notifyListeners();
      } else {
        notifyListeners();
      }
    });
    
    notifyListeners();
  }

  // Pauza/Wznów
  void pauseResume() {
    if (_state == StopwatchState.running) {
      // Pauza
      _timer?.cancel();
      _state = StopwatchState.paused;
      notifyListeners();
    } else if (_state == StopwatchState.paused) {
      // Wznów - tylko jeśli nie osiągnął maksimum
      if (_elapsedSeconds >= maxSeconds) {
        return; // Nie pozwól wznawiać gdy osiągnął maksimum
      }
      _state = StopwatchState.running;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedSeconds++;
        
        // Zatrzymaj automatycznie przy osiągnięciu 60:00
        if (_elapsedSeconds >= maxSeconds) {
          _elapsedSeconds = maxSeconds;
          _state = StopwatchState.paused;
          timer.cancel();
          notifyListeners();
        } else {
          notifyListeners();
        }
      });
      notifyListeners();
    }
  }

  // Reset - przywróć do zera i zatrzymaj
  void reset() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _state = StopwatchState.idle;
    notifyListeners();
  }

  // Stop - zatrzymaj i wyczyść
  void stop() {
    _timer?.cancel();
    _timer = null;
    _elapsedSeconds = 0;
    _state = StopwatchState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Stany stopera
enum StopwatchState {
  idle,    // Początkowy stan, nie działa
  running, // Zliczanie w toku
  paused,  // Zatrzymany
}
