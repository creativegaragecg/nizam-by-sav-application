
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:savvyions/models/forumCategories.dart';
import 'package:savvyions/models/forums.dart';
import 'package:savvyions/models/serviceTypes.dart';
import 'package:savvyions/models/services.dart';
import 'package:savvyions/repository/forums_repo.dart';
import 'package:savvyions/repository/services_repo.dart';

import '../Utils/Constants/utils.dart';
import '../models/forumDetail.dart';

class ServicesViewModel extends ChangeNotifier {
  final _myRepo = ServicesRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ServicesModel? _servicesModel;

  ServicesModel? get servicesModel => _servicesModel;

  ServiceTypesModel? _serviceTypesModel;

  ServiceTypesModel? get serviceTypesModel => _serviceTypesModel;


  Future<void> fetchServices(BuildContext context,String categoryId) async {
    try {
      setLoading(true);
      final response = await _myRepo.getServices(categoryId);
      _servicesModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load services: ${e.toString()}");
      setLoading(false);
      _servicesModel = null;
    }
  }

  Future<void> fetchServiceTypes(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getServiceTypes();
      _serviceTypesModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load service categories: ${e.toString()}");
      setLoading(false);
      _serviceTypesModel = null;
    }
  }


}