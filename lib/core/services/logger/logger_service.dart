import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerService {
  static Logger? _logger;

  static Logger get _instance => _logger ??= Logger(
        filter: kDebugMode ? null : ProductionFilter(),
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
        ),
      );

  static void t(String message, {String? tag}) {
    _instance.t(_tagged(message, tag));
  }

  static void d(String message, {String? tag}) {
    _instance.d(_tagged(message, tag));
  }

  static void i(String message, {String? tag}) {
    _instance.i(_tagged(message, tag));
  }

  static void w(String message, {String? tag}) {
    _instance.w(_tagged(message, tag));
  }

  static void e(String message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    _instance.e(
      _tagged(message, tag),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void f(String message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    _instance.f(
      _tagged(message, tag),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void json(Map<String, dynamic> data, {String? tag}) {
    const encoder = JsonEncoder.withIndent('  ');
    _instance.d(_tagged(encoder.convert(data), tag));
  }

  static String _tagged(String message, String? tag) {
    if (tag == null) return message;
    return '[$tag] $message';
  }
}
