// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

// Widget do wyświetlania czasu w formacie MM:SS
class TimeDisplay extends StatefulWidget {
  final int totalSeconds;
  final bool isOverdue; // czy czas został przekroczony (negatywny)
  final Color? textColor;

  const TimeDisplay({
    super.key,
    required this.totalSeconds,
    this.isOverdue = false,
    this.textColor,
  });

  @override
  State<TimeDisplay> createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Konfiguracja animacji pulsowania
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animacja fade in/out (od 0.5 do 1.0)
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Uruchom animację w pętli, gdy czas jest przekroczony
    if (widget.isOverdue) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TimeDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Uruchom animację gdy czas stanie się przekroczony
    if (widget.isOverdue && !oldWidget.isOverdue) {
      _animationController.repeat(reverse: true);
    }
    // Zatrzymaj animację gdy czas przestanie być przekroczony
    if (!widget.isOverdue && oldWidget.isOverdue) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Oblicz minuty i sekundy
    final absSeconds = widget.totalSeconds.abs();
    final minutes = absSeconds ~/ 60;
    final seconds = absSeconds % 60;

    // Formatuj jako MM:SS (lub -MM:SS jeśli przekroczony)
    final timeString = widget.isOverdue
        ? '-${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    // Kolor - czerwony jeśli przekroczony, w przeciwnym razie użyj podanego lub domyślnego
    final displayColor = widget.isOverdue
        ? Colors.red
        : (widget.textColor ?? Theme.of(context).colorScheme.onSurface);

    // Jeśli przekroczony, użyj animacji fade
    if (widget.isOverdue) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Text(
              timeString,
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w700,
                color: displayColor,
                letterSpacing: 2,
                fontFeatures: const [FontFeature.tabularFigures()], // Stała szerokość cyfr
                shadows: [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    }

    // Normalny wyświetlacz bez animacji
    return Text(
      timeString,
      style: TextStyle(
        fontSize: 96,
        fontWeight: FontWeight.w700,
        color: displayColor,
        letterSpacing: 2,
        fontFeatures: const [FontFeature.tabularFigures()], // Stała szerokość cyfr
        shadows: [
          Shadow(
            offset: const Offset(0, 2),
            blurRadius: 4,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
