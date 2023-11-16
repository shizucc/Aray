import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String name;
  String description;
  DateTime? startTime;
  DateTime? endTime;
  String coverImage;
  List<dynamic>? files;
  bool timestamp;
  int order;

  Activity.withTimestamp(
      {this.coverImage = '',
      required this.name,
      this.description = '',
      this.startTime,
      this.endTime,
      this.files,
      required this.timestamp,
      required this.order});

  Activity.withoutTimestamp(
      {this.coverImage = '',
      required this.name,
      this.description = '',
      this.files,
      required this.timestamp,
      required this.order});

  factory Activity.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timestamp'] as bool;
    if (timestamp) {
      return Activity.withTimestamp(
          name: json['name'] as String,
          description: json['description'] as String,
          coverImage: json['cover_image'] as String,
          startTime: (json['start_time'] as Timestamp).toDate(),
          endTime: (json['end_time'] as Timestamp).toDate(),
          files: json['files'] ?? [],
          timestamp: timestamp,
          order: json['order'] as int);
    } else {
      return Activity.withoutTimestamp(
          name: json['name'] as String,
          description: json['description'] as String,
          coverImage: json['cover_image'] as String,
          files: json['files'] ?? [],
          timestamp: timestamp,
          order: json['order'] as int);
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "name": name,
      "description": description,
      "cover_image": coverImage,
      "files": files,
      "timestamp": false,
      "order": order
    };

    if (startTime != null && endTime != null) {
      json["start_time"] = startTime;
      json["end_time"] = endTime;
      json["timestamp"] = true;
    }

    return json;
  }
}
