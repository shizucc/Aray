import 'package:aray/app/data/model/model_user.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/global_widgets/loading_text.dart';
import 'package:aray/app/modules/workspaces/controller/controller_workspace.dart';
import 'package:aray/app/modules/workspaces/controller/controller_workspace_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class WorkspaceDetail extends StatefulWidget {
  const WorkspaceDetail({super.key});

  @override
  State<WorkspaceDetail> createState() => _WorkspaceDetailState();
}

class _WorkspaceDetailState extends State<WorkspaceDetail> {
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
                  PopupMenuItem(
                    value: 'End This Workspace',
                    // ignore: unnecessary_const
                    child: Text('End This Workspace',
                        style: TextStyle(color: Color(0xffFF0000))),
                    onTap: () async {
                      final bool isDeletable =
                          await c.getIsWorkspaceDeletable();

                      isDeletable
                          ? showDialog(
                              context: context,
                              builder: (context) =>
                                  deleteWorkspaceDialog(context, a, c),
                            )
                          : showDialog(
                              context: context,
                              builder: (context) =>
                                  deleteWorkspaceDialogFail(context, a, c),
                            );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: StreamBuilder(
              stream: c.streamWorkspace(workspaceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LoadingText(labelText: "Crunching your data..."),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                          "An error occurred while loading your workspace details"));
                } else {
                  final workspaceSnapshot = snapshot.data!;
                  final workspace = workspaceSnapshot.data()!;
                  return WorkspaceContent(a: a, workspace: workspace, c: c);
                }
              }),
        ));
  }

  AlertDialog deleteWorkspaceDialog(BuildContext context,
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
              onPressed: () async {
                c.deleteWorkspace();
                Get.offAllNamed('/workspace');
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ))
        ],
        title: const Text("Delete this Workspace"),
        content: const Text("This Method cannot be undone"));
  }

  AlertDialog deleteWorkspaceDialogFail(BuildContext context,
      WorkspaceDetailAnimationController a, WorkspaceDetailController c) {
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black))),
        ],
        title: const Text("Cannot delete this Workspace"),
        content: Text("There are still several projects in this workspace!"));
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
              WorkspaceCollaboratorField(workspace: workspace),
              //Kotak Boards
            ],
          ),
        )
      ],
    );
  }
}

class WorkspaceCollaboratorField extends StatelessWidget {
  const WorkspaceCollaboratorField({super.key, required this.workspace});
  final Workspace workspace;
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
      const Gap(10),
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
            return memberTile(userSnapshot, userRole, c, a);
          }).toList();
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: usersTile,
            ),
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => addMemberDialog(context, a, c),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      backgroundColor: Colors.deepPurple.withOpacity(0.5)),
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
          ],
        ),
      ),
    ]);
  }

  ListTile memberTile(DocumentSnapshot<UserModel> userSnapshot, String userRole,
      WorkspaceDetailController c, WorkspaceDetailAnimationController a) {
    final UserModel user = userSnapshot.data()!;
    final bool isCreator = userRole == "creator";
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      leading: const Icon(
        CupertinoIcons.circle_fill,
        size: 7,
      ),
      title: RichText(
          text:
              TextSpan(style: const TextStyle(color: Colors.black), children: [
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
                PopupMenuItem(
                  value: 'remove_membership',
                  child: const Text('Remove',
                      style: TextStyle(color: Color(0xffFF0000))),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          removeMembershipDialog(context, userSnapshot, a, c),
                    );
                  },
                ),
              ],
            )
          : null,
    );
  }

  AlertDialog removeMembershipDialog(
      BuildContext context,
      DocumentSnapshot<UserModel> userSnapshot,
      WorkspaceDetailAnimationController a,
      WorkspaceDetailController c) {
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black))),
          TextButton(
              onPressed: () async {
                c.removeWorkspaceMember(userSnapshot.id);
                Get.offAllNamed('/workspace');
              },
              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.red),
              ))
        ],
        title: const Text("Remove Membership"),
        // titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        content: const Text("This member can be invited again"));
  }

  AlertDialog addMemberDialog(BuildContext context,
      WorkspaceDetailAnimationController a, WorkspaceDetailController c) {
    final formKey = GlobalKey<FormState>();
    final userEmailTextFieldController = TextEditingController();
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black))),
          TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final userEmail = userEmailTextFieldController.value.text;
                  c.sendInvitationWorkspaceMember(userEmail, workspace.name!);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Invite",
                style: TextStyle(color: Colors.blue),
              ))
        ],
        title: const Text("Add Member to this workspace"),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter Email Address"),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: userEmailTextFieldController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty!';
                    }
                    if (!value.isEmail) {
                      return 'Enter a valid email!';
                    }
                    return null;
                  },
                ),
              ),
            ]));
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
          Obx(() {
            final bool isDescriptionEmpty = workspace.description!.isEmpty;
            return Container(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        a.setDefaultValueTextfield(
                            a.workspaceDescriptionController,
                            workspace.description!);
                        a.switchIsWorkspaceDescriptionEditing(true);
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
                                c.updateWorkspaceFromTextField('description',
                                    a.workspaceDescriptionController);
                                a.switchIsWorkspaceDescriptionEditing(false);
                              },
                            )
                          : isDescriptionEmpty
                              ? Text(
                                  "Add Workspace Description",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              : Text(
                                  (workspace.description!),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                    )));
          }),
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
    final bool isWorkspaceNameEmpty = workspace.name!.isEmpty;
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
          Obx(() {
            return Container(
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
                                c.updateWorkspaceFromTextField(
                                    'name', a.workspaceNameController);
                                a.switchIsWorkspaceNameEditing(false);
                              },
                            )
                          : isWorkspaceNameEmpty
                              ? const Text("Add Workspace Name")
                              : Text(workspace.name!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                    )));
          }),
        ],
      ),
    );
  }
}
