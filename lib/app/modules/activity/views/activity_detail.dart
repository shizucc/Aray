import 'dart:io';
import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_checklist.dart';
import 'package:aray/app/data/model/model_file.dart';
import 'package:aray/app/global_widgets/my_text_button_icon.dart';
import 'package:aray/app/modules/activity/controller/controller_activity_detail.dart';
import 'package:aray/app/modules/projects/controller/controller_project_detail.dart';
import 'package:aray/utils/date_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ActivityDetail extends StatelessWidget {
  const ActivityDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ActivityDetailController());
    final a = Get.put(ActivityDetailAnimationController());
    c.args = Get.arguments;
    return Scaffold(
        body: StreamBuilder(
      stream: c.streamActivity(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final activitySnapshot = snapshot.data!;
        final Activity activity = activitySnapshot.data()!;
        return ActivityDetailData(
          activity: activity,
          a: a,
          c: c,
        );
      },
    ));
  }
}

class ActivityDetailData extends StatelessWidget {
  const ActivityDetailData(
      {super.key, required this.activity, required this.c, required this.a});
  final Activity activity;
  final ActivityDetailController c;
  final ActivityDetailAnimationController a;

  @override
  Widget build(BuildContext context) {
    final ActivityDetailAnimationController a =
        Get.find<ActivityDetailAnimationController>();
    // Identify The color scheme
    a.setColorThemeActivity(c.colorTheme());

    // Get value of use image or not
    final bool isUseCoverImage = activity.coverName.isNotEmpty;
    return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                decoration: isUseCoverImage
                    ? BoxDecoration(
                        color: a.colorThemeActivity.value.withOpacity(0.5))
                    : null,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    // const Placeholder(),
                    isUseCoverImage
                        ? Image.network(activity.coverUrl)
                        : Container(),
                    isUseCoverImage
                        ? MyTextButtonIcon(
                            label: "Add Cover",
                            labelTextStyle: TextStyle(color: Colors.white),
                            icon: const Icon(
                              CupertinoIcons.add,
                              size: 13,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.black.withOpacity(0.3),
                            onTap: () async {
                              final XFile? image = await c.openImagePicker();
                              await c.uploadActivityCover(image!);
                            },
                          )
                        : MyTextButtonIcon(
                            label: "Delete Cover",
                            icon: const Icon(
                              CupertinoIcons.trash,
                              size: 13,
                            ),
                            backgroundColor: const Color(0xffFF8383),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    deleteCoverAlertDialog(context),
                              );
                            },
                          ),
                  ],
                ),
              )),
              actions: [
                PopupMenuButton(
                  icon: const Icon(CupertinoIcons.ellipsis_vertical),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: const Text('Delete Activity'),
                      value: 'delete_activity',
                      onTap: () {
                        print("activity deleted");
                      },
                    ),
                  ],
                ),
              ]),
          Builder(
            builder: (context) {
              return Theme(
                  data: ThemeData(
                    primaryColor: a.colorThemeActivity.value,
                    iconTheme: IconThemeData(color: a.colorThemeActivity.value),
                    inputDecorationTheme: InputDecorationTheme(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: a.colorThemeActivity.value))),
                    // Warna utama
                  ),
                  child: SliverList(
                    delegate: SliverChildListDelegate([
                      Gap(10),
                      ActivityNameField(activity: activity),
                      ActivityDescriptionField(activity: activity),
                      ActivityTimeStampField(activity: activity),
                      ActivityChecklistField(
                        a: a,
                        c: c,
                      ),
                      ActivityAttachmentField(activity: activity),
                    ]),
                  ));
            },
          )
        ]);
  }

  AlertDialog deleteCoverAlertDialog(BuildContext context) {
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () async {
                c.deleteActivityCover(activity);
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ))
        ],
        title: const Text("Are you sure to delete this cover?"),
        content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [Text("This action cannot be undone")]));
  }
}

