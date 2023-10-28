import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/controller_project.dart';
import 'package:aray/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectViewX extends StatelessWidget {
  const ProjectViewX({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectController());
    final QueryDocumentSnapshot<Project> projectSnapshot =
        Get.arguments['project'];
    final DocumentReference<Workspace> workspaceRef =
        Get.arguments['workspace'];
    final Project project = projectSnapshot.data();
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.ellipsis))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot<CardModel>>(
          stream: controller.streamCards(projectSnapshot, workspaceRef),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return SizedBox(
              height: Get.height * 0.75,
              child: ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                onReorder: (oldIndex, newIndex) {},
                itemBuilder: (context, index) {
                  final cardSnapshot = snapshot.data!.docs;
                  final CardModel card = cardSnapshot[index].data();
                  return Container(
                    key: ValueKey(card),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: Get.width * (0.8),
                    // height: 400,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  card.name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.ellipsis))
                            ],
                          ),
                          StreamBuilder<QuerySnapshot<Activity>>(
                            stream: controller
                                .streamActivities(cardSnapshot[index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: ReorderableListView(
                                  onReorder: (oldIndex, newIndex) {},
                                  children: snapshot.data!.docs
                                      .map((activitySnapshot) {
                                    return ListTile(
                                      key: ValueKey(activitySnapshot),
                                      onTap: () {
                                        Get.toNamed(Routes.ACTIVITY,
                                            arguments: {
                                              "activity": activitySnapshot,
                                              "activity_path":
                                                  controller.activityPath.value
                                            });
                                      },
                                      title: Text(activitySnapshot.data().name),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
