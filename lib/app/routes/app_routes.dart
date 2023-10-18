part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const LOGINPAGE = _Paths.LOGINPAGE;
  static const WORKSPACE = _Paths.WORKSPACE;
  static const PROJECT = _Paths.PROJECT;
  static const ACTIVITY = _Paths.ACTIVITY;
}

abstract class _Paths {
  _Paths._();
  static const LOGINPAGE = "/loginPage";
  static const WORKSPACE = "/workspace";
  static const PROJECT = "/project";
  static const ACTIVITY = "/activity";
}
