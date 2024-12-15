import 'dart:convert';
import 'package:notifychat/core/routes/app_routes.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';
import 'package:notifychat/features/notifications/data/models/notification_model.dart';
import 'package:notifychat/features/notifications/logic/notification_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

abstract class NotificationFirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static const _androidNotificationChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    description: 'This channel is used for important notifications.',
  );

  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static void handleMessage(RemoteMessage? message) async {
    if (message == null) {
      return;
    }
    // navigate to the notification page
    Get.find<HomeController>().changePage(0);
    Get.toNamed(AppRoutes.home);
  }

  static Future<void> initNotifications() async {
    final settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('User declined or has not accepted permission');
      return;
    }

    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    initPushNotifications();
    initLocalNotifications();
  }

  // when app is in foreground, this will be called
  static Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);
    try {
      await _localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (notification) async {
          if (notification.payload != null) {
            final message =
                RemoteMessage.fromMap(jsonDecode(notification.payload!));

            handleMessage(message);
          }
        },
      );
    } catch (e) {
      print('Error initializing local notifications: $e');
    }

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!;
    platform.createNotificationChannel(_androidNotificationChannel);
  }

  static Future initPushNotifications() async {
    // foreground notification options
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // when app is terminated
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message == null) {
        return;
      }
      final newNotification = NotificationModel(
        id: message.messageId ?? const Uuid().v4(),
        title: message.notification?.title ?? '',
        content: message.notification?.body ?? '',
        receivedTime: DateTime.now(),
      );
      Get.find<NotificationController>().saveNotification(newNotification);

      handleMessage(message);
    });

    // when app is in the foreground
    FirebaseMessaging.onMessage.listen(
      (message) {
        final notification = message.notification;
        if (notification == null) {
          return;
        }

        final newNotification = NotificationModel(
          id: message.messageId ?? const Uuid().v4(),
          title: message.notification?.title ?? '',
          content: message.notification?.body ?? '',
          receivedTime: DateTime.now(),
        );
        Get.find<NotificationController>().saveNotification(newNotification);

        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidNotificationChannel.id,
              _androidNotificationChannel.name,
              channelDescription: _androidNotificationChannel.description,
              icon: '@drawable/ic_launcher',
              importance: Importance.max,
              playSound: true,
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      },
    );

    // when app is in the background and not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);

      final newNotification = NotificationModel(
        id: message.messageId ?? const Uuid().v4(),
        title: message.notification?.title ?? '',
        content: message.notification?.body ?? '',
        receivedTime: DateTime.now(),
      );
      Get.find<NotificationController>().saveNotification(newNotification);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}
