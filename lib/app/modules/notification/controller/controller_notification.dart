import 'package:aray/app/data/model/model_invitation.dart';
import 'package:aray/app/data/model/model_user.dart';
import 'package:aray/app/data/model/model_user_workspace.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/notification/controller/crud_controller_notification.dart';
import 'package:aray/app/modules/workspaces/controller/crud_controller_user_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationAnimationController extends GetxController {}

class NotificationController extends GetxController {
  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.get('userId') as String;
    return userIdFromPrefs;
  }

  CollectionReference<UserWorkspace> userWorkspacesRef() =>
      FirebaseFirestore.instance.collection('user_workspace').withConverter(
          fromFirestore: (snapshot, _) =>
              UserWorkspace.fromJson(snapshot.data()!),
          toFirestore: (UserWorkspace userWorkspace, _) =>
              userWorkspace.toJson());

  CollectionReference<UserModel> usersRef() =>
      FirebaseFirestore.instance.collection('user').withConverter(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (UserModel user, _) => user.toJson());

  CollectionReference<Workspace> workspacesRef() =>
      FirebaseFirestore.instance.collection('workspace').withConverter(
          fromFirestore: (snapshot, _) => Workspace.fromJson(snapshot.data()!),
          toFirestore: (Workspace workspace, _) => workspace.toJson());

  Future<CollectionReference<Invitation>> invitationsRef() async {
    final invitationsRef = usersRef()
        .doc(await getUserId())
        .collection("invitation")
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Invitation.fromJson(snapshot.data()!),
            toFirestore: (Invitation user, _) => user.toJson());
    return invitationsRef;
  }

  Future<List<QueryDocumentSnapshot<Invitation>>> getInvitations() async {
    final ref = await invitationsRef();
    final invitationsSnapshot = await ref.get();

    final invitations = invitationsSnapshot.docs;
    return invitations;
  }

  Stream<QuerySnapshot<Invitation>> streamInvitations() async* {
    final ref = await invitationsRef();
    final invitationsSnapshot = ref.snapshots();
    yield* invitationsSnapshot;
  }

  Future<DocumentSnapshot<Workspace>> getWorkspace(String workspaceId) async {
    final workspaceSnapshot = await workspacesRef().doc(workspaceId).get();
    return workspaceSnapshot;
  }

  Future<void> acceptInvitation(
      QueryDocumentSnapshot<Invitation> invitationSnapshot) async {
    // Search userId with email
    // final userId = userSnapshot.id;
    await UserWorkspaceCRUDController.join(userWorkspacesRef(),
        invitationSnapshot.data().workspaceId, await getUserId());

    final refs = await invitationsRef();
    final ref = refs.doc(invitationSnapshot.id);
    await NotificationCRUDController.accept(ref);
  }

  Future<void> deleteInvitation(String inviationId) async {
    final refs = await invitationsRef();
    final ref = refs.doc(inviationId);
    await NotificationCRUDController.delete(ref);
  }
}
