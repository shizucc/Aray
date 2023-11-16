import 'package:flutter/material.dart';

class EditableCheckTile extends StatefulWidget {
  const EditableCheckTile(
      {super.key,
      required this.title,
      required this.textEditingController,
      required this.onFinishEditing});
  final String title;
  final Function onFinishEditing;
  final TextEditingController textEditingController;

  @override
  State<EditableCheckTile> createState() => _EditableCheckTileState();
}

class _EditableCheckTileState extends State<EditableCheckTile> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onLongPress: () {
                print("Longpress");
              },
              onTap: () {
                setState(() {
                  isEditing = true;
                });
              },
              child: isEditing
                  ? TextField(
                      autofocus: true,
                      onEditingComplete: () {
                        setState(() {
                          isEditing = false;
                        });
                        widget.onFinishEditing();
                      },
                    )
                  : Text(widget.title),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.check_box))
        ],
      ),
    );
  }
}
