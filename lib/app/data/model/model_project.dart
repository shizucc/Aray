import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  Map<String, dynamic> personalize;
  int order;

  Project(
      {required this.name,
      this.description = '',
      required this.createdAt,
      required this.updatedAt,
      required this.personalize,
      required this.order});

  factory Project.fromJson(Map<String, dynamic> json) => Project(
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      updatedAt: (json['updated_at'] as Timestamp).toDate(),
      personalize: json['personalize'] as Map<String, dynamic>,
      order: json['order'] as int);

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'created_at': Timestamp.fromDate(createdAt),
        'updated_at': Timestamp.fromDate(updatedAt),
        'personalize': personalize,
        'order': order,
      };
}
