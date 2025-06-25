import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static Future<void> subscribeToUserTopic(String userType) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic('pembeli');
    await FirebaseMessaging.instance.unsubscribeFromTopic('penitip');
    await FirebaseMessaging.instance.unsubscribeFromTopic('kurir');
    await FirebaseMessaging.instance.unsubscribeFromTopic('hunter');

    await FirebaseMessaging.instance.subscribeToTopic(userType);
    print("Subscribed to topic: $userType");
  }
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Android setup: notification icon
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // ID
      'High Importance Notifications', // Nama channel
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Show notification saat app di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    // Cetak token FCM
    final token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
  }

  static void showNotification(RemoteMessage message) {
    if (message.notification == null) return;

    final notif = message.notification!;
    _flutterLocalNotificationsPlugin.show(
      notif.hashCode,
      notif.title,
      notif.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}