import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:copaw/Feature/calender/bloc/calendar_bloc.dart';
import 'package:copaw/Feature/calender/bloc/calendar_event.dart';
import 'package:copaw/Feature/calender/bloc/calendar_state.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Feature/widgets/calender/custom_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  List<Task> _getTasksForDay(DateTime day, Map<DateTime, List<Task>> map) {
    return map[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc()..add(LoadCalendarTasks()),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          final bloc = context.read<CalendarBloc>();

          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: MyCustomAppBar(head: 'Calendar', img: null),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Customcontainer(
                Width: double.infinity,
                Height: MediaQuery.of(context).size.height * 0.7,
                child: CustomCalendar(
                  bloc: bloc,
                  state: state,
                  getTasksForDay: _getTasksForDay,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
