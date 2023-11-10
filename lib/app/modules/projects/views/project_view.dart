import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_color_theme.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/animation_controller_project.dart';
import 'package:aray/app/modules/projects/controller/controller_project.dart';
import 'package:aray/app/modules/projects/controller/global_controller_project_detail.dart';
import 'package:aray/app/routes/app_pages.dart';
import 'package:aray/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProjectController());
    final g = Get.put(ProjectGlobalController());
    final QueryDocumentSnapshot<Project> projectSnapshot =
        Get.arguments['project'];
    final DocumentReference<Workspace> workspaceRef =
        Get.arguments['workspace'];
    final Project project = projectSnapshot.data();

    Color cardColor = const Color.fromRGBO(241, 239, 239, 1).withOpacity(0.95);
    // a.streamProject(workspaceRef.id, projectSnapshot.id);
    return StreamBuilder(
      stream: c.streamProject(workspaceRef.id, projectSnapshot.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(project.name),
            ),
          );
        }
        final projectStream = snapshot.data!;
        final Project projectData = projectStream.data()!;
        final projectColor = projectData.personalize['color'];
        final projectTheme = ColorTheme(code: projectColor);
        final bool isUseImage = projectData.personalize['use_image'] as bool;

        final int projectCoverImageDominantColorDecimal =
            projectData.personalize['image_dominant_color'] ?? 0;
        final Color projectCoverImageDominantColor =
            Color(0xFFFFFFFF & projectCoverImageDominantColorDecimal);

        final bool isProjectCoverImageDark =
            projectCoverImageDominantColor.isDark;

        final projectCoverImageUrl =
            projectData.personalize['image_link'] as String;

        return Scaffold(
          backgroundColor: isUseImage
              ? projectCoverImageDominantColor
              : Color(projectTheme.baseColor!),
          appBar: AppBar(
            elevation: 1,
            backgroundColor: isUseImage
                ? projectCoverImageDominantColor
                : Color(projectTheme.primaryColor!),
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: isUseImage
                    ? Icon(
                        Icons.arrow_back,
                        color: isProjectCoverImageDark
                            ? Colors.white
                            : Colors.black,
                      )
                    : const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
            title: Text(
              projectData.name,
              style: isUseImage
                  ? TextStyle(
                      color:
                          isProjectCoverImageDark ? Colors.white : Colors.black)
                  : const TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.PROJECTDETAIL, arguments: {
                      'projectId': projectSnapshot.id,
                      'workspaceId': workspaceRef.id
                    });
                  },
                  icon: isUseImage
                      ? Icon(
                          CupertinoIcons.ellipsis,
                          color: isProjectCoverImageDark
                              ? Colors.white
                              : Colors.black,
                        )
                      : const Icon(
                          CupertinoIcons.ellipsis,
                          color: Colors.white,
                        ))
            ],
          ),
          body: Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
                image: isUseImage
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(projectCoverImageUrl))
                    : null),
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: StreamBuilder<QuerySnapshot<CardModel>>(
              stream: c.streamCards(projectSnapshot, workspaceRef),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return SizedBox(
                  height: Get.height * 0.8,
                  child: ReorderableListView(
                    scrollDirection: Axis.horizontal,
                    onReorder: (oldIndex, newIndex) {},
                    children: snapshot.data!.docs.map((cardSnapshot) {
                      final CardModel card = cardSnapshot.data();
                      return Container(
                        key: ValueKey(cardSnapshot),
                        margin: const EdgeInsets.only(right: 15, left: 15),
                        width: Get.width * (0.85),
                        decoration: BoxDecoration(

                            // color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        card.name,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon:
                                            const Icon(CupertinoIcons.ellipsis))
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: StreamBuilder<QuerySnapshot<Activity>>(
                                  stream: c.streamActivities(cardSnapshot),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    return Column(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                              top: 5,
                                              right: 25,
                                              left: 25,
                                            ),
                                            height:
                                                snapshot.data!.docs.length * 75,
                                            child: ReorderableListView(
                                              onReorder: (oldIndex, newIndex) {
                                                final QueryDocumentSnapshot<
                                                        Activity>
                                                    activitySnapshot = snapshot
                                                        .data!.docs[oldIndex];
                                                c.reorderActivity(
                                                    activitySnapshot,
                                                    cardSnapshot,
                                                    oldIndex,
                                                    newIndex);
                                              },
                                              children: snapshot.data!.docs
                                                  .map((activitySnapshot) {
                                                final Activity activity =
                                                    activitySnapshot.data();
                                                return Draggable(
                                                  feedback: const Placeholder(),
                                                  key: ValueKey(activity),
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 15,
                                                        horizontal: 15),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.toNamed(
                                                            Routes.ACTIVITY,
                                                            arguments: {
                                                              "activity":
                                                                  activitySnapshot,
                                                              "activity_path": c
                                                                  .activityPath
                                                                  .value
                                                            });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              activity.name,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                          ),
                                                          const Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .attach_file,
                                                                size: 14,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text("2")
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .task_outlined,
                                                                size: 14,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text("1/2")
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            )),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 25),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(
                                                  projectTheme.baseColor!)),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(CupertinoIcons.add),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Add Activity"),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
