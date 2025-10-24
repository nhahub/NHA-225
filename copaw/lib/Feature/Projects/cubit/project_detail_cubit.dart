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

  /// ✅ Add a new task to Firestore and update local state
  Future<void> addTask(Task task) async {
    await TaskService.addTaskToProject(task, project);
    final updatedTasks = List<Task>.from(state.project.tasks)..add(task);
    emit(state.copyWith(project: project.copyWith(tasks: updatedTasks)));
  }

  /// ✅ Listen in real-time to project tasks
  void _subscribeToTasks() {
    _taskSubscription = TaskService.listenToProjectTasks(project.id!).listen(
      (tasks) {
        // Firestore sends updated tasks automatically
        emit(state.copyWith(project: project.copyWith(tasks: tasks)));
      },
    );
  }

  /// ✅ Optionally allow manual start (if not done in constructor)
  Future<void> retrieveTask() async {
    _taskSubscription?.cancel();
    _subscribeToTasks();
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
