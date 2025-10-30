import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final UserModel user;
  StreamSubscription<List<Task>>? _tasksSubscription;

  CalendarBloc(this.user) : super(CalendarLoadingState()) {
    on<LoadCalendarTasks>(_onLoadTasks);
    on<SelectDay>(_onSelectDay);
    on<TasksUpdated>(_onTasksUpdated);
  }

  /// 🔹 Start Firestore stream listener for user's tasks
  void _onLoadTasks(LoadCalendarTasks event, Emitter<CalendarState> emit) {
    emit(CalendarLoadingState());
    _tasksSubscription?.cancel();

    _tasksSubscription = TaskService.listenToTasksForUser(user).listen(
      (tasks) {
        add(TasksUpdated(tasks));
      },
      onError: (error) {
        emit(CalendarErrorState(error.toString()));
      },
    );
  }

  /// 🔹 When Firestore stream sends new task data
  void _onTasksUpdated(TasksUpdated event, Emitter<CalendarState> emit) {
    final tasksByDate = _groupTasksByDate(event.tasks);
    emit(CalendarLoadedState(
      tasksByDate: tasksByDate,
      focusedDay: DateTime.now(),
    ));
  }

  /// 🔹 When user selects a specific date
  void _onSelectDay(SelectDay event, Emitter<CalendarState> emit) {
    if (state is CalendarLoadedState) {
      final current = state as CalendarLoadedState;
      emit(current.copyWith(
        selectedDay: event.selectedDay,
        focusedDay: event.selectedDay,
      ));
    }
  }

  /// 🔹 Group tasks by deadline day
  Map<DateTime, List<Task>> _groupTasksByDate(List<Task> tasks) {
    final Map<DateTime, List<Task>> grouped = {};

    for (final task in tasks) {
      DateTime? deadline;
      if (task.deadline is DateTime) {
        deadline = task.deadline;
      } else if (task.deadline != null) {
        deadline = (task.deadline as dynamic).toDate();
      }

      if (deadline != null) {
        final key = DateTime(deadline.year, deadline.month, deadline.day);
        grouped.putIfAbsent(key, () => []);
        grouped[key]!.add(task);
      }
    }

    return grouped;
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
