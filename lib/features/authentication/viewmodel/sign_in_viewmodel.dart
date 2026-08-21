import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/route_names.dart';
import 'package:postly/core/repository/user_preferences_repository.dart';
import 'package:postly/core/services/notification_service.dart';
import 'package:postly/features/authentication/model/linkedin_user.dart';
import 'package:postly/features/authentication/repository/auth_repository.dart';

class SignInViewmodel extends GetxController {
  SignInViewmodel({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;

  final RxBool isLoading = false.obs;
  final Rxn<LinkedInUserProfile> profile = Rxn<LinkedInUserProfile>();

  Future<void> linkedINTapped() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final result = await _repository.signInWithLinkedIn();
      profile.value = result;
      await _navigateAfterSignIn(result);
    } on Exception catch (e) {
      final raw = e.toString().replaceFirst('Exception: ', '');
      if (raw.contains('cancelled')) return;
      _showErrorSnackbar(raw);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _navigateAfterSignIn(LinkedInUserProfile user) async {
    final sub = user.sub?.isNotEmpty == true ? user.sub! : 'anonymous';
    final repo = UserPreferencesRepository(userSub: sub);
    final hasOnboarded = await repo.hasCompletedOnboarding();

    if (user.accessToken.isNotEmpty) {
      await NotificationService.instance.mirrorCredentials(
        accessToken: user.accessToken,
        personUrn: user.sub ?? '',
      );
    }

    if (hasOnboarded) {
      Get.offAllNamed(Routes.home, arguments: [user, _repository]);
    } else {
      Get.offAllNamed(Routes.preferences, arguments: [user, _repository]);
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Sign-in failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      borderRadius: 14,
      backgroundColor: const Color(0xFFFFEBEE),
      colorText: const Color(0xFFB71C1C),
      icon: const Icon(Icons.error_outline_rounded, color: Color(0xFFE53935)),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
    );
  }
}
