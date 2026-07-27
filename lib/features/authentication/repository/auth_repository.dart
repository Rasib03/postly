import 'package:postly/features/authentication/model/linkedin_user.dart';

abstract class AuthRepository {
  Future<LinkedInUserProfile> signInWithLinkedIn();
  Future<bool> isLinkedInConnected();
  Future<void> disconnectLinkedIn();
  LinkedInUserProfile? storedProfile();
}
