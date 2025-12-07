import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/Feature/calender/bloc/calendar_bloc.dart';
import 'package:copaw/Feature/calender/bloc/calendar_event.dart';
import 'package:copaw/Feature/calender/bloc/calendar_state.dart';
import 'package:copaw/Feature/tasks/Models/task.dart';
import 'package:copaw/Feature/widgets/calender/custom_calendar.dart';
import 'package:copaw/Feature/Auth/Models/user.dart';

class CalendarScreen extends StatelessWidget {
  final UserModel user;

  const CalendarScreen({super.key, required this.user});

  /// Helper function to safely fetch tasks for a given day
  List<Task> _getTasksForDay(DateTime day, Map<DateTime, List<Task>> map) {
    final localDay = DateTime(day.year, day.month, day.day);
    return map[localDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc(user)..add(LoadCalendarTasks(user)),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          final bloc = context.read<CalendarBloc>();

          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: MyCustomAppBar(head: 'Calendar', img: user.avatarUrl),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Customcontainer(
                Width: double.infinity,
                Height: MediaQuery.of(context).size.height * 0.7,
                child: _buildBody(state, bloc),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(CalendarState state, CalendarBloc bloc) {
    if (state is CalendarLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CalendarLoadedState) {
      return CustomCalendar(
        bloc: bloc,
        state: state,
        getTasksForDay: (day) => _getTasksForDay(day, state.tasksByDate),
      );
    } else if (state is CalendarErrorState) {
      return Center(
        child: Text(
          "Error: ${state.message}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return const Center(child: Text("No tasks available"));
    }
  }
}
