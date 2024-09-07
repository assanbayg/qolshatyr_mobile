// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // Initialize the local notifications with permission check
  static Future<void> init() async {
    final PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        return;
      }
    }

    // Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => {},
    );

    // Combined settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the plugin
    _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // On tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload == "didTheyAnswer") {
      onClickNotification.add('true');
    }
  }

  // Show a simple notification
  static Future<void> showReminderNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reminder_notification',
      'Reminder Notification',
      channelDescription:
          'Notifications for reminding about upcoming check-in.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _notifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Show notification after calling emergency contact
  static Future<bool> showCallResultNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'emergency_notification',
      'Emergency Alerts',
      channelDescription:
          'Notifications for emergency situations requiring immediate attention.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _notifications.show(
      0,
      "Did they answer?",
      "React or another call will be made",
      notificationDetails,
      payload: 'didTheyAnswer',
    );

    onClickNotification.add('');
    await Future.delayed(const Duration(seconds: 15));
    if (onClickNotification.value != 'true') {
      return false;
    }
    return true;
  }

  // Close a specific channel notification
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  // Close all the notifications available
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
