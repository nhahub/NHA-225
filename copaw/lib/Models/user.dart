class UserModel {
  static const String collectionName = "users";
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? confirmPassword;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.password,
    this.confirmPassword,
    this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
