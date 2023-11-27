import 'package:aray/app/data/model/model_user_workspace.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/workspaces/controller/crud_controller_user_workspace.dart';
import 'package:aray/utils/id_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkspaceCRUDController {
  static Future<void> addNew(
      CollectionReference<UserWorkspace> userWorkpaceRef,
      CollectionReference<Workspace> workspaceRef,
      Workspace workspace,
      String userId) async {
    // Generate a uniqe id for workspaceID
    final workspaceId = generateRandomCode(21);
    await workspaceRef.doc(workspaceId).set(workspace);
    await UserWorkspaceCRUDController.addNew(
        userWorkpaceRef, workspaceId, userId);
  }

  static Future<void> updateName(
      DocumentReference<Workspace> reference, String name) async {
    await reference.update({'name': name});
    await refreshUpdatedAt(reference);
  }

  static Future<void> updateDescription(
      DocumentReference<Workspace> reference, String description) async {
    await reference.update({'name': description});
    await refreshUpdatedAt(reference);
  }

  static Future<void> refreshUpdatedAt(
      DocumentReference<Workspace> reference) async {
    await reference.update({'updated_at': Timestamp.fromDate(DateTime.now())});
  }
}
