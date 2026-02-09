import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:savvyions/models/serviceSuspension.dart';
import 'package:savvyions/models/serviceSuspensionDetail.dart';
import 'package:savvyions/repository/serviceSuspensionRepo.dart';
import '../Utils/Constants/utils.dart';

class ServiceSuspensionViewModel extends ChangeNotifier {
  final _myRepo = ServiceSuspensionRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ServiceSuspensionModel? _serviceSuspensionModel;

  ServiceSuspensionModel? get serviceSuspensionModel => _serviceSuspensionModel;

  ServiceSuspensionDetailModel? _detailModel;

  ServiceSuspensionDetailModel? get detailModel => _detailModel;

  Future<void> fetchSuspensions(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getServiceSuspension();
      _serviceSuspensionModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load suspensions: ${e.toString()}");
      setLoading(false);
      _serviceSuspensionModel = null;
    }
  }

  Future<void> fetchDetails(BuildContext context, String id) async {
    try {
      setLoading(true);
      final response = await _myRepo.getDetails(id);
      _detailModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load suspension details: ${e.toString()}");
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
      if (decoded['success'] == true) {
        String msg = decoded['message'] ?? 'Comment added successfully';

        // Refresh the details to show the new comment
        await fetchDetails(context, id);

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


}