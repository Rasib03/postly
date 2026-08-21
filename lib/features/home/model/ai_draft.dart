import 'package:cloud_firestore/cloud_firestore.dart';

class AiDraft {
  const AiDraft({
    required this.id,
    required this.postBody,
    required this.createdAt,
    this.status = DraftStatus.ready,
  });

  final String id;
  final String postBody;
  final DateTime createdAt;
  final DraftStatus status;

  factory AiDraft.fromMap(String id, Map<String, dynamic> map) {
    return AiDraft(
      id: id,
      postBody: map['postBody'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: DraftStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => DraftStatus.ready,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
    'postBody': postBody,
    'createdAt': FieldValue.serverTimestamp(),
    'status': status.name,
  };
}

enum DraftStatus { ready, published, skipped }
