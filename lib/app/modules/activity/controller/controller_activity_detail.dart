import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_checklist.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_activity.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityDetailAnimationController extends GetxController {
  final RxList<TextEditingController> checklistTextEditingControllers =
      <TextEditingController>[].obs;
  final RxList<bool> isEditingCheckList = <bool>[].obs;

  final isEditingProjectName = false.obs;
  final isEditingProjectDescription = false.obs;
  final isEditingProjectStartTime = false.obs;
  final isEditingProjectDueDate = false.obs;

  set isEditingProjectName(value) => isEditingProjectName.value = value;
  set isEditingProjectDescription(value) =>
      isEditingProjectDescription.value = value;
  set isEditingProjectStartTime(value) =>
      isEditingProjectStartTime.value = value;
  set isEditingProjectDueDate(value) => isEditingProjectDueDate.value = value;

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

  String cardPath() => args["card_path"] as String;
  String cardId() => args["card_id"] as String;
  String activityId() => args["activity_id"] as String;

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
}
