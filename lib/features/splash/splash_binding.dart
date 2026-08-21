import 'package:get/get.dart';
import 'package:postly/features/splash/viewmodel/splash_viewmodel.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashViewmodel>(SplashViewmodel());
  }
}
