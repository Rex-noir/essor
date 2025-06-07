import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _base = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
    level: Level.debug,
  );

  static TaggedLogger tag(String tag) => TaggedLogger(tag);
}

class TaggedLogger {
  final String tag;

  TaggedLogger(this.tag);

  void info(dynamic message) {
    AppLogger._base.i(_format(message));
  }

  void debug(dynamic message) {
    AppLogger._base.d(_format(message));
  }

  void warning(dynamic message) {
    AppLogger._base.w(_format(message));
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger._base.e(_format(message), error: error, stackTrace: stackTrace);
  }

  void verbose(dynamic message) {
    AppLogger._base.t(_format(message));
  }

  String _format(dynamic message) => "[$tag] $message";
}
