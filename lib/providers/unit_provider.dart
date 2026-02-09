import 'package:flutter/material.dart';
import 'package:savvyions/models/leaseDetail.dart';
import 'package:savvyions/models/mylease.dart';
import 'package:savvyions/models/unitDetails.dart';
import 'package:savvyions/repository/lease_repository.dart';
import 'package:savvyions/repository/unit_repository.dart';

import '../models/myunits.dart';


class UnitViewModel extends ChangeNotifier {
  final _myRepo = UnitRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // User profile with getter/setter
  MyUnits? _myUnits;

  MyUnits? get myUnits => _myUnits;

  // User profile with getter/setter
  UnitDetails? _unitDetailModel;

  UnitDetails? get unitDetailModel => _unitDetailModel;

  Future<void> fetchUnits(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getUnits();
      _myUnits = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load my units: ${e.toString()}");
      setLoading(false);
      _myUnits = null;
    }
  }

  Future<void> fetchUnitDetails(BuildContext context,String unitId) async {
    try {
      setLoading(true);
      final response = await _myRepo.getUnitDetails(unitId);
      _unitDetailModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load unit detail: ${e.toString()}");
      setLoading(false);
      _unitDetailModel = null;
    }
  }

}
