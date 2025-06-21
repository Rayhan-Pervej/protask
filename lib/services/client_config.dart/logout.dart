import 'dart:async';

class LogoutEvent {
  static final LogoutEvent _instance = LogoutEvent._internal();
  final StreamController<void> _controller = StreamController<void>.broadcast();

  factory LogoutEvent() {
    return _instance;
  }

  LogoutEvent._internal();

  Stream<void> get onLogout => _controller.stream;

  void triggerLogout() {
    _controller.add(null);
  }
}
