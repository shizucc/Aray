import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/modules/activity/controller/controller_activity_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ActivityDetailController());
    c.args = Get.arguments;
    return Scaffold(
        body: StreamBuilder(
      stream: c.streamActivity(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final activitySnapshot = snapshot.data!;
        final Activity activity = activitySnapshot.data()!;
        return Text("data");
      },
    ));
  }
}
