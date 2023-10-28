import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final RxString cardPath = ''.obs;
  final RxString activityPath = ''.obs;

  Map<String, String> activitiesPath = {};

  // Stream semua card
  Stream<QuerySnapshot<CardModel>> streamCards(
      QueryDocumentSnapshot projectSnapshot,
      DocumentReference<Workspace> workspaceRef) async* {
    final cardRef = workspaceRef
        .collection('project')
        .doc(projectSnapshot.id)
        .collection('card')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                CardModel.fromJson(snapshot.data()!),
            toFirestore: (CardModel card, _) => card.toJson());
    final Stream<QuerySnapshot<CardModel>> listCard =
        cardRef.orderBy('order').snapshots();
    cardPath.value = cardRef.path;
    yield* listCard;
  }

  // Stream Activity dengan parameter satu card
  Stream<QuerySnapshot<Activity>> streamActivities(
      QueryDocumentSnapshot<CardModel> cardSnapshot) async* {
    final activityRef = FirebaseFirestore.instance
        .collection(cardPath.value)
        .doc(cardSnapshot.id)
        .collection('activity')
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());
    final Stream<QuerySnapshot<Activity>> listActivity =
        activityRef.orderBy('order').snapshots();
    activityPath.value = activityRef.path;
    yield* listActivity;
  }

  // Reorder Activity
  Future<void> reorderActivity(
      QueryDocumentSnapshot<Activity> activitySnapshot,
      QueryDocumentSnapshot<CardModel> cardSnapshot,
      int oldIndex,
      int newIndex) async {
    final activityRef = FirebaseFirestore.instance
        .collection(cardPath.value)
        .doc(cardSnapshot.id)
        .collection('activity')
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());

    final QuerySnapshot<Activity> activitiesSnapshot = await activityRef.get();
    for (var activity in activitiesSnapshot.docs) {
      // Logika untuk loop setiap aktivitas
      // activityRef.doc(activitySnapshot.id).update();
    }

    print(cardPath);
    print(activitySnapshot.id);
    print(cardSnapshot.id);
    print(oldIndex);
    print(newIndex);

    // Logika untuk Reorder
  }
}
