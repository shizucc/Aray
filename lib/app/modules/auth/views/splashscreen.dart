import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Text("Aray[Project]"),
            Spacer(),
            Text("Powered by"),
            Text("Endour Studio")
          ],
        ),
      ),
    );
  }
}
