import 'package:aray/app/data/model/model_invitation.dart';
import 'package:aray/app/global_widgets/loading_text.dart';
import 'package:aray/app/modules/notification/controller/controller_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final a = Get.find<NotificationAnimationController>();
    final c = Get.find<NotificationController>();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        title: const Text("Notifications"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        child: SingleChildScrollView(
            child: StreamBuilder(
          stream: c.streamInvitations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingText(labelText: "Crunching your notifications"),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("An error encountered"),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("Empty"),
              );
            }
            final invitationsSnapshot = snapshot.data!.docs;
            final List<NotificationTile> notificationsTile =
                invitationsSnapshot.map(
              (invitationSnapshot) {
                return NotificationTile(
                  invitationSnapshot: invitationSnapshot,
                );
              },
            ).toList();
            return Container(
              child: Column(
                children: notificationsTile,
              ),
            );
          },
        )),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.invitationSnapshot});

  final QueryDocumentSnapshot<Invitation> invitationSnapshot;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotificationController>();
    final Invitation invitation = invitationSnapshot.data();
    final bool isInvitationResponded = invitation.status != '';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.mail),
          const Gap(15),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: RichText(
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                          TextSpan(
                              text: "${invitation.senderName} ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            text: "invites you to join ",
                          ),
                          TextSpan(
                              text: "${invitation.workspaceName} ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            text: "workspace",
                          ),
                        ])))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: !isInvitationResponded
                          ? Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      c.acceptInvitation(invitationSnapshot);
                                    },
                                    child: const Text("Accept")),
                                TextButton(
                                    onPressed: () {
                                      c.deleteInvitation(invitationSnapshot.id);
                                    },
                                    child: const Text("Delete",
                                        style: TextStyle(color: Colors.black))),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                        "Status : ${invitation.status.capitalizeFirst!}"),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      c.deleteInvitation(invitationSnapshot.id);
                                    },
                                    child: const Text("Delete",
                                        style: TextStyle(color: Colors.black)))
                              ],
                            ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
