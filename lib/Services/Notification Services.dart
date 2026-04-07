import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:savvyions/models/Web Sos.dart';
import 'package:savvyions/Services/Sos Service.dart';
import 'package:firebase_core/firebase_core.dart'; // ← ADD THIS


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Must show notification manually when app is killed
  if (message.data['type'] == 'sos') {
    await _showBackgroundSosNotification(message);
  }
}

Future<void> _showBackgroundSosNotification(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin plugin =
  FlutterLocalNotificationsPlugin();

  // Must re-create channel in background isolate
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'sos_alerts',
    'SOS Alerts',
    description: 'Emergency SOS alerts',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    ledColor: Color(0xFFFF0000),
  );

  await plugin
      .resolvePlatformSpecificImplementation
  <AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  final String title =
      message.notification?.title ?? '⚠ SOS ALERT';
  final String body =
      message.notification?.body ?? 'Emergency triggered!';

  await plugin.show(
    message.hashCode,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'sos_alerts',
        'SOS Alerts',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        color: Color(0xFFFF0000),
        fullScreenIntent: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.critical,
      ),
    ),
  );
}

/*@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();


}*/

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifs =
  FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const String _sosChannelId = 'sos_alerts';
  static const String _sosChannelName = 'SOS Alerts';

  Future<void> initialize() async {
    await _setupLocalNotifications();
    await _requestPermission();
    _listenForeground();
    _listenNotificationTap();
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _sosChannelId,
      _sosChannelName,
      description: 'Emergency SOS alerts',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Colors.red,
    );

    final androidImpl = _localNotifs
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifs.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }


  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,   // ← ADD
    );

    // ── Android 13+ notification permission ──
    if (Platform.isAndroid) {
      final plugin = FlutterLocalNotificationsPlugin();
      await plugin
          .resolvePlatformSpecificImplementation
      <AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground FCM: ${message.data}');
      if (_isSosMessage(message)) {
        _showSosNotification(message);
        _pushToSosStream(message);
      }
    });
  }

  void _listenNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tap (background): ${message.data}');
      if (_isSosMessage(message)) {
        _pushToSosStream(message);
      }
    });
  }

  Future<void> checkInitialMessage() async {
    final RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && _isSosMessage(initialMessage)) {
      await Future.delayed(const Duration(milliseconds: 500));
      _pushToSosStream(initialMessage);
    }
  }

  bool _isSosMessage(RemoteMessage message) {
    return message.data['type'] == 'sos';
  }

  Future<void> _showSosNotification(RemoteMessage message) async {
    final String title = message.notification?.title ?? '⚠ SOS ALERT';
    final String body = message.notification?.body ?? 'Emergency triggered!';
    final String payload = jsonEncode(message.data);

    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      _sosChannelId,
      _sosChannelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      color: Colors.red,
/*
      sound: const RawResourceAndroidNotificationSound('sos_alarm'),
*/
/*
      icon: '@drawable/ic_launcher',
*/
      fullScreenIntent: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    //  sound: 'sos_alarm.wav',
      interruptionLevel: InterruptionLevel.critical,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifs.show(
      message.hashCode,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void _pushToSosStream(RemoteMessage message) {
    try {
      final data = message.data;
      if (data['sos'] != null) {
        final Datum sosData = Datum.fromJson(jsonDecode(data['sos']));
        SosService().emitSos(sosData);
      }
    } catch (e) {
      debugPrint('Error parsing SOS from FCM: $e');
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
  }

  Future<String?> getToken() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
}