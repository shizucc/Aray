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
    final workspaceRef = FirebaseFirestore.instance
        .collection('workspace')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Workspace.fromJson(snapshot.data()!),
            toFirestore: (Workspace workspace, _) => workspace.toJson());

    var projects = await workspaceRef.get();
    var members = projects.docs.first.data();
    // print(members.members.first['user']);
    getUserByWorkspace("aSn6COQKq3fQnxCSLGtG");

    // var user = members['user'];
    // print(user);
    // DocumentReference<Map<String, dynamic>> userSnapshot =
    //     await FirebaseFirestore.instance.doc(user);
  }

  Future<void> getUserByWorkspace(String workspaceId) async {
    try {
      // Mengakses koleksi "workspace" pada Firestore
      DocumentSnapshot workspaceDoc = await FirebaseFirestore.instance
          .collection('workspace')
          .doc(workspaceId)
          .get();

      if (workspaceDoc.exists) {
        // Mengambil data "member" dari dokumen workspace
        dynamic membersDump = workspaceDoc.data();
        List<dynamic> members = membersDump['member'];

        for (var member in members) {
          // Memberikan perhatian terhadap role yang sesuai (creator, co-creator)
          if (member['role'] == 'creator' || member['role'] == 'co-creator') {
            // Mendapatkan ID pengguna dari referensi Firestore
            String userId = member['user'].split('/')[1];

            // Mengakses koleksi "user" pada Firestore untuk mendapatkan data pengguna
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('user')
                .doc(userId)
                .get();

            if (userDoc.exists) {
              // Data pengguna berhasil ditemukan
              var userData = userDoc.data();
              print(userData);
            } else {
              print('Pengguna tidak ditemukan');
            }
          }
        }
      } else {
        print('Workspace tidak ditemukan');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

// Panggil fungsi untuk mencari data pengguna berdasarkan workspace
}
