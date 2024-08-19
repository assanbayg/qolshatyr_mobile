// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/contacts/call_service.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // Initialize the local notifications with permission check
  static Future<void> init() async {
    // Check and request notification permissions
    final PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        // Handle the case where the permission is denied
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
    if (payload == "test") {
      // Handle the test payload if needed
    }
    onClickNotification.add(payload ?? '');
  }

  // Handle no response from the user
  static Future<void> _handleNoResponse() async {
    List<Contact> contacts = await SharedPreferencesManager.getContacts();
    if (contacts.isNotEmpty) {
      CallService.callNumber(contacts.first.phoneNumber);
      await showCallResultNotification();
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
  static Future<void> showCallResultNotification() async {
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
      payload: 'worked',
    );

    Future.delayed(const Duration(seconds: 30), () async {
      if (!onClickNotification.hasValue) {
        await _handleNoResponse();
      }
    });
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
