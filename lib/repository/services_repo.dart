import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/serviceTypes.dart';
import 'package:savvyions/models/services.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class ServicesRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<ServicesModel> getServices(String categoryId) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.service}/$categoryId");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.service}/$categoryId");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Services response: $response");
        return ServicesModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return ServicesModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting services: $e");
      rethrow;
    }
  }


  Future<ServiceTypesModel> getServiceTypes() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.serviceTypes}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.serviceTypes);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Service Categories response: $response");
        return ServiceTypesModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return ServiceTypesModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting service categories: $e");
      rethrow;
    }
  }


}