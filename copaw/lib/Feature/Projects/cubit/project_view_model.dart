import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/Projects/cubit/project_states.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Services/firebaseServices/project_service.dart';

class ProjectViewModel extends Cubit<ProjectStates> {
  ProjectViewModel() : super(ProjectInitialState());

  /// 🔹 Create a new project and save it to Firestore
  Future<void> createProject(ProjectModel project) async {
    emit(ProjectLoadingState());
    try {
      await ProjectService.addProjectToFirestore(project);
      emit(ProjectSuccessState(message: "Project created successfully"));
    } catch (e) {
      emit(ProjectErrorState(error: e.toString()));
    }
  }

  /// 🔹 Load all projects that belong to a specific user
  Future<void> getUserProjects(String userId) async {
    emit(ProjectLoadingState());
    try {
      final projects = await ProjectService.getUserProjects(userId);
      emit(ProjectLoadedState(projects: projects));
    } catch (e) {
      emit(ProjectErrorState(error: e.toString()));
    }
  }

  /// 🔹 Update an existing project in Firestore
  Future<void> updateProject(ProjectModel project) async {
    emit(ProjectLoadingState());
    try {
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
      emit(ProjectSuccessState(message: "👥 User added successfully"));
    } catch (e) {
      
      emit(ProjectErrorState(error: e.toString()));
    }
  }
}
