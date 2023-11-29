import 'package:aray/app/global_widgets/my_text_button_icon.dart';
import 'package:aray/app/modules/auth/controller/controller_login_page.dart';
import 'package:aray/app/modules/auth/widgets/login_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController());
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Placeholder(
                fallbackHeight: 150,
                fallbackWidth: 10,
              ),
              Gap(40),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: Get.width / 1.5),
                  child: Text(
                    "Manage Your Projects More Easily & More Clean",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 18,
                        letterSpacing: 1),
                  )),
              Gap(50),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Get.width / 1.5),
                child: LoginButtonIcon(
                    backgroundColor: Colors.purpleAccent,
                    label: "Login With Google",
                    icon: Icon(
                      Icons.abc,
                      color: Colors.white,
                    ),
                    labelTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    onTap: () async {
                      await controller.signInWithGoogle();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
