import 'package:cloud_firestore/cloud_firestore.dart';

class Invitation {
  String senderName;
  String senderEmail;
  String status;
  DateTime createdAt;
  String workspaceId;
  String workspaceName;

  Invitation({
    required this.senderName,
    required this.senderEmail,
    required this.status,
    required this.createdAt,
    required this.workspaceId,
    required this.workspaceName,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        senderName: json["sender_name"] as String,
        senderEmail: json["sender_email"] as String,
        status: json["status"] as String,
        createdAt: (json["created_at"] as Timestamp).toDate(),
        workspaceId: json["workspace_id"] as String,
        workspaceName: json["workspace_name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "sender_name": senderName,
        "sender_email": senderEmail,
        "status": status,
        "created_at": createdAt,
        "workspace_id": workspaceId,
        "workspace_name": workspaceName
      };
}
