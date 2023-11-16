import 'package:aray/app/modules/workspaces/controller/controller_workspace_detail.dart';
import 'package:flutter/material.dart';
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
                return ListView(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          //Kotak Nama Workspace
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              children: [
                                Container(
                                    child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Workspace Name',
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                )),
                                Obx(() => Container(
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            a.setDefaultValueTextfield(
                                                a.workspaceNameController,
                                                workspace.name!);
                                            a.switchIsWorkspaceNameEditing(
                                                true);
                                          },
                                          child: a.isWorkspaceNameEditing.value
                                              ? TextField(
                                                  autofocus: true,
                                                  controller:
                                                      a.workspaceNameController,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  onEditingComplete: () {
                                                    c.updateProjectFromTextField(
                                                        'name',
                                                        a.workspaceNameController);
                                                    a.switchIsWorkspaceNameEditing(
                                                        false);
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
                          ),
                          //Kotak deskripsi Workspace
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              children: [
                                Container(
                                    child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Workspace Description',
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 12),
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
                                            a.switcIsWorkspaceDescriptionEditing(
                                                true);
                                          },
                                          child: a.isWorkspaceDescriptionEditing
                                                  .value
                                              ? TextField(
                                                  autofocus: true,
                                                  controller: a
                                                      .workspaceDescriptionController,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  onEditingComplete: () {
                                                    c.updateProjectFromTextField(
                                                        'description',
                                                        a.workspaceDescriptionController);
                                                    a.switcIsWorkspaceDescriptionEditing(
                                                        false);
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
                          ),
                          //Kotak Collaborator
                          Column(children: [
                            Container(
                                child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Member Of Workspace',
                                style: TextStyle(
                                    color: Colors.black38, fontSize: 12),
                              ),
                            )),
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 0.0, right: 0.0),
                              leading: CircleAvatar(
                                maxRadius: 18,
                                backgroundColor:
                                    const Color.fromRGBO(10, 0, 1, 1),
                                child: Image.network(
                                    fit: BoxFit.fill,
                                    "https://cdn1.katadata.co.id/media/images/thumb/2022/11/10/Ilustrasi_Ciri-ciri_Orang_Yang_Bersyukur-2022_11_10-13_22_48_d368708753bdc5c3131472013522d76c_960x640_thumb.jpg"),
                              ),
                              title: const Text("Yudith Nico Priambodo",
                                  style: TextStyle(fontSize: 14)),
                              trailing: const Icon(
                                Icons.more_vert,
                                size: 18,
                              ),
                            ),
                            ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0),
                                leading: const CircleAvatar(
                                  maxRadius: 18,
                                  backgroundColor: Color.fromRGBO(10, 0, 1, 1),
                                ),
                                title: Container(
                                    child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Yudith Nico Priamb",
                                        style: TextStyle(fontSize: 14)),
                                    Text("Creator",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black38,
                                        )),
                                  ],
                                )),
                                trailing: const Icon(
                                  Icons.more_vert,
                                  size: 18,
                                )),
                            ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0),
                                leading: const CircleAvatar(
                                  maxRadius: 18,
                                  backgroundColor: Color.fromRGBO(10, 0, 1, 1),
                                ),
                                title: Container(
                                    child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Yudith Nico Priamb",
                                        style: TextStyle(fontSize: 14)),
                                    Text("Creator",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black38,
                                        )),
                                  ],
                                )),
                                trailing: const Icon(
                                  Icons.more_vert,
                                  size: 18,
                                )),
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
                                          primary: const Color.fromARGB(
                                              255, 222, 177, 230),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                        ),
                                        icon: const Icon(
                                          Icons.add,
                                          size: 20.0,
                                          color: Colors.black54,
                                        ),
                                        label: const Text(
                                          'Add Member',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
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
                                          primary: const Color.fromARGB(
                                              255, 222, 177, 230),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          size: 20.0,
                                          color: Colors.black54,
                                        ),
                                        label: const Text(
                                          'See All',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          //Kotak Boards
                          Column(children: [
                            Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Boards On This Workspace',
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                )),
                            // Kotak list Workspace
                            ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0),
                                leading: Card(
                                  child: const SizedBox(
                                    width: 50,
                                    height: 35,
                                  ),
                                  color: const Color.fromRGBO(236, 72, 89, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                title: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text("Project Osareta",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                            "Created at : 11/10/2023",
                                            style: TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                )),
                            ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0),
                                leading: Card(
                                  child: const SizedBox(
                                    width: 50,
                                    height: 35,
                                  ),
                                  color: const Color.fromRGBO(230, 188, 100, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                title: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text("Lykaia Volume 2",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                            "Created at : 11/10/2023",
                                            style: TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                )),
                            ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0),
                                leading: Card(
                                  child: const SizedBox(
                                    width: 50,
                                    height: 35,
                                  ),
                                  color: const Color.fromRGBO(72, 184, 236, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                title: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text("Project Osareta",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                            "Created at : 11/10/2023",
                                            style: TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: SizedBox(
                                      width: 108,
                                      height: 30,
                                      child: FilledButton.icon(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 222, 177, 230),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          size: 20.0,
                                          color: Colors.black54,
                                        ),
                                        label: const Text(
                                          'See All',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ],
                      ),
                    )
                  ],
                );
              }
            }));
  }
}
