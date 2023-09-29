// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCq3rkU6JvM2ne0cygeXmh7HOHSb4Vey0A',
    appId: '1:89093935615:web:5a6e1473ef1c254ca717ca',
    messagingSenderId: '89093935615',
    projectId: 'project-aray',
    authDomain: 'project-aray.firebaseapp.com',
    storageBucket: 'project-aray.appspot.com',
    measurementId: 'G-6V90CD731X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdqRuIHwvh9Ey0EZ1ZWZ5Nlx-U4Qmnw8Q',
    appId: '1:89093935615:android:d4a07852f7016869a717ca',
    messagingSenderId: '89093935615',
    projectId: 'project-aray',
    storageBucket: 'project-aray.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbGgXyiiMppbPQZUWGoKuOJ4zd_enmOvA',
    appId: '1:89093935615:ios:cae0f87c2de4c562a717ca',
    messagingSenderId: '89093935615',
    projectId: 'project-aray',
    storageBucket: 'project-aray.appspot.com',
    iosClientId: '89093935615-onibdcrp4f1l8dniidois5cnbjik1m5a.apps.googleusercontent.com',
    iosBundleId: 'com.example.aray',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbGgXyiiMppbPQZUWGoKuOJ4zd_enmOvA',
    appId: '1:89093935615:ios:ab03d86b0a28ff07a717ca',
    messagingSenderId: '89093935615',
    projectId: 'project-aray',
    storageBucket: 'project-aray.appspot.com',
    iosClientId: '89093935615-ahri8oqa50vuf0bm81vq80u32kapin3a.apps.googleusercontent.com',
    iosBundleId: 'com.example.aray.RunnerTests',
  );
}
