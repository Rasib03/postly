class PostHistoryItem {
  const PostHistoryItem({
    required this.dateLabel,
    required this.teaser,
    required this.status,
    required this.linkedInUrl,
  });

  final String dateLabel;
  final String teaser;
  final PostStatus status;
  final String linkedInUrl;
}

enum PostStatus { published, scheduled }
