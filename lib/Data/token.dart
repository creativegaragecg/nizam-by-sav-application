import 'package:flutter/material.dart';
import 'package:savvyions/Utils/Constants/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserToken with ChangeNotifier {
  static String token = "";
  static int user_id = 0;
  static String user_name = "";
  static String user_email = "";



  void setUserToken({required String? token,required String? url}) async {
    debugPrint("TOKEN SET: $token");
    token = token;
    AppEndPoints.baseUrl=url!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token??"");
    await prefs.setString('baseUrl', url??"");
    //loadUserToken();

  }


  void setUserInfo({required int userId,required String userName,required String userEmail}) async {
    user_id=userId;
    user_name=userName;
    user_email=userEmail;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId',user_id);
    prefs.setString('userName', userName);
    prefs.setString('userEmail', userEmail);

  }
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt('userId') ?? 0;
    user_name = prefs.getString('userName') ?? '';
    user_email = prefs.getString('userEmail') ?? '';

    debugPrint("ID LOAD: $user_id");
    debugPrint("USER NAME LOAD: $user_name");
    debugPrint("USER EMAIL LOAD: $user_email");

  }
  Future<void> loadUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('user_token') ?? '';
    AppEndPoints.baseUrl = prefs.getString('baseUrl') ?? '';
    debugPrint("TOKEN LOAD: $token");

  }
}
