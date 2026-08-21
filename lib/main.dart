import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linkedin_login_android/linkedin_login_android.dart';
import 'package:linkedin_login_ios/linkedin_login_ios.dart';
import 'package:postly/app/app.dart';
import 'package:postly/core/services/notification_service.dart';
import 'package:postly/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

const String kPrefGeminiApiKey = 'postly_gemini_api_key_bg';

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

  await NotificationService.instance.init();

  await NotificationService.instance.requestPermission();

  final storage = GetStorage();
  final storedToken = storage.read<String>('linkedin_access_token') ?? '';
  final storedUrn = storage.read<String>('linkedin_sub') ?? '';

  if (storedToken.isNotEmpty) {
    await NotificationService.instance.mirrorCredentials(
      accessToken: storedToken,
      personUrn: storedUrn,
    );
  }

  final geminiKey = dotenv.get('GEMENI_API_KEY', fallback: '');
  if (geminiKey.isNotEmpty) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefGeminiApiKey, geminiKey);
    debugPrint('[main] Gemini API key mirrored.');
  }

  runApp(const MyApp());
}
