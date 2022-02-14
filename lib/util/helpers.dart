import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

Future<void> showSimpleDialog(String title, {String? message}) => RM.navigate.toDialog(AlertDialog(
      title: Text(title),
      content: message != null ? Text(message) : null,
      actions: [
        TextButton(
          onPressed: () => RM.navigate.back(),
          child: const Text("Okay"),
        ),
      ],
    ));

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
