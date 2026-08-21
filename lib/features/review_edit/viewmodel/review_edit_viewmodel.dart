import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:postly/core/services/notification_service.dart';
import 'package:postly/features/home/model/ai_draft.dart';
import 'package:postly/features/home/repository/draft_repository.dart';
import 'package:postly/features/home/repository/linkedin_publish_repository.dart';

class ReviewEditViewmodel extends GetxController {
  ReviewEditViewmodel({required AiDraft draft})
    : _originalDraft = draft,
      postBody = draft.postBody.obs;

  final AiDraft _originalDraft;

  final RxString postBody;
  final RxBool isPublishing = false.obs;
  final RxBool isSavingDraft = false.obs;

  Future<void> publishToLinkedIn() async {
    if (isPublishing.value) return;
    isPublishing.value = true;

    try {
      final storage = GetStorage();
      final accessToken = storage.read<String>('linkedin_access_token') ?? '';
      final sub = storage.read<String>('linkedin_sub') ?? '';

      if (accessToken.isEmpty) {
        Get.snackbar('Authentication Error', "Please sign in again.");
        return;
      }

      final publisher = LinkedInPublishRepository();
      String personUrn = sub;

      if (personUrn.isEmpty) {
        personUrn = await publisher.fetchPersonUrn(accessToken);
      }

      await publisher.publishPost(
        accessToken: accessToken,
        personUrn: personUrn,
        postText: postBody.value,
      );

      await NotificationService.instance.cancelDraftNotification(
        _originalDraft.id,
      );

      await _markAsPublished();

      Get.back();
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
      final message = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Publish failed',
        message,
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

  Future<void> saveDraft() async {
    if (isSavingDraft.value) return;
    isSavingDraft.value = true;

    try {
      final sub = GetStorage().read<String>('linkedin_sub') ?? 'anonymous';
      final repo = DraftsRepository(userSub: sub);

      final updated = AiDraft(
        id: _originalDraft.id,
        postBody: postBody.value,
        createdAt: _originalDraft.createdAt,
        status: DraftStatus.ready,
      );

      await repo.saveDraft(updated);

      Get.snackbar(
        '📋 Draft saved',
        'Your edits have been saved.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE3F2FD),
        colorText: const Color(0xFF0D47A1),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        borderRadius: 14,
        duration: const Duration(seconds: 3),
      );
    } on Exception catch (e) {
      Get.snackbar(
        'Save failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSavingDraft.value = false;
    }
  }

  Future<void> _markAsPublished() async {
    try {
      final sub = GetStorage().read<String>('linkedin_sub') ?? 'anonymous';
      final repo = DraftsRepository(userSub: sub);
      await repo.updateStatus(_originalDraft.id, DraftStatus.published);
    } catch (_) {}
  }
}
