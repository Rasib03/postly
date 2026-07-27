import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linkedin_login_android/linkedin_login_android.dart';
import 'package:linkedin_login_ios/linkedin_login_ios.dart';
import 'package:postly/app/app.dart';
import 'package:postly/firebase_options.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidWebViewPlatform.registerWith();
    LinkedinLoginAndroid.registerWith();
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    WebKitWebViewPlatform.registerWith();
    LinkedinLoginIos.registerWith();
  }

  await dotenv.load(fileName: '.env');
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
