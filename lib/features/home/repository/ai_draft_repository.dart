import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiDraftRepository {
  late final GenerativeModel _model;

  AiDraftRepository() {
    _model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: dotenv.get("GEMENI_API_KEY"),
    );
  }

  Future<String> generateLinkedInPost({
    required String tone,
    required List<String> selectedTopics,
  }) async {
    if (selectedTopics.isEmpty) {
      throw Exception(
        'No topics selected. Please set your topics in Preferences first.',
      );
    }

    final prompt =
        '''
You are a LinkedIn content writer. Write a LinkedIn post on one of these topics: ${selectedTopics.join(', ')}.
Focus on the latest developments in that area.

Tone: $tone

Requirements:
- 150-250 words
- Start with a strong hook
- Include 3-5 relevant hashtags at the end
- Write in first person
- Sound natural, not like an AI wrote it
- Do NOT include any URLs
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text;
    if (text == null || text.trim().isEmpty) {
      throw Exception('AI returned an empty response. Please try again.');
    }
    return text;
  }

  Future<String> generateCustomPost({
    required String topic,
    required String tone,
  }) async {
    final prompt =
        '''
You are a LinkedIn content writer. Write a LinkedIn post based on the user's idea below.

Tone: $tone
User's idea / topic: $topic

Requirements:
- 150-250 words
- Start with a strong hook that grabs attention
- Include 3-5 relevant hashtags at the end
- Write in first person
- Sound natural and conversational, not like an AI wrote it
- Do NOT mention that this was AI-generated
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }
}
