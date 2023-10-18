import 'package:cloud_firestore/cloud_firestore.dart';

class UserWorkspace {
  String? userId;
  String? workspaceId;
  DateTime joinDate;
  String? permission;

  UserWorkspace(
      {required this.userId,
      required this.workspaceId,
      required this.joinDate,
      required this.permission});

  factory UserWorkspace.fromJson(Map<String, dynamic> json) => UserWorkspace(
      userId: json['user_id'],
      workspaceId: json['workspace_id'],
      joinDate: (json['join_date'] as Timestamp).toDate(),
      permission: json['permission']);

  Map<String, Object?> toJson() {
    return {
      'user_id': userId,
      'workspace_id': workspaceId,
      'join_date': Timestamp.fromDate(joinDate),
      'permission': permission
    };
  }
}
