import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String kPrefPendingSyncId = 'postly_pending_sync_published_id';

const String kActionPost = 'action_post';
const String kActionLater = 'action_later';

const String kIosCategoryId = 'DRAFT_READY_CATEGORY';
const String kIosActionPost = 'POST_NOW_ACTION';
const String kIosActionLater = 'LATER_ACTION';

const String kDraftChannelId = 'postly_draft_channel';
const String kDraftChannelName = 'Draft Ready';
const String kDraftChannelDesc =
    'Notifies you when a LinkedIn draft is ready to publish.';

const String kPrefAccessToken = 'postly_access_token_bg';
const String kPrefPersonUrn = 'postly_person_urn_bg';

@pragma('vm:entry-point')
Future<void> onDidReceiveBackgroundNotificationResponse(
  NotificationResponse response,
) async {
  final actionId = response.actionId;
  final payloadJson = response.payload;

  debugPrint(' ====>>>> [BG Notification] action=$actionId');

  if (actionId == kActionLater || payloadJson == null) return;

  if (actionId == kActionPost) {
    await _publishFromNotificationPayload(payloadJson);
  }
}

Future<void> _publishFromNotificationPayload(String payloadJson) async {
  try {
    final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
    final draftId = (payload['draftId'] as String?) ?? '';
    final postBody = (payload['postBody'] as String?) ?? '';
    final personUrn = (payload['personUrn'] as String?) ?? '';

    if (postBody.isEmpty) {
      debugPrint('==>>>> [BG Notification] Empty postBody – aborting.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(kPrefAccessToken) ?? '';
    final resolvedUrn = personUrn.isNotEmpty
        ? personUrn
        : (prefs.getString(kPrefPersonUrn) ?? '');

    if (accessToken.isEmpty) {
      debugPrint('===>> [BG Notification] No access token – cannot publish.');
      return;
    }

    await _linkedInPublish(
      accessToken: accessToken,
      personUrn: resolvedUrn,
      postBody: postBody,
    );

    if (draftId.isNotEmpty) {
      await prefs.setString(kPrefPendingSyncId, draftId);
    }

    debugPrint(
      '==>> [BG Notification] ✅ Published draft "$draftId" from notification.',
    );
  } catch (e) {
    debugPrint('===>>>> [BG Notification] ❌ Publish failed: $e');
  }
}

Future<void> _linkedInPublish({
  required String accessToken,
  required String personUrn,
  required String postBody,
}) async {
  final formattedUrn = personUrn.startsWith('urn:li:person:')
      ? personUrn
      : 'urn:li:person:$personUrn';

  final response = await http
      .post(
        // 1. Full URL provided
        Uri.parse('https://api.linkedin.com/rest/posts'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'X-Restli-Protocol-Version': '2.0.0',
          // 2. LinkedIn Version header format fixed (YYYYMM)
          'LinkedIn-Version': '202601',
        },
        body: jsonEncode({
          'author': formattedUrn,
          'commentary': postBody,
          'visibility': 'PUBLIC',
          'distribution': {
            'feedDistribution': 'MAIN_FEED',
            'targetEntities': [],
            'thirdPartyDistributionChannels': [],
          },
          'lifecycleState': 'PUBLISHED',
          'isReshareDisabledByAuthor': false,
        }),
      )
      .timeout(const Duration(seconds: 20));

  // 3. Handle both 201 Created and 200 OK responses
  if (response.statusCode != 201 && response.statusCode != 200) {
    throw Exception('LinkedIn API ${response.statusCode}: ${response.body}');
  }
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');

    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          kIosCategoryId,
          actions: [
            DarwinNotificationAction.plain(
              kIosActionPost,
              '🚀 Post Now',
              options: {DarwinNotificationActionOption.foreground},
            ),
            DarwinNotificationAction.plain(
              kIosActionLater,
              '⏰ Later',
              options: {DarwinNotificationActionOption.destructive},
            ),
          ],
        ),
      ],
    );

    await _plugin.initialize(
      InitializationSettings(android: androidInit, iOS: iosInit),

      onDidReceiveNotificationResponse: _onForegroundResponse,

      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            kDraftChannelId,
            kDraftChannelName,
            description: kDraftChannelDesc,
            importance: Importance.high,
            playSound: true,
          ),
        );

    _initialized = true;
    debugPrint('[NotificationService] Initialised.');
  }

  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final granted = await android?.requestNotificationsPermission() ?? true;
    debugPrint('====>>> [NotificationService] Permission granted: $granted');
    return granted;
  }

  Future<void> mirrorCredentials({
    required String accessToken,
    required String personUrn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefAccessToken, accessToken);
    await prefs.setString(kPrefPersonUrn, personUrn);
    debugPrint('===>>> [NotificationService] Credentials mirrored.');
  }

  Future<void> showDraftReadyNotification({
    required String draftId,
    required String postBody,
    required String personUrn,
  }) async {
    final teaser = postBody.length > 100
        ? '${postBody.substring(0, 100)}…'
        : postBody;

    final payload = jsonEncode({
      'draftId': draftId,
      'postBody': postBody,
      'personUrn': personUrn,
    });

    final androidDetails = AndroidNotificationDetails(
      kDraftChannelId,
      kDraftChannelName,
      channelDescription: kDraftChannelDesc,
      importance: Importance.high,
      priority: Priority.high,

      styleInformation: BigTextStyleInformation(teaser),
      actions: const [
        AndroidNotificationAction(
          kActionPost,
          '🚀 Post Now',

          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          kActionLater,
          '⏰ Later',
          showsUserInterface: false,

          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: kIosCategoryId,
    );

    await _plugin.show(
      draftId.hashCode,
      '✨ Your LinkedIn draft is ready',
      teaser,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );

    debugPrint(
      '===>>> [NotificationService] Notification shown for draft $draftId.',
    );
  }

  Future<void> cancelDraftNotification(String draftId) async {
    await _plugin.cancel(draftId.hashCode);
  }

  Future<void> cancelAll() async => _plugin.cancelAll();

  void _onForegroundResponse(NotificationResponse response) {
    debugPrint('[NotificationService] Foreground action: ${response.actionId}');

    if (response.actionId == kActionPost && response.payload != null) {
      _publishFromNotificationPayload(response.payload!);
    }
  }
}
