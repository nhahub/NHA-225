import 'package:equatable/equatable.dart';
import 'package:copaw/Feature/tasks/Models/task.dart';

/// Base class for all calendar states
abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

/// 🔹 State while loading or waiting for stream
class CalendarLoadingState extends CalendarState {}

/// 🔹 State when tasks are successfully loaded
class CalendarLoadedState extends CalendarState {
  final Map<DateTime, List<Task>> tasksByDate;
  final DateTime focusedDay;
  final DateTime? selectedDay;

  const CalendarLoadedState({
    required this.tasksByDate,
    required this.focusedDay,
    this.selectedDay,
  });

  CalendarLoadedState copyWith({
    Map<DateTime, List<Task>>? tasksByDate,
    DateTime? focusedDay,
    DateTime? selectedDay,
  }) {
    return CalendarLoadedState(
      tasksByDate: tasksByDate ?? this.tasksByDate,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }

  @override
  List<Object?> get props => [tasksByDate, focusedDay, selectedDay];
}

/// 🔹 State when an error occurs (stream or Firestore)
class CalendarErrorState extends CalendarState {
  final String message;
  const CalendarErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
