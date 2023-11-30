import 'package:flutter/material.dart';

class MyTextButtonIcon extends StatelessWidget {
  const MyTextButtonIcon(
      {super.key,
      required this.label,
      required this.icon,
      this.backgroundColor = Colors.white,
      this.labelTextStyle = const TextStyle(),
      required this.onTap});
  final String label;
  final Icon icon;
  final Color backgroundColor;
  final TextStyle labelTextStyle;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(
                  width: 5,
                ),
                Text(
                  label,
                  style: labelTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
