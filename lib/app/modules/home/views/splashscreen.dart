import 'package:aray/app/modules/home/controller/controller_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Ini adalah Splashscreen"),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
