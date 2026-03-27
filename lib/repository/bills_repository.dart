import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/bills.dart';
import 'package:savvyions/models/ownerPayment.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';
import '../models/payment methods.dart';


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

  Future<PaymentMethodsModel> postPaymentMethods(dynamic data) async {
    try {
      debugPrint('Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse(AppEndPoints.paymentMethods, data);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Payment Methods response: $response");
        return PaymentMethodsModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return PaymentMethodsModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");


    } catch (e) {
      showToast("Failed to fetch payment methods");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }


  Future<dynamic> postInitiateMethods(dynamic data) async {
    try {
      debugPrint('Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse(AppEndPoints.initiatePaymentMethods, data);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("response: $response");
        return response;
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return response;
        }
      }
      throw Exception("Response is not valid: $response");


    } catch (e) {
      showToast("Failure in payments");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }


  Future<dynamic> postOfflineMethod(dynamic data,{PlatformFile? file}) async {
    try {
      if (file != null) {
        debugPrint('File to upload: ${file.name}, Size: ${file.size} bytes');
      }
      debugPrint('Data: $data');
      // Remove the file from data map before sending
      Map<String, dynamic> cleanData = Map.from(data);
      cleanData.remove('receipt_file'); // IMPORTANT: Remove the file object

      debugPrint('Data: $cleanData');
      dynamic response = await _apiService
          .postMultipartApiResponse(AppEndPoints.offlinePayments, cleanData,file: file,path:'receipt_file' );

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("response: $response");
        return response;
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return response;
        }
      }
      throw Exception("Response is not valid: $response");


    } catch (e) {
      showToast("Failure in offline payments");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }




}
