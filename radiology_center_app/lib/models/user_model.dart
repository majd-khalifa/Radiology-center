// lib/data/models/user_model.dart
class UserModel {
  final int? id;
  final String username;
  final String email;
  final String? fullName;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      fullName: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      if (fullName != null) "full_name": fullName,
    };
  }
}
