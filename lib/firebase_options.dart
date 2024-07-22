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
    apiKey: 'AIzaSyC2cInu0sqmze6EvMV7_BCP9LfJvjA9KSI',
    appId: '1:988071215040:web:2b5079c4cc5c6dc7d65225',
    messagingSenderId: '988071215040',
    projectId: 'flutter-webview-universal',
    authDomain: 'flutter-webview-universal.firebaseapp.com',
    storageBucket: 'flutter-webview-universal.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLyYkz4QaNf8e3sXkTUBuw4gwtx6TJfYc',
    appId: '1:988071215040:android:b2e579ab0a35297fd65225',
    messagingSenderId: '988071215040',
    projectId: 'flutter-webview-universal',
    storageBucket: 'flutter-webview-universal.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrJ_U0T6t97-ukpOiytOxDxCq7ZHzNXqQ',
    appId: '1:988071215040:ios:166b567faa64e192d65225',
    messagingSenderId: '988071215040',
    projectId: 'flutter-webview-universal',
    storageBucket: 'flutter-webview-universal.appspot.com',
    iosBundleId: 'com.example.arthashaktiWebview',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCrJ_U0T6t97-ukpOiytOxDxCq7ZHzNXqQ',
    appId: '1:988071215040:ios:166b567faa64e192d65225',
    messagingSenderId: '988071215040',
    projectId: 'flutter-webview-universal',
    storageBucket: 'flutter-webview-universal.appspot.com',
    iosBundleId: 'com.example.arthashaktiWebview',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2cInu0sqmze6EvMV7_BCP9LfJvjA9KSI',
    appId: '1:988071215040:web:148f8e770682bc1ed65225',
    messagingSenderId: '988071215040',
    projectId: 'flutter-webview-universal',
    authDomain: 'flutter-webview-universal.firebaseapp.com',
    storageBucket: 'flutter-webview-universal.appspot.com',
  );
}
