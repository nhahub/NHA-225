import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid; 
  final String email;
  final String username;
  final bool isLeader; 
  final String? projectId;
  final List<String> taskIds;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    this.isLeader = false,
    this.projectId,
    this.taskIds = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// تحويل من JSON (Firestore → Model)
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      isLeader: json['isLeader'] ?? false,
      projectId: json['projectId'],
      taskIds: List<String>.from(json['taskIds'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// تحويل لـ JSON (Model → Firestore)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'isLeader': isLeader,
      'projectId': projectId,
      'taskIds': taskIds,
      'createdAt': createdAt,
    };
  }
}
