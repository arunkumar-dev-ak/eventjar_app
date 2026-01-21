import 'dart:convert';

import 'package:eventjar/logger_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'global/app_toast.dart';
import 'storage/storage_service.dart';

@pragma('vm:entry-point')
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> init() async {
    // FIXED: Proper error handling for getToken
    try {
      String? token = await _firebaseMessaging.getToken();

      LoggerService.loggerInstance.dynamic_d(token);

      if (token != null) {
        StorageService.to.setString("storageFcmToken", token);
      }
    } on FirebaseException catch (e) {
      // FIXED: Extract error message from FirebaseException
      if (Get.context != null) {
        await Future.delayed(Duration(milliseconds: 300));
        AppToast.show(
          message: e.message ?? "Failed to get notification token",
          title: "Firebase Error",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      // FIXED: Handle other exceptions
      if (Get.context != null) {
        await Future.delayed(Duration(milliseconds: 300));
        AppToast.show(
          message: "Could not initialize notifications",
          title: "Firebase Error",
          backgroundColor: Colors.red,
        );
      }
    }

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request notification permissions
    await _requestPermission();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize local notifications
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    // Setup foreground and background handlers
    _setupMessageHandlers();
  }

  void onSelectNotification(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final Map<String, dynamic> val = jsonDecode(response.payload!);
        LoggerService.loggerInstance.dynamic_d(val);

        // final String vendorType = val['vendorType'] ?? '';
        // final bool isReceiverVendor = val['isReceiverVendor'] == "true";

        // if (isReceiverVendor) {
        //   // Vendor-side navigation
        //   switch (vendorType) {
        //     case 'PRODUCT':
        //       Get.offAllNamed(
        //         AppRouteName.orderHistory,
        //         arguments: {
        //           'serviceId': "",
        //           'payment': "",
        //           'isService': false,
        //           "from": "message",
        //         },
        //       );
        //       break;
        //     case 'BANNER':
        //       Get.toNamed(
        //         AppRouteName.bannerHistory,
        //         arguments: {"from": "message"},
        //       );
        //       break;
        //     case 'SERVICE':
        //       Get.toNamed(
        //         AppRouteName.serviceHistory,
        //         arguments: {"from": "message"},
        //       );
        //       break;
        //   }
        // } else {
        //   // Customer-side navigation
        //   switch (vendorType) {
        //     case 'BANNER':
        //       Get.toNamed(
        //         AppRouteName.customerHistoryList,
        //         arguments: {'index': 2, "from": "message"},
        //       );
        //       break;
        //     case 'PRODUCT':
        //       Get.toNamed(
        //         AppRouteName.customerHistoryList,
        //         arguments: {'index': 1, "from": "message"},
        //       );
        //       break;
        //     case 'SERVICE':
        //       Get.toNamed(
        //         AppRouteName.customerHistoryList,
        //         arguments: {'index': 3, "from": "message"},
        //       );
        //       break;
        //   }
        // }
      } catch (e) {
        if (Get.context != null) {
          AppToast.show(
            message: "Could not open notification",
            title: "Error",
            backgroundColor: Colors.red,
          );
        }
      }
    }
  }

  // Ask user for permission
  Future<void> _requestPermission() async {
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    } catch (e) {
      AppToast.show(
        message: "Error requesting notification permission: $e",
        title: "Error",
        backgroundColor: Colors.red,
      );
    }
  }

  // Setup flutter notifications only once
  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(initSettings);
      _isFlutterLocalNotificationsInitialized = true;
    } catch (e) {
      return;
    }
  }

  // Display notification
  Future<void> showNotification(RemoteMessage message) async {
    try {
      final title =
          message.data["title"] ??
          message.notification?.title ??
          'New Notification';
      final body =
          message.data["body"] ??
          message.notification?.body ??
          'You have a new message';
      final senderId = message.data['senderId'] ?? 'unknown';
      final notificationId = senderId.hashCode;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'chat_channel',
            'Chat Notifications',
            channelDescription: 'Notifications for chat messages',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(''),
          );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      return;
    }
  }

  // Background message handler
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    try {
      await Firebase.initializeApp();
      await NotificationService._instance.setupFlutterNotifications();
      await NotificationService._instance.showNotification(message);
    } catch (e) {
      return;
    }
  }

  // Setup message handlers
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleBackgroundMessage(message);
    });

    // App launched from terminated state
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleBackgroundMessage(message);
      }
    });

    _firebaseMessaging.onTokenRefresh
        .listen((newToken) {
          StorageService.to.setString("storageFcmToken", newToken);
        })
        .onError((error) {
          return;
        });
  }

  // Handle notification tap
  void _handleBackgroundMessage(RemoteMessage message) {
    try {
      if (message.data['type'] == 'chat') {
        return;
      }
    } catch (e) {
      return;
    }
  }

  // Refresh FCM token
  Future<void> refreshToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      String? newToken = await _firebaseMessaging.getToken();
      if (newToken != null) {
        StorageService.to.setString("storageFcmToken", newToken);
      }
    } catch (e) {
      return;
    }
  }
}
