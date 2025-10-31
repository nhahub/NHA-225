import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit() : super(CreateTaskInitial());

  Future<void> createTask({
    required ProjectModel project,
    required UserModel user,
    required String title,
    required String description,
    required DateTime deadline,
    required String status,
    String? assignedUserId,
  }) async {
    emit(CreateTaskLoading());
    try {
      final List<String> assignedUsers =
          assignedUserId != null ? <String>[assignedUserId] : <String>[];

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        description: description.trim(),
        assignedTo: assignedUsers,
        status: status,
        deadline: deadline,
        createdAt: DateTime.now(),
        projectId: project.id ?? '',
        isCompleted: status == 'done',
        createdBy: user.id,
      );

      await TaskService.addTaskToProject(newTask, project);

      if (assignedUserId != null) {
        final userRef = FirebaseFirestore.instance
            .collection(UserModel.collectionName)
            .doc(assignedUserId);
        await userRef.update({
          'taskIds': FieldValue.arrayUnion([newTask.id]),
        });
      }

      emit(CreateTaskSuccess(newTask));
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }

  /// 🔹 Fetch user’s tasks (once)
  Future<void> loadUserTasks(UserModel user) async {
    emit(CreateTaskLoading());
    try {
      final tasks = await TaskService.getUserTasks(user.id);
      emit(CreateTaskSuccessList(tasks));
    } catch (e) {
      emit(CreateTaskError(e.toString()));
    }
  }
}
