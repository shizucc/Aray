import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String username;
  String role;
  DateTime joinDate;

  UserModel(
      {required this.email,
      required this.username,
      this.role = 'user',
      required this.joinDate});

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          email: json['email'] as String,
          username: json['username'] as String,
          role: json['role'] as String,
          joinDate: (json['join_date'] as Timestamp).toDate(),
        );

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'username': username,
      'role': role,
      'join_date': joinDate
    };
  }
}
