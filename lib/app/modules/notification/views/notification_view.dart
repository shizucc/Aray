import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        title: const Text("Notification"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "New",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 20),
                )
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 18,
                  child: Image.network(
                      fit: BoxFit.cover,
                      "https://i.pinimg.com/originals/c1/dc/be/c1dcbe1bce28a1551dbd262aa97ca007.jpg"),
                ),
                const SizedBox(width: 10),
                const Expanded(
                    child: Text(
                        style: TextStyle(fontSize: 15),
                        'Yudith Nico Priambodo invites you to join "Endour Studio" workspace')),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(style: TextStyle(fontSize: 12), "Accept"),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 238, 251),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(style: TextStyle(fontSize: 12), "Decline"),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 251, 233, 233),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(
                        width: 70,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black.withOpacity(0.5)),
                                "12.21"),
                            Text(
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black.withOpacity(0.5)),
                                "12-31-23"),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "All",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 18,
                  child: Image.network(
                      fit: BoxFit.cover,
                      "https://i.pinimg.com/originals/c1/dc/be/c1dcbe1bce28a1551dbd262aa97ca007.jpg"),
                ),
                const SizedBox(width: 10),
                const Expanded(
                    child: Text(
                        style: TextStyle(fontSize: 15),
                        'Yudith Nico Priambodo invites you to join "Endour Studio" workspace')),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        child: const Row(
                          children: [
                            Text(style: TextStyle(fontSize: 12), "Accepted"),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 238, 251),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      const SizedBox(
                        width: 120,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 47),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Text(
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black.withOpacity(0.5)),
                                    "12.21"),
                                Text(
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black.withOpacity(0.5)),
                                    "12-31-23"),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 18,
                  child: Image.network(
                      fit: BoxFit.cover,
                      "https://i.pinimg.com/originals/c1/dc/be/c1dcbe1bce28a1551dbd262aa97ca007.jpg"),
                ),
                const SizedBox(width: 10),
                const Expanded(
                    child: Text(
                        style: TextStyle(fontSize: 15),
                        'Yudith Nico Priambodo invites you to join "Endour Studio" workspace')),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        child: const Row(
                          children: [
                            Text(style: TextStyle(fontSize: 12), "Declined"),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 251, 233, 233),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      const SizedBox(
                        width: 120,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 50),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black.withOpacity(0.5)),
                                    "12.21"),
                                Text(
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black.withOpacity(0.5)),
                                    "12-31-23"),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
