import 'package:get/get.dart';
import 'package:postly/features/custom_post/viewmodel/custom_post_viewmodel.dart';

class CustomPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomPostViewmodel>(CustomPostViewmodel());
  }
}
