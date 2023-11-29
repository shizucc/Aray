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
              const Spacer(),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: Image.asset('assets/app_image/login_image.png')),
              const Gap(30),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: Get.width / 1.5),
                  child: Text(
                    "Manage Your Projects More Easily & More Clean",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 18,
                        letterSpacing: 1),
                  )),
              const Gap(50),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Get.width / 1.5),
                child: LoginButtonIcon(
                    backgroundColor: const Color(0xffD85AC3),
                    label: "Login With Google",
                    imageIcon: Image.asset(
                      'assets/app_icon/google_icon.png',
                      height: 18,
                      width: 18,
                    ),
                    labelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    onTap: () async {
                      await controller.signInWithGoogle();
                    }),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/app_icon/aray_icon.png",
                    height: 17,
                    width: 17,
                  ),
                  const Gap(5),
                  const Text(
                    "Aray[Project]",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
