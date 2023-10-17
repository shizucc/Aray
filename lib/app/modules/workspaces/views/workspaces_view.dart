import 'package:aray/app/data/model/model_project.dart';
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
                  final workspaces = snapshot.data!;
                  return Column(
                    children: workspaces.map((workspace) {
                      // Mendapatkan nama workspace (ini kode ngakalin)
                      return FutureBuilder<String>(
                        future: controller.getWorkspaceName(workspace),
                        builder: (context, nameSnapshot) {
                          if (nameSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (nameSnapshot.hasError) {
                            return Text("Error: ${nameSnapshot.error}");
                          } else {
                            final workspaceName = nameSnapshot.data;
                            final projects =
                                controller.fetchProjects(workspace);
                            return Column(
                              children: [
                                Text(workspaceName.toString()),
                                FutureBuilder<
                                    List<QueryDocumentSnapshot<Project>>>(
                                  future: projects,
                                  builder: (context, projectSnapshot) {
                                    if (projectSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (projectSnapshot.hasError) {
                                      return Text(
                                          "Error: ${projectSnapshot.error}");
                                    } else if (!projectSnapshot.hasData ||
                                        projectSnapshot.data!.isEmpty) {
                                      return const Text("Invalid Name");
                                    } else {
                                      final projectList = projectSnapshot.data!;
                                      return Column(
                                        children: projectList.map((project) {
                                          return ListTile(
                                            title: Text(project.data().name),
                                            onTap: () {},
                                          );
                                        }).toList(),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }).toList(),
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
