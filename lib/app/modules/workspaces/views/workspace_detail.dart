import 'package:flutter/material.dart';

class WorkspaceDetail extends StatelessWidget {
  const WorkspaceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects"),
        actions: <Widget>[
          Padding(padding: const EdgeInsets.only(right: 20.0),
          child : PopupMenuButton(
              icon: Icon(Icons.more_horiz),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'End This Workspace',
                // ignore: unnecessary_const
                child: Text('End This Workspace', style: TextStyle(color: Color(0xffFF0000))),
              ),
            ],
            onSelected: (dynamic value) {
              print(value);
            }),
            )
        ],
      ),
       body: ListView(
        children: <Widget> [
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
                  child:Text(
                  'Workspace Name', 
                  style: TextStyle(
                    color:Colors.black38, 
                    fontSize: 12),),
                  )),
                  Container(
                child: const Align(alignment: Alignment.centerLeft, child: Text('Endour Studio', 
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                  ))),
                  
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
                    child:Text(
                      'Workspace Description', 
                      style: TextStyle(
                        color:Colors.black38, 
                        fontSize: 12),),
                  )),
                  Container(
                child: const Align(
                  alignment: Alignment.centerLeft, 
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sollicitudin diam metus, ac interdum neque rhoncus sed. Nullam id lobortis nibh. Nulla a felis tortor. Praesent commodo eros hendrerit, tempus diam vitae, pharetra arcu. Sed commodo mollis dolor, et molestie nulla lacinia eu.', 
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ))),
                ],
              ),
            ),
            //Kotak Collaborator
            Column(
                children: [
                  Container(
                  child: const Align(
                    alignment: Alignment.centerLeft, 
                    child:Text(
                      'Member Of Workspace', 
                      style: TextStyle(
                        color:Colors.black38, 
                        fontSize: 12),),
                  )),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0,right: 0.0),
                    leading: CircleAvatar(
                    maxRadius: 18,
                    backgroundColor: Color.fromRGBO(10, 0, 1, 1),
                   ),
                   title: Text("Yudith Nico Priambodo",
                   style: TextStyle(fontSize: 14)
                   ),
                   trailing: Icon(Icons.more_vert,size: 18,),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0,right: 0.0),
                    leading: CircleAvatar(
                    maxRadius: 18,
                    backgroundColor: Color.fromRGBO(10, 0, 1, 1),
                   ),
                   title: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Yudith Nico Priamb",
                            style: TextStyle(fontSize: 14)),
                            Text("Creator",
                              style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                              )
                            ),
                          ],
                        ) 
                   ), 
                   trailing: Icon(Icons.more_vert,size: 18,)
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0,right: 0.0),
                    leading: CircleAvatar(
                    maxRadius: 18,
                    backgroundColor: Color.fromRGBO(10, 0, 1, 1),
                   ),
                   title: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Yudith Nico Priamb",
                            style: TextStyle(fontSize: 14)),
                            Text("Creator",
                              style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                              )
                            ),
                          ],
                        ) 
                   ), 
                   trailing: Icon(Icons.more_vert,size: 18,)
                  ),
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
                              primary: const Color.fromARGB(255, 222, 177, 230),
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                            icon: Icon(Icons.add,
                              size: 20.0,
                              color: Colors.black54,
                            ),
                            label: Text(
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
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                            icon: Icon(Icons.arrow_drop_down,
                              size: 20.0,
                              color: Colors.black54,
                            ),
                            label: Text(
                              'See All',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ),
                          ),
                        ),
                        
                      ],
                    ),  
                  ),
                ]
              ),
            //Kotak Boards
            Column(
              children: [
                  Container(
                  margin: EdgeInsets.only(top: 30),
                  child: const Align(
                    alignment: Alignment.centerLeft, 
                    child:Text(
                      'Boards On This Workspace', 
                      style: TextStyle(
                        color:Colors.black38, 
                        fontSize: 12),),
                  )),
                  // Kotak list Workspace
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0,right: 0.0),
                    leading: Card(
                      child: SizedBox(
                        width: 50,
                        height: 35,
                      ),
                      color: Color.fromRGBO(236, 72, 89, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),),
                   title: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Project Osareta",
                      style: TextStyle(fontSize: 14)
                      ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Created at : 11/10/2023",
                      style: TextStyle(fontSize: 10)
                      ),
                      ),
                    ],
                   ), 
                   ) 
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0,right: 0.0),
                     leading: Card(
                      child: SizedBox(
                        width: 50,
                        height: 35,
                      ),
                      color: Color.fromRGBO(230, 188, 100, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),),
                   title: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Lykaia Volume 2",
                      style: TextStyle(fontSize: 14)
                      ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Created at : 11/10/2023",
                      style: TextStyle(fontSize: 10)
                      ),
                      ),
                    ],
                   ), 
                   ) 
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0,right: 0.0),
                    leading: Card(
                      child: SizedBox(
                        width: 50,
                        height: 35,
                      ),
                      color: Color.fromRGBO(72, 184, 236, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),),
                   title: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Project Osareta",
                      style: TextStyle(fontSize: 14)
                      ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Created at : 11/10/2023",
                      style: TextStyle(fontSize: 10)
                      ),
                      ),
                    ],
                   ), 
                   ) 
                  ),
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
                              primary: const Color.fromARGB(255, 222, 177, 230),
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                            icon: Icon(Icons.arrow_drop_down,
                              size: 20.0,
                              color: Colors.black54,
                            ),
                            label: Text(
                              'See All',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ),
                          ),
                        ),
                        
                      ],
                    ),  
                  ),
                ]
              ),
          ],
        ),
       )
        ],
       )
       
      
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