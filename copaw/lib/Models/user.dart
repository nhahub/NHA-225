class UserModel {
  static const String collectionName = 'users'; // ✅ Firestore collection name

  final String id;
  final String name;
  final String email;
  final bool isLeader;
  final String? projectId;
  final List<String> taskIds;
  final String? phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isLeader = false,
    this.projectId,
    this.taskIds = const [],
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']??'',
      isLeader: json['isLeader'] ?? false,
      projectId: json['projectId'],
      taskIds: List<String>.from(json['taskIds'] ?? []),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isLeader': isLeader,
      'projectId': projectId,
      'taskIds': taskIds,
      'phone':phone
    };
  }
}
