// import 'package:aray/app/data/model/model_activity.dart';
// import 'package:aray/app/data/model/model_checklist.dart';
// import 'package:aray/app/modules/activity/controller/controller_activity_detail.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ActivityView extends StatelessWidget {
//   const ActivityView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ActivityDetailController c = Get.find<ActivityDetailController>();
//     // controller.args = Get.arguments;
//     print(c.getPath());
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Activity"),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             // const Text("Ini Halaman Activity"),
//             StreamBuilder<DocumentSnapshot<Activity>>(
//                 stream: c.streamActivity(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return const Text("Something went wrong");
//                   }
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   }
//                   final activity = snapshot.data!;
//                   final activityData = activity.data()!;
//                   return Column(
//                     children: [
//                       Text(activityData.name),
//                       Text(activityData.description),
//                       Text(activityData.startTime.toString()),
//                       Text(activityData.endTime.toString()),
//                       Text(activityData.files.toString()),
//                       Text("Ini adalah data checklist"),
//                       StreamBuilder<QuerySnapshot<Checklist>>(
//                           stream: c.streamChecklist(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) {
//                               return const Text("Something went wrong");
//                             }
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const CircularProgressIndicator();
//                             }
//                             final checklist = snapshot.data!.docs;

//                             return Column(
//                               children: checklist.map((checkItem) {
//                                 final checkItemData = checkItem.data();
//                                 return ListTile(
//                                   title: Text(checkItemData.name),
//                                   subtitle:
//                                       Text(checkItemData.status.toString()),
//                                 );
//                               }).toList(),
//                             );
//                           })
//                     ],
//                   );
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }
