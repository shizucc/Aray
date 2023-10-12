import 'package:aray/app/data/model/model_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  // Fungsi untuk login by gogle
  void signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    checkUser(userCredential);
  }

  // Fungsi untuk mengecek User sudah terdaftar atau belum (jika belum masukan ke database)
  Future<void> checkUser(UserCredential userCredential) async {
    final userRef = FirebaseFirestore.instance.collection('user').withConverter(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson());

    var username = await userRef
        .where('username', isEqualTo: userCredential.user?.displayName)
        .where('email', isEqualTo: userCredential.user?.email)
        .get();

    if (username.docs.isNotEmpty) {
      print(username.docs.first.data().email);
    } else {
      userRef
          .add(UserModel(
              email: userCredential.user?.email,
              username: userCredential.user?.displayName))
          .then((_) {});
    }
  }
}
