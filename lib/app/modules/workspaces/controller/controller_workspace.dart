import 'package:aray/app/data/model/model_project.dart';
import 'package:aray/app/data/model/model_user_workspace.dart';
import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/projects/controller/crud_controller_project.dart';
import 'package:aray/app/modules/workspaces/controller/crud_controller_workspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkspaceAnimationController extends GetxController {
  // Expansion Workspaces Panel List
  final _isOpen = <bool>[].obs;

  // Variabel for add new project

  // Init _isOpen for each Panel
  void initIsOpen(int length) {
    for (int i = 0; i < length; i++) {
      _isOpen.add(true);
    }
  }

  bool isOpen(int index) {
    return _isOpen[index];
  }

  // Switch
  void switchPanel(int i, bool isOpen) {
    _isOpen[i] = isOpen;
  }

  // Operation in Add New Project
}

class WorkspaceController extends GetxController {
  final RxString selectedWorkspaceIdAddProject = ''.obs;
  final User? user = FirebaseAuth.instance.currentUser;
  final RxString userId = ''.obs;
  set selectedWorkspaceIdAddProject(value) =>
      selectedWorkspaceIdAddProject.value = value;

  set userId(value) => userId.value = value;

  Future<void> setUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.get('userId') as String;
    userId = userIdFromPrefs;
  }

  CollectionReference<UserWorkspace> userWorkspacesRef() =>
      FirebaseFirestore.instance.collection('user_workspace').withConverter(
          fromFirestore: (snapshot, _) =>
              UserWorkspace.fromJson(snapshot.data()!),
          toFirestore: (UserWorkspace userWorkspace, _) =>
              userWorkspace.toJson());

  CollectionReference<Workspace> workspacesRef() =>
      FirebaseFirestore.instance.collection('workspace').withConverter(
          fromFirestore: (snapshot, _) => Workspace.fromJson(snapshot.data()!),
          toFirestore: (Workspace workspace, _) => workspace.toJson());

  Future<void> logOutWithGoogle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<String> getWorkspaceName(DocumentReference<Workspace> docs) async {
    final name = await docs.get().then((value) => value.data()!.name);
    return name.toString();
  }

  Future<List<DocumentReference<Workspace>>> fetchWorkspaces() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.get('userId');

    // Mendapatkan List Berupa UserWorkspace milik User login
    final List<QueryDocumentSnapshot<UserWorkspace>> listUserWorkspaces =
        await userWorkspacesRef()
            .where('user_id', isEqualTo: userId)
            .get()
            .then((value) => value.docs);

    final List<DocumentReference<Workspace>> listWorkspace = [];
    await Future.wait(listUserWorkspaces.map((element) async {
      final workspaceId = element.data().workspaceId;
      final workspace = workspacesRef().doc(workspaceId);

      listWorkspace.add(workspace);
    }));
    return listWorkspace;
  }

  // Fungsi untuk menghasilkan list project dengan parameter satu buah Workspace
  Future<List<QueryDocumentSnapshot<Project>>> fetchProjects(
      DocumentReference<Workspace> workspace) async {
    final projectRef = workspace.collection('project').withConverter(
        fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
        toFirestore: (Project project, _) => project.toJson());

    final List<QueryDocumentSnapshot<Project>> listProject =
        await projectRef.get().then((value) => value.docs);

    return listProject;
  }

  // Func for getting the Workpace can be added new project by this user
  Future<List<DocumentSnapshot<Workspace>>>
      getAllowedWorkspaceNewProject() async {
    final List<String> allowedToCreate = ['creator', 'co-creator'];
    final allowedUserWorkspacesSnapshot = await userWorkspacesRef()
        .where('user_id', isEqualTo: userId.value)
        .where('permission', whereIn: allowedToCreate)
        .get();

    final allowedUserWorkspaces = allowedUserWorkspacesSnapshot.docs;

    final List<DocumentSnapshot<Workspace>> allowedWorkspaceSnapshots = [];

    for (var userWorkspace in allowedUserWorkspaces) {
      final workspaceId = userWorkspace.data().workspaceId;
      final workspaceSnapshot = await workspacesRef().doc(workspaceId).get();

      allowedWorkspaceSnapshots.add(workspaceSnapshot);
    }
    // Init the first workspace to Workspace Dropdown;
    final firstWorkspaceId = allowedWorkspaceSnapshots.first.id;
    selectedWorkspaceIdAddProject = firstWorkspaceId;

    return allowedWorkspaceSnapshots;
  }

  // Operation for project
  Future<void> addNewProject(String projectName) async {
    final workspaceId = selectedWorkspaceIdAddProject.value;
    final CollectionReference<Project> projectRef = workspacesRef()
        .doc(workspaceId)
        .collection('project')
        .withConverter(
            fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
            toFirestore: (Project project, _) => project.toJson());

    final Project project = Project(
        name: projectName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        personalize: {
          'color': 'color_black',
          'image': '',
          'image_dominant_color': 0,
          'image_link': '',
          'use_image': false
        },
        order: 1);
    await ProjectCRUDController.addNew(projectRef, project);
  }

  // Operation for workspace
  Future<void> addNewWorkspace(String workspaceName) async {
    final Workspace workspace = Workspace(
        name: workspaceName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    final userIdDump = userId.value;
    await WorkspaceCRUDController.addNew(
        userWorkspacesRef(), workspacesRef(), workspace, userIdDump);
  }
}
