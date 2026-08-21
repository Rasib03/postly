import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:postly/features/home/model/ai_draft.dart';

class DraftsRepository {
  DraftsRepository({required this.userSub});

  final String userSub;

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userSub)
      .collection('drafts');

  Future<void> saveDraft(AiDraft draft) async {
    await _col.doc(draft.id).set(draft.toMap());
  }

  Future<int> countReadyDrafts() async {
    final snap = await _col.where('status', isEqualTo: 'ready').get();

    return snap.docs.length;
  }

  Future<List<AiDraft>> fetchDrafts({int limit = 10}) async {
    final snap = await _col
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snap.docs.map((d) => AiDraft.fromMap(d.id, d.data())).toList();
  }

  Future<AiDraft?> fetchLatestReadyDraft() async {
    final snap = await _col.where('status', isEqualTo: 'ready').limit(1).get();

    if (snap.docs.isEmpty) return null;
    return AiDraft.fromMap(snap.docs.first.id, snap.docs.first.data());
  }

  Future<void> updateStatus(String draftId, DraftStatus status) async {
    await _col.doc(draftId).update({'status': status.name});
  }

  Future<int> calculateStreak() async {
    final snap = await _col.where('status', isEqualTo: 'published').get();

    if (snap.docs.isEmpty) return 0;

    final days =
        snap.docs
            .map((d) {
              final ts = d.data()['createdAt'];
              if (ts == null) return null;
              final dt = (ts as Timestamp).toDate();
              return DateTime(dt.year, dt.month, dt.day);
            })
            .whereType<DateTime>()
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    if (days.isEmpty) return 0;
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final yesterday = todayOnly.subtract(const Duration(days: 1));

    if (days.first != todayOnly && days.first != yesterday) return 0;

    int streak = 1;
    for (int i = 1; i < days.length; i++) {
      final expected = days[i - 1].subtract(const Duration(days: 1));
      if (days[i] == expected) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  Future<List<AiDraft>> fetchRecentActivity({int limit = 5}) async {
    final snap = await _col
        .where('status', whereIn: ['published', 'ready'])
        .get();

    final drafts =
        snap.docs.map((d) => AiDraft.fromMap(d.id, d.data())).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return drafts.take(limit).toList();
  }
}
