import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/user.dart';

class TaskService {
  static final _firestore = FirebaseFirestore.instance;

  /// 🔹 Update a specific task inside a project
  static Future<void> updateTask(Task task, ProjectModel project) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    final projectRef = _firestore
        .collection(ProjectModel.collectionName)
        .doc(project.id);

    final updatedTasks = project.tasks.map((t) {
      return t.id == task.id ? task : t;
    }).toList();

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// 🔹 Delete a specific task inside a project
  static Future<void> deleteTask(Task task, ProjectModel project) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    final projectRef = _firestore
        .collection(ProjectModel.collectionName)
        .doc(project.id);

    final updatedTasks = project.tasks.where((t) => t.id != task.id).toList();

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// ✅ Get all tasks for a given project (one-time fetch)
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

  /// ✅ Listen to real-time updates of tasks in a project
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

  /// ✅ Get all tasks created by a specific user (used in ProfileScreen)
  static Future<List<Task>> getUserTasks(String userId) async {
    final projectSnapshot = await _firestore
        .collection(ProjectModel.collectionName)
        .get();

    final userTasks = <Task>[];

    for (var doc in projectSnapshot.docs) {
      final data = doc.data();
      if (data.isEmpty) continue;

      final project = ProjectModel.fromFirestore(data);
      final tasksForUser = project.tasks
          .where((t) => t.createdBy == userId)
          .toList();

      userTasks.addAll(tasksForUser);
    }

    return userTasks;
  }

  /// ✅ Get all tasks assigned to a specific user (not all created by them)
  static Future<List<Task>> getTasksAssignedToUser(String userId) async {
    final projectSnapshot = await _firestore
        .collection(ProjectModel.collectionName)
        .get();

    final userTasks = <Task>[];

    for (var doc in projectSnapshot.docs) {
      final data = doc.data();
      if (data.isEmpty) continue;

      final project = ProjectModel.fromFirestore(data);
      final tasksForUser = project.tasks
          .where((t) => t.assignedTo == userId)
          .toList();

      userTasks.addAll(tasksForUser);
    }

    return userTasks;
  }

  static Future<void> addTaskToProject(Task task, ProjectModel project) async {
    final firestore = FirebaseFirestore.instance;

    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    final projectRef = firestore
        .collection(ProjectModel.collectionName)
        .doc(project.id);

    // 1️⃣ check if project exists
    final snapshot = await projectRef.get();
    if (!snapshot.exists) {
      throw Exception("Project not found for ID: ${project.id}");
    }

    // 2️⃣ check if task ID is set, if not generate one
    if (task.id.isEmpty) {
      task.id = firestore.collection('tasks').doc().id;
    }

    // 3️⃣ add task to project's task list
    final updatedTasks = [...project.tasks, task];
    project.tasks = updatedTasks;

    // 4️⃣ update the project document with new task list
    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });

    // 5️⃣ update each user's subcollection with the new task list
    for (final user in project.users) {
      final userProjectRef = firestore
          .collection('users')
          .doc(user.id)
          .collection(ProjectModel.collectionName)
          .doc(project.id);

      await userProjectRef.update({
        'tasks': updatedTasks.map((t) => t.toJson()).toList(),
      });
    }
  }


  /// 🔹 Listen to tasks assigned to a specific user (real-time)
  static Future<List<Task>> getTasksForUserByIds(UserModel user) async {
  if (user.taskIds.isEmpty) return [];

  final allProjectsSnapshot = await _firestore.collection(ProjectModel.collectionName).get();

  final tasks = <Task>[];

  for (var doc in allProjectsSnapshot.docs) {
    final project = ProjectModel.fromFirestore(doc.data());
    // Take only tasks that are in user.taskIds
    final userTasks = project.tasks.where((t) => user.taskIds.contains(t.id)).toList();
    tasks.addAll(userTasks);
  }

  return tasks;
}
}
