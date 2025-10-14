class Task {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final String projectId;
  final bool isCompleted;
  final String createdBy;
  final List<String> assignedTo;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.deadline,
    this.projectId = '',
    this.isCompleted = false,
    this.createdBy = '',
    this.assignedTo = const [],
  });
}
