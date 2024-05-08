import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/src/services/call_service.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // On tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    if (notificationResponse.payload! == "test") {
      // TODO: send emergency message to contacts
    }
    onClickNotification.add(notificationResponse.payload!);
  }

  // Initialize the local notifications
  static Future init() async {
    // Initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => {},
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // Show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
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

    Future.delayed(Duration(seconds: 5), () {
      // Check if user reacted on notification to confirm their safety status
      // if not clicked then should send a notification to emergency contacts
      if (!onClickNotification.hasValue) {
        print('OH NO');
        final container = ProviderContainer();
        List<Contact> contacts = container.read(contactListProvider);
        if (contacts.isNotEmpty) {
          CallService.callNumber(contacts.first.phoneNumber);
        }
        container.dispose();
      }
    });
  }

  // Close a specific channel notification
  static Future cancel(int id) async {
    await _notifications.cancel(id);
  }

  // Close all the notifications available
  static Future cancelAll() async {
    await _notifications.cancelAll();
  }
}
