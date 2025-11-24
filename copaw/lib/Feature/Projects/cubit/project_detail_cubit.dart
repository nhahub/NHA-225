import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';

part 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  ProjectDetailsCubit(this.project)
    : super(ProjectDetailsState(project: project)) {
    _subscribeToTasks(); // listen to tasks on creation
  }

  final ProjectModel project;
  StreamSubscription<List<Task>>? _taskSubscription;

  /// Edit an existing task
  Future<void> editTask(Task task) async {
    // Use current state's project which has the latest tasks, not the original project
    final currentProject = state.project;
    await TaskService.updateTask(task, currentProject);
    // No need to call retrieveTasks() as the stream will automatically update
  }

  /// Listen to project tasks in real-time
  void _subscribeToTasks() {
    if (project.id == null || project.id!.isEmpty) return;

    _taskSubscription = TaskService.listenToProjectTasks(project.id!).listen(
      (tasks) {
        // Update the project with new tasks while preserving other project data
        final updatedProject = state.project.copyWith(tasks: tasks);
        emit(state.copyWith(project: updatedProject));
      },
      onError: (error) {
        print("Task stream error: $error");
      },
    );
  }

  /// Restart the task stream
  Future<void> retrieveTasks() async {
    _taskSubscription?.cancel();
    _subscribeToTasks();
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
