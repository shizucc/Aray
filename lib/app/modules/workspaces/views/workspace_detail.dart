import 'package:aray/app/modules/workspaces/controller/controller_workspace.dart';
import 'package:aray/app/modules/workspaces/controller/controller_workspace_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkspaceDetail extends StatelessWidget {
  const WorkspaceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final a = Get.put(WorkspaceDetailAnimationController());
    final c = Get.put(WorkspaceDetailController());
    // final args = Get.arguments;
    // final String workspaceId = args["workspaceId"] ?? '';

    return Scaffold(
        appBar: AppBar(
          title: Text("Projects"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: PopupMenuButton(
                  icon: Icon(Icons.more_horiz),
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
            stream: c.streamWorkspace('Tn0zXxCGh2YM1alngXLP'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Terdapat Error");
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
                                                  style: TextStyle(
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
                                                  style: TextStyle(
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
                            margin: EdgeInsets.only(bottom: 20.0),
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
                                                  style: TextStyle(
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
                                                  style: TextStyle(
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
                                  EdgeInsets.only(left: 0.0, right: 0.0),
                              leading: CircleAvatar(
                                maxRadius: 18,
                                backgroundColor: Color.fromRGBO(10, 0, 1, 1),
                                child: Image.network(
                                    fit: BoxFit.fill,
                                    "https://cdn1.katadata.co.id/media/images/thumb/2022/11/10/Ilustrasi_Ciri-ciri_Orang_Yang_Bersyukur-2022_11_10-13_22_48_d368708753bdc5c3131472013522d76c_960x640_thumb.jpg"),
                              ),
                              title: Text("Yudith Nico Priambodo",
                                  style: TextStyle(fontSize: 14)),
                              trailing: Icon(
                                Icons.more_vert,
                                size: 18,
                              ),
                            ),
                            ListTile(
                                contentPadding:
                                    EdgeInsets.only(left: 0.0, right: 0.0),
                                leading: CircleAvatar(
                                  maxRadius: 18,
                                  backgroundColor: Color.fromRGBO(10, 0, 1, 1),
                                ),
                                title: Container(
                                    child: Row(
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
                                trailing: Icon(
                                  Icons.more_vert,
                                  size: 18,
                                )),
                            ListTile(
                                contentPadding:
                                    EdgeInsets.only(left: 0.0, right: 0.0),
                                leading: CircleAvatar(
                                  maxRadius: 18,
                                  backgroundColor: Color.fromRGBO(10, 0, 1, 1),
                                ),
                                title: Container(
                                    child: Row(
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
                                trailing: Icon(
                                  Icons.more_vert,
                                  size: 18,
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 140,
                                      height: 30,
                                      child: FilledButton.icon(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 222, 177, 230),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                        ),
                                        icon: Icon(
                                          Icons.add,
                                          size: 20.0,
                                          color: Colors.black54,
                                        ),
                                        label: Text(
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                        ),
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          size: 20.0,
                                          color: Colors.black54,
                                        ),
                                        label: Text(
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
                                margin: EdgeInsets.only(top: 30),
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
                                contentPadding:
                                    EdgeInsets.only(left: 0.0, right: 0.0),
                                leading: Card(
                                  child: SizedBox(
                                    width: 50,
                                    height: 35,
                                  ),
                                  color: Color.fromRGBO(236, 72, 89, 1),
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
                                        child: Text("Project Osareta",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Created at : 11/10/2023",
                                            style: TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                )),
                            ListTile(
                                contentPadding:
                                    EdgeInsets.only(left: 0.0, right: 0.0),
                                leading: Card(
                                  child: SizedBox(
                                    width: 50,
                                    height: 35,
                                  ),
                                  color: Color.fromRGBO(230, 188, 100, 1),
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
                                        child: Text("Lykaia Volume 2",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Created at : 11/10/2023",
                                            style: TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                )),
                            ListTile(
                                contentPadding:
                                    EdgeInsets.only(left: 0.0, right: 0.0),
                                leading: Card(
                                  child: SizedBox(
                                    width: 50,
                                    height: 35,
                                  ),
                                  color: Color.fromRGBO(72, 184, 236, 1),
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
                                        child: Text("Project Osareta",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Created at : 11/10/2023",
                                            style: TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 10),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                        ),
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          size: 20.0,
                                          color: Colors.black54,
                                        ),
                                        label: Text(
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
            })

        // ListView(
        //   children: <Widget>[
        //     ListTile(
        //       title: Text('Endour Studio'),
        //       trailing: PopupMenuButton(
        //         icon: Icon(Icons.more_horiz),
        //         itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        //         PopupMenuItem(
        //           child: Text('Edit'),
        //           value: 'Edit',
        //         ),
        //         PopupMenuItem(
        //           child: Text('Delete'),
        //           value: 'Delete',
        //         ),
        //       ],
        //       onSelected: (dynamic value) {
        //         print(value);
        //       }),
        //     ),
        //     Card(
        //       color: Color.fromARGB(255, 255, 237, 237),
        //       child: ListTile(
        //         leading:Icon(Icons.rectangle_rounded, color: Color.fromARGB(255, 255, 194, 194), size: 30.0),
        //         title: Text('Project Osareta'),
        //         trailing: Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //     ),
        //     Card(
        //       color: Color.fromARGB(255, 255, 241, 233),
        //       child: ListTile(
        //         leading:Icon(Icons.rectangle_rounded, color: Color.fromARGB(255, 255, 216, 194), size: 30.0),
        //         title: Text('Lykaia Volume 2'),
        //         trailing: Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //     ),
        //     Card(
        //       color: Color.fromARGB(255, 231, 227, 255),
        //       child: ListTile(
        //         leading:Icon(Icons.rectangle_rounded, color: Color.fromARGB(255, 203, 194, 255), size: 30.0),
        //         title: Text('Project Osareta 2'),
        //         trailing: Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //     ),
        //   ],
        // ),
        // floatingActionButton: FloatingActionButton(onPressed: (){
        //   print("Test");
        // },
        // foregroundColor: Color.fromARGB(255, 61, 2, 66),
        // backgroundColor: Color.fromARGB(255, 236, 188, 250),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)) ),
        // child: Icon(Icons.add),
        // ),

        );
  }
}
