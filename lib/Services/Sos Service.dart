import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:savvyions/Utils/Constants/urls.dart';
import 'package:savvyions/models/Web%20Sos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SosService {
  static final SosService _instance = SosService._internal();
  factory SosService() => _instance;
  SosService._internal();

  Timer? _timer;
  final _sosController = StreamController<Datum>.broadcast();
  Stream<Datum> get sosStream => _sosController.stream;

  // ── Cache last unacknowledged SOS ──
  Datum? _pendingSos;

  final Set<String> _sessionShownIds = {};
  static const String _acknowledgedKey = 'acknowledged_sos_ids';

  final FlutterLocalNotificationsPlugin _notifPlugin =
  FlutterLocalNotificationsPlugin();
  bool _notifInitialized = false;

  // ── Subscribe and immediately get pending SOS if any ──
  StreamSubscription<Datum> listenToSos(void Function(Datum) onData) {
    // Deliver any missed SOS immediately
    if (_pendingSos != null) {
      Future.microtask(() => onData(_pendingSos!));
    }
    return sosStream.listen(onData);
  }

  Future<void> initNotifications() async {
    if (_notifInitialized) return;

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

    await _notifPlugin
        .resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _notifPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    _notifInitialized = true;
  }

  void startPolling() {
    debugPrint('🔍 SOS startPolling called'); // ← ADD
    _timer?.cancel();
    _checkSos();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      debugPrint('🔍 SOS timer tick'); // ← ADD
      _checkSos();
    });
  }

  Future<void> _checkSos() async {
    print("checkinggg");
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token') ?? '';
      debugPrint('🔍 SOS token: $token'); // ← ADD

      if (token.isEmpty) {
        debugPrint('🔍 SOS: token empty, skipping'); // ← ADD
        return;
      }
      debugPrint('🔍 Hitting SOS URL: ${AppEndPoints.SosUrl}'); // ← ADD

      final response = await http.get(
        Uri.parse(AppEndPoints.SosUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      debugPrint('🔍 SOS response status: ${response.statusCode}'); // ← ADD
      debugPrint('🔍 SOS response body: ${response.body}'); // ← ADD

      if (response.statusCode == 200) {
        final model = WebSosModel.fromJson(json.decode(response.body));
        if (model.success == true && model.data != null) {
          final acknowledgedIds = await _getAcknowledgedIds();
          debugPrint('🔍 SOS data count: ${model.data!.length}'); // ← ADD
          debugPrint('🔍 Session shown IDs: $_sessionShownIds'); // ← ADD
          debugPrint('🔍 Acknowledged IDs: $acknowledgedIds'); // ← ADD

          for (final sos in model.data!) {
            final idStr = sos.sosId ?? '';
            final sosData = sos.notifications?.isNotEmpty == true
                ? sos.notifications!.first.data
                : null;
            final status = sosData?.status ?? '';
            debugPrint('🔍 SOS id: $idStr, status: $status'); // ← ADD

            if (status == 'active' &&
                idStr.isNotEmpty &&
                !acknowledgedIds.contains(idStr) &&
                !_sessionShownIds.contains(idStr)) {
              debugPrint('🔍 EMITTING SOS: $idStr'); // ← ADD

              _sessionShownIds.add(idStr);

              // ── Cache it so late subscribers get it ──
              _pendingSos = sos;

              await _showSosNotification(sos);
              _sosController.add(sos);
              break;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('SOS polling error: $e');
    }
  }

  Future<void> _showSosNotification(Datum sos) async {
    if (!_notifInitialized) await initNotifications();

    final notifData = sos.notifications?.isNotEmpty == true
        ? sos.notifications!.first.data
        : null;
    final notifTitle = sos.notifications?.isNotEmpty == true
        ? sos.notifications!.first.notification
        : null;

    final String reason = notifData?.reason ?? 'Emergency';
    final String by = notifData?.triggeredBy ?? 'Unknown';
    final String society = notifData?.societyName ?? 'SOS Alert';
    final String title = notifTitle?.title ?? '⚠ $society';
    final String body = notifTitle?.body ?? '$reason — by $by';

    final int notifId = int.tryParse(sos.sosId ?? '0') ??
        DateTime.now().millisecondsSinceEpoch;

    await _notifPlugin.show(
      notifId,
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
          ongoing: true,
          autoCancel: false,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
    );
  }

  void emitSos(Datum sosData) {
    final idStr = sosData.sosId.toString();
    if (!_sessionShownIds.contains(idStr)) {
      _sessionShownIds.add(idStr);
      _pendingSos = sosData;
      _sosController.add(sosData);
    }
  }

  Future<Set<String>> _getAcknowledgedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_acknowledgedKey) ?? [];
    return list.toSet();
  }

  Future<void> acknowledgesSos(String sosId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_acknowledgedKey) ?? [];
    list.add(sosId.toString());
    await prefs.setStringList(_acknowledgedKey, list);
    _sessionShownIds.remove(sosId.toString());

    // ── Clear pending cache on acknowledge ──
    if (_pendingSos?.sosId == sosId) {
      _pendingSos = null;
    }

    final int notifId = int.tryParse(sosId) ?? 0;
    await _notifPlugin.cancel(notifId);
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _sosController.close();
  }
}