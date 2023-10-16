import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  Map<String, dynamic> personalize;

  Project(
      {required this.name,
      this.description = '',
      required this.createdAt,
      required this.updatedAt,
      required this.personalize});

  factory Project.fromJson(Map<String, dynamic> json) => Project(
      name: json['name'],
      description: json['description'],
      createdAt: (json['created_at'] as Timestamp).toDate(),
      updatedAt: (json['updated_at'] as Timestamp).toDate(),
      personalize: json['personalize']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'created_at': Timestamp.fromDate(createdAt),
        'updated_at': Timestamp.fromDate(updatedAt),
        'personalize': personalize
      };
}
