import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

class Logger {
  static final StreamController<String> _logStreamController =
      StreamController.broadcast();

  static Stream<String> get logStream => _logStreamController.stream;

  static int _infoCount = 0;
  static int _warningCount = 0;
  static int _errorCount = 0;
  static int _logCount = 0;

  // Using LinkedHashMap for optimized performance with predictable iteration order
  static final LinkedHashMap<String, int> _logMessageCount =
      LinkedHashMap<String, int>();

  static void info(String message) {
    _log("INFO", message, _infoCount++);
  }

  static void warning(String message) {
    _log("WARNING", message, _warningCount++);
  }

  static void error(String message) {
    _log("ERROR", message, _errorCount++);
  }

  static void log(String message) {
    _log("LOG", message, _logCount++);
  }

  static void clear() {
    _logStreamController.add('');
  }

  static void close() {
    _logStreamController.close();
  }

  static void _log(String level, String message, int count) {
    final String baseLogMessage = "[$level $count]: $message";

    // Use putIfAbsent to optimize map operation and reduce duplicate lookups
    final int duplicateCount =
        _logMessageCount.putIfAbsent(baseLogMessage, () => 0);

    final String logMessage = duplicateCount > 0
        ? "$baseLogMessage ($duplicateCount)"
        : baseLogMessage;

    // Increment the message count
    _logMessageCount[baseLogMessage] = duplicateCount + 1;

    // Broadcast log message to listeners
    _logStreamController.add(logMessage);

    // Print the log message in debug mode
    assert(() {
      if (kDebugMode) {
        print(logMessage);
      }
      return true;
    }());
  }
}
