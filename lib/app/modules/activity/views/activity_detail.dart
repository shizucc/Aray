import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/modules/activity/controller/controller_activity_detail.dart';
import 'package:aray/app/modules/activity/widgets/checktile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityDetail extends StatelessWidget {
  const ActivityDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ActivityDetailController());
    c.args = Get.arguments;
    return Scaffold(
        body: StreamBuilder(
      stream: c.streamActivity(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final activitySnapshot = snapshot.data!;
        final Activity activity = activitySnapshot.data()!;
        return ActivityDetailData(
          activity: activity,
          c: c,
        );
      },
    ));
  }
}

class ActivityDetailData extends StatelessWidget {
  const ActivityDetailData(
      {super.key, required this.activity, required this.c});
  final Activity activity;
  final ActivityDetailController c;

  @override
  Widget build(BuildContext context) {
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
                      child: Text('Delete Activity'),
                      value: 'delete_activity',
                      onTap: () {
                        print("activity deleted");
                      },
                    ),
                  ],
                ),
              ]),
          SliverList(
            delegate: SliverChildListDelegate([
              ActivityNameField(activity: activity),
              ActivityDescriptionField(activity: activity),
              ActivityTimeStampField(),
              ActivityChecklistField(
                c: c,
              ),
              ActivityAttachmentField(),
            ]),
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
  const ActivityChecklistField({super.key, required this.c});
  final ActivityDetailController c;

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
              const Icon(
                Icons.add,
                color: Colors.grey,
                size: 15,
              )
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
            return Text("Something went wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final checklistSnapshot = snapshot.data!;
          final checklist = checklistSnapshot.docs;

          final checklistWidgets = checklist.map((check) {
            final TextEditingController textEditingController =
                TextEditingController();
            final checkTile = check.data();
            return EditableCheckTile(
                title: checkTile.name,
                textEditingController: textEditingController,
                onFinishEditing: () {});
          }).toList();

          return Column(
            children: checklistWidgets,
          );
        },
      ),
    ];
  }
}

class ActivityTimeStampField extends StatelessWidget {
  const ActivityTimeStampField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
      child: const Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("Start Time")),
              Icon(Icons.calendar_month),
              Text("12-31-23")
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("Due Date")),
              Icon(Icons.calendar_month),
              Text("12-31-23")
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
          Text(
            activity.description,
            style: TextStyle(fontSize: 15),
          )
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
    return Container(
        margin: const EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Row(
              children: [
                Text("In Board 'Endour Studio'",
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.5))),
              ],
            )
          ],
        ));
  }
}
