import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/serviceSuspension.dart';
import 'package:savvyions/models/serviceSuspensionDetail.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class ServiceSuspensionRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<ServiceSuspensionModel> getServiceSuspension() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.serviceSuspensions}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.serviceSuspensions);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Service Suspension response: $response");
        return ServiceSuspensionModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return ServiceSuspensionModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting service suspensions: $e");
      rethrow;
    }
  }


  Future<ServiceSuspensionDetailModel> getDetails(String id) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.serviceSuspensions}/$id");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.serviceSuspensions}/$id");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Service Suspension Details response: $response");
        return ServiceSuspensionDetailModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return ServiceSuspensionDetailModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting service suspension details: $e");
      rethrow;
    }
  }



  /// Create Comment (Original - without file)
  Future<dynamic> createComment(dynamic data,String id) async {
    try {
      debugPrint('Create Comment Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse("${AppEndPoints.serviceSuspensions}/$id/reply", data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to create comment");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }


}