import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectDetailAnimationController extends GetxController {
  final isShowProjectNameError = false.obs;
  final isProjectNameEditing = false.obs;
  final isProjectDescriptionEditing = false.obs;

  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();

  void switchIsProjectNameEditing(bool value) {
    isProjectNameEditing.value = value;
  }

  void switchIsProjectDescriptionEditing(bool value) {
    isProjectDescriptionEditing.value = value;
  }

  void showProjectNameError() async {
    isShowProjectNameError.value = true;

    Future.delayed(const Duration(seconds: 5), () {
      isShowProjectNameError.value = false;
    });
  }

  void setDefaultValueTextField(
      TextEditingController textEditingController, String value) {
    textEditingController.text = value;
  }
}

class ProjectDetailController extends GetxController {
  final workspace = Workspace(name: '').obs;
  final workspaceId = ''.obs;
  final projectId = ''.obs;

  Future<void> refreshProjectUpdatedAt() async {
    FirebaseFirestore.instance
        .collection('workspace')
        .doc(workspaceId.value)
        .collection('project')
        .doc(projectId.value)
        .update({'updated_at': Timestamp.fromDate(DateTime.now())});
  }

  Stream<DocumentSnapshot<Project>> streamProject(
      String workspaceId, String projectId) async* {
    // Set Workspace ID and Project Id
    this.workspaceId.value = workspaceId;
    this.projectId.value = projectId;
    final workspaceRef = FirebaseFirestore.instance
        .collection('workspace')
        .doc(workspaceId)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Workspace.fromJson(snapshot.data()!),
            toFirestore: (Workspace workspace, _) => workspace.toJson());

    // set Workspace

    final workspace = await workspaceRef.get();
    this.workspace.value = workspace.data()!;

    final projectRef = workspaceRef
        .collection('project')
        .doc(projectId)
        .withConverter(
            fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
            toFirestore: (Project project, _) => project.toJson());

    final Stream<DocumentSnapshot<Project>> project = projectRef.snapshots();
    yield* project;
  }

  Future<void> updateProjectFromTextField(
      String field, TextEditingController textEditingController) async {
    final Map<String, String> fields = {
      'name': 'name',
      'description': 'description'
    };
    final value = textEditingController.text;

    final updateProject = FirebaseFirestore.instance
        .collection('workspace')
        .doc(workspaceId.value)
        .collection('project')
        .doc(projectId.value)
        .update({fields[field].toString(): value}).then((value) {
      refreshProjectUpdatedAt();
    });
  }
}
