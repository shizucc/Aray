import 'package:aray/app/data/model/model_workspace.dart';
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
  Stream<DocumentSnapshot<Workspace>> streamWorkspace(String id) async* {
    final workspaceRef = FirebaseFirestore.instance
        .collection("workspace")
        .doc(id)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Workspace.fromJson(snapshot.data()!),
            toFirestore: (Workspace workspace, _) => workspace.toJson());
    final workspace = workspaceRef.snapshots();

    workspaceId.value = id;
    yield* workspace;
  }

  Future<void> updateProjectFromTextField(
      String field, TextEditingController textEditingController) async {
    final Map<String, String> fields = {
      'name': 'name',
      'description': 'description'
    };
    final value = textEditingController.text;
    final updateProject = await FirebaseFirestore.instance
        .collection('workspace')
        .doc(workspaceId.value)
        .update({fields[field].toString(): value});
  }
}
