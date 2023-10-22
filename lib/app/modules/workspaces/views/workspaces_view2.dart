import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkspaceView2 extends StatelessWidget {
  const WorkspaceView2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Endour Studio'),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_horiz),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Text('Edit'),
                value: 'Edit',
              ),
              PopupMenuItem(
                child: Text('Delete'),
                value: 'Delete',
              ),
            ],
            onSelected: (dynamic value) {
              print(value);
            }),
          ),
          Card(
            color: Color.fromARGB(255, 255, 237, 237),
            child: ListTile(
              leading:Icon(Icons.rectangle_rounded, color: Color.fromARGB(255, 255, 194, 194), size: 30.0),
              title: Text('Project Osareta'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
          Card(
            color: Color.fromARGB(255, 255, 241, 233),
            child: ListTile(
              leading:Icon(Icons.rectangle_rounded, color: Color.fromARGB(255, 255, 216, 194), size: 30.0),
              title: Text('Lykaia Volume 2'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
          Card(
            color: Color.fromARGB(255, 231, 227, 255),
            child: ListTile(
              leading:Icon(Icons.rectangle_rounded, color: Color.fromARGB(255, 203, 194, 255), size: 30.0),
              title: Text('Project Osareta 2'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print("Test");  
      },  
      foregroundColor: Color.fromARGB(255, 61, 2, 66),
      backgroundColor: Color.fromARGB(255, 236, 188, 250),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)) ),
      child: Icon(Icons.add),
      ),

    );
  }
}