import 'package:aray/app/modules/projects/controller/controller_project_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogDeleteProjectCover extends StatelessWidget {
  const DialogDeleteProjectCover({super.key, required this.c});
  final ProjectDetailController c;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Are you sure to delete this cover?",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: Colors.red),
            ),
            Text(
              "The theme will be back to the default theme",
              style: TextStyle(color: Colors.black.withOpacity(0.7)),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    )),
                TextButton(
                    onPressed: () {
                      c.deleteProjectCoverImage().then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
