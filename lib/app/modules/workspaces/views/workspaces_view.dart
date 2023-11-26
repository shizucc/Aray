import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/workspaces/controller/controller_workspace.dart';
import 'package:aray/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  @override
  Widget build(BuildContext context) {
    final a = Get.put(WorkspaceAnimationController());
    final c = Get.put(WorkspaceController());
    // c.fetchWorkspaces();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text("Projects"),
        actions: [
          IconButton(
              onPressed: () => c.logOutWithGoogle(),
              icon: const Icon(Icons.power))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await c.fetchWorkspaces();
          setState(() {
            // Setelah refresh, panggil setState untuk memicu pembaruan widget
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: FutureBuilder<List<DocumentReference<Workspace>>>(
            future: c.fetchWorkspaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("Tidak ada data.");
              } else {
                final workspaces = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: WorskpaceList(workspaces: workspaces, c: c),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: PopupMenuButton(
            icon: const Icon(Icons.add),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 'add_new_project',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => addProjectDialog(context, a, c),
                  );
                },
                child: const Text('Add New Project'),
              ),
              PopupMenuItem(
                value: 'add_new_workspace',
                onTap: () {},
                child: const Text('Add New Workspace'),
              ),
            ],
          )),
    );
  }

  AlertDialog addProjectDialog(BuildContext context,
      WorkspaceAnimationController a, WorkspaceController c) {
    final formKey = GlobalKey<FormState>();
    final projectNameTextFieldController = TextEditingController();
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
                  final projectName = projectNameTextFieldController.value.text;
                  c.addNewProject(projectName);
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.blue),
              ))
        ],
        title: const Text("Add New Project"),
        // titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter the name of the project"),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: projectNameTextFieldController,
                  autofocus: true,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Project name cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              const Gap(5),
              const Text("Select Workspace to place the project"),
              const Gap(15),
              FutureBuilder(
                future: c.getAllowedWorkspaceNewProject(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "You're not allowed to any workspace",
                          style: TextStyle(color: Colors.red),
                        ),
                        Text("Create or join a workspace!"),
                      ],
                    );
                  }
                  final workspacesSnapshots = snapshot.data!;
                  final List<DropdownMenuItem> workspacesMenuItems =
                      workspacesSnapshots.map(
                    (workspaceSnapshot) {
                      final String workspaceName =
                          workspaceSnapshot.data()!.name ?? '';
                      return DropdownMenuItem(
                          value: workspaceSnapshot.id,
                          child: Text(workspaceName));
                    },
                  ).toList();

                  return DropdownButton(
                    value: c.selectedWorkspaceIdAddProject.value,
                    items: workspacesMenuItems,
                    onChanged: (value) {
                      c.selectedWorkspaceIdAddProject = value as String;
                    },
                  );
                },
              ),
              const Gap(15),
              Text(
                "You must be 'Creator' or 'Co-Creator' of the Workspace",
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              )
            ]));
  }
}

class WorskpaceList extends StatelessWidget {
  final List<DocumentReference<Workspace>> workspaces;
  final WorkspaceController c;
  const WorskpaceList({super.key, required this.workspaces, required this.c});

  @override
  Widget build(BuildContext context) {
    final a = Get.put(WorkspaceAnimationController());
    a.initIsOpen(workspaces.length);
    return ListView.builder(
      itemCount: workspaces.length,
      itemBuilder: (context, index) {
        final workspace = workspaces[index];

        return FutureBuilder(
            future: c.getWorkspaceName(workspace),
            builder: (context, nameSnapshot) {
              if (nameSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (nameSnapshot.hasError) {
                return Text("Error: ${nameSnapshot.error}");
              } else {
                final workspaceName = nameSnapshot.data;
                final projects = c.fetchProjects(workspace);
                return FutureBuilder(
                    future: projects,
                    builder: ((context, projectSnapshot) {
                      if (projectSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (projectSnapshot.hasError) {
                        return Text("Error: ${projectSnapshot.error}");
                      } else if (!projectSnapshot.hasData ||
                          projectSnapshot.data!.isEmpty) {
                        return const Text("Invalid Name");
                      } else {
                        final projectList = projectSnapshot.data;
                        return Obx(() => Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          a.switchPanel(
                                              index, !a.isOpen(index));
                                        },
                                        icon: a.isOpen(index)
                                            ? const Icon(
                                                CupertinoIcons.chevron_up,
                                                size: 25,
                                              )
                                            : const Icon(
                                                CupertinoIcons.chevron_down,
                                                size: 25,
                                              )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        workspaceName.toString(),
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          print("Tombol  ditekan");
                                          Get.toNamed('/workspace/detail',
                                              arguments: {
                                                'workspaceId': workspace.id
                                              });
                                        },
                                        icon: const Icon(
                                            CupertinoIcons.ellipsis)),
                                    const SizedBox(width: 15)
                                  ],
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: a.isOpen(index) == true
                                      ? Column(
                                          children: projectList!.map((project) {
                                            return ProjectTile(
                                                title: project.data().name,
                                                image:
                                                    project.data().personalize[
                                                            'image_link'] ??
                                                        '',
                                                onTap: () {
                                                  Get.toNamed(Routes.PROJECT,
                                                      arguments: {
                                                        "project":
                                                            project.data(),
                                                        "workspace_id":
                                                            workspace.id,
                                                        "project_id": project.id
                                                      });
                                                });
                                          }).toList(),
                                        )
                                      : null,
                                )
                              ],
                            ));
                      }
                    }));
              }
            });
      },
    );
  }
}

class ProjectTile extends StatelessWidget {
  final Function onTap;
  final String image;
  final String title;

  const ProjectTile({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        width: Get.width,
        child: Row(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.alarm)),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            )),
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: const Icon(CupertinoIcons.forward)),
          ],
        ),
      ),
    );
  }
}
