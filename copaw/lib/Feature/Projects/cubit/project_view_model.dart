import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/project_service.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/Feature/Projects/cubit/project_states.dart';

class ProjectViewModel extends Cubit<ProjectStates> {
  ProjectViewModel() : super(ProjectInitialState());

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDescreptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  StreamSubscription<List<ProjectModel>>? _subscription;

  /// --- CREATE PROJECT ---
  Future<void> createProject(BuildContext context) async {
    try {
      emit(ProjectLoadingState());

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        emit(ProjectErrorState("User not logged in."));
        return;
      }

      // ✅ Fetch user data
      final user = await AuthService.getUserById(firebaseUser.uid);
      if (user == null) {
        emit(ProjectErrorState("Failed to fetch user data."));
        return;
      }

      // ✅ Create project object
      final project = ProjectModel(
        name: projectNameController.text.trim(),
        description: projectDescreptionController.text.trim(),
        deadline: selectedDate,
        leaderId: user.id,
        users: [user],
        tasks: [],
      );

      // ✅ Add to Firestore
      await ProjectService.addProjectToFirestore(project);

      emit(ProjectSuccessState("Project created successfully!"));
    } catch (e) {
      emit(ProjectErrorState("Failed to create project: $e"));
    }
  }

  /// --- REAL-TIME PROJECTS LISTENER ---
  void listenToProjects(String userId) {
    emit(ProjectsLoadingState());
    _subscription?.cancel();

    _subscription = ProjectService.listenToUserProjects(userId).listen(
      (projects) => emit(ProjectsLoadedState(projects)),
      onError: (error) => emit(ProjectsErrorState(error.toString())),
    );
  }

  /// --- ADD MEMBER TO PROJECT ---
  Future<void> addMemberToProject(String projectId, String memberEmail) async {
    try {
      emit(AddMemberLoadingState());

      // ✅ Add member using ProjectService (already handles syncing)
      final result = await ProjectService.addUserToProjectByEmail(projectId, memberEmail);

      if (result.contains("successfully")) {
        emit(AddMemberSuccessState(result));
      } else {
        emit(AddMemberErrorState(result));
      }
    } catch (e) {
      emit(AddMemberErrorState("Failed to add member: $e"));
    }
  }

  /// --- DELETE PROJECT ---
  Future<void> deleteProject(String projectId) async {
    try {
      await ProjectService.deleteProject(projectId);
      emit(ProjectSuccessState("Project deleted successfully"));
    } catch (e) {
      emit(ProjectErrorState(e.toString()));
    }
  }

  /// --- DATE PICKER ---
  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    emit(ProjectDateUpdatedState(date));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    projectNameController.dispose();
    projectDescreptionController.dispose();
    return super.close();
  }
}
