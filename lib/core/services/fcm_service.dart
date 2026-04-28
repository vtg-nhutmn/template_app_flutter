import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class FcmService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  FcmService(this._messaging, this._firestore, this._auth);

  Future<void> init() async {
    await _requestPermission();
    await _initLocalNotifications();
    _listenForegroundMessages();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final token = await _messaging.getToken();
    debugPrint('==============================');
    debugPrint('FCM TOKEN: $token');
    debugPrint('==============================');
  }
  void setupTapHandlers(void Function(String route) onNotificationTapped) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM tapped (background): ${message.messageId}');
      onNotificationTapped('/notifications');
    });
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint('FCM tapped (terminated): ${message.messageId}');
        onNotificationTapped('/notifications');
      }
    });
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(settings);
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _showLocalNotification(
          title: notification.title ?? '',
          body: notification.body ?? '',
        );
      }
    });
  }

  Future<void> saveTokenForUser() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    try {
      final token = await _messaging.getToken();
      debugPrint('==============================');
      debugPrint('FCM TOKEN (user: $userId): $token');
      debugPrint('==============================');
      if (token != null) {
        await _firestore.collection('users').doc(userId).update({
          'fcmToken': token,
        });
      }
    } catch (e) {
      debugPrint('FcmService.saveTokenForUser error: $e');
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    await showLocalNotification(title: title, body: body);
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Thông báo',
      channelDescription: 'Kênh thông báo mặc định của ứng dụng',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
