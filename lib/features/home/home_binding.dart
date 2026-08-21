import 'package:get/get.dart';
import 'package:postly/features/authentication/model/linkedin_user.dart';
import 'package:postly/features/authentication/repository/auth_repository.dart';
import 'package:postly/features/authentication/repository/linkedIN_auth_repository.dart';
import 'package:postly/features/home/viewmodel/home_viewmodel.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(LinkedinAuthRepository());
    }
    final authRepository = Get.find<AuthRepository>();

    LinkedInUserProfile? profile;
    final args = Get.arguments;
    if (args is List && args.isNotEmpty && args[0] is LinkedInUserProfile) {
      profile = args[0] as LinkedInUserProfile;
    }
    profile ??= authRepository.storedProfile();
    profile ??= const LinkedInUserProfile(
      accessToken: '',
      firstName: '',
      lastName: '',
      email: '',
    );

    Get.put<HomeViewmodel>(
      HomeViewmodel(userProfile: profile, authRepository: authRepository),
    );
  }
}
