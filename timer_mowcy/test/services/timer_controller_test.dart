// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

// ignore_for_file: depend_on_referenced_packages
// The vibration platform interface is a transitive dependency of `vibration`.
// We import it directly to swap in a fake platform instance so that
// `Vibration.hasVibrator()` returns true under the macOS test host (where the
// real plugin would return false and never call vibrate).

import 'package:flutter_test/flutter_test.dart';
import 'package:timer_mowcy/services/timer_controller.dart';
import 'package:vibration_platform_interface/vibration_platform_interface.dart';

/// Fake [VibrationPlatform] that records vibrate() invocations and reports a
/// vibrator as present, so the [TimerController] vibration path can be observed
/// in tests regardless of the host platform.
class _FakeVibrationPlatform extends VibrationPlatform {
  int vibrateCount = 0;
  List<int> durations = <int>[];

  @override
  Future<bool> hasVibrator() async => true;

  @override
  Future<void> vibrate({
    int duration = 500,
    List<int> pattern = const [],
    int repeat = -1,
    List<int> intensities = const [],
    int amplitude = -1,
    double sharpness = 0.5,
  }) async {
    vibrateCount++;
    durations.add(duration);
  }
}

void main() {
  late _FakeVibrationPlatform fakeVibration;

  setUp(() {
    fakeVibration = _FakeVibrationPlatform();
    VibrationPlatform.instance = fakeVibration;
  });

  // Helper that drains pending microtasks so fire-and-forget async work inside
  // the controller (the vibration path) completes.
  Future<void> flush(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
  }

  group('TimerController.start', () {
    testWidgets('start(60) sets state to running and remainingSeconds to 60', (
      tester,
    ) async {
      final c = TimerController();
      c.start(60);
      expect(c.state, TimerState.running);
      expect(c.remainingSeconds, 60);
      expect(c.initialSeconds, 60);
      expect(c.isRunning, isTrue);
      expect(c.isIdle, isFalse);
      c.dispose();
    });

    testWidgets(
      'after 2 seconds of running, state is running and remaining is 58',
      (tester) async {
        final c = TimerController();
        c.start(60);
        await tester.pump(const Duration(seconds: 2));
        expect(c.state, TimerState.running);
        expect(c.remainingSeconds, 58);
        c.dispose();
      },
    );
  });

  group('TimerController.pauseResume', () {
    testWidgets('from running sets paused and stops ticking', (tester) async {
      final c = TimerController();
      c.start(60);
      await tester.pump(const Duration(seconds: 1));
      expect(c.remainingSeconds, 59);

      c.pauseResume();
      expect(c.state, TimerState.paused);
      expect(c.isPaused, isTrue);

      // Advance time further; the timer must not tick while paused.
      await tester.pump(const Duration(seconds: 10));
      expect(c.remainingSeconds, 59);
      c.dispose();
    });

    testWidgets('from paused sets running and resumes ticking', (tester) async {
      final c = TimerController();
      c.start(60);
      await tester.pump(const Duration(seconds: 1)); // -> 59
      c.pauseResume(); // paused at 59
      await tester.pump(const Duration(seconds: 10)); // no tick while paused
      expect(c.remainingSeconds, 59);

      c.pauseResume(); // resume
      expect(c.state, TimerState.running);
      expect(c.isRunning, isTrue);

      await tester.pump(const Duration(seconds: 2)); // -> 57
      expect(c.remainingSeconds, 57);
      c.dispose();
    });

    testWidgets('pauseResume from idle does nothing', (tester) async {
      final c = TimerController();
      c.pauseResume();
      expect(c.state, TimerState.idle);
      expect(c.remainingSeconds, 0);
      c.dispose();
    });
  });

  group('TimerController.reset', () {
    testWidgets(
      'sets state to idle and remainingSeconds back to initialSeconds',
      (tester) async {
        final c = TimerController();
        c.start(60);
        await tester.pump(const Duration(seconds: 10)); // -> 50
        expect(c.remainingSeconds, 50);

        c.reset();
        expect(c.state, TimerState.idle);
        expect(c.isIdle, isTrue);
        expect(c.remainingSeconds, 60);
        expect(c.initialSeconds, 60);

        // No further ticks after reset.
        await tester.pump(const Duration(seconds: 5));
        expect(c.remainingSeconds, 60);
        c.dispose();
      },
    );
  });

  group('TimerController.stop', () {
    testWidgets('sets state idle, remaining 0, initial 0', (tester) async {
      final c = TimerController();
      c.start(60);
      await tester.pump(const Duration(seconds: 10));

      c.stop();
      expect(c.state, TimerState.idle);
      expect(c.remainingSeconds, 0);
      expect(c.initialSeconds, 0);

      await tester.pump(const Duration(seconds: 5));
      expect(c.remainingSeconds, 0);
      c.dispose();
    });
  });

  group('TimerController overdue', () {
    testWidgets(
      'start(0) followed by a tick produces isOverdue and negative remaining',
      (tester) async {
        final c = TimerController();
        c.start(0);
        expect(c.remainingSeconds, 0);
        expect(c.isOverdue, isFalse);

        await tester.pump(const Duration(seconds: 1));
        expect(c.remainingSeconds, -1);
        expect(c.isOverdue, isTrue);
        c.dispose();
      },
    );

    testWidgets('keeps counting down past zero', (tester) async {
      final c = TimerController();
      c.start(2);
      await tester.pump(const Duration(seconds: 4));
      expect(c.remainingSeconds, -2);
      expect(c.isOverdue, isTrue);
      c.dispose();
    });
  });

  group('TimerController vibration', () {
    testWidgets('vibration is called EXACTLY ONCE when remaining hits 0', (
      tester,
    ) async {
      final c = TimerController();
      c.start(2, vibrationEnabled: true);

      await tester.pump(const Duration(seconds: 1)); // remaining 1
      expect(c.remainingSeconds, 1);
      expect(fakeVibration.vibrateCount, 0);

      await tester.pump(const Duration(seconds: 1)); // remaining 0 -> vibrate
      expect(c.remainingSeconds, 0);
      await flush(tester);
      expect(fakeVibration.vibrateCount, 1);
      expect(fakeVibration.durations, [200]);

      // Continue ticking into overdue: must NOT vibrate again.
      await tester.pump(const Duration(seconds: 5)); // remaining -5
      await flush(tester);
      expect(c.remainingSeconds, -5);
      expect(fakeVibration.vibrateCount, 1);
      c.dispose();
    });

    testWidgets('does not vibrate when vibrationEnabled is false', (
      tester,
    ) async {
      final c = TimerController();
      c.start(1, vibrationEnabled: false);

      await tester.pump(const Duration(seconds: 1)); // remaining 0
      await flush(tester);
      expect(c.remainingSeconds, 0);
      expect(fakeVibration.vibrateCount, 0);
      c.dispose();
    });
  });

  group('TimerController.dispose', () {
    testWidgets('cancels the Timer so no further ticks occur', (tester) async {
      final c = TimerController();
      c.start(60);
      await tester.pump(const Duration(seconds: 1));
      expect(c.remainingSeconds, 59);

      c.dispose();
      final remainingAfterDispose = c.remainingSeconds;

      // Advancing the fake clock after dispose must not tick the controller.
      await tester.pump(const Duration(seconds: 30));
      expect(c.remainingSeconds, remainingAfterDispose);
    });
  });
}
