import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProjectAdd extends StatelessWidget {
  const ProjectAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close),
        title: Center(child: Text("Add New Project")),
        actions: [Icon(CupertinoIcons.check_mark)],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: ListView(
          children: [
            Text(
              "Project Name",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Your Project Name",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Workpsace",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Icon(CupertinoIcons.chevron_down),
                Text(
                  "Endour Studio",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Project Description",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(
              height: 4,
            ),
            Text("Your Project Description",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400))
          ],
        ),
      )),
    );
  }
}
