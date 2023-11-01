import 'package:aray/app/data/model/model_color_theme.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/controller_project_detail.dart';
import 'package:aray/utils/date_formating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectDetail extends StatelessWidget {
  const ProjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final a = Get.put(ProjectDetailAnimationController());
    final c = Get.put(ProjectDetailController());
    final projectId = Get.arguments['projectId'];
    final workspaceId = Get.arguments['workspaceId'];

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

              final ColorTheme colorTheme =
                  ColorTheme(code: project?.personalize['color']);

              return ListView(
                children: [
                  titleOfDetail("Project Name", CupertinoIcons.doc),
                  Obx(() => Container(
                        child: a.isProjectNameEditing.value
                            ? TextField(
                                controller: a.projectNameController,
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.w600),
                                // decoration: InputDecoration(),
                                onEditingComplete: () {
                                  a.switchisProjectNameEditing(false);
                                },
                              )
                            : GestureDetector(
                                onTap: () {
                                  a.setDefaultValueProjectName(project.name);
                                  a.switchisProjectNameEditing(true);
                                },
                                child: Text(
                                  project!.name,
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  titleOfDetail("Workspace", CupertinoIcons.square_grid_2x2),
                  Obx(() => Text(
                        c.workspace.value.name!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  titleOfDetail(
                      "Project Description", CupertinoIcons.doc_plaintext),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    project!.description,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  titleOfDetail("Personalize", CupertinoIcons.paintbrush),
                  Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Color(colorTheme.baseColor!),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(colorTheme.primaryColor!)),
                          child: const Center(
                              child: Text(
                            "Use Default Theme",
                            style: TextStyle(fontSize: 12),
                          )),
                        )),
                        const Expanded(
                            child: Center(
                                child: Text(
                          "Add Cover Image",
                          style: TextStyle(fontSize: 12),
                        )))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  titleOfDetail("Created at", CupertinoIcons.calendar),
                  Text(
                    DateFormating.createdAtFormat(project.createdAt),
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

  Widget titleOfDetail(String label, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 10,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.black.withOpacity(1),
            ),
          )
        ],
      ),
    );
  }
}
