import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferences {
  const UserPreferences({
    this.selectedTopics = const [],
    this.writingTone = 'professional',
    this.dailyReminders = false,
  });

  final List<String> selectedTopics;
  final String writingTone;
  final bool dailyReminders;

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      selectedTopics: List<String>.from(map['selectedTopics'] ?? []),
      writingTone: (map['writingTone'] as String?) ?? 'professional',
      dailyReminders: (map['dailyReminders'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'selectedTopics': selectedTopics,
    'writingTone': writingTone,
    'dailyReminders': dailyReminders,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  UserPreferences copyWith({
    List<String>? selectedTopics,
    String? writingTone,
    bool? dailyReminders,
  }) {
    return UserPreferences(
      selectedTopics: selectedTopics ?? this.selectedTopics,
      writingTone: writingTone ?? this.writingTone,
      dailyReminders: dailyReminders ?? this.dailyReminders,
    );
  }
}

class UserPreferencesRepository {
  UserPreferencesRepository({required this.userSub});

  final String userSub;

  static const _collection = 'users';
  static const _settingsDoc = 'settings';
  static const _prefsDoc = 'preferences';

  DocumentReference<Map<String, dynamic>> get _ref => FirebaseFirestore.instance
      .collection(_collection)
      .doc(userSub)
      .collection(_settingsDoc)
      .doc(_prefsDoc);

  Future<UserPreferences> fetch() async {
    final snap = await _ref.get();
    if (!snap.exists || snap.data() == null) {
      return const UserPreferences();
    }
    return UserPreferences.fromMap(snap.data()!);
  }

  Future<void> save(UserPreferences prefs) async {
    await _ref.set(prefs.toMap(), SetOptions(merge: true));
  }

  Future<bool> hasCompletedOnboarding() async {
    try {
      final snap = await _ref.get();
      if (!snap.exists || snap.data() == null) return false;
      final topics = snap.data()!['selectedTopics'];
      return topics is List && topics.isNotEmpty;
    } catch (_) {
      return true;
    }
  }

  Future<void> patch(Map<String, dynamic> fields) async {
    await _ref.set({
      ...fields,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
