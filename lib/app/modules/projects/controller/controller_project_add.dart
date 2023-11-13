import 'package:flutter/material.dart';

class ProjectAddController {
  // Controller logic goes here
}

class ProjectAddTab {
  final String title;
  final IconData icon;
  final Widget content;

  ProjectAddTab({required this.title, required this.icon, required this.content});
}

class ProjectAddDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              // Handle drawer item click for home
            },
          ),
          ListTile(
            title: Text("Projects"),
            leading: Icon(Icons.folder),
            onTap: () {
              // Handle drawer item click for projects
            },
          ),
          Divider(),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
            onTap: () {
              // Handle drawer item click for settings
            },
          ),
        ],
      ),
    );
  }
}
