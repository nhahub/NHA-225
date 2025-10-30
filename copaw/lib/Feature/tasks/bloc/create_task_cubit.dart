import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit() : super(CreateTaskInitial());

  /// 🔹 Create a new task and sync it with the project and users
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

      // Save to Firestore under the project’s tasks subcollection
      await TaskService.addTaskToProject(newTask, project);

      // If assigned to someone, update their record
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

  /// 🔹 Real-time stream for tasks under a project
  Stream<List<Task>> streamTasksForProject(String projectId) {
    return FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .doc(projectId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }
}
