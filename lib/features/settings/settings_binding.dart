import 'package:get/get.dart';
import 'package:postly/features/authentication/model/linkedin_user.dart';
import 'package:postly/features/authentication/repository/auth_repository.dart';
import 'package:postly/features/authentication/repository/linkedIN_auth_repository.dart';
import 'package:postly/features/settings/viewmodel/settings_viewmodel.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(LinkedinAuthRepository());
    }
    final authRepository = Get.find<AuthRepository>();

    LinkedInUserProfile? profile = Get.arguments as LinkedInUserProfile?;
    profile ??= authRepository.storedProfile();
    profile ??= const LinkedInUserProfile(
      accessToken: '',
      firstName: '',
      lastName: '',
      email: '',
    );

    Get.put<SettingsViewmodel>(
      SettingsViewmodel(userProfile: profile, authRepository: authRepository),
    );
  }
}
