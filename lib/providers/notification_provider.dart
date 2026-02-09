import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/notifications.dart';
import 'package:savvyions/repository/notification_repo.dart';


class NotificationsViewModel extends ChangeNotifier {
  final _myRepo = NotificationsRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // User profile with getter/setter
  NotificationsModel? _notificationsModel;

  NotificationsModel? get notificationsModel => _notificationsModel;


  Future<void> fetchNotifications(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getNotifications();
      _notificationsModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load notifications: ${e.toString()}");
      setLoading(false);
      _notificationsModel = null;
    }
  }


  Future<void> markAsRead(dynamic data, BuildContext context) async {
    try {
      final response = await _myRepo.readNotification(data);

      debugPrint('Mark as Read Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // FIXED: Check for success field and data field (not comment field)
      if (decoded['success'] == true ) {

       fetchNotifications(context);

      } else {
        String errorMsg = decoded['message'] ?? 'Failed to read message';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      showToast("An error occurred: ${e.toString()}");
    }
  }


}