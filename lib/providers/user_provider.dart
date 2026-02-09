import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:savvyions/models/health.dart';
import 'package:savvyions/models/overdue.dart';
import '../../Data/token.dart';
import '../Utils/Constants/utils.dart';
import '../models/userprofile.dart';
import '../repository/user_repository.dart';

class UserProfileViewModel extends ChangeNotifier {
  final _myRepo = UserProfileRepository();
  bool _loading = false;
  final userToken = UserToken();

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // User profile with getter/setter
  UserProfileModel? _userProfile;

  UserProfileModel? get userProfile => _userProfile;

OverDueAmountModel? _amountModel;

  OverDueAmountModel? get amountModel => _amountModel;

  HealthModel? _healthModel;

  HealthModel? get healthModel => _healthModel;

  Future<void> fetchUserProfile(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getUserProfile();
      _userProfile = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load user profile: ${e.toString()}");
      setLoading(false);
      _userProfile = null;
    }
  }


  Future<void> fetchDueAmount(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getOverDueAmount();
      _amountModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load due amount: ${e.toString()}");
      setLoading(false);
      _amountModel = null;
    }
  }




  Future<void> fetchHealth(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.healthApi();
      _healthModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load health: ${e.toString()}");
      setLoading(false);
      _healthModel = null;
    }
  }




}
