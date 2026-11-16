import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../quotes.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel(
    this._repository, {
    Future<void> Function(Duration)? wait,
    SplashQuoteId Function()? selectQuote,
    this.minimumDuration = const Duration(seconds: 2),
  }) : _wait = wait ?? Future<void>.delayed,
       quote =
           (selectQuote ??
           () =>
               SplashQuoteId.values[Random().nextInt(
                 SplashQuoteId.values.length,
               )])();

  final AuthRepository _repository;
  final Future<void> Function(Duration) _wait;
  final Duration minimumDuration;
  final SplashQuoteId quote;
  bool _started = false;
  bool _disposed = false;
  bool _ready = false;
  bool get ready => _ready;
  AuthFailure? failure;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    try {
      await Future.wait<void>([
        _wait(minimumDuration),
        _repository.restoreSession().then((_) {}),
      ]);
    } catch (_) {
      failure = AuthFailure.unavailable;
    }
    if (_disposed) return;
    _ready = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
