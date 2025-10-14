import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class LoadCalendarTasks extends CalendarEvent {}

class SelectDay extends CalendarEvent {
  final DateTime selectedDay;
  const SelectDay(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}
