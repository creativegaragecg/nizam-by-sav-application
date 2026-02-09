import 'package:flutter/material.dart';
import 'package:savvyions/models/bills.dart';
import 'package:savvyions/models/ownerPayment.dart';
import 'package:savvyions/repository/bills_repository.dart';


class BillsViewModel extends ChangeNotifier {
  final _myRepo = BillsRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // User profile with getter/setter
  BillsModel? _billsModel;

  BillsModel? get billsModel => _billsModel;

 OwnerPaymentModel? _ownerPaymentModel;

  OwnerPaymentModel? get ownerPaymentModel => _ownerPaymentModel;


  Future<void> fetchBills(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getUnpaidBills();
      _billsModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load bills: ${e.toString()}");
      setLoading(false);
      _billsModel = null;
    }
  }

  Future<void> fetchOwnerBills(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getOwnerPayments();
      _ownerPaymentModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load owner bills: ${e.toString()}");
      setLoading(false);
      _ownerPaymentModel = null;
    }
  }

}