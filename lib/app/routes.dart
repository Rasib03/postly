import 'package:get/get.dart';
import 'package:postly/app/route_names.dart';
import 'package:postly/core/middlewares/auth_middleware.dart';
import 'package:postly/features/authentication/auth_binding.dart';
import 'package:postly/features/authentication/view/sign_in.dart';
import 'package:postly/features/custom_post/custom_post_bindings.dart';
import 'package:postly/features/custom_post/view/custom_post.dart';
import 'package:postly/features/home/home_binding.dart';
import 'package:postly/features/home/view/home.dart';
import 'package:postly/features/preferences/preferences_binding.dart';
import 'package:postly/features/preferences/view/preferences_screen.dart';
import 'package:postly/features/review_edit/review_edit_binding.dart';
import 'package:postly/features/review_edit/view/review_edit_screen.dart';
import 'package:postly/features/settings/settings_binding.dart';
import 'package:postly/features/settings/view/settings_screen.dart';
import 'package:postly/features/splash/splash_binding.dart';
import 'package:postly/features/splash/view/splash.dart';

class AppPages {
  AppPages._();

  static const String initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const Splash(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.signIn,
      page: () => const SignIn(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.preferences,
      page: () => const PreferencesScreen(),
      binding: PreferencesBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.reviewEdit,
      page: () => const ReviewEditScreen(),
      binding: ReviewEditBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.home,
      page: () => const Home(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.customPost,
      page: () => CustomPost(),
      binding: CustomPostBinding(),
    ),
  ];
}
