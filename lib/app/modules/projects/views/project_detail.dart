import 'package:aray/app/data/model/model_color_theme.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/controller_project_detail.dart';
import 'package:aray/utils/color_constants.dart';
import 'package:aray/utils/date_handler.dart';
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
              a.initPersonalize(project!);
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  a.isProjectNameEditing(false);
                },
                child: ListView(
                  children: [
                    titleOfDetail("Project Name", CupertinoIcons.doc),
                    Obx(() => projectNameField(a, c, project!)),
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
                    Obx(() => projectDescriptionField(a, c, project!)),
                    const SizedBox(
                      height: 20,
                    ),
                    titleOfDetail("Personalize", CupertinoIcons.paintbrush),
                    Obx(() {
                      return personalizeField(colorTheme, c, a);
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    titleOfDetail("Created at", CupertinoIcons.calendar),
                    Text(
                      DateHandler.createdAtFormat(project.createdAt),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    titleOfDetail(
                        "Last Modified", CupertinoIcons.calendar_today),
                    Text(
                      DateHandler.createdAtFormat(project.updatedAt),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget personalizeField(ColorTheme colorTheme, ProjectDetailController c,
      ProjectDetailAnimationController a) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Color(colorTheme.baseColor!),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    a.personalizeSwitch(Personalize.defaultTheme);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: a.personalize.value == Personalize.defaultTheme
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(colorTheme.primaryColor!))
                        : null,
                    child: const Center(
                        child: Text(
                      "Use Default Theme",
                      style: TextStyle(fontSize: 12),
                    )),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    a.personalizeSwitch(Personalize.customImage);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: a.personalize.value == Personalize.customImage
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(colorTheme.primaryColor!))
                        : null,
                    child: const Center(
                        child: Text(
                      "Add Cover Image",
                      style: TextStyle(fontSize: 12),
                    )),
                  ),
                ))
              ],
            ),
          ),
          a.personalize.value == Personalize.defaultTheme
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        runSpacing: 10,
                        spacing: 10,
                        alignment: WrapAlignment.center,
                        children: listColorPersonalize(c, a),
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  List<Widget> listColorPersonalize(
      ProjectDetailController c, ProjectDetailAnimationController a) {
    return ColorConstants.colors.keys.map((colorCode) {
      final color = ColorConstants.colors[colorCode]!;
      final Color primaryColor = Color(color['primary_color']!);
      return Obx(() => GestureDetector(
            onTap: () {
              c.updateProjectPersonalizeColor(colorCode);
            },
            child: Container(
              decoration: BoxDecoration(
                  border: colorCode == a.defaultTheme.value
                      ? Border.all(width: 3)
                      : null,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              // color: primaryColor,
              width: 50,
              height: 50,
            ),
          ));
    }).toList();
  }

  Widget projectNameField(ProjectDetailAnimationController a,
      ProjectDetailController c, Project project) {
    return Container(
      child: a.isProjectNameEditing.value
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  autofocus: true,
                  maxLength: 30,
                  controller: a.projectNameController,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w600),
                  onEditingComplete: () {
                    if (a.projectNameController.text.isEmpty) {
                      a.showProjectNameError();
                      return;
                    } else if (project.name != a.projectNameController.text) {
                      c.updateProjectFromTextField(
                          'name', a.projectNameController);
                    }
                    a.switchIsProjectNameEditing(false);
                  },
                ),
                Obx(() => a.isShowProjectNameError.value
                    ? const Text(
                        "*Project Name can't be empty!",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : Container())
              ],
            )
          : GestureDetector(
              onTap: () {
                a.setDefaultValueTextField(
                    a.projectNameController, project.name);
                a.switchIsProjectNameEditing(true);
              },
              child: Text(
                project.name,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ),
    );
  }

  Widget projectDescriptionField(ProjectDetailAnimationController a,
      ProjectDetailController c, Project project) {
    return Container(
      child: a.isProjectDescriptionEditing.value
          ? Column(
              children: [
                TextField(
                  maxLength: 500,
                  autofocus: true,
                  maxLines: 5,
                  controller: a.projectDescriptionController,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  onEditingComplete: () {
                    if (project.description !=
                        a.projectDescriptionController.text) {
                      c.updateProjectFromTextField(
                          'description', a.projectDescriptionController);
                    }
                    a.switchIsProjectDescriptionEditing(false);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          a.switchIsProjectDescriptionEditing(false);
                        },
                        child: const Text(
                          "Discard",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      InkWell(
                        onTap: () {
                          if (project.description !=
                              a.projectDescriptionController.text) {
                            c.updateProjectFromTextField(
                                'description', a.projectDescriptionController);
                          }
                          a.switchIsProjectDescriptionEditing(false);
                        },
                        child: Text("Save"),
                      ),
                    ],
                  ),
                )
              ],
            )
          : GestureDetector(
              onTap: () {
                a.setDefaultValueTextField(
                    a.projectDescriptionController, project.description);
                a.switchIsProjectDescriptionEditing(true);
              },
              child: project.description.isEmpty
                  ? Text(
                      'Add Project Description',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.3)),
                    )
                  : Text(
                      project.description,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
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
