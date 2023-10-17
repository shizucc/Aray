import 'dart:convert';

import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/worspaces/controller/controller_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkspaceController());
    controller.fetchWorkspaces();
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
          Expanded(
            child: FutureBuilder<List<DocumentReference<Workspace>>>(
              future: controller.fetchWorkspaces(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("Tidak ada data.");
                } else {
                  // Mengambil data workspace pertama
                  final firstWorkspaceRef = snapshot.data![0];
                  return FutureBuilder(
                    future: firstWorkspaceRef.get(),
                    builder: (context, workspaceSnapshot) {
                      if (workspaceSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (workspaceSnapshot.hasError) {
                        return Text("Error: ${workspaceSnapshot.error}");
                      } else {
                        final workspaceData = workspaceSnapshot.data!;
                        final projects = firstWorkspaceRef
                            .collection('project')
                            .get()
                            .then((value) => value.docs);

                        return Column(
                          children: [
                            Text(workspaceData.data()!.name.toString()),
                            FutureBuilder(
                                future: projects,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    final project = snapshot.data!.first.data();
                                    return Text(project['name']);
                                  }
                                })
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),

          const Divider(),

          Container(
            child: Column(
              children: [
                Text("Nama Workspace"),
                Text("Project 1"),
                Text("Project 2")
              ],
            ),
          )
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
