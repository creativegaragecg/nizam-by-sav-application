import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/events.dart';
import 'package:savvyions/models/tickets.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class EventsRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<EventsModel> getEvents() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.events}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.events);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Event response: $response");
        return EventsModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return EventsModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting events: $e");
      rethrow;
    }
  }
}