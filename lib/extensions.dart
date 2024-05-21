import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  String toShortString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}

extension TimeOfDayExtension on TimeOfDay {
  bool isAfter(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute > other.minute);
  }

  bool isBefore(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }
}

extension DateTimeComparison on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
