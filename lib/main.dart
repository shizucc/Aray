import 'package:aray/app/modules/auth/views/login_page.dart';
import 'package:aray/app/modules/projects/views/project_view.dart';
import 'package:aray/app/modules/workspaces/views/workspaces_view.dart';
import 'package:aray/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'Aray',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff2A042B)),
        useMaterial3: true,
      ),
      getPages: AppPages.routes,
      home: _streamUser(),
    );
  }
}

Widget _streamUser() {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        if (snapshot.data == null) {
          return const LoginPage();
        } else {
          return const WorkspacePage();
        }
      } else {
        return CircularProgressIndicator(); // Atau widget lain untuk menunggu
      }
    },
  );
}
