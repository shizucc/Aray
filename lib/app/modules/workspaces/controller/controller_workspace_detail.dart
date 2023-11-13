import 'package:aray/app/data/model/model_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class WorkspaceDetailController extends GetxController {
  Stream<DocumentSnapshot<Workspace>> streamWorkspace(String id) async* {
    final workspaceRef = FirebaseFirestore.instance
        .collection('workspace')
        .doc(id)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Workspace.fromJson(snapshot.data()!),
            toFirestore: (Workspace workspace, _) => workspace.toJson());

    final workspace = workspaceRef.snapshots();
    yield* workspace;
  }
}
