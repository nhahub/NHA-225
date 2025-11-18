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

  /// Add a new task
  Future<void> addTask(Task task) async {
    await TaskService.addTaskToProject(task, project);
  }

  /// Edit an existing task
  Future<void> editTask(Task task) async {
    await TaskService.updateTask(task, project.id.toString()); // replaces old task
    await retrieveTasks(); // refresh stream
  }

  /// Listen to project tasks in real-time
  void _subscribeToTasks() {
    if (project.id == null || project.id!.isEmpty) return;

    _taskSubscription = TaskService.listenToProjectTasks(project.id!).listen(
      (tasks) {
        emit(state.copyWith(project: project.copyWith(tasks: tasks)));
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
