part of 'project_detail_cubit.dart';

class ProjectDetailsState extends Equatable {
  final ProjectModel project;

  const ProjectDetailsState({required this.project});

  ProjectDetailsState copyWith({ProjectModel? project}) {
    return ProjectDetailsState(project: project ?? this.project);
  }

  @override
  List<Object?> get props => [project];
}
