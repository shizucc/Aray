import 'package:aray/app/modules/activity/controller/controller_activity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final ActivityController controller = Get.find<ActivityController>();
    // controller.args = Get.arguments;
    // print(controller.args);
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Ini Halaman Activity"),
          ],
        ),
      ),
    );
  }
}
