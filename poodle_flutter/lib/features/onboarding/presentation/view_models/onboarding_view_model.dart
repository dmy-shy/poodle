import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../onboarding_story.dart';

enum PauseReason {
  manual,
  hold,
  lifecycle,
  route,
  scroll,
  focus,
  accessibility,
  finished,
}

@immutable
class OnboardingState {
  const OnboardingState({
    required this.index,
    required this.paused,
    required this.accessible,
  });
  final int index;
  final bool paused;
  final bool accessible;
}

/// Boundary timer only. Views animate progress without rebuilding the router.
class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel({Duration Function()? now}) {
    final clock = Stopwatch()..start();
    _now = now ?? () => clock.elapsed;
    _startedAt = _now();
    _schedule();
  }
  static const storyDuration = Duration(seconds: 8);
  late final Duration Function() _now;
  late Duration _startedAt;
  Duration _elapsed = Duration.zero;
  Duration? _lastAutoAdvance;
  final Set<PauseReason> _pauses = {};
  Timer? _timer;
  int _index = 0;
  bool _accessible = false;
  bool _disposed = false;

  OnboardingState get state => OnboardingState(
    index: _index,
    paused: _pauses.isNotEmpty,
    accessible: _accessible,
  );
  Duration get elapsed =>
      (_elapsed + (_pauses.isEmpty ? _now() - _startedAt : Duration.zero))
          .clampDuration(storyDuration);
  double get progress => elapsed.inMicroseconds / storyDuration.inMicroseconds;
  OnboardingStory get story => OnboardingStory.values[_index];
  bool get isLast => _index == OnboardingStory.values.length - 1;

  void _schedule() {
    _timer?.cancel();
    if (_disposed || _pauses.isNotEmpty) return;
    _timer = Timer(storyDuration - elapsed, () {
      if (isLast) {
        _elapsed = storyDuration;
        _pauses.add(PauseReason.finished);
        notifyListeners();
      } else {
        _lastAutoAdvance = _now();
        _change(_index + 1);
      }
    });
  }

  void _change(int index) {
    if (_disposed || index == _index) return;
    _index = index;
    _elapsed = Duration.zero;
    _startedAt = _now();
    _pauses.remove(PauseReason.finished);
    _pauses.remove(PauseReason.scroll);
    _schedule();
    notifyListeners();
  }

  bool get _atAutoBoundary =>
      _lastAutoAdvance != null &&
      _now() - _lastAutoAdvance! < const Duration(milliseconds: 150);

  void next() {
    // Input arriving with a handled automatic boundary belongs to that story.
    if (!_atAutoBoundary && !isLast) _change(_index + 1);
  }

  void previous() {
    if (!_atAutoBoundary && _index > 0) _change(_index - 1);
  }

  void setPaused(PauseReason reason, bool paused) {
    if (_disposed || _pauses.contains(reason) == paused) return;
    final saved = elapsed;
    if (paused) {
      _pauses.add(reason);
    } else {
      _pauses.remove(reason);
    }
    _elapsed = saved;
    _startedAt = _now();
    _schedule();
    notifyListeners();
  }

  void setAccessible(bool accessible) {
    if (_accessible == accessible) return;
    _accessible = accessible;
    if (!accessible) _pauses.add(PauseReason.manual);
    setPaused(PauseReason.accessibility, accessible);
  }

  void togglePlayback() {
    if (_accessible || _pauses.contains(PauseReason.finished)) return;
    setPaused(PauseReason.manual, !_pauses.contains(PauseReason.manual));
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}

extension on Duration {
  Duration clampDuration(Duration maximum) =>
      this < Duration.zero ? Duration.zero : (this > maximum ? maximum : this);
}
