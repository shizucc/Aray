import 'dart:async';

import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Personalize { defaultTheme, customImage }

class ProjectDetailAnimationController extends GetxController {
  final isShowProjectNameError = false.obs;
  final isProjectNameEditing = false.obs;
  final isProjectDescriptionEditing = false.obs;
  final defaultTheme = ''.obs;
  final customImage = ''.obs;

  final Rx<Personalize> personalize = Personalize.defaultTheme.obs;

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

  // Personalize,
  void personalizeSwitch(Personalize personalize) {
    this.personalize.value = personalize;
  }

  void initPersonalize(Project project) {
    final personalize = project.personalize;
    defaultTheme.value = personalize['color'];
    customImage.value = personalize['image'];
    final isUseImage = personalize['use_image'] as bool;

    if (isUseImage) {
      personalizeSwitch(Personalize.customImage);
    }
  }
}

class ProjectDetailController extends GetxController {
  final workspace = Workspace(name: '').obs;
  final workspaceId = ''.obs;
  final projectId = ''.obs;
  final projectCoverImageUrl =
      'https://webstatic.hoyoverse.com/upload/op-public/2023/01/09/1a2f542593b9c3bd4209290cc6202ea4_3666194450370987357.jpg'
          .obs;

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

    final updateProject = await FirebaseFirestore.instance
        .collection('workspace')
        .doc(workspaceId.value)
        .collection('project')
        .doc(projectId.value)
        .update({fields[field].toString(): value}).then((value) {
      refreshProjectUpdatedAt();
    });
  }

  Future<void> updateProjectPersonalizeColor(String colorCode) async {
    final projectRef = FirebaseFirestore.instance
        .collection('workspace')
        .doc(workspaceId.value)
        .collection('project')
        .doc(projectId.value)
        .withConverter(
            fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
            toFirestore: (Project project, _) => project.toJson());
    final projectData = await projectRef.get();
    final personalize = projectData.data()!.personalize;
    personalize['color'] = colorCode;

    // update
    final updateProject = await projectRef.update({'personalize': personalize});
  }

  Future<String> getProjectCoverImageUrl(String url) async {
    print("Hello");
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final projectCoverImagePath =
          "user/public/projects/project_${projectId.value}/cover_${projectId.value}";
      final projectCoverImageRef = storageRef.child(projectCoverImagePath);
      final projectCoverImageUrl = await projectCoverImageRef.getDownloadURL();
      print(projectCoverImageUrl);
    } catch (e) {
      print("Image Error");
    }
    return "Success";
  }
}
