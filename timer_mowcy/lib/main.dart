// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

// TimerMówcy - Aplikacja minutników i stopera
// Faza 6: Funkcje systemu - Full screen, keep screen on, wibracje

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ustaw orientację poziomą dla całej aplikacji
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Ukryj pasek systemowy i ustaw prawdziwy pełny ekran
  // immersive zamiast immersiveSticky - belki nie wracają po geście
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersive,
    overlays: [], // Całkowicie ukryte - brak overlay
  );

  runApp(const TimerMowcyApp());
}

class TimerMowcyApp extends StatefulWidget {
  const TimerMowcyApp({super.key});

  @override
  State<TimerMowcyApp> createState() => _TimerMowcyAppState();
}

class _TimerMowcyAppState extends State<TimerMowcyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    // Załaduj motyw po pierwszym renderze, aby nie blokować UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadThemeMode();
    });
  }

  // Załaduj zapisany motyw
  Future<void> _loadThemeMode() async {
    try {
      final themeMode = await StorageService.loadThemeMode();
      if (mounted) {
        setState(() {
          _themeMode = _stringToThemeMode(themeMode);
        });
      }
    } catch (e) {
      // W razie błędu, zostaw domyślny motyw (system)
    }
  }

  // Konwertuj String na ThemeMode
  ThemeMode _stringToThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  // Callback do odświeżania motywu
  void _onThemeChanged() {
    _loadThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(onThemeChanged: _onThemeChanged),
    );
  }
}
