import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerState {
  final int seconds;
  final bool isRunning;
  final DateTime? startTime;

  TimerState({
    required this.seconds,
    required this.isRunning,
    this.startTime,
  });

  TimerState copyWith({
    int? seconds,
    bool? isRunning,
    DateTime? startTime,
  }) {
    return TimerState(
      seconds: seconds ?? this.seconds,
      isRunning: isRunning ?? this.isRunning,
      startTime: startTime ?? this.startTime,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(TimerState(seconds: 0, isRunning: false)) {
    _loadState();
  }

  Timer? _timer;
  int _lastStartTime = 0;

  final String _prefKey = 'timer_start_time';
  final String _prefStartTimeKey = 'start_timestamp';

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeString = prefs.getString(_prefKey);
    final startTimestampString = prefs.getString(_prefStartTimeKey);

    DateTime? startTime;
    if (startTimestampString != null) {
      startTime = DateTime.parse(startTimestampString);
    }

    if (startTimeString != null) {
      final startTimeSaved = DateTime.parse(startTimeString);
      final elapsed = DateTime.now().difference(startTimeSaved).inSeconds;
      _lastStartTime = startTimeSaved.millisecondsSinceEpoch;
      state = TimerState(seconds: elapsed, isRunning: true, startTime: startTime ?? startTimeSaved);
      _startTimer();
    } else {
      state = TimerState(seconds: 0, isRunning: false, startTime: startTime);
    }
  }

  void toggleTimer() async {
    if (state.isRunning) {
      _stopTimer();
    } else {
      await _startTimer();
    }
  }

  Future<void> _startTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    final startTime = state.startTime ?? now;
    if (state.startTime == null) {
      prefs.setString(_prefStartTimeKey, startTime.toIso8601String());
    }

    _lastStartTime = now.millisecondsSinceEpoch - state.seconds * 1000;
    prefs.setString(_prefKey, DateTime.fromMillisecondsSinceEpoch(_lastStartTime).toIso8601String());

    state = state.copyWith(isRunning: true, startTime: startTime);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(_lastStartTime)).inSeconds;
      state = state.copyWith(seconds: elapsed);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() async {
    _stopTimer();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_prefKey);
    prefs.remove(_prefStartTimeKey);
    state = TimerState(seconds: 0, isRunning: false, startTime: null);
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>(
  (ref) => TimerNotifier(),
);
