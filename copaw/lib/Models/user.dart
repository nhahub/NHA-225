class AppUser {
  final String uid;
  final String? username;
  final String? email;
  final String? photoUrl;
  final bool isLeader;
  final List<String> projectIds; 

  AppUser({
    required this.uid,
    this.username,
    this.email,
    this.photoUrl,
    this.isLeader = false,
    this.projectIds = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      isLeader: json['isLeader'] ?? false,
      projectIds: List<String>.from(json['projectIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'photoUrl': photoUrl,
        'isLeader': isLeader,
        'projectIds': projectIds,
      };
}
