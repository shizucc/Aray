import 'package:cloud_firestore/cloud_firestore.dart';

class FileModel {
  String name;
  String url;
  DateTime createdAt;

  FileModel({required this.name, required this.url, required this.createdAt});

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        name: json['name'] as String,
        url: json['url'] as String,
        createdAt: (json['created_at'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'created_at': Timestamp.fromDate(createdAt),
      };
}
