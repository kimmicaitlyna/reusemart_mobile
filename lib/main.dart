import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Kurir/profile.dart';
import 'package:reusemart_mobile/Login/sebelumLogin.dart';
import 'package:reusemart_mobile/push_notification.dart';

import 'firebase_options.dart';

// function to listen to bg changes
// Future _firebaseBackgroundMessage(RemoteMessage message) async {
//   if(message.notification != null) {
//     print("Some notification Received");
//   }
//   // await Firebase.initializeApp(); // WAJIB saat background
//   // if (message.notification != null) {
//   //   print("Background Notification Received: ${message.notification!.title}");
//   //   PushNotifications.showNotification(message);
//   // }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
  
//   // Kalau mau juga tampilkan local notif saat di background, bisa panggil fungsi showNotification di sini
// }

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  PushNotifications.showNotification(message);
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotifications.init();
  // Listen to bg notification
  // FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SebelumLogin(),
    );
  }
}