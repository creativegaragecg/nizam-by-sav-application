import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:savvyions/models/agents.dart';
import 'package:savvyions/models/gatepassrequests.dart';
import 'package:savvyions/models/ticketTenants.dart';
import 'package:savvyions/models/ticketTypes.dart';
import 'package:savvyions/repository/gatepass_repository.dart';
import '../Utils/Constants/utils.dart';
import '../models/gatePassDetail.dart';
import '../models/gatePassTypes.dart';
import '../models/ticketDetails.dart';
import '../models/tickets.dart';


class GatePassViewModel extends ChangeNotifier {
  final _myRepo = GatePassRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  GatePassRequestModel? _gatePassRequestModel;
  GatePassRequestModel? get gatePassRequestModel => _gatePassRequestModel;

  GatePassRequestDetailModel? _detailModel;
  GatePassRequestDetailModel? get detailModel => _detailModel;


  GatePassTypesModel? _gatePassTypesModel;
  GatePassTypesModel? get gatePassTypesModel => _gatePassTypesModel;



  Future<void> fetchGatePass(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getGatePass();
      _gatePassRequestModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load gate pass: ${e.toString()}");
      setLoading(false);
      _gatePassRequestModel = null;
    }
  }

  Future<void> fetchGatePassDetails(BuildContext context,String id) async {
    try {
      setLoading(true);
      final response = await _myRepo.getGatePassDetail(id);
      _detailModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load gate pass details: ${e.toString()}");
      setLoading(false);
      _detailModel = null;
    }
  }


  Future<void> fetchGetPassTypes(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getGetPassTypes();
      _gatePassTypesModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load get pass types: ${e.toString()}");
      setLoading(false);
      _gatePassTypesModel = null;
    }
  }


  Future<void> addGatePass(dynamic data, BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.createGatePass(data);

      debugPrint('Create Gate Pass Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'];
        setLoading(false);
        Navigator.pop(context);
        fetchGatePass(context);
        showToast(msg);
      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to create Gate Pass Request';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);
      showToast("An error occurred");
    }
  }


}