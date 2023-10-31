import 'package:aray/app/data/model/model_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProjectAnimationController extends GetxController {
  Stream<DocumentSnapshot<Project>> streamProject(
      String workspaceId, String projectId) async* {
    print('hehe');
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
