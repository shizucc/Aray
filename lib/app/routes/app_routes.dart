part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const PROJECT = _Paths.PROJECT;
  static const LOGINPAGE = _Paths.LOGINPAGE;
}

abstract class _Paths {
  _Paths._();
  static const PROJECT = "/project";
  static const LOGINPAGE = "/loginPage";
}
