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
    _subscribeToTasks(); // 👈 Automatically start listening on creation
  }

  final ProjectModel project;
  StreamSubscription<List<Task>>? _taskSubscription;

  /// ✅ Add a new task to Firestore
  Future<void> addTask(Task task) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Cannot add task — project ID is missing.");
    }
    await TaskService.addTaskToProject(task, project);
  }

  /// ✅ Real-time listener for project tasks
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

  /// ✅ Optionally allow manual restart of stream
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
