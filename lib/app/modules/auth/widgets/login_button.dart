import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginButtonIcon extends StatelessWidget {
  const LoginButtonIcon(
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
      width: Get.width,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: labelTextStyle,
                ),
                const SizedBox(
                  width: 15,
                ),
                icon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
