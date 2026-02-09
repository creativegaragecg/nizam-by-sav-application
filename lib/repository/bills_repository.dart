import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/bills.dart';
import 'package:savvyions/models/ownerPayment.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class BillsRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<BillsModel> getUnpaidBills() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.bills}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.bills);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Bill response: $response");
        return BillsModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return BillsModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting bills: $e");
      rethrow;
    }
  }


  Future<OwnerPaymentModel> getOwnerPayments() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.ownerPayment}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.ownerPayment);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Owner Payment response: $response");
        return OwnerPaymentModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return OwnerPaymentModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting payments: $e");
      rethrow;
    }
  }

}
