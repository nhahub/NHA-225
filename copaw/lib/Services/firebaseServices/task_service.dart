import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/project_model.dart';

class TaskService {
  /// ✅ Add a new Task inside the Project document
  static Future<void> addTaskToProject(Task task, ProjectModel project) async {
    final projectRef = FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .doc(project.id);

    // Generate task ID if missing
    if (task.id.isEmpty) {
      task.id = projectRef.collection('tasks').doc().id;
    }

    // Append task to list
    final updatedTasks = [...project.tasks, task];

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// 🔹 Update a task inside the Project document
  static Future<void> updateTask(Task task, ProjectModel project) async {
    final projectRef = FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .doc(project.id);

    final updatedTasks = project.tasks.map((t) {
      return t.id == task.id ? task : t;
    }).toList();

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// 🔹 Delete a specific task inside the Project document
  static Future<void> deleteTask(Task task, ProjectModel project) async {
    final projectRef = FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .doc(project.id);

    final updatedTasks = project.tasks.where((t) => t.id != task.id).toList();

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// ✅ Retrieve all tasks (one-time fetch)
  static Future<List<Task>> getProjectTasks(String projectId) async {
    final projectDoc = await FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .doc(projectId)
        .get();

    if (!projectDoc.exists || projectDoc.data() == null) {
      return [];
    }

    final project = ProjectModel.fromFirestore(projectDoc.data()!);
    return project.tasks;
  }

  /// ✅ Real-time listener for project tasks
  ///
  /// Firestore automatically sends updates whenever
  /// the project document changes.
  static Stream<List<Task>> listenToProjectTasks(String projectId) {
    return FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .doc(projectId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) return [];
          final project = ProjectModel.fromFirestore(snapshot.data()!);
          return project.tasks;
        });
  }
  /// ✅ Get all tasks created by a specific user across all projects
static Future<List<Task>> getTasksByUserId(String userId) async {
  final firestore = FirebaseFirestore.instance;

  // Fetch all project documents
  final projectSnapshot = await firestore.collection(ProjectModel.collectionName).get();

  final userTasks = <Task>[];

  // Loop through all projects
  for (var doc in projectSnapshot.docs) {
    final projectData = doc.data();

    if (projectData.isEmpty) continue;

    final project = ProjectModel.fromFirestore(projectData);

    // Filter only tasks created by this user
    final tasksForUser = project.tasks.where((t) => t.createdBy == userId).toList();

    userTasks.addAll(tasksForUser);
  }

  return userTasks;
}

}
