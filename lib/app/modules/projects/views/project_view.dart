import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_color_theme.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/modules/projects/controller/controller_project.dart';
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

    final String projectId = Get.arguments['projectId'];
    final String workspaceId = Get.arguments['workspaceId'];
    final Project projectDump = Get.arguments['project'];

    Color cardColor = const Color.fromRGBO(241, 239, 239, 1).withOpacity(0.95);
    // a.streamProject(workspaceRef.id, projectSnapshot.id);
    return StreamBuilder(
      stream: c.streamProject(workspaceId, projectId),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(projectDump.name),
            ),
          );
        }
        final projectSnapshot = snapshot.data!;
        final Project project = projectSnapshot.data()!;
        final projectColor = project.personalize['color'];
        final projectTheme = ColorTheme(code: projectColor);
        final bool isUseImage = project.personalize['use_image'] as bool;

        final int projectCoverImageDominantColorDecimal =
            project.personalize['image_dominant_color'] ?? 0;
        final Color projectCoverImageDominantColor =
            Color(0xFFFFFFFF & projectCoverImageDominantColorDecimal);

        final bool isProjectCoverImageDark =
            projectCoverImageDominantColor.isDark;

        final projectCoverImageUrl =
            project.personalize['image_link'] as String;

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
              project.name,
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
                      'projectId': projectId,
                      'workspaceId': workspaceId
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
              stream: c.streamCards(projectId, workspaceId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final cardsSnapshot = snapshot.data!;
                return ProjectCards(
                    cardsSnapshot: cardsSnapshot,
                    cardColor: cardColor,
                    c: c,
                    projectTheme: projectTheme,
                    projectId: projectId);
              },
            ),
          ),
        );
      },
    );
  }
}

class ProjectCards extends StatelessWidget {
  const ProjectCards(
      {super.key,
      required this.cardColor,
      required this.c,
      required this.projectId,
      required this.projectTheme,
      required this.cardsSnapshot});

  final Color cardColor;
  final ProjectController c;
  final String projectId;
  final ColorTheme projectTheme;
  final QuerySnapshot<CardModel> cardsSnapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.8,
      child: ReorderableListView(
        scrollDirection: Axis.horizontal,
        onReorder: (oldIndex, newIndex) {},
        children: cardsSnapshot.docs.map((cardSnapshot) {
          final CardModel card = cardSnapshot.data();
          return Container(
            key: ValueKey(cardSnapshot),
            margin: const EdgeInsets.only(right: 15, left: 15),
            width: Get.width * (0.85),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: const BorderRadius.only(
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
                            icon: const Icon(CupertinoIcons.ellipsis))
                      ],
                    ),
                  ),
                  ProjectActivities(
                      cardSnapshot: cardSnapshot,
                      cardColor: cardColor,
                      projectId: projectId,
                      c: c,
                      projectTheme: projectTheme),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ProjectActivities extends StatelessWidget {
  const ProjectActivities(
      {super.key,
      required this.cardColor,
      required this.c,
      required this.projectId,
      required this.projectTheme,
      required this.cardSnapshot});

  final Color cardColor;
  final ProjectController c;
  final String projectId;
  final ColorTheme projectTheme;
  final QueryDocumentSnapshot<CardModel> cardSnapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: StreamBuilder<QuerySnapshot<Activity>>(
        stream: c.streamActivities(cardSnapshot.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                  height: snapshot.data!.docs.length * 75,
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      c.reorderActivity(cardSnapshot.id, oldIndex, newIndex);
                    },
                    children: snapshot.data!.docs.map((activitySnapshot) {
                      final Activity activity = activitySnapshot.data();
                      return Draggable(
                        feedback: const Placeholder(),
                        key: ValueKey(activity),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed("/activity/detail", arguments: {
                              "card_id": cardSnapshot.id,
                              "card_path": c.cardPath.value,
                              "activity_id": activitySnapshot.id,
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    activity.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.attach_file,
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
                                      Icons.task_outlined,
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
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(projectTheme.baseColor!)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
