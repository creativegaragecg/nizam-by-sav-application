import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/acknowledge.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../Utils/Constants/utils.dart';

class AuthRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<dynamic> loginApi(dynamic data,{String? baseUrl}) async {
    try {
      debugPrint('Login Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse("${baseUrl}auth/login", data, isAuth: true);
      return response;
    } catch (e) {
    showToast("Login Failed");
      debugPrint("Exception: ${e.toString()}");
    }
  }


  Future<dynamic> emergencyApi() async {
    try {

      dynamic response = await _apiService
          .postApiWithOutBody(AppEndPoints.emergency,  isAuth: false);
      return response;
    } catch (e) {
      showToast("Fail to sent emergency alert");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }


  Future<dynamic> changePassApi(dynamic data) async {
    try {
      debugPrint('Change Pass Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse(AppEndPoints.changePass, data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to change password");
      debugPrint("Exception: ${e.toString()}");
    }
  }


  Future<dynamic> forgotPassApi(dynamic data) async {
    try {
      debugPrint('Forgot Pass Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse(AppEndPoints.forgotPass, data, isAuth: true);
      return response;
    } catch (e) {
      showToast("Failed to change password");
      debugPrint("Exception: ${e.toString()}");
    }
  }

  Future<AcknowledgeModel> getEmergencyResponse() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.acknowledge}");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.acknowledge}");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Emergency Acknowledge response: $response");
        return AcknowledgeModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return AcknowledgeModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting emergency acknowledge: $e");
      rethrow;
    }
  }


}
