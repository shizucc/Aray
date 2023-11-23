import 'package:flutter/material.dart';

class MyButtonIcon extends StatelessWidget {
  const MyButtonIcon({super.key, required this.icon, required this.onTap});

  final Icon icon;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      // margin: const EdgeInsets.only(right: 10, bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: icon,
          ),
        ),
      ),
    );
  }
}
