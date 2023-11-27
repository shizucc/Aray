import 'package:aray/app/data/model/model_user.dart';
import 'package:aray/app/data/model/model_user_workspace.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/workspaces/controller/crud_controller_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkspaceDetailAnimationController extends GetxController {
  final isWorkspaceNameEditing = false.obs;
  final isWorkspaceDescriptionEditing = false.obs;

  TextEditingController workspaceNameController = TextEditingController();
  TextEditingController workspaceDescriptionController =
      TextEditingController();

  void setDefaultValueTextfield(
      TextEditingController textEditingController, String value) {
    textEditingController.text = value;
  }

  void switchIsWorkspaceNameEditing(bool value) {
    isWorkspaceNameEditing.value = value;
  }

  void switcIsWorkspaceDescriptionEditing(bool value) {
    isWorkspaceDescriptionEditing.value = value;
  }
}

class WorkspaceDetailController extends GetxController {
  final workspaceId = ''.obs;

  CollectionReference<UserWorkspace> userWorkspacesRef() =>
      FirebaseFirestore.instance.collection('user_workspace').withConverter(
          fromFirestore: (snapshot, _) =>
              UserWorkspace.fromJson(snapshot.data()!),
          toFirestore: (UserWorkspace userWorkspace, _) =>
              userWorkspace.toJson());

  CollectionReference<UserModel> usersRef() =>
      FirebaseFirestore.instance.collection('user').withConverter(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (UserModel user, _) => user.toJson());

  DocumentReference<Workspace> workspaceRef(String workspaceId) =>
      FirebaseFirestore.instance
          .collection("workspace")
          .doc(workspaceId)
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  Workspace.fromJson(snapshot.data()!),
              toFirestore: (Workspace workspace, _) => workspace.toJson());

  Stream<DocumentSnapshot<Workspace>> streamWorkspace(String id) async* {
    final workspace = workspaceRef(id).snapshots();
    workspaceId.value = id;
    yield* workspace;
  }

  // Generate List User who is a member of the workspace
  Future<List<Map<String, dynamic>>> getWorkspaceMembers() async {
    final List<Map<String, dynamic>> usersDump = [];

    final userWorkspacesSnapshot = await userWorkspacesRef()
        .where('workspace_id', isEqualTo: workspaceId.value)
        .get();
    for (var userWorkspaceSnapshot in userWorkspacesSnapshot.docs) {
      final userId = userWorkspaceSnapshot.data().userId;
      final userRole = userWorkspaceSnapshot.data().permission;
      final userMember = {'userId': userId, 'userRole': userRole};
      usersDump.add(userMember);
    }
    // print(users);

    // print('object');
    // print(users);
    final List<Map<String, dynamic>> users = [];
    for (var user in usersDump) {
      final userId = user['userId'];

      final userSnapshot = await usersRef().doc(userId).get();
      // user.remove('userId');
      final userMap = {
        'userSnapshot': userSnapshot,
        'userRole': user['userRole']
      };
      users.add(userMap);
    }
    return users;
  }

  Future<void> updateProjectFromTextField(
      String field, TextEditingController textEditingController) async {
    final value = textEditingController.text;

    switch (field) {
      case 'name':
        WorkspaceCRUDController.updateName(
            workspaceRef(workspaceId.value), value);
        break;
      case 'description':
        WorkspaceCRUDController.updateDescription(
            workspaceRef(workspaceId.value), value);
        break;
      default:
    }
  }
}
