import 'package:equatable/equatable.dart';
import 'package:copaw/Models/task.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}


class CalendarLoadingState extends CalendarState {}


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
