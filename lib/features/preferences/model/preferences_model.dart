class TopicItem {
  const TopicItem({required this.emoji, required this.label});

  final String emoji;
  final String label;
}

enum WritingTone {
  professional('Professional & Informative'),
  casual('Casual & Engaging'),
  storyteller('Storyteller / Thought Leader');

  const WritingTone(this.label);
  final String label;
}

abstract class PreferencesData {
  static const List<TopicItem> topics = [
    TopicItem(emoji: '📱', label: 'Flutter & Mobile Dev'),
    TopicItem(emoji: '🤖', label: 'AI & Machine Learning'),
    TopicItem(emoji: '💻', label: 'Web Development'),
    TopicItem(emoji: '⚡', label: 'Tech News & Trends'),
    TopicItem(emoji: '🚀', label: 'Startups & SaaS'),
    TopicItem(emoji: '📊', label: 'Data Science'),
    TopicItem(emoji: '🔐', label: 'Cybersecurity'),
    TopicItem(emoji: '☁️', label: 'Cloud & DevOps'),
  ];
}
