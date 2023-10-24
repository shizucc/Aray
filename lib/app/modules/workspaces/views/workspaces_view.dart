import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/workspaces/controller/controller_workspace.dart';
import 'package:aray/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
        leading: const Icon(Icons.menu),
        title: const Text("Projects"),
        actions: [
          IconButton(
              onPressed: () => controller.logOutWithGoogle(),
              icon: const Icon(Icons.power))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: FutureBuilder<List<DocumentReference<Workspace>>>(
          future: controller.fetchWorkspaces(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("Tidak ada data.");
            } else {
              final workspaces = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
                        final projects = controller.fetchProjects(workspace);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.chevron_up,
                                  size: 25,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    workspaceName.toString(),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Icon(CupertinoIcons.ellipsis)
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<List<QueryDocumentSnapshot<Project>>>(
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
                                      return ProjectTile(
                                          title: project.data().name,
                                          image: project
                                              .data()
                                              .personalize['image'],
                                          onTap: () {
                                            Get.toNamed(Routes.PROJECT,
                                                arguments: {
                                                  "workspace": workspace,
                                                  "project": project
                                                });
                                          });
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 10)
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
    );
  }
}

class ProjectTile extends StatelessWidget {
  final Function onTap;
  final String image;
  final String title;

  const ProjectTile({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 7),
        width: Get.width,
        child: Row(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.alarm)),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            )),
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: const Icon(CupertinoIcons.forward)),
          ],
        ),
      ),
    );
  }
}
