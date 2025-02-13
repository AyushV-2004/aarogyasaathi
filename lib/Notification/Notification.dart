import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService() {
    initializeLocalNotifications();
    initializeFCM();
  }

  void initializeLocalNotifications() {
    // Initialize the timezone package
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Use your app icon

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void initializeFCM() async {
    // Request notification permissions for iOS (if necessary)
    await FirebaseMessaging.instance.requestPermission();

    // Fetch the FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token"); // The token is printed here

    // Listen for FCM messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showLocalNotification(
            message.notification?.title, message.notification?.body);
      }
    });

    // Handle notification taps (when the app is opened from a notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked with message: ${message.notification}');
      // Handle navigation directly here
      // Navigator.pushNamed(context, '/someRoute'); // Example navigation
    });
  }

  void showLocalNotification(String? title, String? message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
    );
  }

  void scheduleFunnyNotification(String message) {
    // Schedule a notification for 1 minute in the future
    var scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));

    var androidDetails = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Hey!",
      message,
      scheduledTime,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
