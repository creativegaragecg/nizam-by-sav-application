/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savvyions/Utils/Custom/navigationbar.dart';
import 'package:savvyions/screens/AuthScreens/loginScreen.dart';
import 'package:savvyions/screens/mainLandingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/token.dart';
import '../Repository/auth_repository.dart';
import '../Utils/Constants/utils.dart';
import '../models/userprofile.dart';

class AuthViewModel extends ChangeNotifier {
  final _myRepo = AuthRepository();
  bool _loading = false;
  final userToken = UserToken();

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.loginApi(data);

      debugPrint('LoginData: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {
        // ✅ Get access_token from data.tokens
        String token = decoded['data']['tokens']['access_token'] ?? '';
        String tokenType = decoded['data']['tokens']['token_type'] ?? 'Bearer';

        String msg = decoded['message'];
        debugPrint("Login Msg: $msg");
        debugPrint("USER TOKEN: $token");

        userToken.setUserToken(token: token);


        var prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);

        // ✅ Pass entire user data to UserProfileModel

       UserProfileModel userProfile = UserProfileModel.fromJson(decoded['data']['user']);
       num id=decoded['data']['user']['info']['id']??0;
       String name=decoded['data']['user']['info']['name']?? '';
       String email=decoded['data']['user']['info']['email']?? '';


          // Store basic info
          userToken.setUserInfo(
            userId:int.parse(id.toString()),
              userName:name,
              userEmail:email,
          );


          debugPrint("User ID: $id");
          debugPrint("User Name: $name");
          debugPrint("User Email: $email");



        setLoading(false);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationBarScreen(),
          ),
              (route) => false,
        );

        showToast(msg);

      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Login failed';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);

    }
  }


  Future<void> changePass(dynamic data, BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.changePassApi(data);

      debugPrint('LoginData: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {

        String msg = decoded['message'];
        debugPrint("Change Pass Msg: $msg");
        setLoading(false);
        showToast(msg);

      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to change password';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);

    }
  }

}
*/


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savvyions/Utils/Custom/navigationbar.dart';
import 'package:savvyions/models/acknowledge.dart';
import 'package:savvyions/screens/AuthScreens/loginScreen.dart';
import 'package:savvyions/screens/mainLandingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/token.dart';
import '../Repository/auth_repository.dart';
import '../Utils/Constants/urls.dart';
import '../Utils/Constants/utils.dart';
import '../models/account.dart';
import '../models/userprofile.dart';

class AuthViewModel extends ChangeNotifier {
  final _myRepo = AuthRepository();
  final userToken = UserToken();

  // List of all accounts
  List<Account> _accounts = [];
  List<Account> get accounts => _accounts;

  // Currently active account
  Account? _currentAccount;
  Account? get currentAccount => _currentAccount;

