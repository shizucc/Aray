import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/controller_project.dart';
import 'package:aray/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

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
        leading: Icon(Icons.menu),
        // title: Text("Project"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(project.name),
            Text(project.description),
            Text(project.createdAt.toString()),
            StreamBuilder<QuerySnapshot<CardModel>>(
                stream: controller.streamCards(projectSnapshot, workspaceRef),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text(snapshot.error.toString());
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    children: snapshot.data!.docs.map((cardSnapshot) {
                      final CardModel card = cardSnapshot.data();
                      return Column(
                        children: [
                          Text(card.name),
                          StreamBuilder<QuerySnapshot<Activity>>(
                            stream: controller.streamActivities(cardSnapshot),
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
                                  Text("activity dari ${card.name}"),
                                  Column(
                                    children: snapshot.data!.docs
                                        .map((activitySnapshot) {
                                      return ListTile(
                                        onTap: () {
                                          Get.toNamed(Routes.ACTIVITY,
                                              arguments: {
                                                "activity": activitySnapshot,
                                                "activity_path": controller
                                                    .activityPath.value
                                              });
                                        },
                                        title:
                                            Text(activitySnapshot.data().name),
                                      );
                                    }).toList(),
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