class ActivityAttachmentField extends StatelessWidget {
  const ActivityAttachmentField({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final ActivityDetailAnimationController a =
        Get.find<ActivityDetailAnimationController>();
    final ActivityDetailController c = Get.find<ActivityDetailController>();

    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          Obx(() {
            final isUploadingProgress =
                c.isActivityFilesUploadingProgress.value;
            return Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.folder),
                  const Gap(3),
                  const Expanded(child: Text("Files")),
                  isUploadingProgress ? uploadProgressStatus() : Container()
                ],
              ),
            );
          }),
          // fileTile(a, c),
          Column(
            children: fileList(a, c),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: a.colorThemeActivity.value,
                borderRadius: BorderRadius.circular(15)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () async {
                  await c.openFilePicker();
                  final List<File> files = c.activityFiles;
                  c.uploadActivityFiles(files);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      "Add Attachment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget uploadProgressStatus() {
    return Container(
      child: Text(
        "Uploading some files ...",
        style: TextStyle(
            fontSize: 13,
            color: Colors.black.withOpacity(0.5),
            fontStyle: FontStyle.italic),
      ),
    );
  }

  List<Widget> fileList(
      ActivityDetailAnimationController a, ActivityDetailController c) {
    return [
      StreamBuilder(
        stream: c.streamActivityFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final filesSnapshot = snapshot.data!;
          final files = filesSnapshot.docs;

          final filesWidgets = files.asMap().entries.map((entry) {
            final index = entry.key;
            final fileSnapshot = entry.value;
            return fileTile(a, c, fileSnapshot);
          }).toList();

          return Column(
            children: filesWidgets,
          );
        },
      ),
    ];
  }

  Widget fileTile(
      ActivityDetailAnimationController a,
      ActivityDetailController c,
      QueryDocumentSnapshot<FileModel> fileSnapshot) {
    final FileModel file = fileSnapshot.data();
    final String fileId = fileSnapshot.id;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: a.colorThemeActivity.value),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            child: const Icon(
              CupertinoIcons.doc,
              size: 14,
            ),
          ),
          const Gap(10),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  c.downloadActivityFile(Uri.parse(file.url));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        const Gap(3),
                        Text(
                          file.name,
                        ),
                      ],
                    ),
                    const Gap(5),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.clock,
                          size: 13,
                        ),
                        const Gap(3),
                        Text(DateHandler.dateAndTimeFormat(file.createdAt),
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black.withOpacity(0.5)))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 16,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: const Text('Delete this file'),
                value: 'delete_file',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  c.deleteActivityFile(fileId, file);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ))
                          ],
                          title:
                              const Text("Are you sure to delete this file?"),
                          content: Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    file.name,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  const Gap(5),
                                  const Text("This action cannot be undone")
                                ]),
                          ));
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ActivityChecklistField extends StatelessWidget {
  const ActivityChecklistField({super.key, required this.c, required this.a});
  final ActivityDetailController c;
  final ActivityDetailAnimationController a;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 40, right: 40),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5), offset: const Offset(0, 2))
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Checklist",
                style: TextStyle(
                    fontSize: 13, color: Colors.black.withOpacity(0.5)),
              ),
              IconButton(
                  onPressed: () {
                    c.addNewChecklist();
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 15,
                  ))
            ],
          ),
          Column(children: checklist()),
        ],
      ),
    );
  }

  List<Widget> checklist() {
    return [
      StreamBuilder(
        stream: c.streamChecklist(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final checklistSnapshot = snapshot.data!;
          final checklist = checklistSnapshot.docs;

          final checklistWidgets = checklist.asMap().entries.map((entry) {
            final index = entry.key;
            final checkTileSnapshot = entry.value;
            // Init textEditingController
            a.initCheckList();
            return checkTile(checkTileSnapshot, index);
          }).toList();

          return Column(
            children: checklistWidgets,
          );
        },
      ),
    ];
  }

  Widget checkTile(
      QueryDocumentSnapshot<Checklist> checkTileSnaphsot, int index) {
    final TextEditingController textEditingController =
        a.getChecklistTextController(index);
    final checkTile = checkTileSnaphsot.data();
    textEditingController.text = checkTile.name;
    final isChecked = checkTile.status;
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                c.updateChecklistStatus(checkTileSnaphsot.id, !isChecked);
              },
              icon: isChecked
                  ? Icon(
                      Icons.check_box,
                      size: 18,
                      color: a.colorThemeActivity.value,
                    )
                  : Icon(
                      Icons.crop_square,
                      size: 18,
                      color: a.colorThemeActivity.value,
                    )),
          Expanded(
            child: Obx(() {
              final bool isEditing = a.getIsEditingChecklist(index);
              return GestureDetector(
                  onTap: () {
                    a.switchIsEditingChecklist(index, !isEditing);
                  },
                  child: isEditing
                      ? Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(),
                                  maxLength: 50,
                                  style: const TextStyle(fontSize: 14),
                                  autofocus: true,
                                  controller: textEditingController,
                                  onEditingComplete: () {
                                    a.switchIsEditingChecklist(
                                        index, !isEditing);
                                    if (textEditingController.text !=
                                        checkTile.name) {
                                      c.updateCheckListName(
                                          checkTileSnaphsot.id,
                                          textEditingController.text);
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    a.switchIsEditingChecklist(
                                        index, !isEditing);
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.clear,
                                    size: 15,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                onPressed: () {
                                  a.switchIsEditingChecklist(index, !isEditing);
                                  if (textEditingController.text !=
                                      checkTile.name) {
                                    c.updateCheckListName(checkTileSnaphsot.id,
                                        textEditingController.text);
                                  }
                                },
                                icon: const Icon(
                                  CupertinoIcons.check_mark,
                                  size: 15,
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          child: Row(
                          children: [
                            Expanded(child: Text(checkTile.name)),
                            PopupMenuButton(
                              icon: const Icon(
                                CupertinoIcons.ellipsis_vertical,
                                size: 14,
                              ),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 'delete_checklist_in_activity',
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel")),
                                              TextButton(
                                                  onPressed: () {
                                                    c.deleteChecklist(
                                                        checkTileSnaphsot.id);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                            title: const Text(
                                                "Are you sure to delete this checklist?"),
                                            content: Container(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      checkTile.name,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    const Gap(5),
                                                    const Text(
                                                        "This action cannot be undone")
                                                  ]),
                                            ));
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Delete this cheklist',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )));
            }),
          ),
        ],
      ),
    );
  }
}

class ActivityTimeStampField extends StatelessWidget {
  const ActivityTimeStampField({
    super.key,
    required this.activity,
  });
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final ActivityDetailAnimationController a =
        Get.find<ActivityDetailAnimationController>();

    final ActivityDetailController c = Get.find<ActivityDetailController>();

    final bool isTimeStamp = activity.timestamp;

    if (isTimeStamp) {
      a.selectedDateTimeRange.value =
          DateTimeRange(start: activity.startTime!, end: activity.endTime!);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5), offset: const Offset(0, 2))
          ]),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Text("Start Date")),
              GestureDetector(
                onTap: () async {
                  final DateTimeRange? dateTimeRangeSelect =
                      await showDateRangePicker(
                          initialDateRange: a.selectedDateTimeRange.value,
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000));
                  if (dateTimeRangeSelect != null) {
                    a.selectedDateTimeRange.value = dateTimeRangeSelect;
                    c.updateActivityTimeStamp(a.selectedDateTimeRange.value);
                  }
                },
                child: isTimeStamp
                    ? Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const Gap(5),
                          Text(DateHandler.dateFormat(activity.startTime!)),
                        ],
                      )
                    : Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const Gap(5),
                          Text(
                            "Add",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          )
                        ],
                      ),
              ),
              //
            ],
          ),
          const Gap(5),
          Row(
            children: [
              const Expanded(child: Text("Due Date")),
              GestureDetector(
                onTap: () async {
                  final DateTimeRange? dateTimeRangeSelect =
                      await showDateRangePicker(
                          initialDateRange: a.selectedDateTimeRange.value,
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000));
                  if (dateTimeRangeSelect != null) {
                    a.selectedDateTimeRange.value = dateTimeRangeSelect;
                    c.updateActivityTimeStamp(a.selectedDateTimeRange.value);
                  }
                },
                child: isTimeStamp
                    ? Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const Gap(5),
                          Text(DateHandler.dateFormat(activity.endTime!))
                        ],
                      )
                    : Container(),
              ),
              //
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityDescriptionField extends StatelessWidget {
  const ActivityDescriptionField({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final ActivityDetailAnimationController a =
        Get.find<ActivityDetailAnimationController>();

    final ActivityDetailController c = Get.find<ActivityDetailController>();
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(40),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5), offset: const Offset(0, 2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style:
                TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.5)),
          ),
          Obx(() {
            final TextEditingController controller =
                a.activityDescriptionController;
            controller.text = activity.description;
            final isEditing = a.isEditingProjectDescription.value;
            return GestureDetector(
              onTap: () {
                a.isEditingProjectDescription.value = !isEditing;
              },
              child: isEditing
                  ? Container(
                      child: Column(
                        children: [
                          TextField(
                            maxLines: 5,
                            autofocus: true,
                            controller: controller,
                            style: const TextStyle(fontSize: 14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    a.isEditingProjectDescription.value =
                                        !isEditing;
                                  },
                                  child: const Text(
                                    "Discard",
                                    style: TextStyle(color: Colors.red),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    a.isEditingProjectDescription.value =
                                        !isEditing;
                                    if (controller.text !=
                                        activity.description) {
                                      c.updateActivityTextField(
                                          'description', controller.text);
                                    }
                                  },
                                  child: const Text("Save"))
                            ],
                          )
                        ],
                      ),
                    )
                  : Text(
                      activity.description.isEmpty
                          ? "Add Activity Description"
                          : activity.description,
                      style: activity.description.isEmpty
                          ? TextStyle(color: Colors.black.withOpacity(0.5))
                          : const TextStyle(color: Colors.black)),
            );
          }),
        ],
      ),
    );
  }
}

class ActivityNameField extends StatelessWidget {
  const ActivityNameField({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final a = Get.find<ActivityDetailAnimationController>();
    final c = Get.find<ActivityDetailController>();
    return Container(
        margin: const EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final TextEditingController controller = a.activityNameController;
              controller.text = activity.name;
              final isEditing = a.isEditingProjectName.value;
              return GestureDetector(
                onTap: () {
                  a.isEditingProjectName.value = !isEditing;
                },
                child: isEditing
                    ? TextField(
                        autofocus: true,
                        controller: controller,
                        onEditingComplete: () {
                          a.isEditingProjectName.value = !isEditing;
                          if (controller.text != activity.name) {
                            c.updateActivityTextField('name', controller.text);
                          }
                        },
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      )
                    : Text(
                        activity.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
              );
            }),
            FutureBuilder(
              future: c.getCard(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final CardModel card = snapshot.data!;
                return Text("In Card '${card.name}'",
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.5)));
              },
            ),
          ],
        ));
  }
}
