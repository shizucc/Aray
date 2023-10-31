import 'package:aray/app/modules/activity/bindings/bindings_activity.dart';
import 'package:aray/app/modules/activity/views/activity_view.dart';
import 'package:aray/app/modules/auth/bindings/bindings_login_page.dart';
import 'package:aray/app/modules/auth/views/login_page.dart';
import 'package:aray/app/modules/projects/bindings/bindings_project.dart';
import 'package:aray/app/modules/projects/bindings/bindings_project_detail.dart';
import 'package:aray/app/modules/projects/views/project_detail.dart';
import 'package:aray/app/modules/projects/views/project_view.dart';
import 'package:aray/app/modules/workspaces/bindings/bindings_workspace.dart';
import 'package:aray/app/modules/workspaces/views/workspaces_view.dart';
import 'package:get/get.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGINPAGE;

  static final routes = [
    GetPage(
        name: _Paths.PROJECT,
        page: () => const ProjectView(),
        binding: ProjectBinding()),
    GetPage(
        name: _Paths.LOGINPAGE,
        page: () => const LoginPage(),
        binding: LoginPageBinding()),
    GetPage(
        name: _Paths.WORKSPACE,
        page: () => const WorkspacePage(),
        binding: WorkspaceBinding()),
    GetPage(
        name: _Paths.ACTIVITY,
        page: () => const ActivityView(),
        binding: ActivityBinding()),
    GetPage(
        name: _Paths.PROJECTDETAIL,
        page: () => const ProjectDetail(),
        binding: ProjectDetailBinding())
  ];
}
