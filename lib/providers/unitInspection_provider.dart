import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:savvyions/models/unitInspection.dart';
import 'package:savvyions/repository/unitInspection_repo.dart';

import '../Utils/Constants/utils.dart';
import '../models/unitInspectionDetail.dart';

class UnitInspectionViewModel extends ChangeNotifier {
  final _myRepo = UnitInspectionRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  UnitInspectionModel? _inspectionModel;

  UnitInspectionModel? get inspectionModel => _inspectionModel;

  UnitInspectionDetailModel? _detailModel;

  UnitInspectionDetailModel? get detailModel => _detailModel;

  Future<void> fetchInspections(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getInspections();
      _inspectionModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load inspections: ${e.toString()}");
      setLoading(false);
      _inspectionModel = null;
    }
  }

  Future<void> fetchInspectionDetail(BuildContext context, String id) async {
    try {
      setLoading(true);
      final response = await _myRepo.getInspectionDetails(id);
      _detailModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load inspection details: ${e.toString()}");
      setLoading(false);
      _detailModel = null;
    }
  }

  Future<void> addComment(dynamic data, BuildContext context, String id) async {
    try {
      final response = await _myRepo.createComment(data, id);

      debugPrint('Create Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // FIXED: This API returns success flag with nested data
      // Response structure: {"success": true, "data": {"comment": {...}}}
      if (decoded['success'] == true && decoded['data']?['comment'] != null) {
        String msg = decoded['message'] ?? 'Comment added successfully';

        // Refresh the details to show the new comment
        await fetchInspectionDetail(context, id);

        showToast(msg);
      } else {
        String errorMsg = decoded['message'] ?? 'Failed to create comment';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      showToast("An error occurred");
    }
  }

  // Add comment with file upload
  Future<void> addCommentWithFile(
      Map<String, dynamic> data,
      BuildContext context,
      String id, {
        PlatformFile? file,
      }) async {
    try {
      debugPrint('Adding comment with file...');
      final response = await _myRepo.createCommentWithFileApi(data, id, file: file);

      debugPrint('Create Comment Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // FIXED: This API returns success flag with nested data
      if (decoded['success'] == true && decoded['data']?['comment'] != null) {
        String msg = decoded['message'] ?? 'Comment added successfully';

        // Refresh the details to show the new comment
        await fetchInspectionDetail(context, id);

        showToast(msg);
      } else {
        String errorMsg = decoded['message'] ?? 'Failed to create comment';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      showToast("An error occurred while creating comment");
    }
  }
}