// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCUDYkFTMoCGE3yclHzDW4cCsrbeAunZx0',
    appId: '1:251070254807:web:2fad4265494496bed32a92',
    messagingSenderId: '251070254807',
    projectId: 'task-manager-4u',
    authDomain: 'task-manager-4u.firebaseapp.com',
    storageBucket: 'task-manager-4u.firebasestorage.app',
    measurementId: 'G-H4QN23DK17',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC24UdQPYEhZYziQf6GcNBWN_36PUEU79c',
    appId: '1:251070254807:android:dcda16a4554b3460d32a92',
    messagingSenderId: '251070254807',
    projectId: 'task-manager-4u',
    storageBucket: 'task-manager-4u.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBl3d2K8GsWGm8nPj9FGNEgG2ZcqcZv5pY',
    appId: '1:251070254807:ios:ba77f0c418d1a809d32a92',
    messagingSenderId: '251070254807',
    projectId: 'task-manager-4u',
    storageBucket: 'task-manager-4u.firebasestorage.app',
    iosBundleId: 'com.taskers.taskManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBl3d2K8GsWGm8nPj9FGNEgG2ZcqcZv5pY',
    appId: '1:251070254807:ios:ba77f0c418d1a809d32a92',
    messagingSenderId: '251070254807',
    projectId: 'task-manager-4u',
    storageBucket: 'task-manager-4u.firebasestorage.app',
    iosBundleId: 'com.taskers.taskManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUDYkFTMoCGE3yclHzDW4cCsrbeAunZx0',
    appId: '1:251070254807:web:cd0a91cc8912072ad32a92',
    messagingSenderId: '251070254807',
    projectId: 'task-manager-4u',
    authDomain: 'task-manager-4u.firebaseapp.com',
    storageBucket: 'task-manager-4u.firebasestorage.app',
    measurementId: 'G-0DP0LE7PVN',
  );
}