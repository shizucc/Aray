import 'package:aray/app/data/model/model_user_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserWorkspaceCRUDController {
  static Future<void> addNew(CollectionReference<UserWorkspace> reference,
      String workspaceId, String userId) async {
    final UserWorkspace userWorkspace = UserWorkspace(
        userId: userId,
        workspaceId: workspaceId,
        joinDate: DateTime.now(),
        permission: 'creator');

    await reference.add(userWorkspace);
  }

  static Future<void> join(CollectionReference<UserWorkspace> reference,
      String workspaceId, String userId) async {
    final UserWorkspace userWorkspace = UserWorkspace(
        userId: userId,
        workspaceId: workspaceId,
        joinDate: DateTime.now(),
        permission: "co-creator");

    await reference.add(userWorkspace);
  }

  static Future<void> leave(DocumentReference<UserWorkspace> reference) async {
    reference.delete();
  }
}
