import 'dart:convert';
import 'package:http/http.dart' as http;

class LinkedInPublishRepository {
  static const _restBase = 'https:
  static const _v2Base = 'https:

  static const _linkedInVersion = '202601';

  Map<String, String> _restHeaders(String accessToken) => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    'X-Restli-Protocol-Version': '2.0.0',
    'LinkedIn-Version': _linkedInVersion,
  };

  Future<void> publishPost({
    required String accessToken,
    required String personUrn,
    required String postText,
  }) async {
    final uri = Uri.parse('$_restBase/posts');

    final formattedAuthor = personUrn.startsWith('urn:li:person:')
        ? personUrn
        : 'urn:li:person:$personUrn';

    final body = jsonEncode({
      'author': formattedAuthor,
      'commentary': postText,
      'visibility': 'PUBLIC',
      'distribution': {
        'feedDistribution': 'MAIN_FEED',
        'targetEntities': [],
        'thirdPartyDistributionChannels': [],
      },
      'lifecycleState': 'PUBLISHED',
      'isReshareDisabledByAuthor': false,
    });

    final response = await http.post(
      uri,
      headers: _restHeaders(accessToken),
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception(
        'LinkedIn publish failed: ${response.statusCode} — ${response.body}',
      );
    }
  }

  Future<String> fetchPersonUrn(String accessToken) async {
    final uri = Uri.parse('$_v2Base/userinfo');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch LinkedIn profile: ${response.statusCode} — ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final sub = data['sub'] as String?;
    if (sub == null || sub.isEmpty) {
      throw Exception('LinkedIn profile returned empty sub field.');
    }
    return sub;
  }
}
