import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/controller_project_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectDetail extends StatelessWidget {
  const ProjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProjectDetailController());
    final QueryDocumentSnapshot<Project> projectSnapshot =
        Get.arguments['projectSnapshot'];
    final DocumentReference<Workspace> workspaceRef =
        Get.arguments['workspaceRef'];

    final Project project = projectSnapshot.data();
    TextStyle titleTextStyle = TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 13,
        color: Colors.black.withOpacity(1));
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(CupertinoIcons.ellipsis_vertical))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
          child: ListView(
            children: [
              Text(
                "Project Name",
                style: titleTextStyle,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                project.name,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Workspace",
                style: titleTextStyle,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Endour Studio",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Project Description",
                style: titleTextStyle,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                project.description,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
