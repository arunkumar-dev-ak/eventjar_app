import 'package:eventjar/notification/utils/notification_message_handling.dart';
import 'package:eventjar/notification/utils/notification_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:eventjar/logger_service.dart'; // Adjust import
import 'package:eventjar/storage/storage_service.dart'; // Adjust import

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    await NotificationService._instance.setupFlutterNotifications();
    await NotificationService._instance.showNotification(message);
  } catch (e) {
    LoggerService.loggerInstance.e("error while handling bg notification $e");
  }
}

@pragma('vm:entry-point')
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isFlutterLocalNotificationsInitialized = false;
  static const String storageFcmToken = "myEventJar_fcmToken";

  Future<void> init() async {
    /*-----
    Type: Background
    When: App is in background or terminated
    ----*/
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 🔥 2. OLD .then() pattern - iOS SAFE (waits for Firebase)
    _firebaseMessaging
        .getToken()
        .then((token) {
          if (token != null) {
            StorageService.to.setString(storageFcmToken, token);
            LoggerService.loggerInstance.dynamic_d("🔥 FCM Token: $token");
          } else {
            LoggerService.loggerInstance.dynamic_d("❌ Failed to get FCM Token");
          }
        })
        .catchError((error) {
          LoggerService.loggerInstance.dynamic_d("❌ FCM Token Error: $error");
        });

    // 🔥 3. Request permissions
    await _requestPermission();

    // 🔥 4. iOS + Android settings (iOS CRITICAL)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // or 'logo'

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

    // 🔥 5. Initialize local notifications
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    // 🔥 6. Setup handlers
    _setupMessageHandlers();
  }

  // 🔥 iOS Legacy support (< iOS 10)
  static void onSelectNotificationLegacy(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    LoggerService.loggerInstance.dynamic_d("🔔 Legacy notification: $payload");
  }

  void onSelectNotification(NotificationResponse response) {
    LoggerService.loggerInstance.dynamic_d(
      "🔔 Notification tapped: payload: ${response.payload}, body: ${response.data} ",
    );

    // Handle navigation based on payload
    if (response.payload != null) {
      _handleNotificationTap(response.payload!);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    LoggerService.loggerInstance.dynamic_d(
      '🔐 Permission: ${settings.authorizationStatus}',
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
    _isFlutterLocalNotificationsInitialized = true;
  }

  void _setupMessageHandlers() {
    /*-----
    Type: Foreground Message
    When: App is open and visible
    Triggered: When FCM message is received while app is in foreground
    Note: OS will NOT automatically show notification, so we show it manually
    ----*/
    FirebaseMessaging.onMessage.listen(showNotification);

    /*-----
    Type: Notification Tap (Background State)
    When: App is in background (minimized) AND user taps the notification
    Triggered: When notification opens the app from background
    ----*/
    FirebaseMessaging.onMessageOpenedApp.listen(
      _handleBackgroundMessageNotificationTap,
    );

    /*-----
    Type: Notification Tap (Terminated State)
    When: App is completely closed AND user taps the notification
    Triggered: When app launches from terminated state via notification
    ----*/
    _firebaseMessaging.getInitialMessage().then((initialMessage) {
      if (initialMessage != null) {
        _handleBackgroundMessageNotificationTap(initialMessage);
      }
    });

    /*-----
    Type: Token Refresh
    When: FCM registration token changes
    ----*/
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      StorageService.to.setString(storageFcmToken, newToken);
      LoggerService.loggerInstance.d("🔄 Token refreshed: $newToken");
    });
  }

  /*----- message showing -----*/
  //handling message when the app is in opened state
  // Future<void> showNotification(RemoteMessage message) async {
  //   LoggerService.loggerInstance.dynamic_d(
  //     '${message.data}, ${message.notification?.body},  ${message.notification?.title}',
  //   );
  //   try {
  //     final contactId = message.data['contactId'];
  //     final meetingId = message.data['meetingId'];
  //     final ticketId = message.data['ticketId'];
  //     final connectionId = message.data['connectionId'];
  //     final eventId = message.data['eventId'];

  //     final String primaryId =
  //         contactId ??
  //         meetingId ??
  //         ticketId ??
  //         connectionId ??
  //         eventId ??
  //         "unknown";
  //     final int notificationId = primaryId.hashCode;

  //     const AndroidNotificationDetails androidDetails =
  //         AndroidNotificationDetails(
  //           'contact_channel',
  //           'Contact Notifications',
  //           channelDescription: 'Notifications for contact management',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           styleInformation: BigTextStyleInformation(''),
  //         );

  //     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
  //       presentAlert: true,
  //       presentBadge: true,
  //       presentSound: true,
  //     );

  //     const NotificationDetails platformDetails = NotificationDetails(
  //       android: androidDetails,
  //       iOS: iosDetails, // ✅ iOS details
  //     );

  //     final content = buildContactNotification(message);

  //     await flutterLocalNotificationsPlugin.show(
  //       notificationId,
  //       content.title,
  //       content.body,
  //       platformDetails,
  //       payload: message.data['type'],
  //     );
  //   } catch (e) {
  //     LoggerService.loggerInstance.e("Notification show error: $e");
  //   }
  // }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      LoggerService.loggerInstance.dynamic_d(
        '${message.data}, ${message.notification?.body},  ${message.notification?.title}',
      );
      final String type = message.data['type'] ?? '';

      // ✅ Only allow these 4 types
      const allowedTypes = [
        "CONNECTION_RECEIVED",
        "CONNECTION_REJECTED",
        "CONNECTION_ACCEPTED",
        "ATTENDEE_TICKET_CONFIRMED",
      ];

      if (!allowedTypes.contains(type)) {
        LoggerService.loggerInstance.d("Notification ignored for type: $type");
        return; // 🚀 Do NOT show notification
      }

      final connectionId = message.data['connectionId'];
      final ticketId = message.data['ticketId'];
      final eventId = message.data['eventId'];

      final String primaryId = connectionId ?? ticketId ?? eventId ?? "unknown";

      final int notificationId = primaryId.hashCode;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'eventjar_channel',
            'EventJar Notifications',
            channelDescription: 'Important notifications',
            importance: Importance.max,
            priority: Priority.high,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final content = buildNotificationContent(message);

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        content.title,
        content.body,
        platformDetails,
        payload: type,
      );
    } catch (e) {
      LoggerService.loggerInstance.e("Notification show error: $e");
    }
  }

  // //handling message when the app is in bg or terminated state
  // @pragma('vm:entry-point')
  // static Future<void> _firebaseMessagingBackgroundHandler(
  //   RemoteMessage message,
  // ) async {
  //   try {
  //     // 🔥 iOS: Firebase might not be initialized in background
  //     await Firebase.initializeApp();
  //     await NotificationService._instance.setupFlutterNotifications();
  //     await NotificationService._instance.showNotification(message);
  //   } catch (e) {
  //     LoggerService.loggerInstance.e("error while handling bg notification $e");
  //     // Silent fail in background
  //   }
  // }

  void _handleBackgroundMessageNotificationTap(RemoteMessage message) {
    LoggerService.loggerInstance.d("📱 App opened from notification");
    final type = message.data['type'];
    if (type != null) {
      navigateBasedOnNotificationType(type);
    }
  }

  void _handleNotificationTap(String payload) {
    // Handle notification tap navigation
    LoggerService.loggerInstance.d("🔔 Handling tap: $payload");
    navigateBasedOnNotificationType(payload);
  }

  // Manual token refresh
  Future<void> refreshToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      String? newToken = await _firebaseMessaging.getToken();
      if (newToken != null) {
        StorageService.to.setString(storageFcmToken, newToken);
      }
    } catch (e) {
      LoggerService.loggerInstance.e("Token refresh failed: $e");
    }
  }
}
