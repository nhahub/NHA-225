import 'package:copaw/provider/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/Projects/cubit/project_states.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Services/firebaseServices/project_service.dart';
import 'package:copaw/utils/app_assets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ProjectViewModel extends Cubit<ProjectStates> {
  ProjectViewModel() : super(ProjectInitialState()){
    // Initialize selectedDate with today
    selectedDate = DateFormat('MMM d, yyyy').format(DateTime.now());
  }

  // 🔹 Controllers and state
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDescreptionController = TextEditingController();
  String selectedDate = ""; // Initialized in constructor
  List<String> teamMembers = [AppAssets.placeholder];

  /// 🔹 Create a new project and save it to Firestore
  Future<void> createProject(BuildContext context) async {
    emit(ProjectLoadingState());
    try {
      final user = context.read<UserCubit>().state;
      var project = ProjectModel(
        name: projectNameController.text,
        deadline: DateFormat('MMM d, yyyy').parse(selectedDate),
        leaderId: user?.id,
        description: projectDescreptionController.text,
      );
      await ProjectService.addProjectToFirestore(project);
      emit(ProjectSuccessState(message: "Project created successfully"));
    } catch (e) {
      emit(ProjectErrorState(error: e.toString()));
    }
  }

  /// 🔹 Load all projects that belong to a specific user
  Future<void> getUserProjects(BuildContext context) async {
    emit(ProjectLoadingState());
    try {
      final user = context.read<UserCubit>().state;
      final projects = await ProjectService.getUserProjects(user?.id ?? '');
      emit(ProjectLoadedState(projects: projects));
    } catch (e) {
      emit(ProjectErrorState(error: e.toString()));
    }
  }

  /// 🔹 Update an existing project in Firestore
  Future<void> updateProject(BuildContext context) async {
    emit(ProjectLoadingState());
    try {
      final user = context.read<UserCubit>().state;
      var project = ProjectModel(
        name: projectNameController.text,
        deadline: DateFormat('MMM d, yyyy').parse(selectedDate),
        leaderId: user?.id, // Replace with actual current user ID
      );
      await ProjectService.updateProject(project);
      emit(ProjectSuccessState(message: "Project updated successfully"));
    } catch (e) {
      emit(ProjectErrorState(error: e.toString()));
    }
  }

  /// 🔹 Delete a project by its ID
  Future<void> deleteProject(String projectId) async {
    emit(ProjectLoadingState());
    try {
      await ProjectService.deleteProject(projectId);
      emit(ProjectSuccessState(message: "Project deleted successfully"));
    } catch (e) {
      
      emit(ProjectErrorState(error: e.toString()));
    }
  }

  /// 🔹 Add a user to the project using their email
  /// This will allow the project leader to type an email and add that user to the project.
  Future<void> addUserToProject(String projectId, String email) async {
    emit(ProjectLoadingState());
    try {
      await ProjectService.addUserToProjectByEmail(projectId, email);
      emit(ProjectSuccessState(message: "User added successfully"));
    } catch (e) {
      
      emit(ProjectErrorState(error: e.toString()));
    }
  }
}
