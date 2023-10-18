import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String name;
  String description;
  DateTime? startTime;
  DateTime? endTime;
  String coverImage;
  List<dynamic>? files;

  Activity(
      {this.coverImage = '',
      required this.name,
      this.description = '',
      this.startTime,
      this.endTime,
      this.files});

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        name: json['name'],
        description: json['description'],
        coverImage: json['cover_image'],
        startTime: (json['start_time'] as Timestamp).toDate(),
        endTime: (json['end_time'] as Timestamp).toDate(),
        files: json['files'] ?? [],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "cover_image": coverImage,
        "start_time": startTime,
        "end_time": endTime,
        "files": files,
      };
}
