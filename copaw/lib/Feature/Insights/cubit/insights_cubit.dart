import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Services/firebaseServices/project_service.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit() : super(InsightsInitial());

  /// Load all projects and tasks for insights
  Future<void> loadInsightsData(UserModel user) async {
    emit(InsightsLoading());
    try {
      // Load projects using ProjectService
      final projects = await ProjectService.getUserProjects(user.id);

      // Get all tasks from all projects
      final allTasks = <Task>[];
      for (var project in projects) {
        allTasks.addAll(project.tasks);
      }

      emit(InsightsLoaded(projects: projects, allTasks: allTasks));
    } catch (e) {
      emit(InsightsError('Failed to load insights: $e'));
    }
  }
}
