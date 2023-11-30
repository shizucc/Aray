import 'package:cloud_firestore/cloud_firestore.dart';

class Workspace {
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  Workspace(
      {required this.name,
      this.createdAt,
      this.description = '',
      this.updatedAt});

  factory Workspace.fromJson(Map<String, dynamic> json) => Workspace(
        name: json['name'] as String,
        description: json['description'] as String,
        updatedAt: (json['updated_at'] as Timestamp).toDate(),
        createdAt: DateTime.now(),
      );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }
}
