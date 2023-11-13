import 'package:aray/app/data/model/model_color_theme.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/modules/projects/controller/controller_project_detail.dart';
import 'package:aray/app/modules/projects/widgets/show_dialog_delete_cover.dart';
import 'package:aray/utils/extension.dart';
import 'package:gap/gap.dart';
import 'package:aray/utils/color_constants.dart';
import 'package:aray/utils/date_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
              a.initPersonalize(c, project!, projectId, workspaceId);

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
                    personalizeField(context, colorTheme, project, c, a),
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

  Widget personalizeField(BuildContext context, colorTheme, Project project,
      ProjectDetailController c, ProjectDetailAnimationController a) {
    final bool isUseImage = project.personalize['use_image'] as bool;
    final int projectCoverImageDominantColorDecimal =
        project.personalize['image_dominant_color'] ?? 0;
    final Color projectCoverImageDominantColor =
        Color(0xFFFFFFFF & projectCoverImageDominantColorDecimal);
    final bool isProjectCoverImageDark = projectCoverImageDominantColor.isDark;
    return Container(
      child: Column(
        children: [
          Obx(() => Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: isUseImage
                        ? projectCoverImageDominantColor.withOpacity(0.4)
                        : Color(colorTheme.baseColor!),
                    // Color(colorTheme.baseColor!),
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
                        decoration:
                            a.personalize.value == Personalize.defaultTheme
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isUseImage
                                        ? projectCoverImageDominantColor
                                            .withOpacity(0.8)
                                        : Color(colorTheme.primaryColor!))
                                : null,
                        child: Center(
                            child: Text(
                          "Use Default Theme",
                          style: isUseImage
                              ? TextStyle(
                                  fontSize: 12,
                                  color: isProjectCoverImageDark
                                      ? Colors.white
                                      : Colors.black)
                              : const TextStyle(
                                  color: Colors.black, fontSize: 12),
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
                        decoration:
                            a.personalize.value == Personalize.customImage
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isUseImage
                                        ? projectCoverImageDominantColor
                                            .withOpacity(0.8)
                                        : Color(colorTheme.primaryColor!))
                                : null,
                        child: Center(
                            child: Text(
                          "Add Cover Image",
                          style: isUseImage
                              ? TextStyle(
                                  fontSize: 12,
                                  color: isProjectCoverImageDark
                                      ? Colors.white
                                      : Colors.black)
                              : const TextStyle(
                                  color: Colors.black, fontSize: 12),
                        )),
                      ),
                    ))
                  ],
                ),
              )),
          Obx(() => a.personalize.value == Personalize.defaultTheme
              ? personalizeUseDefaultTheme(c, a)
              : personalizeAddCoverImage(context, project, c, a))
        ],
      ),
    );
  }

  Widget personalizeAddCoverImage(BuildContext context, Project project,
      ProjectDetailController c, ProjectDetailAnimationController a) {
    final String projectImage = project.personalize['image'];
    return projectImage.isEmpty
        ? personalizeAddCoverImageNotExist(project, c, a)
        : personalizeAddCoverImageExist(context, project, c, a);
  }

  Widget personalizeAddCoverImageNotExist(Project project,
      ProjectDetailController c, ProjectDetailAnimationController a) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15)),
          child: const Column(children: [
            Icon(
              CupertinoIcons.add,
              size: 40,
            ),
            SizedBox(
              height: 5,
            ),
            Text("Choose from files")
          ]),
        ),
      ),
    );
  }

  Widget personalizeAddCoverImageExist(BuildContext context, Project project,
      ProjectDetailController c, ProjectDetailAnimationController a) {
    final int projectCoverImageDominantColorDecimal =
        project.personalize['image_dominant_color'] ?? 0;
    final Color projectCoverImageDominantColor =
        Color(0xFFFFFFFF & projectCoverImageDominantColorDecimal);

    final projectCoverImageUrl = project.personalize['image_link'];
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Image.network(projectCoverImageUrl),
                Container(
                  margin: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          a.pickProjectCoverImageFile();
                          c.updateProjectCoverImage(
                              a.projectCoverImageFile.value);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.pencil,
                                  size: 16,
                                  color: Colors.black.withOpacity(0.5)),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Edit Cover",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.5)),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DialogDeleteProjectCover();
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 131, 131, 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.trash,
                                size: 16,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("Delete Cover",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.5)))
                            ],
                          ),
                        ),
                      ),
                      // Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const Gap(5),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Switch(
                activeColor: projectCoverImageDominantColor,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                // trackOutlineWidth: MaterialStatePropertyAll(5),
                value: project.personalize['use_image'] as bool,
                onChanged: (value) {
                  c.updateProjectUseImage(value);
                },
              ),
              const Gap(5),
              const Text(
                "Enable use Image as Cover?",
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget personalizeUseDefaultTheme(
      ProjectDetailController c, ProjectDetailAnimationController a) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          IgnorePointer(
            ignoring: a.isUseImage.value,
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: 10,
              spacing: 10,
              alignment: WrapAlignment.center,
              children: listColorPersonalize(c, a),
            ),
          ),
          const Gap(10),
          a.isUseImage.value
              ? const Text(
                  "Disable Cover Image first for use Default Theme!",
                  style: TextStyle(color: Colors.red, fontSize: 12),
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
