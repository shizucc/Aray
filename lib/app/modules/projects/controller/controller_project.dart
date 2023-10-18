import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final RxString cardPath = ''.obs;
  // Mendapatkan Semua Cards
  Future<List<QueryDocumentSnapshot<CardModel>>> fetchCards(
      QueryDocumentSnapshot projectSnapshot,
      DocumentReference<Workspace> workspaceRef) async {
    final cardRef = workspaceRef
        .collection('project')
        .doc(projectSnapshot.id)
        .collection('card')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                CardModel.fromJson(snapshot.data()!),
            toFirestore: (CardModel card, _) => card.toJson());
    final List<QueryDocumentSnapshot<CardModel>> listCard =
        await cardRef.get().then((value) => value.docs);
    cardPath.value = cardRef.path;
    return listCard;
  }

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
    final Stream<QuerySnapshot<CardModel>> listCard = cardRef.snapshots();
    cardPath.value = cardRef.path;
    yield* listCard;
  }

  // Mendapatkan Activity dengan parameter satu card
  Future<dynamic> fetchActivity(
      QueryDocumentSnapshot<CardModel> cardSnapshot) async {
    final activityRef = FirebaseFirestore.instance
        .collection(cardPath.value)
        .doc(cardSnapshot.id)
        .collection('activity')
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());
    final List<QueryDocumentSnapshot<Activity>> listActivity =
        await activityRef.get().then((value) => value.docs);
    return listActivity;
  }

  // Stream Activity dengan parameter satu card
  Stream<QuerySnapshot<Activity>> streamActivities(
      QueryDocumentSnapshot<CardModel> cardSnapshot) async* {
    print(cardPath.value);
    final activityRef = FirebaseFirestore.instance
        .collection(cardPath.value)
        .doc(cardSnapshot.id)
        .collection('activity')
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());
    final Stream<QuerySnapshot<Activity>> listActivity =
        activityRef.snapshots();
    yield* listActivity;
  }
}
