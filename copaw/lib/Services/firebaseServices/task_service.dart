import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/user.dart';

class TaskService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> updateTask(Task task, ProjectModel project) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    final projectRef = _firestore
        .collection(ProjectModel.collectionName)
        .doc(project.id);
    final updatedTasks = project.tasks
        .map((t) => t.id == task.id ? task : t)
        .toList();

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });
  }

  static Future<void> deleteTask(String taskId, ProjectModel project) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception("Project ID cannot be empty");
    }

    final firestore = FirebaseFirestore.instance;
    final projectRef = firestore
        .collection(ProjectModel.collectionName)
        .doc(project.id);

    // 1️⃣ Remove the task from the project's tasks list
    final updatedTasks = project.tasks.where((t) => t.id != taskId).toList();

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });

    // 2️⃣ Update each user's project subcollection + remove task from user document
    for (final user in project.users) {
      final userDocRef = firestore.collection('users').doc(user.id);
      final userProjectRef = userDocRef
          .collection(ProjectModel.collectionName)
          .doc(project.id);

      // Remove task from user's project subcollection
      final userProjectSnap = await userProjectRef.get();
      if (userProjectSnap.exists) {
        final userProjectData = userProjectSnap.data();
        if (userProjectData != null && userProjectData['tasks'] != null) {
          final updatedUserTasks = (userProjectData['tasks'] as List<dynamic>)
              .where((t) => t['id'] != taskId)
              .toList();
          await userProjectRef.update({'tasks': updatedUserTasks});
        }
      }

      // 3️⃣ Remove the taskId from user's `taskIds` array in Firestore
      await userDocRef.update({
        'taskIds': FieldValue.arrayRemove([taskId]),
      });
    }
  }

  static Future<List<Task>> getProjectTasks(String projectId) async {
    if (projectId.isEmpty) return [];
    final projectDoc = await _firestore
        .collection(ProjectModel.collectionName)
        .doc(projectId)
        .get();
    if (!projectDoc.exists || projectDoc.data() == null) return [];
    final project = ProjectModel.fromFirestore(projectDoc.data()!);
    return project.tasks;
  }

  static Stream<List<Task>> listenToProjectTasks(String projectId) {
    if (projectId.isEmpty) throw Exception("Project ID cannot be empty");
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

  static Future<void> addTaskToProject(Task task, ProjectModel project) async {
    final firestore = FirebaseFirestore.instance;
    if (project.id == null || project.id!.isEmpty)
      throw Exception("Project ID cannot be empty");

    final projectRef = firestore
        .collection(ProjectModel.collectionName)
        .doc(project.id);
    final snapshot = await projectRef.get();
    if (!snapshot.exists)
      throw Exception("Project not found for ID: ${project.id}");

    if (task.id.isEmpty) task.id = firestore.collection('tasks').doc().id;

    final updatedTasks = [...project.tasks, task];
    project.tasks = updatedTasks;

    await projectRef.update({
      'tasks': updatedTasks.map((t) => t.toJson()).toList(),
    });

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

  static Future<List<Task>> getTasksForUserByIds(UserModel user) async {
    if (user.taskIds.isEmpty) return [];
    final allProjectsSnapshot = await _firestore
        .collection(ProjectModel.collectionName)
        .get();
    final tasks = <Task>[];
    for (var doc in allProjectsSnapshot.docs) {
      final project = ProjectModel.fromFirestore(doc.data());
      final userTasks = project.tasks
          .where((t) => user.taskIds.contains(t.id))
          .toList();
      tasks.addAll(userTasks);
    }
    return tasks;
  }

  /// 🔥 NEW — Stream real-time user tasks
  static Stream<List<Task>> listenToUserTasks(UserModel user) {
    return _firestore.collection(ProjectModel.collectionName).snapshots().map((
      snapshot,
    ) {
      final tasks = <Task>[];
      for (var doc in snapshot.docs) {
        final project = ProjectModel.fromFirestore(doc.data());
        final userTasks = project.tasks
            .where((t) => user.taskIds.contains(t.id))
            .toList();
        tasks.addAll(userTasks);
      }
      return tasks;
    });
  }
}
