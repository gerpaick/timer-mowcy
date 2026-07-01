// Copyright 2025 Gerard Rakoczy
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_test/flutter_test.dart';
import 'package:timer_mowcy/services/stopwatch_controller.dart';

void main() {
  group('StopwatchController.start', () {
    testWidgets('begins counting up from 0', (tester) async {
      final c = StopwatchController();
      c.start();
      expect(c.state, StopwatchState.running);
      expect(c.elapsedSeconds, 0);
      expect(c.isRunning, isTrue);

      await tester.pump(const Duration(seconds: 3));
      expect(c.elapsedSeconds, 3);
      c.dispose();
    });

    testWidgets('does not start when already maxed', (tester) async {
      final c = StopwatchController();
      // Run up to the cap in a single elapse; the controller auto-pauses.
      c.start();
      await tester.pump(
        const Duration(seconds: StopwatchController.maxSeconds),
      );
      expect(c.isMaxed, isTrue);
      expect(c.state, StopwatchState.paused);

      // Calling start() again at the cap is a no-op.
      c.start();
      expect(c.state, StopwatchState.paused);
      expect(c.elapsedSeconds, StopwatchController.maxSeconds);
      c.dispose();
    });
  });

  group('StopwatchController auto-stop', () {
    testWidgets('auto-stops at 60:00 (3600s) and pauses further ticks', (
      tester,
    ) async {
      final c = StopwatchController();
      c.start();

      // Elapsing the full 60 minutes fires 3600 periodic ticks; on the 3600th
      // tick the controller sets elapsed to maxSeconds, switches to paused and
      // cancels its own timer.
      await tester.pump(
        const Duration(seconds: StopwatchController.maxSeconds),
      );

      expect(c.elapsedSeconds, StopwatchController.maxSeconds);
      expect(c.state, StopwatchState.paused);
      expect(c.isPaused, isTrue);
      expect(c.isMaxed, isTrue);

      // No further ticks after auto-stop.
      await tester.pump(const Duration(seconds: 120));
      expect(c.elapsedSeconds, StopwatchController.maxSeconds);
      c.dispose();
    });
  });

  group('StopwatchController.pauseResume', () {
    testWidgets('from running sets paused and stops counting', (tester) async {
      final c = StopwatchController();
      c.start();
      await tester.pump(const Duration(seconds: 5));
      expect(c.elapsedSeconds, 5);

      c.pauseResume();
      expect(c.state, StopwatchState.paused);
      await tester.pump(const Duration(seconds: 10));
      expect(c.elapsedSeconds, 5);
      c.dispose();
    });

    testWidgets('from paused sets running and resumes counting', (
      tester,
    ) async {
      final c = StopwatchController();
      c.start();
      await tester.pump(const Duration(seconds: 5)); // 5
      c.pauseResume(); // paused
      await tester.pump(const Duration(seconds: 10)); // no tick
      expect(c.elapsedSeconds, 5);

      c.pauseResume(); // resume
      expect(c.state, StopwatchState.running);
      await tester.pump(const Duration(seconds: 2)); // -> 7
      expect(c.elapsedSeconds, 7);
      c.dispose();
    });

    testWidgets('resume from idle does nothing', (tester) async {
      final c = StopwatchController();
      c.pauseResume();
      expect(c.state, StopwatchState.idle);
      expect(c.elapsedSeconds, 0);
      c.dispose();
    });
  });

  group('StopwatchController.reset', () {
    testWidgets('restores elapsed to 0 and state to idle', (tester) async {
      final c = StopwatchController();
      c.start();
      await tester.pump(const Duration(seconds: 10));
      expect(c.elapsedSeconds, 10);

      c.reset();
      expect(c.state, StopwatchState.idle);
      expect(c.isIdle, isTrue);
      expect(c.elapsedSeconds, 0);

      await tester.pump(const Duration(seconds: 5));
      expect(c.elapsedSeconds, 0);
      c.dispose();
    });
  });

  group('StopwatchController.stop', () {
    testWidgets('sets state idle and elapsed 0', (tester) async {
      final c = StopwatchController();
      c.start();
      await tester.pump(const Duration(seconds: 8));

      c.stop();
      expect(c.state, StopwatchState.idle);
      expect(c.elapsedSeconds, 0);

      await tester.pump(const Duration(seconds: 5));
      expect(c.elapsedSeconds, 0);
      c.dispose();
    });
  });

  group('StopwatchController.dispose', () {
    testWidgets('cancels the Timer so no further ticks occur', (tester) async {
      final c = StopwatchController();
      c.start();
      await tester.pump(const Duration(seconds: 2));
      expect(c.elapsedSeconds, 2);

      c.dispose();
      await tester.pump(const Duration(seconds: 30));
      expect(c.elapsedSeconds, 2);
    });
  });
}
