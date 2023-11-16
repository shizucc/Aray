import 'package:aray/app/modules/activity/controller/controller_activity_detail.dart';
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
        body: CustomScrollView(
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
              Container(
                  margin: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Brainstorming",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("In Board 'Endour Studio'",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.5))),
                        ],
                      )
                    ],
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(0, 2))
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          "It is a long established ",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(0, 2))
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "checklist",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                        const Icon(
                          Icons.add,
                          color: Colors.grey,
                          size: 15,
                        )
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.crop_square_outlined),
                        Expanded(child: Text("Literature Study")),
                        Icon(Icons.delete),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.crop_square_outlined),
                        Expanded(child: Text("Watch Movies")),
                        Icon(Icons.delete),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.crop_square_outlined),
                        Expanded(child: Text("Go To Museum")),
                        Icon(Icons.delete),
                      ],
                    ),
                  ],
                ),
              ),
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
            ]),
          )
        ]));
  }
}
