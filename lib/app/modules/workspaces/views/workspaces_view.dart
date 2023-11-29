import 'package:aray/app/data/model/model_color_theme.dart';
import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/global_widgets/loading_box.dart';
import 'package:aray/app/global_widgets/loading_text.dart';
import 'package:aray/app/modules/workspaces/controller/controller_workspace.dart';
import 'package:aray/app/routes/app_pages.dart';
import 'package:aray/utils/color_handler.dart';
import 'package:aray/utils/extension.dart';
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
    c.setUserId();
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.menu),
        title: const Text("Projects"),
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
                return const Center(
                  child: LoadingText(labelText: "Crunching your projects..."),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("An error occurred while loading your projects"),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Let's Start by create or join a workspace!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    addWorkspaceDialog(context, a, c),
                              );
                            },
                            child: const Text("Add New Workspace"))
                      ],
                    ),
                  ),
                );
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
      drawer: Drawer(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipOval(
                          child: Image.network(
                            c.user!.photoURL!,
                            height: 75,
                            width: 75,
                          ),
                        ),
                      ),
                      const Gap(15),
                      Text(
                        "${c.user!.displayName}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text("${c.user!.email}",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.5))),
                    ],
                  ),
                ),
                const Gap(15),
                TextButton.icon(
                    onPressed: () {
                      Get.toNamed('/notification');
                    },
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    icon: const Icon(Icons.notifications),
                    label: const Text("Notifications")),
                TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => logoutDialog(c),
                      );
                    },
                    style: const ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
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
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => addWorkspaceDialog(context, a, c),
                  );
                },
                child: const Text('Add New Workspace'),
              ),
            ],
          )),
    );
  }

  AlertDialog logoutDialog(WorkspaceController c) {
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
                Navigator.pop(context);
                await c.logOutWithGoogle();
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ))
        ],
        title: const Text("Logout"),
        // titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        content: const Text("Are you sure you want to log out?"));
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
                  await c.addNewProject(projectName);
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
              const Text("Enter the name of project"),
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
                  } else if (snapshot.data!.isEmpty) {
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

  AlertDialog addWorkspaceDialog(BuildContext context,
      WorkspaceAnimationController a, WorkspaceController c) {
    final formKey = GlobalKey<FormState>();
    final workspaceNameTextFieldController = TextEditingController();
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
                  final workspaceName =
                      workspaceNameTextFieldController.value.text;
                  await c.addNewWorkspace(workspaceName);

                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.blue),
              ))
        ],
        title: const Text("Add New Workspace"),
        // titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter the name of workspace"),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: workspaceNameTextFieldController,
                  autofocus: true,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Workspace name cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
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
                return Container();
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
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: const Row(
                            children: [
                              LoadingBox(
                                height: 50,
                                width: 50,
                                borderRadius: 15,
                              ),
                              Gap(20),
                              Expanded(
                                child: LoadingBox(
                                  height: 50,
                                  borderRadius: 15,
                                ),
                              ),
                              Gap(10),
                              LoadingBox(
                                height: 50,
                                width: 50,
                                borderRadius: 15,
                              ),
                            ],
                          ),
                        );
                      } else if (projectSnapshot.hasError) {
                        return const Center(child: Text("An error occurred"));
                      }
                      final projectList = projectSnapshot.data;
                      return Obx(() => Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        a.switchPanel(index, !a.isOpen(index));
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
                                        Get.toNamed('/workspace/detail',
                                            arguments: {
                                              'workspaceId': workspace.id
                                            });
                                      },
                                      icon:
                                          const Icon(CupertinoIcons.ellipsis)),
                                  const SizedBox(width: 15)
                                ],
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                child: a.isOpen(index) == true
                                    ? Column(
                                        children: projectList!.map((project) {
                                          return ProjectTile(
                                              projectSnapshot: project,
                                              title: project.data().name,
                                              image: project.data().personalize[
                                                      'image_link'] ??
                                                  '',
                                              onTap: () {
                                                Get.toNamed(Routes.PROJECT,
                                                    arguments: {
                                                      "project": project.data(),
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
  final QueryDocumentSnapshot<Project> projectSnapshot;

  const ProjectTile(
      {super.key,
      required this.title,
      required this.image,
      required this.onTap,
      required this.projectSnapshot});

  @override
  Widget build(BuildContext context) {
    final Project project = projectSnapshot.data();
    final bool isUseImage = project.personalize['use_image'] as bool;
    final Color imageDominantColor = ColorHandler.getColorFromDecimal(
        project.personalize['image_dominant_color'] ?? 0);

    final defaultTheme = ColorTheme(code: project.personalize['color']);
    return Container(
      decoration: BoxDecoration(
          color:
              isUseImage ? imageDominantColor : Color(defaultTheme.baseColor!),
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      width: Get.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => onTap(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                        image: isUseImage
                            ? DecorationImage(
                                image: NetworkImage(
                                  project.personalize['image_link'],
                                ),
                                filterQuality: FilterQuality.low,
                                fit: BoxFit.cover)
                            : null,
                        color: isUseImage
                            ? imageDominantColor
                            : Color(defaultTheme.primaryColor!),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.alarm,
                      color: Colors.transparent,
                    )),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: Text(
                  project.name,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: !isUseImage
                          ? Colors.black
                          : imageDominantColor.isDark
                              ? Colors.white
                              : Colors.black),
                )),
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Icon(
                      CupertinoIcons.forward,
                      color: isUseImage
                          ? imageDominantColor
                          : Color(defaultTheme.primaryColor!),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
