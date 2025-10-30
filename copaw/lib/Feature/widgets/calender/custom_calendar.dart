import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/calender/bloc/calendar_bloc.dart';
import 'package:copaw/Feature/calender/bloc/calendar_event.dart';
import 'package:copaw/Feature/calender/bloc/calendar_state.dart';

class CustomCalendar extends StatelessWidget {
  final CalendarBloc bloc;
  final CalendarState state;
  final List<Task> Function(DateTime) getTasksForDay;

  const CustomCalendar({
    super.key,
    required this.bloc,
    required this.state,
    required this.getTasksForDay,
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 Stream updates are handled by BlocBuilder -> CalendarLoadedState updates automatically
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is CalendarLoadingState) {
          return _buildSkeleton(context);
        } else if (state is CalendarLoadedState) {
          return _buildCalendar(context, bloc, state);
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
      },
    );
  }

  /// Build the actual calendar
  Widget _buildCalendar(
    BuildContext context,
    CalendarBloc bloc,
    CalendarLoadedState state,
  ) {
    return Column(
      children: [
        TableCalendar<Task>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: state.focusedDay,
          selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
          eventLoader: (day) => getTasksForDay(day),
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            leftChevronIcon:
                Icon(Icons.chevron_left, color: AppColors.mainColor),
            rightChevronIcon:
                Icon(Icons.chevron_right, color: AppColors.mainColor),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.mainColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.mainColor,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: AppColors.warningColor,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 1,
            outsideDaysVisible: false,
          ),
          onDaySelected: (selectedDay, focusedDay) {
            bloc.add(SelectDay(selectedDay));
          },
        ),
        const SizedBox(height: 10),
        Expanded(
          child: state.selectedDay == null
              ? Center(
                  child: Text(
                    'Select a day to see tasks',
                    style: TextStyle(
                      color: AppColors.grayColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : _buildTaskList(getTasksForDay(state.selectedDay!)),
        ),
      ],
    );
  }

  /// Build list of tasks under the calendar
  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks for this day',
          style: TextStyle(color: AppColors.grayColor),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.mainColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                task.isCompleted ? Icons.check_circle : Icons.access_time,
                color: task.isCompleted ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build skeleton loader while tasks are loading
  Widget _buildSkeleton(BuildContext context) {
    return Skeletonizer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(6, (index) {
              return Container(
                width: 40,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          ...List.generate(5, (row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(6, (col) {
                  return Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}
