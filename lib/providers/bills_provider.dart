import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:savvyions/models/bills.dart' hide Data;
import 'package:savvyions/models/ownerPayment.dart' hide Data;
import 'package:savvyions/models/payment%20methods.dart';
import 'package:savvyions/repository/bills_repository.dart';

import '../Data/app_exceptions.dart';
import '../Utils/Constants/utils.dart';
import '../screens/Bills/bills.dart';
import '../screens/Bills/offline payment.dart';
import '../screens/Bills/payment methods.dart';


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


PaymentMethodsModel? _methodsModel;

  PaymentMethodsModel? get methodsModel => _methodsModel;

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

  Future<void> fetchPaymentMethods(BuildContext context,dynamic data) async {
    try {
      setLoading(true);
      final response = await _myRepo.postPaymentMethods(data);
      _methodsModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load owner bills: ${e.toString()}");
      setLoading(false);
      _methodsModel = null;
    }
  }

  Future<dynamic> fetchInitiateMethods(BuildContext context, dynamic data) async {
    try {
      setLoading(true);
      final response = await _myRepo.postInitiateMethods(data);
      setLoading(false);
      notifyListeners();

      // Return the response as is - it's already parsed by your API service
      return response;
    } catch (e) {
      debugPrint("Failed to initiate payment: ${e.toString()}");
      setLoading(false);

      // Return error response
      return {
        'success': false,
        'message': e.toString()
      };
    }
  }


// Add comment with file upload
  Future<void> submitOffline(
      Map<String, dynamic> data,
      BuildContext context, {
        PlatformFile? file,
      }) async {
    try {
      setLoading(true); // Start loading

      debugPrint('Adding with file...');
      final response = await _myRepo.postOfflineMethod(data, file: file);

      debugPrint('Create Response: $response');
      Map<String, dynamic> decoded;
      if (response is String) {
        decoded = jsonDecode(response);
      } else if (response is Map<String, dynamic>) {
        decoded = response;
      } else {
        throw Exception('Invalid response type');
      }

      setLoading(false); // Stop loading

      // FIXED: Check for the actual response structure
      if (decoded['success'] == true) {
        String msg = decoded['message'] ?? 'Payment request submitted successfully';
        showToast(msg);

        // Check if we can still pop before trying
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      } else {
        String errorMsg = decoded['message'] ?? 'Failed to create request';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }
    } catch (e) {
      setLoading(false); // Stop loading on error
      debugPrint("error: ${e.toString()}");
    //  showToast("An error occurred");
    }
  }

  /*Future<void> handlePaymentMethodSelection(
      PaymentMethod method,
      Data? paymentData,
      BuildContext context,
      int billId
      ) async {
    if (method.type == "offline") {
      // Handle offline payment
      showToast("Offline payment selected: ${method.name}");
      // Show offline payment instructions if available
      if (method.description != null && method.description!.isNotEmpty) {
        if (context.mounted) {
          _showOfflinePaymentInstructions(context, method);
        }
      }
    } else {
      var data = {
        "rent_id": billId,
        "payment_method": method.name?.toLowerCase() ?? ""
      };

      dynamic response = await fetchInitiateMethods(context, data);



      // Check if response is valid
      if (response != null) {
        // Parse if it's a string
        Map<String, dynamic> parsedResponse;
        if (response is String) {
          parsedResponse = json.decode(response);
        } else {
          parsedResponse = response as Map<String, dynamic>;
        }

        // Check success and extract payment URL
        if (parsedResponse['success'] == true && parsedResponse['data'] != null) {
          String paymentUrl = parsedResponse['data']['payment_url'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(url: paymentUrl),
            ),
          );
        } else {
          String errorMessage = parsedResponse['message'] ?? "Failed to initiate payment";
          showToast(errorMessage);
        }
      } else {
        showToast("Failed to initiate payment");
      }
    }
  }*/


  void _showOfflinePaymentInstructions(BuildContext context, PaymentMethod method) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(method.name ?? "Offline Payment"),
          content: Text(method.description ?? "Please follow the offline payment instructions."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void handleOfflinePayment(
      BuildContext context,
      PaymentMethod method,
      int billId,
      String amount,
      ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return OfflinePaymentDialog(
          method: method,
          billId: billId,
          amount: amount,
          onSubmit: (Map<String, dynamic> paymentData) async {
            try {
              // Call your API to submit offline payment
              await submitOffline(
                  paymentData,
                  dialogContext,
                  file: paymentData['receipt_file'] as PlatformFile?
              );
            } catch (e) {
              // If there's an error, close the dialog and show error
              Navigator.pop(dialogContext);
              showToast("Failed to submit payment");
            }
          },
        );
      },
    );
  }


}