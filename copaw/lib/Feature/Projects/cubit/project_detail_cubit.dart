import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';

part 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  ProjectDetailsCubit(this.project)
    : super(ProjectDetailsState(project: project));

  final ProjectModel project;

  Future<void> addTask(Task task) async {
    await TaskService.addTaskToProject(task, project);
    final updatedTasks = List<Task>.from(state.project.tasks)..add(task);
    emit(state.copyWith(project: project.copyWith(tasks: updatedTasks)));
  }
}
