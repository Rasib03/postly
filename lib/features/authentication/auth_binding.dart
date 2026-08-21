import 'package:get/get.dart';
import 'package:postly/features/authentication/repository/auth_repository.dart';
import 'package:postly/features/authentication/repository/linkedIN_auth_repository.dart';
import 'package:postly/features/authentication/viewmodel/sign_in_viewmodel.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(LinkedinAuthRepository());
    Get.put<SignInViewmodel>(
      SignInViewmodel(repository: Get.find<AuthRepository>()),
    );
  }
}
