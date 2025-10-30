import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';
import 'package:copaw/Models/task.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarLoadingState()) {
    on<LoadCalendarTasks>(_onLoadTasks);
    on<SelectDay>(_onSelectDay);
  }

  static final Map<DateTime, List<Task>> _mockTasks = {
    DateTime.utc(2025, 10, 11): [
      Task(
        id: "123",
        title: 'Fix login bug',
        description: 'Resolve the issue preventing user login.',
        deadline: DateTime.utc(2025, 10, 11),
        projectId: 'proj_001',
        createdBy: 'user_001',
        assignedTo: ['user_002'],
        isCompleted: true, status: '', createdAt: DateTime.now(),
      ),
      Task(
        id: '1233',
        title: 'Update dashboard UI',
        description: 'Redesign the dashboard widgets and color scheme.',
        deadline: DateTime.utc(2025, 10, 11),
        projectId: 'proj_002',
        createdBy: 'user_001',
        assignedTo: ['user_003'],
        isCompleted: false, status: '', createdAt: DateTime.now(),
      ),
    ],
    DateTime.utc(2025, 10, 14): [
      Task(
        id: '555',
        title: 'Project A review',
        description: 'Final review meeting for Project A.',
        deadline: DateTime.utc(2025, 10, 14),
        projectId: 'proj_001',
        createdBy: 'user_001',
        assignedTo: ['user_004'],
        isCompleted: false, status: '', createdAt: DateTime.now(),
      ),
    ],
  };

  void _onLoadTasks(LoadCalendarTasks event, Emitter<CalendarState> emit) async {
    emit(CalendarLoadingState());
    await Future.delayed(const Duration(seconds: 2)); 
    emit(CalendarLoadedState(
      tasksByDate: _mockTasks,
      focusedDay: DateTime.now(),
    ));
  }

  void _onSelectDay(SelectDay event, Emitter<CalendarState> emit) {
    if (state is CalendarLoadedState) {
      final current = state as CalendarLoadedState;
      emit(current.copyWith(
        selectedDay: event.selectedDay,
        focusedDay: event.selectedDay,
      ));
    }
  }
}
