import 'package:aray/app/data/model/model_workspace.dart';
import 'package:aray/app/modules/auth/bindings/bindings_login_page.dart';
import 'package:aray/app/modules/auth/views/login_page.dart';
import 'package:aray/app/modules/projects/bindings/bindings_project.dart';
import 'package:aray/app/modules/projects/views/project.dart';
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
        page: () => const Project(),
        binding: ProjectBinding()),
    GetPage(
        name: _Paths.LOGINPAGE,
        page: () => const LoginPage(),
        binding: LoginPageBinding()),
    GetPage(
        name: _Paths.WORSPACE,
        page: () => const WorkspacePage(),
        binding: WorkspaceBinding())
  ];
}
