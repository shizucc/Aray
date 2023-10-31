import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/controller_project_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectDetail extends StatelessWidget {
  const ProjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProjectDetailController());
    final projectId = Get.arguments['projectId'];
    final workspaceId = Get.arguments['workspaceId'];
    print(workspaceId);
    print(projectId);

    TextStyle titleTextStyle = TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 13,
        color: Colors.black.withOpacity(1));
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.ellipsis_vertical))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
          child: StreamBuilder<DocumentSnapshot<Project>>(
            stream: c.streamProject(workspaceId, projectId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              final projectSnapshot = snapshot.data;
              final Project? project = projectSnapshot!.data();

              return ListView(
                children: [
                  Text(
                    "Project Name",
                    style: titleTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    project!.name,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Workspace",
                    style: titleTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Endour Studio",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Project Description",
                    style: titleTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    project.description,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Personalize",
                    style: titleTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // ToggleButtons(children: [], isSelected: isSelected),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Created At",
                    style: titleTextStyle,
                  ),
                  Text(
                    c.dateFormating(project.createdAt),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
