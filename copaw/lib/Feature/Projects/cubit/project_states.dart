import 'package:copaw/Feature/Projects/Model/project_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectStates extends Equatable {
  @override
  List<Object?> get props => [];
}

/// --- INITIAL ---
class ProjectInitialState extends ProjectStates {}

/// --- CREATE PROJECT STATES ---
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

/// --- REAL-TIME PROJECTS STREAM STATES ---
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

/// --- ADD MEMBER STATES ---
class AddMemberLoadingState extends ProjectStates {}

class AddMemberSuccessState extends ProjectStates {
  final String message;
  AddMemberSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class AddMemberErrorState extends ProjectStates {
  final String error;
  AddMemberErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

/// --- DATE PICKER STATE ---
class ProjectDateUpdatedState extends ProjectStates {
  final DateTime date;
  ProjectDateUpdatedState(this.date);

  @override
  List<Object?> get props => [date];
}
