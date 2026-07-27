class LinkedInUserProfile {
  const LinkedInUserProfile({
    required this.accessToken,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePictureUrl,
    this.sub,
  });

  final String accessToken;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePictureUrl;
  final String? sub;

  String get fullName => '$firstName $lastName'.trim();

  @override
  String toString() =>
      'LinkedInUserProfile(name: $fullName, email: $email, sub: $sub)';
}