  AcknowledgeModel? _acknowledgeModel;
  AcknowledgeModel? get acknowledgeModel => _acknowledgeModel;


  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }


  Future<void> changePass(dynamic data, BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.changePassApi(data);

      debugPrint('Change Password data: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true) {

        String msg = decoded['message'];
        debugPrint("Change Pass Msg: $msg");
        Navigator.pop(context);
        setLoading(false);
        showToast(msg);

      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to change password';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);

    }
  }


  Future<void> forgotPass(dynamic data) async {
    try {
      setLoading(true);
      final response = await _myRepo.forgotPassApi(data);

      debugPrint('Forgot Pass data: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {

        String msg = decoded['message'];
        debugPrint("Change Pass Msg: $msg");
        setLoading(false);
        showToast(msg);

      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to change password';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);

    }
  }
  // final storage = FlutterSecureStorage(); // for secure version

  Future<void> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getStringList('accounts') ?? [];

    _accounts = accountsJson
        .map((json) => Account.fromJson(jsonDecode(json)))
        .toList();

    // Load current active (last used)
    final currentEmail = prefs.getString('current_email');

    if (currentEmail != null) {
      _currentAccount = _accounts.firstWhere(
            (acc) => acc.email == currentEmail,
        orElse: () => throw Exception('Account not found'), // Must return Account, so throw instead
      );
    }

    if (_currentAccount == null && _accounts.isNotEmpty) {
      _currentAccount = _accounts.last; // fallback to last used
    }

    // Set token in your NetworkApiService header (important!)
    if (_currentAccount != null) {
      // Update your api service to use current token
      userToken.setUserToken(token:_currentAccount!.token,url: _currentAccount!.baseUrl);
      // Also update your UserToken singleton if still needed
    }

    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context,

  {
    required String societyName,  // NEW PARAMETER
    required String baseUrl,
  } ) async {
    setLoading(true);
    try {
      AppEndPoints.baseUrl = baseUrl;

      final response = await _myRepo.loginApi(data,baseUrl:baseUrl);
      final Map<String, dynamic> decoded = jsonDecode(response);

      if (decoded['success'] == true && decoded['data'] != null) {
        String token = decoded['data']['tokens']['access_token'] ?? '';
        num id = decoded['data']['user']['info']['id'] ?? 0;
        String name = decoded['data']['user']['info']['name'] ?? '';
        String email = decoded['data']['user']['info']['email'] ?? '';

        final newAccount = Account(
          email: email,
          token: token,
          userId: int.parse(id.toString()),
          userName: name,
          societyName: societyName,
          baseUrl: baseUrl
        );

        // Add or update account
        final prefs = await SharedPreferences.getInstance();
        final existingIndex =
        _accounts.indexWhere((acc) => acc.email == email);

        if (existingIndex != -1) {
          _accounts[existingIndex] = newAccount; // update token
        } else {
          _accounts.add(newAccount);
        }

        // Save all accounts
        final accountsJson =
        _accounts.map((acc) => jsonEncode(acc.toJson())).toList();
        prefs.setStringList('accounts', accountsJson);

        // Set as current
        await switchToAccount(email);

        showToast(decoded['message']);
        UserToken().loadUserToken();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const NavigationBarScreen()),
              (route) => false,
        );
      } else {
        showToast(decoded['message'] ?? 'Login failed');
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      showToast("Login Failed");
    }
    setLoading(false);
  }

  Future<void> switchToAccount(String email) async {
    final account = _accounts.firstWhere((acc) => acc.email == email);
    _currentAccount = account;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_email', email);

    // Update base URL for the switched account
    AppEndPoints.baseUrl = account.baseUrl;  // NEW
    debugPrint('Switched to account: ${account.email}');
    debugPrint('Base URL updated to: ${account.baseUrl}');

    // Update API service with new token
    userToken.setUserToken(token:account.token,url: account.baseUrl);
    // ✅ Force reload from SharedPreferences to ensure consistency
    await userToken.loadUserToken();
    loadAccounts();

    notifyListeners();
  }

  Future<void> logoutCurrentAccount() async {
    if (_currentAccount == null) return;

    final prefs = await SharedPreferences.getInstance();
    _accounts.removeWhere((acc) => acc.email == _currentAccount!.email);

    // Save updated list
    final accountsJson =
    _accounts.map((acc) => jsonEncode(acc.toJson())).toList();
    prefs.setStringList('accounts', accountsJson);

    // Switch to another if exists
    if (_accounts.isNotEmpty) {
      await switchToAccount(_accounts.last.email);
    } else {
      prefs.remove('current_email');
      _currentAccount = null;
      userToken.setUserToken(token: null,url: null);
    }

    notifyListeners();
  }

  Future<void> logoutAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // or just remove accounts keys
    _accounts.clear();
    _currentAccount = null;
    userToken.setUserToken(token: null,url: null);
    notifyListeners();
  }


  Future<void> hitEmergency() async {
    try {
      setLoading(true);
      final response = await _myRepo.emergencyApi();

      debugPrint('Health Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'];
        setLoading(false);
        showToast(msg);
      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Fail to sent emergency alert';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);
      showToast("An error occurred");
    }
  }


  Future<void> emergencyAcknowledge(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getEmergencyResponse();
      _acknowledgeModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load acknowledge response: ${e.toString()}");
      setLoading(false);
      _acknowledgeModel = null;
    }
  }

/*
  Future<void> emergencyAcknowledge() async {
    try {
      setLoading(true);
      final response = await _myRepo.getEmergencyResponse();

      debugPrint('Acknowledge Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] == null) {
        String msg = decoded['message'];
        setLoading(false);
        showToast(msg);
      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Fail to sent emergency alert';
        debugPrint("errorMsg: $errorMsg");
       // showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);
   //   showToast("An error occurred");
    }
  }
*/

}