import 'package:aray/app/modules/auth/controller/controller_login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Ini adalah Button untuk Login"),
            ElevatedButton(
                onPressed: () {
                  controller.signInWithGoogle();
                },
                child: Text("Login"))
          ],
        ),
      ),
    );
  }
}
