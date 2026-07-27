import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:postly/core/repository/user_preferences_repository.dart';
import 'package:postly/features/preferences/viewmodel/preferences_viewmodel.dart';

class PreferencesBinding extends Bindings {
  @override
  void dependencies() {
    final sub = _resolveSub();
    final repo = UserPreferencesRepository(userSub: sub);

    Get.put<PreferencesViewmodel>(PreferencesViewmodel(repository: repo));
  }

  String _resolveSub() {
    final args = Get.arguments;
    if (args is List && args.isNotEmpty) {
      try {
        // ignore: avoid_dynamic_calls
        final sub = (args[0] as dynamic).sub as String?;
        if (sub != null && sub.isNotEmpty) return sub;
      } catch (_) {}
    }
    return GetStorage().read<String>('linkedin_sub') ?? 'anonymous';
  }
}
