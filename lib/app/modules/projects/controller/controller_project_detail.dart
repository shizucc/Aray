import 'dart:async';
import 'dart:io';

import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:palette_generator/palette_generator.dart';
import 'package:image_picker/image_picker.dart';

enum Personalize { defaultTheme, customImage }

class ProjectDetailAnimationController extends GetxController {
  final isShowProjectNameError = false.obs;
  final isProjectNameEditing = false.obs;
  final isProjectDescriptionEditing = false.obs;
  final isUseImage = false.obs;
  final defaultTheme = ''.obs;
  final customImage = ''.obs;
  final projectCoverImageFile = File('').obs;

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

    final isUseImage = personalize['use_image'] as bool;
    defaultTheme.value = personalize['color'];

    this.isUseImage.value = isUseImage;

    if (this.isUseImage.value) {
      personalizeSwitch(Personalize.customImage);
    }
  }

  Future<void> pickProjectCoverImageFile() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      projectCoverImageFile.value = File(pickedImage.path);
    }
    final String projectCoverImageFileName =
        projectCoverImageFile.value.path.split('/').last;
  }
}

class ProjectDetailController extends GetxController {
  final workspace = Workspace(name: '').obs;
  final workspaceId = ''.obs;
  final projectId = ''.obs;

  Future<void> updateCoverImageDominantColor(
      String projectCoverImageUrl) async {
    // Generate Image Dominant Color
    final palleteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(projectCoverImageUrl));
    final projectCoverImageDominantColor =
        palleteGenerator.dominantColor!.color;

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

    personalize['image_dominant_color'] = projectCoverImageDominantColor.value;
    final updateProject = await projectRef.update({'personalize': personalize});
    // return myColor;
  }

  Future<void> updateProjectCoverImageLink(
      String projectCoverImageLink, String projectCoverImageFileName) async {
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
    personalize['image'] = projectCoverImageFileName;
    personalize['image_link'] = projectCoverImageLink;
    final updateProject = await projectRef.update({'personalize': personalize});
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

  Future<bool> updateProjectCoverImage(
      Project project, File projectCoverImageFile) async {
    String projectCoverImageFileName =
        Timestamp.now().toString() + projectCoverImageFile.path.split('/').last;
    final projectCoverImageStorageRef = FirebaseStorage.instance.ref().child(
        'user/public/projects/project_$projectId/cover/$projectCoverImageFileName');

    final uploadProjectCoverImage = await projectCoverImageStorageRef.putFile(
        projectCoverImageFile,
        SettableMetadata(
          contentType: "image/jpeg",
        ));

    if (uploadProjectCoverImage.state == TaskState.success) {
      // Delete old cover image
      final oldProjectCoverImageFileName = project.personalize['image'];

      try {
        final projectCoverImageStorageRef = FirebaseStorage.instance.ref().child(
            'user/public/projects/project_$projectId/cover/$oldProjectCoverImageFileName');
        await projectCoverImageStorageRef.delete();
      } catch (e) {}

      final projectCoverImageLink =
          await projectCoverImageStorageRef.getDownloadURL();
      await updateProjectCoverImageLink(
          projectCoverImageLink, projectCoverImageFileName);
      await updateCoverImageDominantColor(projectCoverImageLink);
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteProjectCoverImage() async {
    final projectRef = FirebaseFirestore.instance
        .collection('workspace')
        .doc(workspaceId.value)
        .collection('project')
        .doc(projectId.value)
        .withConverter(
            fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
            toFirestore: (Project project, _) => project.toJson());

    final projectSnapshot = await projectRef.get();
    final Project project = projectSnapshot.data()!;

    final personalize = project.personalize;
    final projectCoverImageFileName = personalize['image'] as String;
    final projectCoverImageStorageRef = FirebaseStorage.instance.ref().child(
        'user/public/projects/project_$projectId/cover/$projectCoverImageFileName');

    await projectCoverImageStorageRef.delete();
    personalize['image'] = '';
    final updateProject = await projectRef.update({'personalize': personalize});

    // Set image to ''
    updateProjectUseImage(false);
  }
}
