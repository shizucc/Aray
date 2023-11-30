import 'dart:io';

import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_checklist.dart';
import 'package:aray/app/data/model/model_file.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_activity.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_activity_cover.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_activity_file.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_checklist.dart';
import 'package:aray/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ActivityDetailAnimationController extends GetxController {
  final RxList<TextEditingController> checklistTextEditingControllers =
      <TextEditingController>[].obs;
  final RxList<bool> isEditingCheckList = <bool>[].obs;
  final Rx<DateTimeRange> selectedDateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  ).obs;
  final Rx<Color> colorThemeActivity = const Color(0x00000000).obs;

  // Variabel for handling Activiy Files

  final isEditingProjectName = false.obs;
  final isEditingProjectDescription = false.obs;
  final isEditingProjectStartTime = false.obs;
  final isEditingProjectDueDate = false.obs;
  final isProjectTimeStampFinished = false.obs;

  set isEditingProjectName(value) => isEditingProjectName.value = value;
  set isEditingProjectDescription(value) =>
      isEditingProjectDescription.value = value;
  set isEditingProjectStartTime(value) =>
      isEditingProjectStartTime.value = value;
  set isEditingProjectDueDate(value) => isEditingProjectDueDate.value = value;

  set isProjectTimeStampFinished(value) =>
      isProjectTimeStampFinished.value = value;
  set selectedDateTimeRange(value) => selectedDateTimeRange.value = value;

  void setColorThemeActivity(Color value) {
    if (value.isDark) {
      colorThemeActivity.value = value;
    } else {
      final darkenColor = value.darken(0.2);
      colorThemeActivity.value = darkenColor;
    }
  }

  final TextEditingController activityNameController = TextEditingController();
  final TextEditingController activityDescriptionController =
      TextEditingController();

  void initCheckList() {
    checklistTextEditingControllers.add(TextEditingController());
    isEditingCheckList.add(false);
  }

  TextEditingController getChecklistTextController(int index) {
    return checklistTextEditingControllers[index];
  }

  bool getIsEditingChecklist(int index) {
    return isEditingCheckList[index];
  }

  void switchIsEditingChecklist(int index, bool isEditing) {
    isEditingCheckList[index] = isEditing;
  }

  @override
  void onClose() {
    for (var controller in checklistTextEditingControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}

class ActivityDetailController extends GetxController {
  final args = <String, dynamic>{}.obs;
  set args(value) => args.value = value;

  final RxList<File> activityFiles = <File>[].obs;
  final isActivityFilesUploadingProgress = false.obs;
  final isActivityCoverUploadingProgress = false.obs;

  String cardPath() => args["card_path"] as String;
  String cardId() => args["card_id"] as String;
  String activityId() => args["activity_id"] as String;
  String projectId() => args["project_id"] as String;
  Color colorTheme() => args["color_theme"] as Color;

  set isActivityFilesUploadingProgress(value) =>
      isActivityFilesUploadingProgress.value = value;
  set isActivityCoverUploadingProgress(value) =>
      isActivityCoverUploadingProgress.value = value;

  CollectionReference<Checklist> checklistRef() => FirebaseFirestore.instance
      .collection(cardPath())
      .doc(cardId())
      .collection('activity')
      .doc(activityId())
      .collection('checklist')
      .withConverter(
          fromFirestore: (snapshot, _) => Checklist.fromJson(snapshot.data()!),
          toFirestore: (Checklist checklist, _) => checklist.toJson());

  DocumentReference<Activity> activityRef() => FirebaseFirestore.instance
      .collection(cardPath())
      .doc(cardId())
      .collection('activity')
      .doc(activityId())
      .withConverter(
          fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
          toFirestore: (Activity activity, _) => activity.toJson());

  CollectionReference<FileModel> activityFileRef() => FirebaseFirestore.instance
      .collection(cardPath())
      .doc(cardId())
      .collection('activity')
      .doc(activityId())
      .collection('file')
      .withConverter(
          fromFirestore: (snapshot, _) => FileModel.fromJson(snapshot.data()!),
          toFirestore: (FileModel file, _) => file.toJson());

  Reference activityStorageRef() => FirebaseStorage.instance.ref().child(
      'user/public/projects/project_${projectId()}/activity_${activityId()}');

  // Get Card Data
  Future<CardModel> getCard() async {
    final cardRef = FirebaseFirestore.instance
        .collection(cardPath())
        .doc(cardId())
        .withConverter(
            fromFirestore: (snapshot, _) =>
                CardModel.fromJson(snapshot.data()!),
            toFirestore: (CardModel card, _) => card.toJson());
    final cardSnaphsot = await cardRef.get();
    final CardModel card = cardSnaphsot.data()!;
    return card;
  }

  Future<void> openFilePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      activityFiles.value = files;
    } else {
      // User canceled the picker
    }
  }

  Future<XFile?> openImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  // Operation for Checklist
  Stream<QuerySnapshot<Checklist>> streamChecklist() async* {
    final Stream<QuerySnapshot<Checklist>> checklist =
        checklistRef().orderBy('created_at').snapshots();
    yield* checklist;
  }

  Future<void> updateChecklistStatus(String id, bool value) async {
    await ChecklistCRUDController.updateStatus(checklistRef(), id, value);
  }

  Future<void> updateCheckListName(String id, String name) async {
    await ChecklistCRUDController.updateName(checklistRef(), id, name);
  }

  Future<void> addNewChecklist() async {
    await ChecklistCRUDController.addNew(checklistRef());
  }

  Future<void> deleteChecklist(String id) async {
    await ChecklistCRUDController.delete(checklistRef(), id);
  }

  // Operations for Activity
  Stream<DocumentSnapshot<Activity>> streamActivity() async* {
    final Stream<DocumentSnapshot<Activity>> activity =
        activityRef().snapshots();
    yield* activity;
  }

  Future<void> updateActivityTextField(String field, String value) async {
    switch (field) {
      case 'name':
        ActivityCRUDController.updateName(activityRef(), value);
        break;
      case 'description':
        ActivityCRUDController.updateDescription(activityRef(), value);
      default:
    }
  }

  Future<void> updateActivityTimeStamp(DateTimeRange dateTimeRange) async {
    ActivityCRUDController.updateTimeStamp(activityRef(), dateTimeRange);
  }

  Future<void> deleteActivityComplete() async {
    ActivityCRUDController.delete(activityRef(), activityStorageRef());
  }

  // Operation for Activity Cover
  Future<void> uploadActivityCover(XFile file) async {
    final Reference activityCoverStorageRef =
        activityStorageRef().child('/cover/');

    final File coverFile = File(file.path);
    isActivityCoverUploadingProgress.value = true;
    await ActivityCoverCRUDController.uploadCover(
        activityRef(), activityCoverStorageRef, coverFile);
    isActivityCoverUploadingProgress.value = false;
  }

  Future<void> deleteActivityCover(
    Activity activity,
  ) async {
    final String coverName = activity.coverName;
    final Reference activityCoverStorageRef =
        activityStorageRef().child('/cover/$coverName');
    await ActivityCoverCRUDController.deleteCover(
        activityRef(), activityCoverStorageRef);
  }

  // Operations for File

  // Stream Files
  Stream<QuerySnapshot<FileModel>> streamActivityFiles() async* {
    final Stream<QuerySnapshot<FileModel>> files =
        activityFileRef().orderBy('created_at').snapshots();
    yield* files;
  }

  // Download File from link
  Future<void> downloadActivityFile(Uri uri) async {
    await ActivityFileCRUDController.download(uri);
  }

  // Upload Files
  Future<void> uploadActivityFiles(List<File> files) async {
    if (files.isNotEmpty) {
      final Reference activityFilesStorageRef =
          activityStorageRef().child('/files/');
      isActivityFilesUploadingProgress.value = true;
      await ActivityFileCRUDController.uploadFiles(
          files, activityFileRef(), activityFilesStorageRef);
      isActivityFilesUploadingProgress.value = false;

      // if uploading complete,set the activityfiles to zero to prevent endless upload
      activityFiles.value = [];
    }
  }

  // Delete Files
  Future<void> deleteActivityFile(String id, FileModel file) async {
    final String fileName = file.name;
    final Reference activityFileStorageRef =
        activityStorageRef().child('/files/$fileName');
    await ActivityFileCRUDController.deleteFile(
        id, activityFileStorageRef, activityFileRef());
  }
}
