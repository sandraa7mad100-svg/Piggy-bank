import 'package:logger/logger.dart';

/// App-wide [Logger] instance. Kept as a single configured instance so log
/// formatting/filtering behavior is consistent everywhere, and so it can be
/// swapped to a no-op/remote sink in release builds from one place.
final Logger appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 100,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
