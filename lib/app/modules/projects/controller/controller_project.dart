import 'package:aray/app/data/model/model_user_workspace.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectController extends GetxController {
  final User? user = FirebaseAuth.instance.currentUser;
  // List<UserWorkspace> userWorkspaces = [].obs as List<UserWorkspace>;

  void logOutWithGoogle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    FirebaseAuth.instance.signOut();

    await prefs.remove('userId');
  }

  Future<CollectionReference> fetchDataWorkspaces() async =>
      FirebaseFirestore.instance.collection('workspace');

  // Logika untuk menampilkan project dari workspace tertentu
  Future<List<DocumentReference>> fetchDataWorkspace() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.get('userId');
    // Init the workspaces id
    List<DocumentSnapshot<UserWorkspace>> userWorkspaces = [];
    // List<DocumentReference<UserWorkspace>> userWorkspacesReference = [];
    // Loop di firestore untuk mencari workspace id milik user
    final workspaceRef = FirebaseFirestore.instance
        .collection('user_workspace')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                UserWorkspace.fromJson(snapshot.data()!),
            toFirestore: (UserWorkspace userWorkspace, _) =>
                userWorkspace.toJson());

    await workspaceRef.where('user_id', isEqualTo: userId).get().then((value) {
      for (var element in value.docs) {
        DocumentSnapshot<UserWorkspace> userWorkspace = element;
        userWorkspaces.add(userWorkspace);
        // print(userWorkspace.id);
      }
    });
    // this.userWorkspaces = userWorkspaces;
    // Loping collection workspace untuk dapet workspace dengan id tertentu
    List<DocumentReference> workspaces = [];
    await Future.forEach(userWorkspaces, (userWorkspace) async {
      final UserWorkspace? workspaceId = userWorkspace.data();
      final workspace = FirebaseFirestore.instance
          .collection('workspace')
          .doc(workspaceId?.workspaceId);

      // workspaces.add(await workspace.get());
      workspaces.add(workspace);
    });

    return workspaces;

    // for (DocumentReference workspaceRef in workspaces) {
    //   QuerySnapshot projectSnapshot =
    //       await workspaceRef.collection('project').get();
    //   for (var projectDoc in projectSnapshot.docs) {
    //     // Lakukan sesuatu dengan data proyek
    //     var projectData = projectDoc.data();
    //     // print(projectData);
    //   }
    // }
    // print(workspaces.first.collection('project').get());
    // var myProjectRef =
    //     workspaces.first.collection('project').get().then((value) {
    //   print(value.docs.first.data());
    // });
  }

  Future<void> fetchDataProject() async {}
}
