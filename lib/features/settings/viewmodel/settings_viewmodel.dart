import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/route_names.dart';
import 'package:postly/core/repository/user_preferences_repository.dart';
import 'package:postly/features/authentication/model/linkedin_user.dart';
import 'package:postly/features/authentication/repository/auth_repository.dart';
import 'package:postly/features/preferences/model/preferences_model.dart';

class SettingsViewmodel extends GetxController {
  SettingsViewmodel({
    required LinkedInUserProfile userProfile,
    required AuthRepository authRepository,
  }) : _userProfile = userProfile,
       _authRepository = authRepository,
       _prefsRepo = UserPreferencesRepository(
         userSub: userProfile.sub?.isNotEmpty == true
             ? userProfile.sub!
             : 'anonymous',
       );

  final LinkedInUserProfile _userProfile;
  final AuthRepository _authRepository;
  final UserPreferencesRepository _prefsRepo;
  late final RxString firstName;
  late final RxString lastName;
  late final RxString email;
  late final RxString profilePictureUrl;
  final RxBool isConnected = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool autoIncludeLinks = true.obs;
  final RxBool dailyReminders = false.obs;
  final RxList<String> selectedTopics = <String>[].obs;
  final Rx<WritingTone> selectedTone = WritingTone.professional.obs;

  @override
  void onInit() {
    super.onInit();

    firstName = _userProfile.firstName.obs;
    lastName = _userProfile.lastName.obs;
    email = _userProfile.email.obs;
    profilePictureUrl = (_userProfile.profilePictureUrl ?? '').obs;

    _checkConnection();
    _loadPreferences();
  }

  String get fullName => '${firstName.value} ${lastName.value}'.trim();
  bool get hasPicture => profilePictureUrl.value.isNotEmpty;
  String get initials {
    final f = firstName.value.isNotEmpty ? firstName.value[0] : '';
    final l = lastName.value.isNotEmpty ? lastName.value[0] : '';
    return (f + l).toUpperCase();
  }

  String get topicsSummary {
    if (selectedTopics.isEmpty) return 'None selected';
    return selectedTopics.take(3).join(', ') +
        (selectedTopics.length > 3
            ? ' +${selectedTopics.length - 3} more'
            : '');
  }

  Future<void> _checkConnection() async {
    try {
      isConnected.value = await _authRepository.isLinkedInConnected();
    } catch (_) {
      isConnected.value = false;
    }
  }

  Future<void> _loadPreferences() async {
    isLoading.value = true;
    try {
      final prefs = await _prefsRepo.fetch();
      autoIncludeLinks.value = prefs.autoIncludeLinks;
      dailyReminders.value = prefs.dailyReminders;
      selectedTopics.assignAll(prefs.selectedTopics);
      selectedTone.value = WritingTone.values.firstWhere(
        (t) => t.name == prefs.writingTone,
        orElse: () => WritingTone.professional,
      );
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAutoIncludeLinks(bool value) async {
    autoIncludeLinks.value = value;
    await _prefsRepo.patch({'autoIncludeLinks': value});
  }

  Future<void> toggleDailyReminders(bool value) async {
    dailyReminders.value = value;
    await _prefsRepo.patch({'dailyReminders': value});
  }

  Future<void> logOut() async {
    isLoading.value = true;
    try {
      await _authRepository.disconnectLinkedIn();
    } finally {
      isLoading.value = false;
    }
    Get.offAllNamed(Routes.signIn);
  }

  void navigateToPreferences() => Get.toNamed(Routes.preferences);

  void openTonePicker(BuildContext context) => Get.toNamed(Routes.preferences);
}
