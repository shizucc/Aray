import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_color_theme.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/global_widgets/my_icon_button.dart';
import 'package:aray/app/global_widgets/my_text_button_icon.dart';
import 'package:aray/app/modules/projects/controller/controller_project.dart';
import 'package:aray/app/routes/app_pages.dart';
import 'package:aray/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:ui';
import 'package:get/get.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProjectController());
    final a = Get.put(ProjectAnimationController());

    // Init the arguments
    c.args = Get.arguments;

    return StreamBuilder(
      stream: c.streamProject(),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(c.projectDump().name),
            ),
          );
        }
        final projectSnapshot = snapshot.data!;
        final Project project = projectSnapshot.data()!;
        final projectColor = project.personalize['color'];
        final projectTheme = ColorTheme(code: projectColor);
        final bool isUseImage = project.personalize['use_image'] as bool;

        a.colorTheme.value = a.getColorTheme(project);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor:
              isUseImage ? a.colorTheme.value : Color(projectTheme.baseColor!),
          appBar: AppBar(
            elevation: 1,
            backgroundColor: isUseImage
                ? a.colorTheme.value
                : Color(projectTheme.primaryColor!),
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: isUseImage
                    ? Icon(
                        Icons.arrow_back,
                        color: a.colorTheme.value.isDark
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
                      color: a.colorTheme.value.isDark
                          ? Colors.white
                          : Colors.black)
                  : const TextStyle(color: Colors.white),
            ),
            actions: [
              PopupMenuButton(
                icon: isUseImage
                    ? Icon(
                        CupertinoIcons.ellipsis_vertical,
                        color: a.colorTheme.value.isDark
                            ? Colors.white
                            : Colors.black,
                      )
                    : const Icon(
                        CupertinoIcons.ellipsis_vertical,
                        color: Colors.white,
                      ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'add_new_card',
                    onTap: () {
                      // Method to add new card
                      showDialog(
                        context: context,
                        builder: (context) => addCardDialog(context, a, c),
                      );
                    },
                    child: const Text('Add New Card'),
                  ),
                  PopupMenuItem(
                    value: 'project_details',
                    onTap: () {
                      Get.toNamed(Routes.PROJECTDETAIL, arguments: {
                        'projectId': c.projectId(),
                        'workspaceId': c.workspaceId()
                      });
                    },
                    child: const Text('Project Details'),
                  ),
                ],
              ),
            ],
          ),
          body: Builder(
            builder: (context) => ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: Get.height, maxWidth: Get.width),
              child: Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                    image: isUseImage
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(project.personalize['image_link']))
                        : null),
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: StreamBuilder(
                  stream: c.streamCards(),
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
                      projectTheme: projectTheme,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AlertDialog addCardDialog(
      BuildContext context, ProjectAnimationController a, ProjectController c) {
    final formKey = GlobalKey<FormState>();
    final cardNameTextFieldController = TextEditingController();
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black))),
          TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final cardName = cardNameTextFieldController.value.text;
                  c.addNewCard(cardName);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.blue),
              ))
        ],
        title: Text("Add Card in '${c.projectDump().name}'"),
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: cardNameTextFieldController,
                  autofocus: true,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Card name cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
            ]));
  }
}

class ProjectCards extends StatelessWidget {
  const ProjectCards(
      {super.key, required this.projectTheme, required this.cardsSnapshot});

  final ColorTheme projectTheme;
  final QuerySnapshot<CardModel> cardsSnapshot;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProjectController>();
    final a = Get.find<ProjectAnimationController>();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.8),
      child: Container(
        child: ReorderableListView(
          proxyDecorator: proxyDecorator,
          scrollDirection: Axis.horizontal,
          onReorder: (oldIndex, newIndex) {
            c.reorderCard(cardsSnapshot.docs, oldIndex, newIndex);
          },
          children: cardsSnapshot.docs.map((cardSnapshot) {
            final CardModel card = cardSnapshot.data();
            return ProjectCardsContent(
                key: ValueKey(card),
                card: card,
                cardSnapshot: cardSnapshot,
                projectTheme: projectTheme);
          }).toList(),
        ),
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }
}

class ProjectCardsContent extends StatelessWidget {
  const ProjectCardsContent({
    super.key,
    required this.card,
    required this.cardSnapshot,
    required this.projectTheme,
  });

  final CardModel card;
  final QueryDocumentSnapshot<CardModel> cardSnapshot;
  final ColorTheme projectTheme;

