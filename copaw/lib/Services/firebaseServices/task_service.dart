import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/project_model.dart';

class TaskService {
  static final _firestore = FirebaseFirestore.instance;

  /// ✅ Add a new Task inside the Project document
  static Future<void> addTaskToProject(Task task, ProjectModel project) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    final projectRef =
        _firestore.collection(ProjectModel.collectionName).doc(project.id);

    final snapshot = await projectRef.get();
    if (!snapshot.exists) {
      throw Exception("Project not found for ID: ${project.id}");
    }

    // Generate a new task ID if missing
    if (task.id.isEmpty) {
      task.id = _firestore.collection('tasks').doc().id;
    }

    // Append the new task
    final updatedTasks = [...project.tasks, task];

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// 🔹 Update a task inside the Project document
  static Future<void> updateTask(Task task, ProjectModel project) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    final projectRef =
        _firestore.collection(ProjectModel.collectionName).doc(project.id);

    final updatedTasks = project.tasks.map((t) {
      return t.id == task.id ? task : t;
    }).toList();

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// 🔹 Delete a specific task inside the Project document
  static Future<void> deleteTask(Task task, ProjectModel project) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    final projectRef =
        _firestore.collection(ProjectModel.collectionName).doc(project.id);

    final updatedTasks = project.tasks.where((t) => t.id != task.id).toList();

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// ✅ One-time fetch
  static Future<List<Task>> getProjectTasks(String projectId) async {
    if (projectId.isEmpty) return [];

    final projectDoc = await _firestore
        .collection(ProjectModel.collectionName)
        .doc(projectId)
        .get();

    if (!projectDoc.exists || projectDoc.data() == null) {
      return [];
    }

    final project = ProjectModel.fromFirestore(projectDoc.data()!);
    return project.tasks;
  }

  /// ✅ Real-time updates
  static Stream<List<Task>> listenToProjectTasks(String projectId) {
    if (projectId.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    return _firestore
        .collection(ProjectModel.collectionName)
        .doc(projectId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) return [];
          final project = ProjectModel.fromFirestore(snapshot.data()!);
          return project.tasks;
        });
  }

  /// ✅ All tasks created by a specific user
  static Future<List<Task>> getTasksByUserId(String userId) async {
    final projectSnapshot =
        await _firestore.collection(ProjectModel.collectionName).get();

    final userTasks = <Task>[];

    for (var doc in projectSnapshot.docs) {
      final data = doc.data();
      if (data.isEmpty) continue;

      final project = ProjectModel.fromFirestore(data);
      final tasksForUser =
          project.tasks.where((t) => t.createdBy == userId).toList();

      userTasks.addAll(tasksForUser);
    }

    return userTasks;
  }
}
