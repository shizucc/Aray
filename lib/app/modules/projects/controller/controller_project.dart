import 'package:aray/app/data/model/model_user_workspace.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectController extends GetxController {
  final User? user = FirebaseAuth.instance.currentUser;

  final _obj = ''.obs;
  set obj(value) => this._obj.value = value;
  get obj => this._obj.value;

  void logOutWithGoogle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    FirebaseAuth.instance.signOut();

    await prefs.remove('userId');
  }

  // Logika untuk menampilkan project dari workspace tertentu
  Future<void> fetchDataProject() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.get('userId');
    // Init the workspaces id
    List<UserWorkspace> userWorkspaces = [];

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
        UserWorkspace userWorkspace = element.data();
        userWorkspaces.add(userWorkspace);
        // print(userWorkspace);
      }
    });
    print(userWorkspaces);
  }
}
