import 'package:aray/app/modules/projects/controller/controller_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Project extends StatelessWidget {
  const Project({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectController());
    controller.fetchDataWorkspace();
    return Scaffold(
      appBar: AppBar(
        title: Text("Project"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                controller.logOutWithGoogle();
              },
            ),
          ),
          FutureBuilder<List<DocumentReference<Object?>>>(
              future: controller.fetchDataWorkspace(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  final workspace = snapshot.data!;
                  workspace.forEach((element) {
                    

                    // print(element
                    //     .collection('project')
                    //     .doc()
                    //     .collection('card')
                    //     .get()
                    //     .then((value) {
                    //   print(value.docs);
                    // }));
                    // print(element.collection('project').get().then((value) {
                    //   // print(value.docs);
                    //   final dump = value.docs.first;
                    //   print(dump.data());
                    // }));

                    final dump3 = element
                        .collection('project')
                        .doc("3ClfZIJQIhiUeGW20YbE");
                    // print(element.collection('project').get().then((value) {
                    //   // print(value.docs);
                    //   final dump2 = value.docs;
                    //   dump2.forEach((element) {
                    //     print(element.data());
                    //   });
                    // }));
                  });
                  return Text("Workspace Berhasil diload");
                }
              })
          // StreamBuilder(
          //     stream: FirebaseFirestore.instance
          //         .collection('workspace')
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return CircularProgressIndicator();
          //       } else {
          //         final docs = snapshot.data?.docs;
          //         print(docs);
          //         return Text("Data distream");
          //       }
          //     })
        ],
      ),
    );
  }
}
