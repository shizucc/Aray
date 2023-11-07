import 'package:flutter/material.dart';

class DialogDeleteProjectCover extends StatelessWidget {
  const DialogDeleteProjectCover({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
              mainAxisAlignment: MainAxisAlignment.end,
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
                    onPressed: () {},
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
