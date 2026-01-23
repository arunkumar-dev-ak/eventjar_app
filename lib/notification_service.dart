import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:eventjar/logger_service.dart'; // Adjust import
import 'package:eventjar/storage/storage_service.dart'; // Adjust import

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
    // 🔥 1. Background handler FIRST (iOS safe)
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
      iOS: iosSettings, // ✅ iOS SETTINGS REQUIRED
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
      "🔔 Notification tapped: ${response.payload}",
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

  Future<void> showNotification(RemoteMessage message) async {
    try {
      final title =
          message.data["title"] ??
          message.notification?.title ??
          'New Notification';
      final body =
          message.data["body"] ??
          message.notification?.body ??
          'You have new activity';
      final senderId = message.data['senderId'] ?? 'unknown';
      final notificationId = senderId.hashCode;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'contact_channel', // Changed from chat_channel
            'Contact Notifications',
            channelDescription: 'Notifications for contact management',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(''),
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails, // ✅ iOS details
      );

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformDetails,
        payload: senderId,
      );
    } catch (e) {
      LoggerService.loggerInstance.e("Notification show error: $e");
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    try {
      // 🔥 iOS: Firebase might not be initialized in background
      await Firebase.initializeApp();
      await NotificationService._instance.setupFlutterNotifications();
      await NotificationService._instance.showNotification(message);
    } catch (e) {
      // Silent fail in background
    }
  }

  void _setupMessageHandlers() {
    // Foreground
    FirebaseMessaging.onMessage.listen(showNotification);

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // App launched from terminated state
    _firebaseMessaging.getInitialMessage().then((initialMessage) {
      if (initialMessage != null) {
        _handleBackgroundMessage(initialMessage);
      }
    });

    // Token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      StorageService.to.setString(storageFcmToken, newToken);
      LoggerService.loggerInstance.d("🔄 Token refreshed: $newToken");
    });
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    LoggerService.loggerInstance.d("📱 App opened from notification");
    if (message.data['type'] == 'contact') {
      final senderId = message.data['senderId'];
      LoggerService.loggerInstance.d("📨 Navigate to contact: $senderId");
      // Navigate to contact screen
      // Get.toNamed('/contact', arguments: senderId);
    }
  }

  void _handleNotificationTap(String payload) {
    // Handle notification tap navigation
    LoggerService.loggerInstance.d("🔔 Handling tap: $payload");
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
