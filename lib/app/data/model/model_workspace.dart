import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_user.dart';
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
        name: json['name'],
        description: json['description'],
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
