import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:postly/app/route_names.dart';
import 'package:postly/core/repository/user_preferences_repository.dart';

class SplashViewmodel extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));

    final storage = GetStorage();
    final token = storage.read<String>('linkedin_access_token');
    final isLoggedIn = token != null && token.isNotEmpty;

    if (!isLoggedIn) {
      Get.offAllNamed(Routes.signIn);
      return;
    }

    final sub = storage.read<String>('linkedin_sub') ?? 'anonymous';
    final repo = UserPreferencesRepository(userSub: sub);
    final hasOnboarded = await repo.hasCompletedOnboarding();

    if (hasOnboarded) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.preferences);
    }
  }
}
