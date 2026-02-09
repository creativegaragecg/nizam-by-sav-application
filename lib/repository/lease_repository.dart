import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/mylease.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Data/token.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';
import '../models/leaseDetail.dart';
import '../models/userprofile.dart';

class LeaseRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<MyLeaseModel> getLeases() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.myLease}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.myLease);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Lease response: $response");
        return MyLeaseModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return MyLeaseModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting lease: $e");
      rethrow;
    }
  }

  Future<LeaseDetailModel> getLeaseDetails(String leaseId) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.myLease}/$leaseId");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.myLease}/$leaseId");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Lease detail response: $response");
        return LeaseDetailModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return LeaseDetailModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting lease details: $e");
      rethrow;
    }
  }

}