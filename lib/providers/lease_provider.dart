import 'package:flutter/material.dart';
import 'package:savvyions/models/leaseDetail.dart';
import 'package:savvyions/models/mylease.dart';
import 'package:savvyions/repository/lease_repository.dart';


class LeaseViewModel extends ChangeNotifier {
  final _myRepo = LeaseRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // User profile with getter/setter
  MyLeaseModel? _leaseModel;

  MyLeaseModel? get leaseModel => _leaseModel;

  // User profile with getter/setter
  LeaseDetailModel? _leaseDetailModel;

  LeaseDetailModel? get leaseDetailModel => _leaseDetailModel;

  Future<void> fetchLease(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getLeases();
      _leaseModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load my leases: ${e.toString()}");
      setLoading(false);
      _leaseModel = null;
    }
  }

  Future<void> fetchLeaseDetails(BuildContext context,String leaseId) async {
    try {
      setLoading(true);
      final response = await _myRepo.getLeaseDetails(leaseId);
      _leaseDetailModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load lease detail: ${e.toString()}");
      setLoading(false);
      _leaseDetailModel = null;
    }
  }

}
