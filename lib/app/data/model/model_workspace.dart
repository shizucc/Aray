import 'package:aray/app/data/model/model_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Workspace {
  String? name;
  String? description;
  List<dynamic> members;
  List<dynamic>? projects;
  DateTime? createdAt;
  DateTime? updatedAt;

  Workspace(
      {required this.name,
      this.createdAt,
      this.description = '',
      required this.members,
      this.projects,
      this.updatedAt});

  factory Workspace.fromJson(Map<String, dynamic> json) => Workspace(
      name: json['name'],
      description: json['description'],
      members: json['members'],
      updatedAt: (json['updated_at'] as Timestamp).toDate(),
      createdAt: DateTime.now(),
      projects: json['projects'] ?? []);

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'members': members,
      'projets': projects,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }
}
