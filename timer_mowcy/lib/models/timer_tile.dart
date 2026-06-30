// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

// Model danych dla kafelka minutnika
class TimerTile {
  final String id;
  final String name;
  final int durationSeconds; // czas w sekundach
  final int colorValue; // wartość koloru jako int

  TimerTile({
    required this.id,
    required this.name,
    required this.durationSeconds,
    required this.colorValue,
  });

  // Konwersja do Map dla zapisu w SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationSeconds': durationSeconds,
      'colorValue': colorValue,
    };
  }

  // Konwersja z Map dla odczytu z SharedPreferences
  factory TimerTile.fromJson(Map<String, dynamic> json) {
    return TimerTile(
      id: json['id'] as String,
      name: json['name'] as String,
      durationSeconds: json['durationSeconds'] as int,
      colorValue: json['colorValue'] as int,
    );
  }

  // Formatowanie czasu do wyświetlania MM:SS
  String get formattedTime {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Kopia z możliwością modyfikacji
  TimerTile copyWith({
    String? id,
    String? name,
    int? durationSeconds,
    int? colorValue,
  }) {
    return TimerTile(
      id: id ?? this.id,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
