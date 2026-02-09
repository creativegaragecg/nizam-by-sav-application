import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:savvyions/models/gatepassrequests.dart';
import 'package:savvyions/models/visitor.dart';
import 'package:savvyions/models/visitorAppartment.dart';
import 'package:savvyions/repository/gatepass_repository.dart';
import 'package:savvyions/repository/visitor_repository.dart';
import '../Utils/Constants/utils.dart';
import '../models/gatePassTypes.dart';
import '../models/visitorTypes.dart';



class VisitorViewModel extends ChangeNotifier {
  final _myRepo = VisitorRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  VisitorModel? _visitorModel;
  VisitorModel? get visitorModel => _visitorModel;

  VisitorAppartmentModel? _visitorAppartmentModel;
  VisitorAppartmentModel? get visitorAppartmentModel => _visitorAppartmentModel;

  VisitorTypesModel? _visitorTypesModel;
  VisitorTypesModel? get visitorTypesModel => _visitorTypesModel;



  Future<void> fetchVisitors(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getVisitor();
      _visitorModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load visitors: ${e.toString()}");
      setLoading(false);
      _visitorModel = null;
    }
  }

  Future<void> fetchVisitorAppartments(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getVisitorAppartments();
      _visitorAppartmentModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load visitor apartment: ${e.toString()}");
      setLoading(false);
      _visitorAppartmentModel = null;
    }
  }


  Future<void> fetchVisitorTypes(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getVisitorTypes();
      _visitorTypesModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load visitor types: ${e.toString()}");
      setLoading(false);
      _visitorTypesModel = null;
    }
  }



  Future<void> addVisitors(dynamic data, BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.createVisitor(data);

      debugPrint('Create Visitor Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'];
        setLoading(false);
        Navigator.pop(context);
        fetchVisitors(context);
        showToast(msg);
      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to create ticket';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);
      showToast("An error occurred");
    }
  }

  Future<void> addVisitorWithFile(Map<String, dynamic> data, BuildContext context, {PlatformFile? file,String? path}) async {
    try {
      setLoading(true);

      debugPrint('Adding ticket with file...');
      final response = await _myRepo.createVisitorWithFileApi(data, file: file,path: path);

      debugPrint('Create Ticket Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'] ?? 'Ticket created successfully';
        setLoading(false);
        Navigator.pop(context);
        fetchVisitors(context);
        showToast(msg);
      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to create ticket';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);
      showToast("An error occurred while creating ticket");
    }
  }


}