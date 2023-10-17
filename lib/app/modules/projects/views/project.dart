import 'package:aray/app/modules/projects/controller/controller_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Project extends StatelessWidget {
  const Project({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Project"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
