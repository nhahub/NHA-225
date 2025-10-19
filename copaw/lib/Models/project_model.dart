import 'package:copaw/Models/user.dart';

class ProjectModel {
  // Firestore collection name
  static const String collectionName = 'projects';

  // Attributes
  String id;
  String name;
  DateTime deadline;
  String leaderId; // team leader ID (user who created the project)
  List<UserModel> users;
  List<String> todoTasks;
  List<String> doingTasks;
  List<String> doneTasks;

  // Constructor
  ProjectModel({
    this.id = "",
    required this.name,
    required this.deadline,
    required this.leaderId,
    this.users = const [],
    this.todoTasks = const [],
    this.doingTasks = const [],
    this.doneTasks = const [],
  });

  // Convert object → Firestore JSON
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'leader_id': leaderId,
      'deadline': deadline.millisecondsSinceEpoch,
      'users': users.map((u) => u.toJson()).toList(),
      'todo_tasks': todoTasks,
      'doing_tasks': doingTasks,
      'done_tasks': doneTasks,
    };
  }

  // Convert Firestore JSON → object
  factory ProjectModel.fromFirestore(Map<String, dynamic> data) {
    return ProjectModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      leaderId: data['leader_id'] ?? '',
      deadline: DateTime.fromMillisecondsSinceEpoch(data['deadline'] ?? 0),
      users: (data['users'] as List<dynamic>?)
              ?.map((u) => UserModel.fromJson(u as Map<String, dynamic>))
              .toList() ??
          [],
      todoTasks: List<String>.from(data['todo_tasks'] ?? []),
      doingTasks: List<String>.from(data['doing_tasks'] ?? []),
      doneTasks: List<String>.from(data['done_tasks'] ?? []),
    );
  }
}
