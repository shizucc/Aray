import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  int order;

  CardModel(
      {required this.name,
      required this.createdAt,
      required this.updatedAt,
      required this.order});

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
      name: json['name'] as String,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      updatedAt: (json['updated_at'] as Timestamp).toDate(),
      order: json['order'] as int);

  Map<String, dynamic> toJson() => {
        'name': name,
        'created_at': Timestamp.fromDate(createdAt),
        'updated_at': Timestamp.fromDate(updatedAt),
        'order': order
      };
}
