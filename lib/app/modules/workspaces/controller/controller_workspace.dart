import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_user_workspace.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkspaceController extends GetxController {
  final User? user = FirebaseAuth.instance.currentUser;
  // List<UserWorkspace> userWorkspaces = [].obs as List<UserWorkspace>;

  void logOutWithGoogle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    FirebaseAuth.instance.signOut();

    await prefs.remove('userId');
  }

  Future<String> getWorkspaceName(DocumentReference<Workspace> docs) async {
    final name = await docs.get().then((value) => value.data()!.name);
    return name.toString();
  }

  Future<List<DocumentReference<Workspace>>> fetchWorkspaces() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.get('userId');
    final userWorkspaceRef = FirebaseFirestore.instance
        .collection('user_workspace')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                UserWorkspace.fromJson(snapshot.data()!),
            toFirestore: (UserWorkspace userWorkspace, _) =>
                userWorkspace.toJson());

    final workspaceRef = FirebaseFirestore.instance
        .collection('workspace')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Workspace.fromJson(snapshot.data()!),
            toFirestore: (Workspace workspace, _) => workspace.toJson());
    // Mendapatkan List Berupa UserWorkspace milik User login
    final List<QueryDocumentSnapshot<UserWorkspace>> listUserWorkspaces =
        await userWorkspaceRef
            .where('user_id', isEqualTo: userId)
            .get()
            .then((value) => value.docs);

    final List<DocumentReference<Workspace>> listWorkspace = [];
    await Future.wait(listUserWorkspaces.map((element) async {
      final workspaceId = element.data().workspaceId;
      final workspace = workspaceRef.doc(workspaceId);

      listWorkspace.add(workspace);
    }));
    return listWorkspace;
  }

  // Fungsi untuk menghasilkan list project dengan parameter satu buah Workspace
  Future<List<QueryDocumentSnapshot<Project>>> fetchProjects(
      DocumentReference<Workspace> workspace) async {
    final projectRef = workspace.collection('project').withConverter(
        fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
        toFirestore: (Project project, _) => project.toJson());

    final List<QueryDocumentSnapshot<Project>> listProject =
        await projectRef.get().then((value) => value.docs);

    return listProject;
  }
}
