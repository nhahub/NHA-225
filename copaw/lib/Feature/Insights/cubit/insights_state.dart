import 'package:equatable/equatable.dart';
import 'package:copaw/Feature/Projects/Model/project_model.dart';
import 'package:copaw/Feature/tasks/Models/task.dart';

abstract class InsightsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InsightsInitial extends InsightsState {}

class InsightsLoading extends InsightsState {}

class InsightsLoaded extends InsightsState {
  final List<ProjectModel> projects;
  final List<Task> allTasks;

  InsightsLoaded({required this.projects, required this.allTasks});

  @override
  List<Object?> get props => [projects, allTasks];
}

class InsightsError extends InsightsState {
  final String message;
  InsightsError(this.message);

  @override
  List<Object?> get props => [message];
}
