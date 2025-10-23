// lib/Models/user_model.dart

class UserModel {
  static const String collectionName = 'users';

  final String id;
  final String name;
  final String email;
  final bool isLeader;
  final String? projectId;
  final List<String> taskIds;
  final String? phone;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isLeader = false,
    this.projectId,
    this.taskIds = const [],
    this.phone,
    this.avatarUrl,
  });

  /// ✅ Create UserModel from Firestore/JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      isLeader: json['isLeader'] ?? false,
      projectId: json['projectId'],
      taskIds: List<String>.from(json['taskIds'] ?? []),
      avatarUrl: json['avatarUrl'],
    );
  }

  /// ✅ Create UserModel directly from Firestore snapshot
  factory UserModel.fromFirestore(Map<String, dynamic>? data, String id) {
    if (data == null) {
      throw ArgumentError('User data is null for id: $id');
    }
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      isLeader: data['isLeader'] ?? false,
      projectId: data['projectId'],
      taskIds: List<String>.from(data['taskIds'] ?? []),
      avatarUrl: data['avatarUrl'],
    );
  }

  /// ✅ Convert UserModel → Firestore Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isLeader': isLeader,
      'projectId': projectId,
      'taskIds': taskIds,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  /// 🔁 Copy with optional overrides
  UserModel copyWith({
    String? name,
    String? email,
    bool? isLeader,
    String? projectId,
    List<String>? taskIds,
    String? phone,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      isLeader: isLeader ?? this.isLeader,
      projectId: projectId ?? this.projectId,
      taskIds: taskIds ?? this.taskIds,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
