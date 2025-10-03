import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> onDidReceiveNotificationResponse(
  NotificationResponse response,
) async {
  final payload = response.payload;
  log("notification recieve ${payload.toString()}");
}

@pragma('vm:entry-point')
Future<void> onDidReceiveBackgroundNotificationResponse(
  NotificationResponse response,
) async {
  final payload = response.payload;
  log("background notification recieve ${payload.toString()}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message ${message.data}');
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    log("Background Notification Title : ${notification.title}");
    log("Background Notification Body : ${notification.body}");
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        ),
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          icon: "@mipmap/ic_launcher",
          importance: Importance.max,
          priority: Priority.max,
          visibility: NotificationVisibility.public,
          largeIcon: const DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
          styleInformation: const BigTextStyleInformation(''),
        ),
      ),
    );
  }
}

class NotificationService {
  Future initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
  }
}

initializeNotification() async {
  const initialzationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  const DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,

        // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );

  const initializationSettings = InitializationSettings(
    android: initialzationSettingsAndroid,
    iOS: iosInitializationSettings,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      log('Handling a message ${message.data}');
      log("Notification Title : ${notification.title}");
      log("Notification Body : ${notification.body}");
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(
            presentSound: true,
            presentAlert: true,
            presentBadge: true,
          ),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.max,
            visibility: NotificationVisibility.public,
            largeIcon: const DrawableResourceAndroidBitmap(
              "@mipmap/ic_launcher",
            ),
            styleInformation: const BigTextStyleInformation(''),
          ),
        ),
      );
    }
  });

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
  );

  await requestNotificationPermission();
  getToken();
}

Future requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    log('User granted provisional permission');
  } else {
    log('User declined or has not accepted permission');
  }
}

Future selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
}

Future onDidReceiveLocalNotification(
  int? id,
  String? title,
  String? body,
  String? payload,
) async {
  log("Notification: $title , $body , $payload");
}

Future<void> getToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  log("FCM Token generated => $token");
}
