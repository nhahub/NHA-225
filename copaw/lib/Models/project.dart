import 'task.dart';
import 'user.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String leaderId;
  final List<String> userIds; // All users assigned
  final List<Task> tasks;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderId,
    required this.userIds,
    required this.tasks,
  });

  factory Project.fromMap(Map<String, dynamic> data) {
    return Project(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      leaderId: data['leaderId'] ?? '',
      userIds: List<String>.from(data['userIds'] ?? []),
      tasks: (data['tasks'] as List<dynamic>?)
              ?.map((task) => Task.fromMap(task))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'leaderId': leaderId,
      'userIds': userIds,
      'tasks': tasks.map((t) => t.toMap()).toList(),
    };
  }
}
