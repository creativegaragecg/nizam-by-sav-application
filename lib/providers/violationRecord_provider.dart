import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:savvyions/models/unitInspection.dart';
import 'package:savvyions/models/violationRecords.dart';
import 'package:savvyions/repository/violationRecords_repo.dart';

import '../Utils/Constants/utils.dart';
import '../models/unitInspectionDetail.dart';
import '../models/violationRecordDetails.dart';

class ViolationRecordsViewModel extends ChangeNotifier {
  final _myRepo = ViolationRecordRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ViolationRecordsModel? _recordsModel;

  ViolationRecordsModel? get recordsModel => _recordsModel;

  ViolationRecordDetailsModel? _detailModel;

  ViolationRecordDetailsModel? get detailModel => _detailModel;

  Future<void> fetchRecords(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getRecords();
      _recordsModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load records: ${e.toString()}");
      setLoading(false);
      _recordsModel = null;
    }
  }

  Future<void> fetchRecordDetail(BuildContext context, String id) async {
    try {
      setLoading(true);
      final response = await _myRepo.getRecordDetails(id);
      _detailModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load record details: ${e.toString()}");
      setLoading(false);
      _detailModel = null;
    }
  }

  Future<void> addComment(dynamic data, BuildContext context, String id) async {
    try {
      final response = await _myRepo.createComment(data, id);

      debugPrint('Create Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);


      if (decoded['success'] == true && decoded['data']?['comment'] != null) {
        String msg = decoded['message'] ?? 'Comment added successfully';

        // Refresh the details to show the new comment
        await fetchRecordDetail(context, id);

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
        await fetchRecordDetail(context, id);

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