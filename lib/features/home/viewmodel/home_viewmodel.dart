import 'package:get/get.dart';
import 'package:postly/app/route_names.dart';
import 'package:postly/features/authentication/model/linkedin_user.dart';
import 'package:postly/features/authentication/repository/auth_repository.dart';

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
  // late final RxString _email;
  late final RxString _profilePictureUrl;

  final RxBool _isConnected = false.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _skipDraft = false.obs;

  @override
  void onInit() {
    super.onInit();
    _firstName = _userProfile.firstName.obs;
    _lastName = _userProfile.lastName.obs;
    // _email = _userProfile.email.obs;
    _profilePictureUrl = (_userProfile.profilePictureUrl ?? '').obs;

    checkConnectionStatus();
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

  void toggleSkipDraft() {
    _skipDraft.value = !_skipDraft.value;
  }

  void settingsTapped() {
    Get.toNamed(Routes.settings, arguments: _userProfile);
    return;
  }

  void reviewTapped() {
    Get.toNamed(Routes.reviewEdit);
    return;
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
  bool get skipDraft => _skipDraft.value;
}
