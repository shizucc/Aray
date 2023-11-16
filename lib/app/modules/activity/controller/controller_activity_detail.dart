import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ActivityDetailAnimationController extends GetxController {
  // final List<TextEditingController> [].obs;
}

class ActivityDetailController extends GetxController {
  final args = <String, dynamic>{}.obs;
  set args(value) => args.value = value;

  String cardPath() => args["card_path"] as String;
  String cardId() => args["card_id"] as String;
  String activityId() => args["activity_id"] as String;

  Stream<DocumentSnapshot<Activity>> streamActivity() async* {
    final activityId = this.activityId();

    final activityRef = FirebaseFirestore.instance
        .collection(cardPath())
        .doc(cardId())
        .collection('activity')
        .doc(activityId)
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());
    final Stream<DocumentSnapshot<Activity>> activity = activityRef.snapshots();

    yield* activity;
  }

  Stream<QuerySnapshot<Checklist>> streamChecklist() async* {
    final activityId = this.activityId();
    final checklistRef = FirebaseFirestore.instance
        .collection(cardPath())
        .doc(cardId())
        .collection('activity')
        .doc(activityId)
        .collection('checklist')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Checklist.fromJson(snapshot.data()!),
            toFirestore: (Checklist checklist, _) => checklist.toJson());

    final Stream<QuerySnapshot<Checklist>> checklist = checklistRef.snapshots();
    yield* checklist;
  }
}
