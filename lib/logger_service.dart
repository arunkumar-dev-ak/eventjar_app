import 'package:logger/web.dart';

class LoggerService {
  //private constructor
  LoggerService._privateConstructor();

  //Instance for logger class
  static final LoggerService loggerInstance =
      LoggerService._privateConstructor();

  //Logger instance
  final Logger _logger = Logger();

  //public method to log messages
  void d(String message) {
    _logger.d(message);
  }

  //public method to info messages
  void i(String message) {
    _logger.i(message);
  }

  //public method to warning messages
  void w(String message) {
    _logger.w(message);
  }

  //public method to error messages
  void e(dynamic message) {
    _logger.e(message);
  }

  void dynamic_d(dynamic message) {
    _logger.d(message);
  }
}