  @override
  Widget build(BuildContext context) {
    final a = Get.find<ProjectAnimationController>();
    final c = Get.find<ProjectController>();
    return Container(
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
                  color: a.cardColor.value,
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
                  PopupMenuButton(
                    icon: const Icon(
                      CupertinoIcons.ellipsis_vertical,
                      size: 16,
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        value: 'rename_card',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                renameCardDialog(context, a, c),
                          );
                        },
                        child: const Text('Rename Card'),
                      ),
                      PopupMenuItem(
                        value: 'delete_card',
                        onTap: () {},
                        child: const Text(
                          'Delete Card',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ProjectActivities(
                cardSnapshot: cardSnapshot, projectTheme: projectTheme),
            Expanded(
                child: IgnorePointer(
              ignoring: true,
              child: SizedBox(
                width: Get.width,
                height: Get.height,
              ),
            ))
          ],
        ),
      ),
    );
  }

  AlertDialog renameCardDialog(
      BuildContext context, ProjectAnimationController a, ProjectController c) {
    final formKey = GlobalKey<FormState>();
    final cardNameTextFieldController = TextEditingController();
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black))),
          TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final cardName = cardNameTextFieldController.value.text;
                  c.updateCardName(cardSnapshot.id, cardName);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Rename",
                style: TextStyle(color: Colors.black),
              ))
        ],
        title: const Text(
          "Rename Card",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "From :",
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
              Text(
                cardSnapshot.data().name,
                style: TextStyle(fontSize: 16),
              ),
              Gap(10),
              Text("To :",
                  style: TextStyle(color: Colors.black.withOpacity(0.5))),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: cardNameTextFieldController,
                  autofocus: true,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Card name cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
            ]));
  }
}

class ProjectActivities extends StatelessWidget {
  const ProjectActivities(
      {super.key, required this.projectTheme, required this.cardSnapshot});

  final ColorTheme projectTheme;
  final QueryDocumentSnapshot<CardModel> cardSnapshot;

  @override
  Widget build(BuildContext context) {
    final ProjectAnimationController a = Get.put(ProjectAnimationController());
    final c = Get.find<ProjectController>();

    return Container(
      decoration: BoxDecoration(
          color: a.cardColor.value,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: StreamBuilder(
        stream: c.streamActivities(cardSnapshot.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final QuerySnapshot<Activity> activitySnapshot = snapshot.data!;
          return projectActivity(context, activitySnapshot, c, a);
        },
      ),
    );
  }

  Column projectActivity(
      BuildContext context,
      QuerySnapshot<Activity> activitySnapshot,
      ProjectController c,
      ProjectAnimationController a) {
    return Column(
      children: [
        ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: activitySnapshot.docs.length * 65),
          child: Container(
              height: Get.height * 0.6,
              margin: const EdgeInsets.only(
                top: 5,
                right: 25,
                left: 25,
              ),
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  c.reorderActivity(cardSnapshot.id, activitySnapshot.docs,
                      oldIndex, newIndex);
                },
                children: activitySnapshot.docs.map((activitySnapshot) {
                  final Activity activity = activitySnapshot.data();
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    key: ValueKey(activity),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.toNamed("/activity/detail", arguments: {
                            "color_theme": a.colorTheme.value,
                            "project_id": c.projectId(),
                            "card_id": cardSnapshot.id,
                            "card_path": c.cardPath.value,
                            "activity_id": activitySnapshot.id,
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            children: [
                              MyButtonIcon(
                                  icon: const Icon(
                                    CupertinoIcons.ellipsis_vertical,
                                    size: 13,
                                  ),
                                  onTap: () {}),
                              const Gap(3),
                              Expanded(
                                child: Text(
                                  activity.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                    ),
                  );
                }).toList(),
              )),
        ),
        const Gap(15),
        Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: Obx(() {
              return MyTextButtonIcon(
                  backgroundColor: a.colorTheme.value.withOpacity(0.5),
                  label: "Add Activity",
                  labelTextStyle: TextStyle(
                      color: a.colorTheme.value.isDark
                          ? Colors.white
                          : Colors.black.withOpacity(0.5)),
                  icon: Icon(
                    Icons.add,
                    color: a.colorTheme.value.isDark
                        ? Colors.white
                        : Colors.black.withOpacity(0.5),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => addActivityDialog(context, a, c),
                    );
                  });
            }))
      ],
    );
  }

  AlertDialog addActivityDialog(
      BuildContext context, ProjectAnimationController a, ProjectController c) {
    final formKey = GlobalKey<FormState>();
    final activityNameTextFieldController = TextEditingController();
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black))),
          TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final activityName =
                      activityNameTextFieldController.value.text;
                  c.addNewActivity(cardSnapshot.id, activityName);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.blue),
              ))
        ],
        title: Text(
          "Add Activity in '${cardSnapshot.data().name}' card",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: activityNameTextFieldController,
                  autofocus: true,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Activity name cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
            ]));
  }
}
