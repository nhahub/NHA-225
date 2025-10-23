import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Models/task.dart';

class ProjectModel {
  static const String collectionName = "projects";

  String? id;
  String? name;
  String? description;
  DateTime? deadline;
  String? leaderId;
  List<UserModel> users;
  List<Task> tasks;
  Timestamp? createdAt;

  ProjectModel({
    this.id,
    this.name,
    this.description,
    this.leaderId,
    List<UserModel>? users,
    List<Task>? tasks,
    this.createdAt,
    this.deadline,
  })  : users = users ?? [],
        tasks = tasks ?? [];

  /// ✅ Convert Firestore data → ProjectModel
  factory ProjectModel.fromFirestore(Map<String, dynamic> data) {
    return ProjectModel(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      leaderId: data['leaderId'],
      users: (data['users'] as List<dynamic>?)
              ?.map((u) => UserModel.fromJson(u))
              .toList() ??
          [],
      tasks: (data['tasks'] as List<dynamic>?)
              ?.map((t) => Task.fromJson(t))
              .toList() ??
          [],
      createdAt: data['createdAt'],
      deadline: data['deadline'],
    );
  }

  /// ✅ Convert ProjectModel → Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'leaderId': leaderId,
      'users': users.map((u) => u.toJson()).toList(),
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'deadline': deadline ?? FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toJson() => toFirestore();
}
