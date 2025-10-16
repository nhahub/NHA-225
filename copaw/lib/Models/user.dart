class AppUser {
  final String uid;
  final String? username;
  final String? email;
  final String? photoUrl;
  final bool isLeader;
  final List<String> projectIds; 
  final List<String> taskIds; 

  AppUser({
    required this.uid,
    this.username,
    this.email,
    this.photoUrl,
    this.isLeader = false,
    this.projectIds = const [],
    this.taskIds = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      isLeader: json['isLeader'] ?? false,
      projectIds: List<String>.from(json['projectIds'] ?? []),
      taskIds: List<String>.from(json['taskIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'photoUrl': photoUrl,
        'isLeader': isLeader,
        'projectIds': projectIds,
        'taskIds': taskIds,
      };
}
