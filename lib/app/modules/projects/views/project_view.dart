import 'package:aray/app/data/model/model_card.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/controller_project.dart';
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
        title: Text("Project"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(project.name),
            Text(project.description),
            Text(project.createdAt.toString()),
            // FutureBuilder(
            //     future: controller.fetchCards(projectSnapshot, workspaceRef),
            //     builder: (context, cardSnapshot) {
            //       if (cardSnapshot.connectionState == ConnectionState.waiting) {
            //         return const CircularProgressIndicator();
            //       } else if (cardSnapshot.hasError) {
            //         return Text("Error: ${cardSnapshot.error}");
            //       } else if (!cardSnapshot.hasData ||
            //           cardSnapshot.data!.isEmpty) {
            //         return const Text("Invalid Name");
            //       } else {
            //         final cardList = cardSnapshot.data!;
            //         return Column(
            //           children: cardList.map((card) {
            //             final cardData = card.data();
            //             return ListTile(
            //               title: Text(cardData.name),
            //               onTap: () {},
            //             );
            //           }).toList(),
            //         );
            //       }
            //     }),
            StreamBuilder<QuerySnapshot<CardModel>>(
                stream: controller.streamCards(projectSnapshot, workspaceRef),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    children: snapshot.data!.docs.map((cardSnapshot) {
                      final CardModel card = cardSnapshot.data();
                      return Text(card.name);
                    }).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
