import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/forumCategories.dart';
import 'package:savvyions/models/forumDetail.dart';
import 'package:savvyions/models/forums.dart';
import 'package:savvyions/models/legalNotice.dart';
import 'package:savvyions/models/legalNoticeDetail.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class ForumsRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<ForumsModel> getForums(String categoryId) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.forums}/$categoryId");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.forums}/$categoryId");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Forums response: $response");
        return ForumsModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return ForumsModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting forums: $e");
      rethrow;
    }
  }


  Future<ForumsCategoriesModel> getForumCategories() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.forumCategories}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.forumCategories);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Forum Categories response: $response");
        return ForumsCategoriesModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return ForumsCategoriesModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting forum categories: $e");
      rethrow;
    }
  }

///   https://web.creativegarage.org/api/forum/44/detail
  Future<ForumDetailModel> getForumDetails(String id) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.forumDetails}/$id/detail");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.forumDetails}/$id/detail");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Forum Detail response: $response");
        return ForumDetailModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return ForumDetailModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting forum details: $e");
      rethrow;
    }
  }

  /// https://web.creativegarage.org/api/forum/44/reply



  /// https://web.creativegarage.org/api/legal-notice/98/comments

  /// Create Comment (Original - without file)
  Future<dynamic> createComment(dynamic data,String id) async {
    try {
      debugPrint('Create Comment Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse("${AppEndPoints.forumDetails}/$id/reply", data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to create comment");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }


}