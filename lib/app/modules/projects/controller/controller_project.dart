import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_color_theme.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_activity.dart';
import 'package:aray/app/modules/projects/controller/crud_controller_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProjectAnimationController extends GetxController {
  final Rx<Color> colorTheme = const Color(0x00000000).obs;
  final Rx<Color> cardColor =
      const Color.fromRGBO(241, 239, 239, 1).withOpacity(0.95).obs;

  final isCardNameEditing = true.obs;
  set colorTheme(value) => colorTheme.value = value;
  set isCardNameEditing(value) => isCardNameEditing.value = value;

  Color getColorTheme(Project project) {
    final bool isUseImage = project.personalize['use_image'] as bool;
    if (isUseImage) {
      final int projectCoverImageDominantColorDecimal =
          project.personalize['image_dominant_color'] ?? 0;
      final Color projectCoverImageDominantColor =
          Color(0xFFFFFFFF & projectCoverImageDominantColorDecimal);
      return projectCoverImageDominantColor;
    } else {
      final projectColor = project.personalize['color'];
      final projectTheme = ColorTheme(code: projectColor);
      return Color(projectTheme.primaryColor!);
    }
  }
}

class ProjectController extends GetxController {
  final args = <String, dynamic>{}.obs;
  set args(value) => args.value = value;

  final RxString cardPath = ''.obs;
  final RxString activityPath = ''.obs;

  String projectId() => args['project_id'] ?? "";
  String workspaceId() => args['workspace_id'] ?? "";
  Project projectDump() => args['project'];

  Map<String, String> activitiesPath = {};

  // Stream 1 project
  DocumentReference<Project> projectRef() => FirebaseFirestore.instance
      .collection('workspace')
      .doc(workspaceId())
      .collection('project')
      .doc(projectId())
      .withConverter(
          fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
          toFirestore: (Project project, _) => project.toJson());

  CollectionReference<CardModel> cardsRef() => FirebaseFirestore.instance
      .collection('workspace')
      .doc(workspaceId())
      .collection('project')
      .doc(projectId())
      .collection('card')
      .withConverter(
          fromFirestore: (snapshot, _) => CardModel.fromJson(snapshot.data()!),
          toFirestore: (CardModel card, _) => card.toJson());

  // Stream one project
  Stream<DocumentSnapshot<Project>> streamProject() async* {
    final Stream<DocumentSnapshot<Project>> project = projectRef().snapshots();
    yield* project;
  }

  // Stream semua card
  Stream<QuerySnapshot<CardModel>> streamCards() async* {
    final Stream<QuerySnapshot<CardModel>> cards =
        cardsRef().orderBy('order').snapshots();
    cardPath.value = cardsRef().path;
    yield* cards;
  }

  // Stream Activities dengan parameter satu card
  Stream<QuerySnapshot<Activity>> streamActivities(String cardId) async* {
    final activityRef = FirebaseFirestore.instance
        .collection(cardPath.value)
        .doc(cardId)
        .collection('activity')
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());
    final Stream<QuerySnapshot<Activity>> listActivity =
        activityRef.orderBy('order').snapshots();
    activityPath.value = activityRef.path;
    yield* listActivity;
  }

  // Stream Activity with id card and id Activity
  Stream<DocumentSnapshot<Activity>> streamActivity(
      String cardId, String activityId) async* {
    final activityRef = FirebaseFirestore.instance
        .collection(cardPath.value)
        .doc(cardId)
        .collection('activity')
        .doc(activityId)
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());
    final activity = activityRef.snapshots();
    yield* activity;
  }

  // Reorder Activity
  Future<void> reorderActivity(
      String cardId,
      List<QueryDocumentSnapshot<Activity>> activitiesSnapshot,
      int oldIndex,
      int newIndex) async {
    final activityRef = FirebaseFirestore.instance
        .collection(cardPath.value)
        .doc(cardId)
        .collection('activity')
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());

    final documents = activitiesSnapshot;
    if (oldIndex < newIndex) {
      for (int i = oldIndex; i < newIndex && i < documents.length - 1; i++) {
        final previousItem = documents[i];
        final item = documents[i + 1];
        activityRef.doc(item.id).update({'order': i});
        activityRef.doc(previousItem.id).update({'order': i + 1});
      }
    } else {
      for (int i = oldIndex; i > newIndex; i--) {
        final previousItem = documents[i];
        final item = documents[i - 1];
        activityRef.doc(item.id).update({'order': i});
        activityRef.doc(previousItem.id).update({'order': i - 1});
      }
    }
  }

  // Add New Activity
  Future<void> addNewActivity(String cardId, String activityName) async {
    final CollectionReference<Activity> activitiesRef = cardsRef()
        .doc(cardId)
        .collection('activity')
        .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (Activity activity, _) => activity.toJson());

    // Get the total of Activity
    final activitiesSnapshot = await activitiesRef.get();
    final activitiesLength = activitiesSnapshot.docs.length;
    final Activity activity =
        Activity.withoutTimestamp(name: activityName, order: activitiesLength);
    await ActivityCRUDController.addNew(activitiesRef, activity);
  }

  // Add New Card
  Future<void> addNewCard(String cardName) async {
    final cardsSnapshot = await cardsRef().get();
    final cardsLength = cardsSnapshot.docs.length;
    final CardModel card = CardModel(
        name: cardName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        order: cardsLength);
    await CardCRUDController.addNew(cardsRef(), card);
  }

  Future<void> updateCardName(String cardId, String cardName) async {
    final reference = cardsRef().doc(cardId);
    await CardCRUDController.update(reference, cardName);
  }

  Future<void> deleteCard(String cardId) async {
    final reference = cardsRef().doc(cardId);
    await CardCRUDController.delete(reference);
  }

  Future<void> reorderCard(
      List<QueryDocumentSnapshot<CardModel>> cardsQuerySnapshot,
      int oldIndex,
      int newIndex) async {
    final documents = cardsQuerySnapshot;
    if (oldIndex < newIndex) {
      for (int i = oldIndex; i < newIndex && i < documents.length - 1; i++) {
        final previousItem = documents[i];
        final item = documents[i + 1];
        cardsRef().doc(item.id).update({'order': i});
        cardsRef().doc(previousItem.id).update({'order': i + 1});
      }
    } else {
      for (int i = oldIndex; i > newIndex; i--) {
        final previousItem = documents[i];
        final item = documents[i - 1];
        cardsRef().doc(item.id).update({'order': i});
        cardsRef().doc(previousItem.id).update({'order': i - 1});
      }
    }
  }
}
