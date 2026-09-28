import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/services/fcm_token_service.dart';
import '../../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotificationsService.instance.initializeLocalNotifications();
  debugPrint('Background message received: ${message.messageId}');
  await PushNotificationsService.instance.showLocalNotification(message);
}

class PushNotificationsService {
  PushNotificationsService._();

  static final PushNotificationsService instance = PushNotificationsService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'skill_grow_default_channel',
    'Skill Grow Notifications',
    description: 'Important updates and alerts from the app.',
    importance: Importance.max,
  );

  bool _initialized = false;

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> init({bool force = false}) async {
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    if (_initialized && !force) {
      return;
    }

    try {
      await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // ⬇️⬇️⬇️ السطر الناقص ⬇️⬇️⬇️
      await _messaging.subscribeToTopic('all_users');
      debugPrint('✅ Subscribed to topic: all_users');
      // ⬆️⬆️⬆️ السطر الناقص ⬆️⬆️⬆️

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await initializeLocalNotifications();
      await _localNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      FirebaseMessaging.onMessage.listen((message) async {
        await showLocalNotification(message);
      });
      FirebaseMessaging.onMessageOpenedApp.listen(_onOpenedAppMessage);

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _onOpenedAppMessage(initialMessage);
      }

      _messaging.onTokenRefresh.listen((token) async {
        await FcmTokenService.updateFcmToken(token: token);
      });

      await FcmTokenService.updateFcmToken();

      _initialized = true;
    } catch (error) {
      debugPrint('PushNotificationsService.init error: $error');
      rethrow;
    }
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    final title = message.notification?.title ??
        message.data['title'] ??
        'New notification';
    final body = message.notification?.body ??
        message.data['body'] ??
        'You have a new update';

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final platformDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      title,
      body,
      platformDetails,
      payload: message.data.toString(),
    );
  }

  void _onOpenedAppMessage(RemoteMessage message) {
    if (Get.context == null) {
      return;
    }

    final payload = message.data['screen'];
    debugPrint('Notification opened: $payload');
  }

  static void _handleNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped with payload: ${response.payload}');
  }
}
