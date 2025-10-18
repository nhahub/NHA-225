class Task {
  final String id;
  final String title;
  final String description;
  final String assignedTo; // userId
  final String status; // "todo" | "in_progress" | "done"
  final DateTime? deadline;
  final DateTime createdAt;
  final String projectId;
  final bool isCompleted;
  final String createdBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.status,
    required this.deadline,
    required this.createdAt,
    required this.projectId,
    required this.isCompleted,
    required this.createdBy,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      status: data['status'] ?? 'todo',
      deadline: data['deadline'] != null
          ? DateTime.parse(data['deadline'])
          : null,
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      projectId: data['projectId'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'projectId': projectId,
      'isCompleted': isCompleted,
      'createdBy': createdBy,
    };
  }
}
