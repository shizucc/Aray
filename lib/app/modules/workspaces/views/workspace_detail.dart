import 'package:aray/app/modules/workspaces/controller/controller_workspace_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkspaceDetail extends StatelessWidget {
  const WorkspaceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    final String workspaceId = args['workspaceId'] ?? '';
    final c = Get.put(WorkspaceDetailController());
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: c.streamWorkspace(workspaceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("ada error");
          } else {
            final workspaceSnapshot = snapshot.data!;
            final workspace = workspaceSnapshot.data()!;
            return Column(
              children: [Text(workspace.name!), Text(workspace.description!)],
            );
          }
        },
      ),
    );
  }
}
