import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:postly/app/route_names.dart';
import 'package:postly/core/repository/user_preferences_repository.dart';
import 'package:postly/core/services/notification_service.dart';
import 'package:postly/features/home/model/ai_draft.dart';
import 'package:postly/features/home/repository/ai_draft_repository.dart';
import 'package:postly/features/home/repository/draft_repository.dart';
import 'package:postly/features/authentication/model/linkedin_user.dart';
import 'package:postly/features/authentication/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewmodel extends GetxController {
  HomeViewmodel({
    required LinkedInUserProfile userProfile,
    required AuthRepository authRepository,
  }) : _userProfile = userProfile,
       _authRepository = authRepository;

  final LinkedInUserProfile _userProfile;
  final AuthRepository _authRepository;

  late final RxString _firstName;
  late final RxString _lastName;
  late final RxString _profilePictureUrl;
  final Rxn<AiDraft> todaysDraft = Rxn<AiDraft>();
  final RxInt readyDraftCount = 0.obs;
  final RxInt dayStreak = 0.obs;
  final RxBool isDraftLoading = false.obs;
  final RxBool isDraftError = false.obs;
  final RxString draftErrorMessage = ''.obs;
  final RxBool _isConnected = false.obs;
  final RxBool _isLoading = false.obs;

  final RxList<AiDraft> recentActivity = <AiDraft>[].obs;

  @override
  void onInit() {
    super.onInit();
    _firstName = _userProfile.firstName.obs;
    _lastName = _userProfile.lastName.obs;
    _profilePictureUrl = (_userProfile.profilePictureUrl ?? '').obs;

    _syncOnLaunch();
    checkConnectionStatus();
  }

  Future<void> _syncOnLaunch() async {
    await _syncBackgroundPublish();
    await _syncBackgroundDraft();
    await loadOrGenerateDraft();
  }

  Future<void> _syncBackgroundPublish() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingId = prefs.getString(kPrefPendingSyncId);
      if (pendingId == null || pendingId.isEmpty) return;

      debugPrint('[HomeViewmodel] Syncing BG-published draft: $pendingId');

      final repo = DraftsRepository(userSub: _userProfile.sub ?? 'anonymous');
      await repo.updateStatus(pendingId, DraftStatus.published);
      await NotificationService.instance.cancelDraftNotification(pendingId);
      await prefs.remove(kPrefPendingSyncId);

      debugPrint('[HomeViewmodel] ✅ Publish sync complete for $pendingId');
    } catch (e) {

      debugPrint('[HomeViewmodel] ⚠️  Publish sync failed: $e');
    }
  }

  Future<void> _syncBackgroundDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString('postly_pending_bg_draft');
      if (draftJson == null || draftJson.isEmpty) return;

      final map = jsonDecode(draftJson) as Map<String, dynamic>;
      final draftId = (map['id'] as String?) ?? '';
      final postBody = (map['postBody'] as String?) ?? '';

      if (draftId.isEmpty || postBody.isEmpty) {
        await prefs.remove('postly_pending_bg_draft');
        return;
      }

      debugPrint(
        '[HomeViewmodel] Saving BG-generated draft to Firestore: $draftId',
      );

      final draft = AiDraft(
        id: draftId,
        postBody: postBody,

        createdAt:
            DateTime.tryParse(map['createdAt'] as String? ?? '') ??
            DateTime.now(),
        status: DraftStatus.ready,
      );

      final repo = DraftsRepository(userSub: _userProfile.sub ?? 'anonymous');
      await repo.saveDraft(draft);

      await prefs.remove('postly_pending_bg_draft');

      debugPrint('[HomeViewmodel] ✅ BG draft saved to Firestore: $draftId');
    } catch (e) {
      debugPrint('[HomeViewmodel] ⚠️  BG draft sync failed: $e');
    }
  }

  Future<void> checkConnectionStatus() async {
    _isLoading.value = true;
    try {
      _isConnected.value = await _authRepository.isLinkedInConnected();
    } catch (_) {
      _isConnected.value = false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> disconnectLinkedIn() async {
    _isLoading.value = true;
    try {
      await _authRepository.disconnectLinkedIn();
      _isConnected.value = false;
    } finally {
      _isLoading.value = false;
    }
  }

  void settingsTapped() =>
      Get.toNamed(Routes.settings, arguments: _userProfile);

  void reviewTapped() =>
      Get.toNamed(Routes.reviewEdit, arguments: todaysDraft.value);

  void refreshData() => loadOrGenerateDraft();

  Future<void> skipDraftTapped(String draftId) async {
    try {
      final repo = DraftsRepository(userSub: _userProfile.sub ?? 'anonymous');
      await repo.updateStatus(draftId, DraftStatus.skipped);
      await NotificationService.instance.cancelDraftNotification(draftId);
      todaysDraft.value = null;
      await loadOrGenerateDraft();
    } catch (_) {
      todaysDraft.value = null;
    }
  }

  Future<void> deleteScheduledDraft(String draftId) async {
    try {
      final repo = DraftsRepository(userSub: _userProfile.sub ?? 'anonymous');
      await repo.updateStatus(draftId, DraftStatus.skipped);
      await NotificationService.instance.cancelDraftNotification(draftId);
      recentActivity.removeWhere((d) => d.id == draftId);
      if (todaysDraft.value?.id == draftId) {
        todaysDraft.value = null;
        await loadOrGenerateDraft();
      }
    } catch (_) {}
  }

  String get initials {
    final f = _firstName.value.isNotEmpty ? _firstName.value[0] : '';
    final l = _lastName.value.isNotEmpty ? _lastName.value[0] : '';
    return (f + l).toUpperCase();
  }

  String get fullName => '${_firstName.value} ${_lastName.value}'.trim();
  String get firstName => _firstName.value;
  String get lastName => _lastName.value;
  String get profilePicture => _profilePictureUrl.value;
  bool get hasPicture => _profilePictureUrl.value.isNotEmpty;
  bool get isConnected => _isConnected.value;
  bool get isLoading => _isLoading.value;

  Future<void> loadOrGenerateDraft() async {
    isDraftLoading.value = true;
    isDraftError.value = false;
    draftErrorMessage.value = '';

    try {
      final draftsRepo = DraftsRepository(
        userSub: _userProfile.sub ?? 'anonymous',
      );

      final streak = await draftsRepo.calculateStreak();
      dayStreak.value = streak;

      final activity = await draftsRepo.fetchRecentActivity();
      recentActivity.assignAll(activity);

      final existing = await draftsRepo.fetchLatestReadyDraft();
      if (existing != null) {
        todaysDraft.value = existing;
        readyDraftCount.value = await draftsRepo.countReadyDrafts();
        return;
      }

      final prefsRepo = UserPreferencesRepository(
        userSub: _userProfile.sub ?? 'anonymous',
      );
      final userPrefs = await prefsRepo.fetch();

      final aiRepo = AiDraftRepository();
      final postBody = await aiRepo.generateLinkedInPost(
        tone: userPrefs.writingTone,
        selectedTopics: userPrefs.selectedTopics,
      );

      final draft = AiDraft(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postBody: postBody,
        createdAt: DateTime.now(),
      );

      await draftsRepo.saveDraft(draft);
      todaysDraft.value = draft;
      readyDraftCount.value = await draftsRepo.countReadyDrafts();

      final personUrn = GetStorage().read<String>('linkedin_sub') ?? '';
      await NotificationService.instance.showDraftReadyNotification(
        draftId: draft.id,
        postBody: draft.postBody,
        personUrn: personUrn,
      );
    } catch (e) {
      isDraftError.value = true;
      draftErrorMessage.value = e.toString().replaceFirst('Exception: ', '');
      debugPrint('[HomeViewmodel] loadOrGenerateDraft failed: $e');
    } finally {
      isDraftLoading.value = false;
    }
  }
}
