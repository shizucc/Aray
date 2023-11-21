import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_checklist.dart';
import 'package:aray/app/modules/activity/controller/controller_activity_detail.dart';
import 'package:aray/utils/date_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
    return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: 200.0,
              flexibleSpace: const FlexibleSpaceBar(background: FlutterLogo()),
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
                      ActivityNameField(activity: activity),
                      ActivityDescriptionField(activity: activity),
                      ActivityTimeStampField(activity: activity),
                      ActivityChecklistField(
                        a: a,
                        c: c,
                      ),
                      const ActivityAttachmentField(),
                    ]),
                  ));
            },
          )
        ]);
  }
}

class ActivityAttachmentField extends StatelessWidget {
  const ActivityAttachmentField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 50, bottom: 10, top: 20),
          child: const Row(
            children: [
              Icon(Icons.folder),
              Text("File"),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 2))
              ]),
          child: Column(children: [
            const Row(
              children: [
                Text("File Tugas.zip"),
                Icon(
                  Icons.file_copy_rounded,
                  size: 15,
                ),
                Expanded(child: Icon(Icons.more_vert)),
              ],
            ),
            Row(
              children: [
                Text(
                  "Ditambahkan: 12-31-12",
                  style: TextStyle(
                      fontSize: 13, color: Colors.black.withOpacity(0.5)),
                )
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Icon(Icons.add), Text("Add Attachement")],
            )
          ]),
        )
      ],
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
                                  decoration: InputDecoration(),
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
                                    c.deleteChecklist(checkTileSnaphsot.id);
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
              Expanded(child: Text("Start Date")),
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
                          Icon(Icons.calendar_month),
                          Gap(5),
                          Text(DateHandler.dateFormat(activity.startTime!)),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(Icons.calendar_month),
                          Gap(5),
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
          Gap(5),
          Row(
            children: [
              Expanded(child: Text("Due Date")),
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
                          Icon(Icons.calendar_month),
                          Gap(5),
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
                                  child: Text("Save"))
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
                          : TextStyle(color: Colors.black)),
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
