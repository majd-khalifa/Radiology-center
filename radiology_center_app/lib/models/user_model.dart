// lib/data/models/user_model.dart
import 'package:radiology_center_app/core/enums/user_role.dart';

class UserModel {
  final int? id;
  final String username;
  final String email;
  final String? fullName;
  final UserRole role;

  UserModel({
    required this.role,
    this.id,
    required this.username,
    required this.email,
    this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.user,
      id: json['id'],
      username: json['name'] ?? "",
      email: json['email'] ?? "",
      fullName: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      if (fullName != null) "full_name": "fullName",
    };
  }
}
