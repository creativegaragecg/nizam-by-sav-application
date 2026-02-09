import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/notifications.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class NotificationsRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<NotificationsModel> getNotifications() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.notifications}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.notifications);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Notification response: $response");
        return NotificationsModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return NotificationsModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting notifications: $e");
      rethrow;
    }
  }


  Future<dynamic> readNotification(dynamic data) async {
    try {
      debugPrint('Read Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse("${AppEndPoints.notifications}/mark-read", data);
      return response;
    } catch (e) {
      showToast("Failed to read message");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }


}