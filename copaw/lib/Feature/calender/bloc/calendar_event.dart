import 'package:equatable/equatable.dart';
import 'package:copaw/Feature/Auth/Models/user.dart';
import 'package:copaw/Feature/tasks/Models/task.dart';

/// Base class for all calendar events
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

/// 🔹 Load tasks for a specific user (start Firestore stream)
class LoadCalendarTasks extends CalendarEvent {
  final UserModel user;
  const LoadCalendarTasks(this.user);

  @override
  List<Object?> get props => [user];
}

/// 🔹 Triggered when a user selects a specific day on the calendar
class SelectDay extends CalendarEvent {
  final DateTime selectedDay;
  const SelectDay(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}

/// 🔹 Internal event triggered when Firestore sends new data
class TasksUpdated extends CalendarEvent {
  final List<Task> tasks; // ✅ Corrected type
  const TasksUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
