import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';

class ProjectService {
  /// 🔹 Reference to global "projects" collection
  static CollectionReference<ProjectModel> getProjectsCollection() {
    return FirebaseFirestore.instance
        .collection(ProjectModel.collectionName)
        .withConverter<ProjectModel>(
          fromFirestore: (snapshot, _) =>
              ProjectModel.fromFirestore(snapshot.data()!),
          toFirestore: (project, _) => project.toFirestore(),
        );
  }

  /// 🔹 Reference to user's sub collection (projects of specific user)
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

  /// ✅ Create a new project:
  /// - Save it in global projects collection
  /// - Save it in the leader's personal sub collection only
  static Future<void> addProjectToFirestore(ProjectModel project) async {
    final projectDocRef = getProjectsCollection().doc();
    project.id = projectDocRef.id;

    // 🔹 Get leader info
    final leader = await AuthService.getUserById(project.leaderId);
    if (leader != null && !project.users.any((u) => u.id == leader.id)) {
      project.users.add(leader);
    }

    // 🔹 Save to global collection
    await projectDocRef.set(project);

    // 🔹 Save only inside the leader’s sub collection
    await getUserProjectsCollection(project.leaderId)
        .doc(project.id)
        .set(project);
  }

  /// 🔹 Update project (sync global + all users sub collections)
  static Future<void> updateProject(ProjectModel project) async {
    // Update main global project
    await getProjectsCollection().doc(project.id).update(project.toFirestore());

    // Sync with every user that’s part of the project
    for (final user in project.users) {
      await getUserProjectsCollection(user.id!)
          .doc(project.id)
          .set(project);
    }
  }

  /// 🔹 Delete project (remove from global + all users sub collections)
  static Future<void> deleteProject(String projectId) async {
    final doc = await getProjectsCollection().doc(projectId).get();
    final project = doc.data();

    if (project != null) {
      // Delete from global
      await getProjectsCollection().doc(projectId).delete();

      // Delete from every user's sub collection
      for (final user in project.users) {
        await getUserProjectsCollection(user.id!)
            .doc(projectId)
            .delete();
      }
    }
  }

  /// 🔹 Add user to project by email (Leader adds member)
  static Future<String> addUserToProjectByEmail(
      String projectId, String userEmail) async {
    // search for user by email
    final user = await AuthService.getUserByEmail(userEmail);
    if (user == null) {
      return 'No user found with this email.';
    }

    // get project data
    final docRef = getProjectsCollection().doc(projectId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      return 'Project not found.';
    }

    final project = snapshot.data()!;
    final exists = project.users.any((u) => u.id == user.id);

    // if user not already in project, add them
    if (!exists) {
      project.users.add(user);

      // Update global project document
      await docRef.update({
        'users': project.users.map((u) => u.toJson()).toList(),
      });

      // Update user's sub collection
      await getUserProjectsCollection(user.id!)
          .doc(projectId)
          .set(project);

      return 'User added successfully!';
    } else {
      return 'User already in project.';
    }
  }

  /// 🔹 Get all projects for a specific user
  static Future<List<ProjectModel>> getUserProjects(String userId) async {
    final querySnapshot = await getUserProjectsCollection(userId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// 🔹 Listen in real-time to user's projects
  static Stream<List<ProjectModel>> listenToUserProjects(String userId) {
    return getUserProjectsCollection(userId).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  /// 🔹 Get a single project by ID
  static Future<ProjectModel?> getProjectById(String projectId) async {
    final doc = await getProjectsCollection().doc(projectId).get();
    return doc.data();
  }
}
