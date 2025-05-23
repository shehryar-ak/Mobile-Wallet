// ignore_for_file: constant_identifier_names
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_BYzgSaOd0Bh8LHx5_ZdzxZ1ynGfodVI',
    authDomain: 'expense-tracker-5e8eb.firebaseapp.com',
    projectId: 'expense-tracker-5e8eb',
    storageBucket: 'expense-tracker-5e8eb.firebasestorage.app',
    messagingSenderId: '239655716279',
    appId: '1:239655716279:web:b281680e0f40c589aa5432',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6uEIWPc7qA6rZSIGldXqqJLwbz2TOuyU',
    appId: '1:239655716279:android:78a2db86bad1c396aa5432',
    messagingSenderId: '239655716279',
    projectId: 'expense-tracker-5e8eb',
    storageBucket: 'expense-tracker-5e8eb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCg8vE3DQmq7nIR1TxE4pC56bfgFkxpcxk',
    appId: '1:239655716279:ios:4f6aee201094f044aa5432',
    messagingSenderId: '239655716279',
    projectId: 'expense-tracker-5e8eb',
    storageBucket: 'expense-tracker-5e8eb.firebasestorage.app',
    iosBundleId: 'myapp',
    // iosClientId is optional, since it's not provided in your plist, you can omit it or leave it null
  );
}
