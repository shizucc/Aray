import 'dart:async';

import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/global_controller_project_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aray/utils/extension.dart';
import 'package:palette_generator/palette_generator.dart';

enum Personalize { defaultTheme, customImage }

class ProjectDetailAnimationController extends GetxController {
  final isShowProjectNameError = false.obs;
  final isProjectNameEditing = false.obs;
  final isProjectDescriptionEditing = false.obs;
  final isUseImage = false.obs;
  final defaultTheme = ''.obs;
  final customImage = ''.obs;
  final projectCoverImageUrl =
      'https://imgix.bustle.com/uploads/image/2021/9/23/b539ad6b-3417-4839-94eb-9ceb92abe21d-wccfgenshinimpact41.jpeg?w=1200&h=630&fit=crop&crop=faces&fm=jpg'
          .obs;
  final projectCoverImageDominantColor = const Color(0x0fffffff).obs;

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

  // Inisiasi untuk ditampilkan di UI
  Future<void> initPersonalize(ProjectDetailController c, Project project,
      String projectId, String workspaceId) async {
    final personalize = project.personalize;
    defaultTheme.value = personalize['color'];
    customImage.value = personalize['image'];
    final isUseImage = personalize['use_image'] as bool;

    this.isUseImage.value = isUseImage;

    if (this.isUseImage.value) {
      personalizeSwitch(Personalize.customImage);
    }
    final projectCoverImageUrl =
        // await getProjectCoverImageUrl(project, projectId);
        await ProjectGlobalController.getProjectCoverImageUrl(
            project, projectId);

    this.projectCoverImageUrl.value = projectCoverImageUrl;

    final Color projectCoverImageDominantColor =
        await c.getCoverImageDominantColor(projectCoverImageUrl);

    this.projectCoverImageDominantColor.value = projectCoverImageDominantColor;
  }
}

class ProjectDetailController extends GetxController {
  final workspace = Workspace(name: '').obs;
  final workspaceId = ''.obs;
  final projectId = ''.obs;

  Future<Color> getCoverImageDominantColor(String projectCoverImageUrl) async {
    // Generate Image Dominant Color
    final palleteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(projectCoverImageUrl));
    final projectCoverImageDominantColor =
        palleteGenerator.dominantColor!.color;

    Color myColor = Color(0xFFFFFFFF & projectCoverImageDominantColor.value);
    await updateProjectImageDominantColor(projectCoverImageDominantColor.value);

    return myColor;
  }

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

  Future<void> updateProjectImageDominantColor(int colorDecimal) async {
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

    personalize['image_dominant_color'] = colorDecimal;
    final updateProject = await projectRef.update({'personalize': personalize});
  }

  Future<void> updateProjectUseImage(bool isUseImage) async {
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

    personalize['use_image'] = isUseImage;
    final updateProject = await projectRef.update({'personalize': personalize});
  }
}
