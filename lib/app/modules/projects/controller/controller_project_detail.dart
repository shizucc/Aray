import 'dart:async';
import 'dart:io';

import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/controller_project.dart';
import 'package:aray/app/modules/projects/controller/crud_controller_card.dart';
import 'package:aray/app/modules/projects/controller/crud_controller_project.dart';

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
  final args = <String, dynamic>{}.obs;
  final workspace = Workspace(name: '').obs;
  final projectDump = Project(
          name: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          personalize: {},
          order: 1)
      .obs;

  set args(value) => args.value = value;

  String projectId() => args['projectId'] ?? "";
  String workspaceId() => args['workspaceId'] ?? "";

  DocumentReference<Workspace> workspaceRef() => FirebaseFirestore.instance
      .collection('workspace')
      .doc(workspaceId())
      .withConverter(
          fromFirestore: (snapshot, _) => Workspace.fromJson(snapshot.data()!),
          toFirestore: (Workspace workspace, _) => workspace.toJson());

  DocumentReference<Project> projectRef() =>
      workspaceRef().collection('project').doc(projectId()).withConverter(
          fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
          toFirestore: (Project project, _) => project.toJson());

  CollectionReference<CardModel> cardsRef() =>
      projectRef().collection('card').withConverter(
          fromFirestore: (snapshot, _) => CardModel.fromJson(snapshot.data()!),
          toFirestore: (CardModel card, _) => card.toJson());

  CollectionReference<Activity> activitiesRef(String cardId) =>
      cardsRef().doc(cardId).collection('activity').withConverter(
          fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
          toFirestore: (Activity activity, _) => activity.toJson());

  Future<void> updateCoverImageDominantColor(
      String projectCoverImageUrl) async {
    // Generate Image Dominant Color
    final palleteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(projectCoverImageUrl));
    final projectCoverImageDominantColor =
        palleteGenerator.dominantColor!.color;

    final projectData = await projectRef().get();
    final personalize = projectData.data()!.personalize;

    personalize['image_dominant_color'] = projectCoverImageDominantColor.value;
    final updateProject =
        await projectRef().update({'personalize': personalize});
    // return myColor;
  }

  Future<void> updateProjectCoverImageLink(
      String projectCoverImageLink, String projectCoverImageFileName) async {
    final projectData = await projectRef().get();
    final personalize = projectData.data()!.personalize;
    personalize['image'] = projectCoverImageFileName;
    personalize['image_link'] = projectCoverImageLink;
    final updateProject =
        await projectRef().update({'personalize': personalize});
  }

  Future<void> refreshProjectUpdatedAt() async {
    await projectRef()
        .update({'updated_at': Timestamp.fromDate(DateTime.now())});
  }

  Stream<DocumentSnapshot<Project>> streamProject() async* {
    // set Workspace

    final workspace = await workspaceRef().get();
    this.workspace.value = workspace.data()!;

    final Stream<DocumentSnapshot<Project>> project = projectRef().snapshots();

    yield* project;
  }

  Future<void> updateProjectFromTextField(
      String field, TextEditingController textEditingController) async {
    final Map<String, String> fields = {
      'name': 'name',
      'description': 'description'
    };
    final value = textEditingController.text;

    await projectRef().update({fields[field].toString(): value}).then((value) {
      refreshProjectUpdatedAt();
    });
  }

  Future<void> updateProjectPersonalizeColor(String colorCode) async {
    final projectData = await projectRef().get();
    final personalize = projectData.data()!.personalize;
    personalize['color'] = colorCode;

    // update
    final updateProject =
        await projectRef().update({'personalize': personalize});
  }

  Future<void> updateProjectImageDominantColor(int colorDecimal) async {
    final projectData = await projectRef().get();
    final personalize = projectData.data()!.personalize;

    personalize['image_dominant_color'] = colorDecimal;
    final updateProject =
        await projectRef().update({'personalize': personalize});
  }

  Future<void> updateProjectUseImage(bool isUseImage) async {
    final projectData = await projectRef().get();
    final personalize = projectData.data()!.personalize;

    personalize['use_image'] = isUseImage;
    final updateProject =
        await projectRef().update({'personalize': personalize});
  }

  Future<bool> updateProjectCoverImage(
      Project project, File projectCoverImageFile) async {
    String projectCoverImageFileName =
        Timestamp.now().toString() + projectCoverImageFile.path.split('/').last;
    final projectCoverImageStorageRef = FirebaseStorage.instance.ref().child(
        'user/public/projects/project_${projectId()}/cover/$projectCoverImageFileName');

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
            'user/public/projects/project_${projectId()}/cover/$oldProjectCoverImageFileName');
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
    final projectSnapshot = await projectRef().get();
    final Project project = projectSnapshot.data()!;

    final personalize = project.personalize;
    final projectCoverImageFileName = personalize['image'] as String;
    final projectCoverImageStorageRef = FirebaseStorage.instance.ref().child(
        'user/public/projects/project_${projectId()}/cover/$projectCoverImageFileName');

    await projectCoverImageStorageRef.delete();
    personalize['image'] = '';
    final updateProject =
        await projectRef().update({'personalize': personalize});

    // Set image to ''
    updateProjectUseImage(false);
  }

  Future<void> deleteProject() async {
    // Delete Project Cover
    try {
      await deleteProjectCoverImage();
    } catch (e) {}
    // Saatnya menyelam
    final cardsSnapshot = await cardsRef().get();
    final cardsDocumentSnapshot = cardsSnapshot.docs;

    // Menyelam Card
    List<String> cardsId = [];
    for (var cardSnapshot in cardsDocumentSnapshot) {
      final cardId = cardSnapshot.id;
      cardsId.add(cardId);
    }

    // Menyelam activity
    for (var cardId in cardsId) {
      try {
        List<Reference> activitiesStorageRef = [];
        final activitiesSnapshot = await activitiesRef(cardId).get();
        final activitiesDocumentSnaphsot = activitiesSnapshot.docs;
        for (var activitySnapshot in activitiesDocumentSnaphsot) {
          // Generate the activity storageref
          final activityId = activitySnapshot.id;
          final Reference ref = FirebaseStorage.instance.ref().child(
              'user/public/projects/project_${projectId()}/activity_$activityId');
          activitiesStorageRef.add(ref);
        }

        final reference = cardsRef().doc(cardId);
        await CardCRUDController.delete(reference, activitiesStorageRef);
      } catch (e) {}
    }
    await ProjectCRUDController.delete(projectRef());
  }
}
