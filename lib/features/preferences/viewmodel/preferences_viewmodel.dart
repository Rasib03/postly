import 'package:get/get.dart';
import 'package:postly/app/route_names.dart';
import 'package:postly/core/repository/user_preferences_repository.dart';
import 'package:postly/features/preferences/model/preferences_model.dart';

class PreferencesViewmodel extends GetxController {
  PreferencesViewmodel({required UserPreferencesRepository repository})
    : _repository = repository;

  final UserPreferencesRepository _repository;
  final RxSet<String> selectedTopics = <String>{}.obs;
  final Rx<WritingTone> selectedTone = WritingTone.professional.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    isLoading.value = true;
    try {
      final prefs = await _repository.fetch();
      selectedTopics.assignAll(prefs.selectedTopics);
      selectedTone.value = _toneFromName(prefs.writingTone);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTopic(TopicItem topic) {
    if (selectedTopics.contains(topic.label)) {
      selectedTopics.remove(topic.label);
    } else {
      selectedTopics.add(topic.label);
    }
  }

  void setTone(WritingTone tone) => selectedTone.value = tone;

  Future<void> saveAndContinue() async {
    isSaving.value = true;
    try {
      await _repository.save(
        UserPreferences(
          selectedTopics: selectedTopics.toList(),
          writingTone: selectedTone.value.name,
          dailyReminders: false,
        ),
      );
      _navigateAfterSave();
    } catch (_) {
      Get.snackbar(
        'Save failed',
        'Could not save preferences. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  void skip() {
    if (Get.previousRoute == Routes.settings) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.home, arguments: Get.arguments);
    }
  }

  void _navigateAfterSave() {
    if (Get.previousRoute == Routes.settings) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.home, arguments: Get.arguments);
    }
  }

  WritingTone _toneFromName(String name) {
    return WritingTone.values.firstWhere(
      (t) => t.name == name,
      orElse: () => WritingTone.professional,
    );
  }
}
