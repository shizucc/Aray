import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  final args = <String, dynamic>{}.obs;
  set args(value) => args.value = value;
  QueryDocumentSnapshot<Activity> getActivity() {
    return args["activity"];
  }

  String getPath() {
    return args["activity_path"];
  }

  Stream<DocumentSnapshot<Activity>> streamActivity() async* {
    final activityPath = getPath();
    final activityId = getActivity().id;
    final activityRef = FirebaseFirestore.instance
        .collection(activityPath)
        .doc(activityId)
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());
    final Stream<DocumentSnapshot<Activity>> activity = activityRef.snapshots();
    yield* activity;
  }

  Stream<QuerySnapshot<Checklist>> streamChecklist() async* {
    final activityPath = getPath();
    final activityId = getActivity().id;
    final checklistRef = FirebaseFirestore.instance
        .collection(activityPath)
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
