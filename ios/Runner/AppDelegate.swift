import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ── Step 1: Register UNUserNotificationCenter category ─────────────────
    // Must happen before GeneratedPluginRegistrant.register so that
    // notifications delivered at launch already have the correct actions.
    registerNotificationCategory()

    // ── Step 2: Register Flutter plugins ───────────────────────────────────
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ── UNUserNotificationCenter category registration ─────────────────────────

  private func registerNotificationCategory() {
    // "Post Now" — .foreground brings the app to the front so the Dart
    // onDidReceiveNotificationResponse callback fires correctly.
    let postAction = UNNotificationAction(
      identifier: "POST_NOW_ACTION",
      title: "🚀 Post Now",
      options: [.foreground]
    )

    // "Later" — .destructive styling signals intent; tapping removes the
    // notification from the shade.
    let laterAction = UNNotificationAction(
      identifier: "LATER_ACTION",
      title: "⏰ Later",
      options: [.destructive]
    )

    let draftCategory = UNNotificationCategory(
      identifier: "DRAFT_READY_CATEGORY",
      actions: [postAction, laterAction],
      intentIdentifiers: [],
      // Shown when the user has disabled notification previews at OS level.
      hiddenPreviewsBodyPlaceholder: NSString.localizedUserNotificationString(
        forKey: "New LinkedIn draft ready",
        arguments: nil
      ),
      options: []
    )

    UNUserNotificationCenter.current().setNotificationCategories([draftCategory])

    // Assign self as delegate so flutter_local_notifications can surface
    // notifications while the app is in the foreground.
    UNUserNotificationCenter.current().delegate = self
  }
}
