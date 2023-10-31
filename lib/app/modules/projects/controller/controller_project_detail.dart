import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProjectDetailController extends GetxController {
  final workspace = Workspace(name: '').obs;

  String dateFormating(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'en_US');
    DateFormat timeFormat = DateFormat('HH.mm');
    String date = dateFormat.format(dateTime);
    String time = timeFormat.format(dateTime);
    return '$date at $time';
  }

  Stream<DocumentSnapshot<Project>> streamProject(
      String workspaceId, String projectId) async* {
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
}
