import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';

class ProjectService {
  /// 🔹 Global "projects" collection
  static CollectionReference<ProjectModel> getProjectsCollection() {
    return FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .withConverter<ProjectModel>(
          fromFirestore: (snapshot, _) =>
              ProjectModel.fromFirestore(snapshot.data()!),
          toFirestore: (project, _) => project.toFirestore(),
        );
  }

  /// 🔹 User's subcollection (projects of that user)
  static CollectionReference<ProjectModel> getUserProjectsCollection(String userId) {
    return AuthService.getUsersCollection()
        .doc(userId)
        .collection(ProjectModel.collectionName)
        .withConverter<ProjectModel>(
          fromFirestore: (snapshot, _) =>
              ProjectModel.fromFirestore(snapshot.data()!),
          toFirestore: (project, _) => project.toFirestore(),
        );
  }

  /// 🔸 Add project ID to user's main document
  static Future<void> addProjectIdToUser(String userId, String projectId) async {
    final userDocRef = AuthService.getUsersCollection().doc(userId);
    await userDocRef.update({
      'projectId': FieldValue.arrayUnion([projectId]),
    });
  }

  /// 🔸 Remove project ID from user's main document
  static Future<void> removeProjectIdFromUser(String userId, String projectId) async {
    final userDocRef = AuthService.getUsersCollection().doc(userId);
    await userDocRef.update({
      'projectId': FieldValue.arrayRemove([projectId]),
    });
  }

  /// ✅ Create a new project:
  /// - Add to global collection
  /// - Add to leader's subcollection
  /// - Add projectId to leader document
  static Future<void> addProjectToFirestore(ProjectModel project) async {
    // 🔹 Create project document with auto ID
    final projectDocRef = getProjectsCollection().doc();
    project.id = projectDocRef.id;

    // 🔹 Ensure leader is included in the project users
    final leader = await AuthService.getUserById(project.leaderId!);
    if (leader != null && !project.users.any((u) => u.id == leader.id)) {
      project.users.add(leader);
    }

    // 🔹 Save to global "projects" collection
    await projectDocRef.set(project);

    // 🔹 Add to leader’s "projects" subcollection
    await getUserProjectsCollection(project.leaderId!)
        .doc(project.id!)
        .set(project);

    // 🔹 Add projectId to leader’s main user doc
    await addProjectIdToUser(project.leaderId!, project.id!);
  }

  /// 🔹 Update project everywhere
  static Future<void> updateProject(ProjectModel project) async {
    if (project.id == null || project.id!.isEmpty) {
      throw Exception('Cannot update project: ID is null or empty');
    }

    // Update in global collection
    await getProjectsCollection().doc(project.id).update(project.toFirestore());

    // Sync to all users’ subcollections
    for (final user in project.users) {
      await getUserProjectsCollection(user.id!)
          .doc(project.id!)
          .set(project);
    }
  }

  /// 🔹 Delete project globally + from all users
  static Future<void> deleteProject(String projectId) async {
    final doc = await getProjectsCollection().doc(projectId).get();
    final project = doc.data();

    if (project != null) {
      await getProjectsCollection().doc(projectId).delete();

      for (final user in project.users) {
        await getUserProjectsCollection(user.id!)
            .doc(projectId)
            .delete();

        await removeProjectIdFromUser(user.id!, projectId);
      }
    }
  }

    /// 🔹 Add user to a project by email (and sync across all project members)
  static Future<String> addUserToProjectByEmail(
      String projectId, String userEmail) async {
    // 1️⃣ Get the user by email
    final user = await AuthService.getUserByEmail(userEmail);
    if (user == null) return 'No user found with this email.';

    // 2️⃣ Get the project document
    final docRef = getProjectsCollection().doc(projectId);
    final snapshot = await docRef.get();
    if (!snapshot.exists) return 'Project not found.';

    final project = snapshot.data()!;
    if (project.users == null) project.users = [];

    // 3️⃣ Check if the user is already part of the project
    final exists = project.users.any((u) => u.id == user.id);
    if (exists) return 'User already in project.';

    // 4️⃣ Add the new user to the project
    project.users.add(user);

    // 5️⃣ Update the project in the global "projects" collection
    await docRef.update({
      'users': project.users.map((u) => u.toJson()).toList(),
    });

    // 6️⃣ Add the project to the new user's personal "projects" subcollection
    await getUserProjectsCollection(user.id!).doc(projectId).set(project);

    // 7️⃣ Add the project ID to the new user's main document
    await addProjectIdToUser(user.id!, projectId);

    // 8️⃣ Sync the updated project data to all existing members’ subcollections
    for (final existingUser in project.users) {
      await getUserProjectsCollection(existingUser.id!)
          .doc(projectId)
          .set(project);
    }

    return 'User added successfully!';
  }



  /// 🔹 Get all projects for user (once)
  static Future<List<ProjectModel>> getUserProjects(String userId) async {
    final querySnapshot = await getUserProjectsCollection(userId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// 🔹 Real-time stream (for Cubit or Bloc)
  static Stream<List<ProjectModel>> listenToUserProjects(String userId) {
    return getUserProjectsCollection(userId).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  /// 🔹 Get project by ID
  static Future<ProjectModel?> getProjectById(String projectId) async {
    final doc = await getProjectsCollection().doc(projectId).get();
    return doc.data();
  }
}
