import 'package:copaw/Models/project_model.dart';

abstract class ProjectStates {}

class ProjectInitialState extends ProjectStates {}

class ProjectLoadingState extends ProjectStates {}

class ProjectSuccessState extends ProjectStates {
  final String message;
  ProjectSuccessState({required this.message});
}

class ProjectErrorState extends ProjectStates {
  final String error;
  ProjectErrorState({required this.error});
}

class ProjectLoadedState extends ProjectStates {
  final List<ProjectModel> projects;
  ProjectLoadedState({required this.projects});
}
