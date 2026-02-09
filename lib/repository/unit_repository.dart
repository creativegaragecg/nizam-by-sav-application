import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/mylease.dart';
import 'package:savvyions/models/myunits.dart';
import 'package:savvyions/models/unitDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Data/token.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';
import '../models/leaseDetail.dart';
import '../models/userprofile.dart';

class UnitRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<MyUnits> getUnits() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.myUnits}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.myUnits);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("My Unit response: $response");
        return MyUnits.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return MyUnits.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting my units: $e");
      rethrow;
    }
  }

  Future<UnitDetails> getUnitDetails(String unitId) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.myUnits}/$unitId");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.myUnits}/$unitId");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Unit detail response: $response");
        return UnitDetails.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return UnitDetails.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting unit details: $e");
      rethrow;
    }
  }

}