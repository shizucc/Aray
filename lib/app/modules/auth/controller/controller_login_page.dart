import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  final _obj = ''.obs;
  set obj(value) => this._obj.value = value;
  get obj => this._obj.value;

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
  void checkUser(UserCredential userCredential) {
    if (userCredential.user?.displayName == "alfi ghozwy") {
      print("User Sudah Terdaftar");
    } else {
      print("User belum terdaftar");
    }
  }
}
