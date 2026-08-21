import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_login/linkedin_login.dart';
import 'package:postly/features/authentication/model/linkedin_user.dart';
import 'package:postly/features/authentication/repository/auth_repository.dart';

class LinkedinAuthRepository implements AuthRepository {
  final GetStorage _storage = GetStorage();
  static const String _keyToken = 'linkedin_access_token';
  @override
  Future<LinkedInUserProfile> signInWithLinkedIn() {
    final completer = Completer<LinkedInUserProfile>();

    Get.to<void>(
      () => LinkedInUserWidget(
        redirectUrl: dotenv.get("REDIRECT_URL"),
        clientId: dotenv.get("CLIENT_ID"),
        clientSecret: dotenv.get("CLIENT_SECRET"),
        destroySession: true,
        scope: const [
          OpenIdScope(),
          EmailScope(),
          ProfileScope(),
          _MemberSocialScope(),
        ],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: CloseButton(
            onPressed: () {
              Get.back();
              if (!completer.isCompleted) {
                completer.completeError(
                  Exception('User cancelled LinkedIn sign-in.'),
                );
              }
            },
          ),
          title: const Text('Sign in with LinkedIn'),
        ),
        onGetUserProfile: (UserSucceededAction action) async {
          if (completer.isCompleted) return;
          final user = action.user;
          final accessToken = user.token.accessToken ?? "";

          final profile = LinkedInUserProfile(
            accessToken: accessToken,
            firstName: user.givenName ?? '',
            lastName: user.familyName ?? '',
            email: user.email ?? '',
            profilePictureUrl: user.picture,
            sub: user.sub,
          );

          if (accessToken.isNotEmpty) {
            await _storage.write(_keyToken, accessToken);
            await _storage.write('linkedin_first_name', profile.firstName);
            await _storage.write('linkedin_last_name', profile.lastName);
            await _storage.write('linkedin_email', profile.email);
            await _storage.write('linkedin_picture', profile.profilePictureUrl);
            await _storage.write('linkedin_sub', profile.sub);
          }
          Get.back();
          completer.complete(profile);
        },
        onError: (UserFailedAction error) {
          if (completer.isCompleted) return;
          Get.back();
          completer.completeError(
            Exception('LinkedIn sign-in failed: ${error.exception}'),
          );
        },
      ),
      fullscreenDialog: true,
    );

    return completer.future;
  }

  @override
  Future<void> disconnectLinkedIn() async {
    await _storage.remove(_keyToken);
    await _storage.remove('linkedin_first_name');
    await _storage.remove('linkedin_last_name');
    await _storage.remove('linkedin_email');
    await _storage.remove('linkedin_picture');
    await _storage.remove('linkedin_sub');
  }

  @override
  Future<bool> isLinkedInConnected() async {
    final token = _storage.read<String>(_keyToken);
    if (token == null || token.isEmpty) return false;

    try {
      final response = await http
          .get(
            Uri.parse('https:
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 401 || response.statusCode == 403) {

        await disconnectLinkedIn();
        return false;
      }

      return response.statusCode == 200;
    } catch (_) {

      return false;
    }
  }

  @override
  LinkedInUserProfile? storedProfile() {
    final token = _storage.read<String>(_keyToken);
    if (token == null || token.isEmpty) return null;
    return LinkedInUserProfile(
      accessToken: token,
      firstName: _storage.read<String>('linkedin_first_name') ?? '',
      lastName: _storage.read<String>('linkedin_last_name') ?? '',
      email: _storage.read<String>('linkedin_email') ?? '',
      profilePictureUrl: _storage.read<String>('linkedin_picture'),
      sub: _storage.read<String>('linkedin_sub'),
    );
  }
}

class _MemberSocialScope extends Scope {
  const _MemberSocialScope() : super('w_member_social');
}
