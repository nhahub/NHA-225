import 'package:copaw/Models/project_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectInitialState extends ProjectStates {}

/// --- Create Project States ---
class ProjectLoadingState extends ProjectStates {}

class ProjectSuccessState extends ProjectStates {
  final String message;
  ProjectSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectErrorState extends ProjectStates {
  final String error;
  ProjectErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

/// --- Real-Time Projects Stream States ---
class ProjectsLoadingState extends ProjectStates {}

class ProjectsLoadedState extends ProjectStates {
  final List<ProjectModel> projects;
  ProjectsLoadedState(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectsErrorState extends ProjectStates {
  final String message;
  ProjectsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// --- Date Picker State ---
class ProjectDateUpdatedState extends ProjectStates {
  final DateTime date;
  ProjectDateUpdatedState(this.date);

  @override
  List<Object?> get props => [date];
}
