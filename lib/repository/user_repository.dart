import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/health.dart';
import 'package:savvyions/models/overdue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Data/token.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';
import '../models/userprofile.dart';

class UserProfileRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<UserProfileModel> getUserProfile() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.profile}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.profile);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("User Profile response: $response");
        return UserProfileModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return UserProfileModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not a valid user object: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getuser: $e");
      rethrow;
    }
  }


  Future<OverDueAmountModel> getOverDueAmount() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.dueAmount}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.dueAmount);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Due Amount response: $response");
        return OverDueAmountModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return OverDueAmountModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not a valid user object: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in get due amount: $e");
      rethrow;
    }
  }

  Future<HealthModel> healthApi() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.health}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.health);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Health response: $response");
        return HealthModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return HealthModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not a valid user object: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting health: $e");
      rethrow;
    }
  }


}