import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/agents.dart';
import 'package:savvyions/models/gatepassrequests.dart';
import 'package:savvyions/models/ticketDetails.dart';
import 'package:savvyions/models/ticketTenants.dart';
import 'package:savvyions/models/ticketTypes.dart';
import 'package:savvyions/models/tickets.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';
import '../models/gatePassDetail.dart';
import '../models/gatePassTypes.dart';


class GatePassRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<GatePassRequestModel> getGatePass() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.gatePass}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.gatePass);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("GatePass response: $response");
        return GatePassRequestModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return GatePassRequestModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting gate pass request: $e");
      rethrow;
    }
  }


  Future<GatePassRequestDetailModel> getGatePassDetail(String id) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.gatePass}/$id");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.gatePass}/$id");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("GatePass Detail response: $response");
        return GatePassRequestDetailModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return GatePassRequestDetailModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting gate pass detail request: $e");
      rethrow;
    }
  }

  Future<GatePassTypesModel> getGetPassTypes() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.gatePass}/types");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.gatePass}/types");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Get Pass Type response: $response");
        return GatePassTypesModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return GatePassTypesModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting get pass types: $e");
      rethrow;
    }
  }



  Future<dynamic> createGatePass(dynamic data) async {
    try {
      debugPrint('Create GatePass Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse(AppEndPoints.createGatePass, data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to create Gate Pass Request");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }



}