import 'package:aray/app/data/model/model_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProjectDetailController extends GetxController {
  final _obj = ''.obs;
  set obj(value) => this._obj.value = value;
  get obj => this._obj.value;

  String dateFormating(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'en_US');
    DateFormat timeFormat = DateFormat('HH.mm');
    String date = dateFormat.format(dateTime);
    String time = timeFormat.format(dateTime);
    return '$date at $time';
  }

  Stream<DocumentSnapshot<Project>> streamProject(
      String workspaceId, String projectId) async* {
    final projectRef = FirebaseFirestore.instance
        .collection('workspace')
        .doc(workspaceId)
        .collection('project')
        .doc(projectId)
        .withConverter(
            fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
            toFirestore: (Project project, _) => project.toJson());

    final Stream<DocumentSnapshot<Project>> project = projectRef.snapshots();
    yield* project;
  }
}
