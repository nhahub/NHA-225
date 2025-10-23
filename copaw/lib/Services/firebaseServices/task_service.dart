import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/project_model.dart';

class TaskService {

  /// ✅ Add Task inside project document
  static Future<void> addTaskToProject(Task task, ProjectModel project) async {
    final projectRef = FirebaseFirestore.instance.collection(ProjectModel.collectionName).doc(project.id);

    // Generate ID for task if not already
    task.id ??= projectRef.collection('tasks').doc().id; 

    // Add the task to the project's tasks list
    final updatedTasks = [...project.tasks, task];

    await projectRef.update({'tasks': updatedTasks.map((t) => t.toJson()).toList()});
  }

  /// 🔹 Update task inside project
  static Future<void> updateTask(Task task, ProjectModel project) async {
    final projectRef = FirebaseFirestore.instance.collection(ProjectModel.collectionName).doc(project.id);

    final updatedTasks = project.tasks.map((t) => t.id == task.id ? task : t).toList();

    await projectRef.update({'tasks': updatedTasks.map((t) => t.toJson()).toList()});
  }

  /// 🔹 Delete task inside project
  static Future<void> deleteTask(Task task, ProjectModel project) async {
    final projectRef = FirebaseFirestore.instance.collection(ProjectModel.collectionName).doc(project.id);

    final updatedTasks = project.tasks.where((t) => t.id != task.id).toList();

    await projectRef.update({'tasks': updatedTasks.map((t) => t.toJson()).toList()});
  }

  /// 🔹 Listen to tasks inside project
  static Stream<List<Task>> listenToProjectTasks(String projectId) {
    return FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .doc(projectId)
        .snapshots()
        .map((snap) {
          final project = ProjectModel.fromFirestore(snap.data()!);
          return project.tasks;
        });
  }
}
