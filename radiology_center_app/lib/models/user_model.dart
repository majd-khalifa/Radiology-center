// lib/data/models/user_model.dart
import 'package:radiology_center_app/core/enums/user_role.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? fullName;
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      fullName: json['full_name'],
      role: json['role'] == "admin" ? UserRole.admin : UserRole.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      if (fullName != null) "full_name": fullName,
      "role": role == UserRole.admin ? "admin" : "user",
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? fullName,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
    );
  }
}
