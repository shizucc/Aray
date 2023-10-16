import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _obj = ''.obs;
  set obj(value) => this._obj.value = value;
  get obj => this._obj.value;

  void countdown() async {
    const int duration = 3;
    Timer(Duration(seconds: duration), () {
      print("Berpindah Page");

      Stream<User?> authStatus = FirebaseAuth.instance.authStateChanges();
    });
  }
}
