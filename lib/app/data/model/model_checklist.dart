import 'package:cloud_firestore/cloud_firestore.dart';

class Checklist {
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  bool status;
  int order;

  Checklist(
      {required this.name,
      required this.createdAt,
      required this.updatedAt,
      required this.status,
      required this.order});

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
      name: json['name'] as String,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      updatedAt: (json['updated_at'] as Timestamp).toDate(),
      status: json['status'] as bool,
      order: json['order'] as int);

  Map<String, dynamic> toJson() => {
        'name': name,
        'created_at': Timestamp.fromDate(createdAt),
        'updated_at': Timestamp.fromDate(updatedAt),
        'status': status,
        'order': order,
      };
}
