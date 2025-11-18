import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/user.dart';

class TaskService {
  static final _firestore = FirebaseFirestore.instance;

static Future<void> updateTask(Task task, String projectId) async {
  if (projectId.isEmpty) throw Exception("Project ID cannot be empty");

  final projectRef = _firestore.collection(ProjectModel.collectionName).doc(projectId);

  await _firestore.runTransaction((tx) async {
    final snapshot = await tx.get(projectRef);
    if (!snapshot.exists) throw Exception("Project not found: $projectId");

    final project = ProjectModel.fromFirestore(snapshot.data()!);
    final updatedTasks = project.tasks.map((t) => t.id == task.id ? task : t).toList();

    tx.update(projectRef, {'tasks': updatedTasks.map((t) => t.toJson()).toList()});
  });
}


static Future<void> deleteTask(String taskId, ProjectModel project) async {
  if (project.id == null || project.id!.isEmpty) {
    throw Exception("Project ID cannot be empty");
  }

  final firestore = FirebaseFirestore.instance;
  final projectRef = firestore.collection(ProjectModel.collectionName).doc(project.id);

  // Use transaction so we remove task atomically from server project
  await firestore.runTransaction((tx) async {
    final snap = await tx.get(projectRef);
    if (!snap.exists) return;
    final serverProject = ProjectModel.fromFirestore(snap.data()!);
    final updatedTasks = serverProject.tasks.where((t) => t.id != taskId).toList();
    tx.update(projectRef, {'tasks': updatedTasks.map((t) => t.toJson()).toList()});
  });

  // update local project instance too
  project.tasks = project.tasks.where((t) => t.id != taskId).toList();

  // Update each user's subcollection & remove taskId from user doc
  for (final user in project.users) {
    final userDocRef = firestore.collection('users').doc(user.id);
    final userProjectRef = userDocRef.collection(ProjectModel.collectionName).doc(project.id);

    final userProjectSnap = await userProjectRef.get();
    if (userProjectSnap.exists) {
      final userProjectData = userProjectSnap.data();
      if (userProjectData != null && userProjectData['tasks'] != null) {
        final updatedUserTasks = (userProjectData['tasks'] as List<dynamic>).where((t) => t['id'] != taskId).toList();
        await userProjectRef.set({'tasks': updatedUserTasks}, SetOptions(merge: true));
      }
    }

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

  final projectRef = firestore.collection(ProjectModel.collectionName).doc(project.id);

  if (task.id.isEmpty) task.id = firestore.collection('tasks').doc().id;

  // 1. transaction to append task safely
  await firestore.runTransaction((tx) async {
    final snap = await tx.get(projectRef);
    if (!snap.exists) throw Exception("Project not found for ID: ${project.id}");

    final serverProject = ProjectModel.fromFirestore(snap.data()!);
    final updatedTasks = [...serverProject.tasks, task];

    tx.update(projectRef, {'tasks': updatedTasks.map((t) => t.toJson()).toList()});
  });

  // 2. Update each user's project subcollection safely (create if missing)
  for (final user in project.users) {
    final userProjectRef = firestore
        .collection('users')
        .doc(user.id)
        .collection(ProjectModel.collectionName)
        .doc(project.id);

    final userProjectSnap = await userProjectRef.get();
    if (userProjectSnap.exists) {
      final userProj = ProjectModel.fromFirestore(userProjectSnap.data()!);
      final updatedUserTasks = [...userProj.tasks, task];
      await userProjectRef.set({'tasks': updatedUserTasks.map((t) => t.toJson()).toList()}, SetOptions(merge: true));
    } else {
      // create basic doc if not exists
      await userProjectRef.set({
        'tasks': [task.toJson()],
        // يمكنك إضافة بيانات المشروع الأخرى هنا إذا تحتاجها
      }, SetOptions(merge: true));
    }

    // 3. Add task id to user's taskIds array (if you keep taskIds)
    final userDocRef = firestore.collection('users').doc(user.id);
    await userDocRef.update({
      'taskIds': FieldValue.arrayUnion([task.id]),
    });
  }
}


}
