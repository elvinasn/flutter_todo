import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'task_priority.dart';

//Q: ar siuo atveju geriau naudoti private kintamuosius?
class Todo {
  String task;
  String description;
  TaskPriority priority;
  DateTime dueDate;
  bool isDone;

  Todo(
      {required this.task,
      this.description = "",
      required this.priority,
      required this.dueDate,
      this.isDone = false});

  Color getColor() {
    switch (priority) {
      case TaskPriority.Low:
        {
          return Colors.green;
        }
      case TaskPriority.Medium:
        {
          return Colors.yellow;
        }
      case TaskPriority.High:
        {
          return Colors.red;
        }
    }
  }

  String getFormattedDate() => DateFormat("yyyy-MM-dd").format(dueDate);

  bool isPast() =>
      !dueDate.add(const Duration(days: 1)).isAfter(DateTime.now());
}
