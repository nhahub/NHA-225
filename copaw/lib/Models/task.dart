// lib/Models/task.dart

class Task {
   String id;
  final String title;
  final String description;
  final List<String> assignedTo; 
  final String status;
  final DateTime? deadline;
  final DateTime createdAt;
  final String projectId;
  final bool isCompleted;
  final String createdBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.assignedTo = const [],
    required this.status,
    this.deadline,
    required this.createdAt,
    required this.projectId,
    required this.isCompleted,
    required this.createdBy,
  });

  /// ✅ Create Task from Firestore / JSON map
  factory Task.fromJson(Map<String, dynamic> data) {
    return Task(
      id: (data['id'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      assignedTo: (data['assignedTo'] is List)
          ? List<String>.from(data['assignedTo'])
          : <String>[],
      status: (data['status'] ?? 'todo') as String,
      deadline: _parseNullableDate(data['deadline']),
      createdAt: _parseDate(data['createdAt']),
      projectId: (data['projectId'] ?? '') as String,
      isCompleted: (data['isCompleted'] ?? false) as bool,
      createdBy: (data['createdBy'] ?? '') as String,
    );
  }

  /// ✅ Create Task from Firestore snapshot (with ID)
  factory Task.fromFirestore(Map<String, dynamic>? data, String id) {
    if (data == null) {
      throw ArgumentError('Task data is null for id: $id');
    }
    return Task.fromJson({
      ...data,
      'id': id,
    });
  }

  /// ✅ Convert Task → Firestore Map
  Map<String, dynamic> toJson() {
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

  /// 🔁 Copy with optional overrides
  Task copyWith({
    String? title,
    String? description,
    List<String>? assignedTo,
    String? status,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt,
      projectId: projectId,
      isCompleted: isCompleted ?? this.isCompleted,
      createdBy: createdBy,
    );
  }


  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static DateTime? _parseNullableDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
