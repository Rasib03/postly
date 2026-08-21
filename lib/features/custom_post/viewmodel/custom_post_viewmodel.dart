import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:postly/features/home/model/ai_draft.dart';
import 'package:postly/features/home/repository/ai_draft_repository.dart';
import 'package:postly/features/home/repository/draft_repository.dart';
import 'package:postly/features/home/repository/linkedin_publish_repository.dart';
import 'package:postly/features/home/viewmodel/home_viewmodel.dart';
import 'package:postly/features/preferences/model/preferences_model.dart';

class CustomPostViewmodel extends GetxController {
  final RxString generatedPost = ''.obs;
  final RxBool isGenerating = false.obs;
  final RxBool isPublishing = false.obs;

  final _aiRepo = AiDraftRepository();
  final _publishRepo = LinkedInPublishRepository();

  Future<void> generate({
    required String topic,
    required WritingTone tone,
  }) async {
    if (isGenerating.value) return;
    isGenerating.value = true;
    generatedPost.value = '';

    try {
      final text = await _aiRepo.generateCustomPost(
        topic: topic,
        tone: tone.label,
      );

      if (text.trim().isEmpty) {
        throw Exception('AI returned an empty response. Please try again.');
      }

      generatedPost.value = text;
    } on Exception catch (e) {
      Get.snackbar(
        'Generation failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEBEE),
        colorText: const Color(0xFFB71C1C),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        borderRadius: 14,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isGenerating.value = false;
    }
  }

  Future<void> publish({required String postText}) async {
    if (isPublishing.value || postText.trim().isEmpty) return;
    isPublishing.value = true;

    try {
      final storage = GetStorage();
      final accessToken = storage.read<String>('linkedin_access_token') ?? '';
      var personUrn = storage.read<String>('linkedin_sub') ?? '';

      if (accessToken.isEmpty) {
        throw Exception('No access token found. Please sign in again.');
      }

      if (personUrn.isEmpty) {
        personUrn = await _publishRepo.fetchPersonUrn(accessToken);
      }

      await _publishRepo.publishPost(
        accessToken: accessToken,
        personUrn: personUrn,
        postText: postText,
      );

      await _saveDraftAsPublished(postText);

      Get.back();

      if (Get.isRegistered<HomeViewmodel>()) {
        Get.find<HomeViewmodel>().refreshData();
      }

      Get.snackbar(
        '🎉 Published!',
        'Your post is now live on LinkedIn.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE8F5E9),
        colorText: const Color(0xFF1B5E20),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        borderRadius: 14,
        duration: const Duration(seconds: 4),
      );
    } on Exception catch (e) {
      Get.snackbar(
        'Publish failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEBEE),
        colorText: const Color(0xFFB71C1C),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        borderRadius: 14,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isPublishing.value = false;
    }
  }

  Future<void> _saveDraftAsPublished(String postText) async {
    try {
      final sub = GetStorage().read<String>('linkedin_sub') ?? 'anonymous';
      final repo = DraftsRepository(userSub: sub);
      final draft = AiDraft(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postBody: postText,
        createdAt: DateTime.now(),
        status: DraftStatus.published,
      );
      await repo.saveDraft(draft);
    } catch (_) {}
  }
}
