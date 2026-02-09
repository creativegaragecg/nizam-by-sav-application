import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/gatepassrequests.dart';
import 'package:savvyions/models/visitor.dart';
import 'package:savvyions/models/visitorAppartment.dart';
import 'package:savvyions/models/visitorTypes.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';
import '../models/gatePassTypes.dart';


class VisitorRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<VisitorModel> getVisitor() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.visitor}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.visitor);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Visitor response: $response");
        return VisitorModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return VisitorModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting visitor: $e");
      rethrow;
    }
  }





  Future<VisitorAppartmentModel> getVisitorAppartments() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.visitor}/apartments");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.visitor}/apartments");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Visitor Appartments response: $response");
        return VisitorAppartmentModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return VisitorAppartmentModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting visitor appartments: $e");
      rethrow;
    }
  }


  Future<VisitorTypesModel> getVisitorTypes() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.visitor}/types");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.visitor}/types");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Visitor Types response: $response");
        return VisitorTypesModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return VisitorTypesModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting visitor types: $e");
      rethrow;
    }
  }


  Future<dynamic> createVisitor(dynamic data) async {
    try {
      debugPrint('Create Visitor Data Without Pic: $data');
      dynamic response = await _apiService
          .postPostApiResponse(AppEndPoints.addVisitor, data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to create visitor without pic");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }

  /// Create Visitor with File Upload (NEW METHOD)
  Future<dynamic> createVisitorWithFileApi(Map<String, dynamic> data, {PlatformFile? file,String? path}) async {
    try {
      debugPrint('Create Visitor Data (with file): $data');
      if (file != null) {
        debugPrint('File to upload: ${file.name}, Size: ${file.size} bytes');
      }

      dynamic response = await _apiService.postMultipartApiResponse(
          AppEndPoints.addVisitor,
          data,
          file: file,
        path: path
      );

      debugPrint('Create Visitor with pic Response: $response');
      return response;

    } catch (e) {
      showToast("Failed to create visitor with pic");
      debugPrint("Exception in create visitor with pic: ${e.toString()}");
      rethrow;
    }
  }



}