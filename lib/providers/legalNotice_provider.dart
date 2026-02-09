import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:savvyions/models/legalNotice.dart';
import 'package:savvyions/models/legalNoticeDetail.dart';
import 'package:savvyions/repository/legalNotice_repo.dart';

import '../Utils/Constants/utils.dart';

class LegalNoticesViewModel extends ChangeNotifier {
  final _myRepo = LegalNoticesRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  LegalNoticeModel? _legalNoticeModel;

  LegalNoticeModel? get legalNoticeModel => _legalNoticeModel;

  LegalNoticeDetailModel? _detailModel;

  LegalNoticeDetailModel? get detailModel => _detailModel;

  Future<void> fetchLegalNotices(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getLegalNotices();
      _legalNoticeModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load legalNotices: ${e.toString()}");
      setLoading(false);
      _legalNoticeModel = null;
    }
  }

  Future<void> fetchLegalNoticeDetail(BuildContext context, String id) async {
    try {
      setLoading(true);
      final response = await _myRepo.getLegalNoticeDetails(id);
      _detailModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load legal notice detail: ${e.toString()}");
      setLoading(false);
      _detailModel = null;
    }
  }

  Future<void> addComment(dynamic data, BuildContext context, String id) async {
    try {
      final response = await _myRepo.createComment(data, id);

      debugPrint('Create Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // FIXED: Check for the actual response structure
      // The API returns: {"message": "...", "comment": {...}}
      if (decoded['comment'] != null) {
        String msg = decoded['message'] ?? 'Comment added successfully';

        // Refresh the details to show the new comment
        await fetchLegalNoticeDetail(context, id);

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

      // FIXED: Check for the actual response structure
      if (decoded['comment'] != null) {
        String msg = decoded['message'] ?? 'Comment added successfully';

        // Refresh the details to show the new comment
        await fetchLegalNoticeDetail(context, id);

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