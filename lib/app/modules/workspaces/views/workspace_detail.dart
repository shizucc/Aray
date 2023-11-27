import 'package:aray/app/data/model/model_user.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/workspaces/controller/controller_workspace.dart';
import 'package:aray/app/modules/workspaces/controller/controller_workspace_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class WorkspaceDetail extends StatelessWidget {
  const WorkspaceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final a = Get.put(WorkspaceDetailAnimationController());
    final c = Get.put(WorkspaceDetailController());
    final args = Get.arguments;
    final String workspaceId = args["workspaceId"] ?? '';

    return Scaffold(
        appBar: AppBar(
          title: const Text("Workspace"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: PopupMenuButton(
                  icon: const Icon(Icons.more_horiz),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        const PopupMenuItem(
                          value: 'End This Workspace',
                          // ignore: unnecessary_const
                          child: Text('End This Workspace',
                              style: TextStyle(color: Color(0xffFF0000))),
                        ),
                      ],
                  onSelected: (dynamic value) {
                    print(value);
                  }),
            )
          ],
        ),
        body: StreamBuilder(
            stream: c.streamWorkspace(workspaceId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("Terdapat Error");
              } else {
                final workspaceSnapshot = snapshot.data!;
                final workspace = workspaceSnapshot.data()!;
                return WorkspaceContent(a: a, workspace: workspace, c: c);
              }
            }));
  }
}

class WorkspaceContent extends StatelessWidget {
  const WorkspaceContent({
    super.key,
    required this.a,
    required this.workspace,
    required this.c,
  });

  final WorkspaceDetailAnimationController a;
  final Workspace workspace;
  final WorkspaceDetailController c;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              //Kotak Nama Workspace
              WorkspaceNameField(workspace: workspace),
              //Kotak deskripsi Workspace
              WorkspaceDescriptionField(workspace: workspace),
              //Kotak Collaborator
              WorkspaceCollaboratorField(),
              //Kotak Boards
            ],
          ),
        )
      ],
    );
  }
}

class WorkspaceCollaboratorField extends StatelessWidget {
  const WorkspaceCollaboratorField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WorkspaceDetailController>();
    final a = Get.find<WorkspaceDetailAnimationController>();
    return Column(children: [
      Container(
          child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Member Of Workspace',
          style: TextStyle(color: Colors.black38, fontSize: 12),
        ),
      )),
      Gap(10),
      FutureBuilder(
        future: c.getWorkspaceMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return Text(
              "Crunching the member's data",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontStyle: FontStyle.italic),
            );
          }
          final users = snapshot.data!;
          List<ListTile> usersTile = users.map((user) {
            final userRole = user['userRole'] as String;
            final userSnapshot =
                user['userSnapshot'] as DocumentSnapshot<UserModel>;
            return memberTile(userSnapshot, userRole);
          }).toList();
          return Column(
            children: usersTile,
          );
        },
      ),
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 140,
                height: 30,
                child: FilledButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                  ),
                  icon: const Icon(
                    Icons.add,
                    size: 20.0,
                    color: Colors.black54,
                  ),
                  label: const Text(
                    'Add Member',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                width: 108,
                height: 30,
                child: FilledButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 222, 177, 230),
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 20.0,
                    color: Colors.black54,
                  ),
                  label: const Text(
                    'See All',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  ListTile memberTile(
      DocumentSnapshot<UserModel> userSnapshot, String userRole) {
    final UserModel user = userSnapshot.data()!;
    final bool isCreator = userRole == "creator";
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      leading: Icon(CupertinoIcons.square),
      title: RichText(
          text: TextSpan(style: TextStyle(color: Colors.black), children: [
        TextSpan(text: "${user.username} "),
        TextSpan(
          style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontStyle: FontStyle.italic),
          text: "(${'${userRole}'.capitalizeFirst})",
        )
      ])),
      trailing: !isCreator
          ? PopupMenuButton(
              icon: const Icon(
                CupertinoIcons.ellipsis_vertical,
                size: 15,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: 'End This Workspace',
                      // ignore: unnecessary_const
                      child: Text('Remove',
                          style: TextStyle(color: Color(0xffFF0000))),
                    ),
                  ],
              onSelected: (dynamic value) {
                print(value);
              })
          : null,
    );
  }

  AlertDialog removeMembershipDialog(BuildContext context,
      WorkspaceDetailAnimationController a, WorkspaceDetailController c) {
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black))),
          TextButton(
              onPressed: () async {},
              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.blue),
              ))
        ],
        title: const Text("Remove Membership"),
        // titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        content: Text("This member can be invited again"));
  }
}

class WorkspaceDescriptionField extends StatelessWidget {
  const WorkspaceDescriptionField({
    super.key,
    required this.workspace,
  });

  final Workspace workspace;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WorkspaceDetailController>();
    final a = Get.find<WorkspaceDetailAnimationController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Container(
              child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Workspace Description',
              style: TextStyle(color: Colors.black38, fontSize: 12),
            ),
          )),
          Obx(() => Container(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      a.setDefaultValueTextfield(
                          a.workspaceDescriptionController,
                          workspace.description!);
                      a.switcIsWorkspaceDescriptionEditing(true);
                    },
                    child: a.isWorkspaceDescriptionEditing.value
                        ? TextField(
                            autofocus: true,
                            controller: a.workspaceDescriptionController,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            onEditingComplete: () {
                              c.updateProjectFromTextField('description',
                                  a.workspaceDescriptionController);
                              a.switcIsWorkspaceDescriptionEditing(false);
                            },
                          )
                        : Text(
                            (workspace.description!),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                  )))),
        ],
      ),
    );
  }
}

class WorkspaceNameField extends StatelessWidget {
  const WorkspaceNameField({
    super.key,
    required this.workspace,
  });

  final Workspace workspace;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WorkspaceDetailController>();
    final a = Get.find<WorkspaceDetailAnimationController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Container(
              child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Workspace Name',
              style: TextStyle(color: Colors.black38, fontSize: 12),
            ),
          )),
          Obx(() => Container(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      a.setDefaultValueTextfield(
                          a.workspaceNameController, workspace.name!);
                      a.switchIsWorkspaceNameEditing(true);
                    },
                    child: a.isWorkspaceNameEditing.value
                        ? TextField(
                            autofocus: true,
                            controller: a.workspaceNameController,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            onEditingComplete: () {
                              c.updateProjectFromTextField(
                                  'name', a.workspaceNameController);
                              a.switchIsWorkspaceNameEditing(false);
                            },
                          )
                        : Text(workspace.name!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                  )))),
        ],
      ),
    );
  }
}
