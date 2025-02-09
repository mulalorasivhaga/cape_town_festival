import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  final Logger _logger = Logger();

  factory AppLogger() {
    return _instance;
  }

  AppLogger._internal();

  void logInfo(String message) {
    _logger.i(message);
  }

  void logWarning(String message) {
    _logger.w(message);
  }

  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void logDebug(String message) {
    _logger.d(message);
  }

  void logTrace(String message) {
    _logger.t(message);
  }
}


// logger.t("Trace log");
// logger.d("Debug log");
// logger.i("Info log");
// logger.w("Warning log");
// logger.e("Error log", error: 'Test Error');
// logger.f("What a fatal log", error: error, stackTrace: stackTrace);