import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/legalNotice.dart';
import 'package:savvyions/models/legalNoticeDetail.dart';
import 'package:savvyions/models/unitInspection.dart';
import 'package:savvyions/models/unitInspectionDetail.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class UnitInspectionRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<UnitInspectionModel> getInspections() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.unitInspections}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.unitInspections);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Unit Inspection response: $response");
        return UnitInspectionModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return UnitInspectionModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting unit inspections: $e");
      rethrow;
    }
  }


  Future<UnitInspectionDetailModel> getInspectionDetails(String id) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.unitInspections}/$id");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.unitInspections}/$id");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Inspection Details response: $response");
        return UnitInspectionDetailModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return UnitInspectionDetailModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting inspection details: $e");
      rethrow;
    }
  }


  /// https://web.creativegarage.org/api/legal-notice/98/comments

  /// Create Comment (Original - without file)
  Future<dynamic> createComment(dynamic data,String id) async {
    try {
      debugPrint('Create Comment Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse("${AppEndPoints.unitInspections}/$id/comments", data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to create comment");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }

  /// Create Comment with File Upload (NEW METHOD)
  Future<dynamic> createCommentWithFileApi(Map<String, dynamic> data, String id,{PlatformFile? file}) async {
    try {
      debugPrint('Create Comment Data (with file): $data');
      if (file != null) {
        debugPrint('File to upload: ${file.name}, Size: ${file.size} bytes');
      }

      dynamic response = await _apiService.postMultipartApiResponse(
          "${AppEndPoints.unitInspections}/$id/comments",
          data,
          file: file
      );

      debugPrint('Create Comment Response: $response');
      return response;

    } catch (e) {
      showToast("Failed to create comments");
      debugPrint("Exception in create comment: ${e.toString()}");
      rethrow;
    }
  }
}