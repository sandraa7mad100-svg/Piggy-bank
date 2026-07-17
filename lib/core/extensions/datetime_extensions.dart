import 'package:intl/intl.dart';

/// Human-friendly date formatting for transaction lists, chat timestamps,
/// and history screens.
extension DateTimeX on DateTime {
  String toFriendlyDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(year, month, day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff > 1 && diff < 7) return DateFormat('EEEE').format(this);
    return DateFormat('MMM d, yyyy').format(this);
  }

  String toTime() => DateFormat('h:mm a').format(this);

  bool isSameWeekAs(DateTime other) {
    final startOfWeek = subtract(Duration(days: weekday - 1));
    final otherStart = other.subtract(Duration(days: other.weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day) ==
        DateTime(otherStart.year, otherStart.month, otherStart.day);
  }
}
