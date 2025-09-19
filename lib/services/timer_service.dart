import 'package:flutter/foundation.dart';

class TimerService with ChangeNotifier {
  DateTime? _startTime;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;
  Timer? _timer;

  TimerService();

  bool get isRunning => _isRunning;
  Duration get elapsedTime => _elapsedTime;

  void start() {
    if (_isRunning) return;

    _startTime = DateTime.now();
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _elapsedTime = DateTime.now().difference(_startTime!);
      notifyListeners();
    });
    notifyListeners();
  }

  void stop() {
    if (!_isRunning) return;

    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _startTime = null;
    _elapsedTime = Duration.zero;
    _isRunning = false;
    notifyListeners();
  }

  String get formattedTime {
    final seconds = _elapsedTime.inSeconds;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}