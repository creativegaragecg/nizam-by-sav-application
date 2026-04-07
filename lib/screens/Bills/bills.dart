import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/providers/bills_provider.dart';
import 'package:savvyions/screens/Bills/payment%20methods.dart';
import '../../Data/token.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/custom_text.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../models/payment methods.dart';

class Bills extends StatefulWidget {
  const Bills({super.key, required this.role});
  final String role;

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  bool isPaid = false; // false = unpaid bills (default), true = paid bills

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchBills();
      print("Role name : ${widget.role}");
    });
  }

  Future<void> _handlePaymentClick(BillsViewModel bills, dynamic billId) async {
    // Store the navigator and scaffold messenger BEFORE any async operations
    final navigatorState = Navigator.of(context);

    var data = {
      "rent_id": billId
    };

    await bills.fetchPaymentMethods(context, data);

    if (!mounted) return;

    if (bills.methodsModel != null &&
        bills.methodsModel!.success == true &&
        bills.methodsModel!.data != null &&
        bills.methodsModel!.data!.paymentMethods != null &&
        bills.methodsModel!.data!.paymentMethods!.isNotEmpty) {

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return PaymentMethodsDialog(
            paymentMethodsData: bills.methodsModel!,
            onMethodSelected: (PaymentMethod selectedMethod) async {
              // Close dialog first
              if (selectedMethod.type == "offline")
                Navigator.pop(dialogContext);

              // Wait for dialog to close completely
              if (selectedMethod.type == "offline")
                  await Future.delayed(Duration(milliseconds: 200));

              // Use a callback to navigate after dialog closes
              if (selectedMethod.type == "offline") {
              // Get the amount from the bill
              String billAmount = bills.methodsModel!.data?.amount ?? "0";

              bills.handleOfflinePayment(
              context,
              selectedMethod,
              billId ?? 0,
              "${UserToken.currency}$billAmount",
              );
              } else {
                // Handle online payment
                var paymentData = {
                  "rent_id": billId,
                  "payment_method": selectedMethod.name?.toLowerCase() ?? ""
                };

                print("🟢 Initiating payment for ${selectedMethod.name}");
                dynamic response = await bills.fetchInitiateMethods(context, paymentData);
                print("🟢 Payment response received: $response");

                if (response != null) {
                  Map<String, dynamic> parsedResponse;
                  if (response is String) {
                    parsedResponse = json.decode(response);
                  } else {
                    parsedResponse = response as Map<String, dynamic>;
                  }

                  if (parsedResponse['success'] == true && parsedResponse['data'] != null) {
                    String paymentUrl = parsedResponse['data']['payment_url'];
                    print("🟢 Navigating to payment URL: $paymentUrl");

                    // Use the stored navigator instead of context
                    navigatorState.push(
                      MaterialPageRoute(
                        builder: (ctx) => WebViewScreen(url: paymentUrl,role: widget.role,),
                      ),
                    );
                    print("🟢 Navigation completed");
                  } else {
                    String errorMessage = parsedResponse['message'] ?? "Failed to initiate payment";
                    print("🔴 Payment error: $errorMessage");
                    showToast(errorMessage);
                  }
                } else {
                  print("🔴 Response is null");
                  showToast("Failed to initiate payment");
                }
              }
            },
          );
        },
      );
    } else {
      showToast("Failed to load payment methods or no methods available");
    }
  }


  Future<void> fetchBills() async {
    var provider=  Provider.of<BillsViewModel>(
      context,
      listen: false,
    );
    if(widget.role=="Tenant"){
      provider.fetchBills(context);
    }
    else if(widget.role=="Owner"){
      provider.fetchOwnerBills(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                    ),
                    SizedBox(width: 3.w),
                    CustomText(
                      text: "Bills",
                      style: basicColorBold(18, Colors.black),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPaid = !isPaid;
                    });
                  },
                  child: IntrinsicWidth(
                    child: Container(
                      height: 4.h,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? AppColors.greenColor
                            : AppColors.greenColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isPaid ? Icons.check_circle : Icons.pending,
                            color: isPaid ? Colors.white : AppColors.greenColor,
                            size: 18,
                          ),
                          SizedBox(width: 1.w),
                          CustomText(
                            text: "Paid Bills",
                            style: basicColorBold(
                              15,
                              isPaid ? Colors.white : AppColors.greenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            customHeaderLine(context),
            SizedBox(height: 2.5.h),
            if(widget.role=="Tenant")
            Consumer<BillsViewModel>(
              builder: (context, bills, child) {
                var allBills = bills.billsModel?.data?.bills ?? [];

                // Filter bills based on isPaid toggle
                var billsList = allBills.where((bill) {
                  String status = bill.status?.toLowerCase() ?? "";
                  if (isPaid) {
                    return status == "paid";
                  } else {
                    return status == "unpaid";
                  }
                }).toList();

                if (bills.loading) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                      ),
                    ),
                  );
                }

                if (billsList.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isPaid ? Icons.check_circle_outline : Icons.receipt_long_outlined,
                            size: 60,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: isPaid
                                ? "No paid bills available"
                                : "No unpaid bills available",
                            style: basicColorBold(16, Colors.grey),
                          ),
                          SizedBox(height: 1.h),
                          CustomText(
                            text: isPaid
                                ? "You don't have any paid bills yet"
                                : "Great! All your bills are paid",
                            style: basicColor(13, Colors.grey.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        color: AppColors.greenColor.withOpacity(0.1),
                        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                        child: Row(
                          children: [
                            buildHeaderCell("Bill Type", 1.1),
                            buildHeaderCell("Amount", 1),
                            buildHeaderCell("Paid", 1.1),

                            buildHeaderCell("Status", 1),
                            buildHeaderCell("Due Date", 1.2),
                            buildHeaderCell("Actions", 1.2),
                          ],
                        ),
                      ),
                      // Divider
                      Container(height: 1, color: AppColors.cardBorderColor),
                      // Table Rows
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: billsList.length,
                          itemBuilder: (context, index) {
                            final bill = billsList[index];
                            String billDate = bill.billDate?.toString().split(' ')[0] ?? "N/A";
                            String dueDate = bill.billDueDate?.toString().split(' ')[0] ?? "N/A";
                            // Use billType.name from nested object
                            String billType = bill.type ?? "N/A";
                            String dueAmount = "${UserToken.currency}${bill.dueAmount}" ?? "N/A";
                            String paidAmount = "${UserToken.currency}${bill.paidAmount}" ?? "N/A";
                            String status = bill.status ?? "N/A";

                            Color statusColor = status.toLowerCase() == "paid"
                                ? Colors.green
                                : status.toLowerCase() == "unpaid"
                                ? Colors.red
                                : Colors.orange;

                            String dummyPaymentUrl = "https://stripe.com";

                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.cardBorderColor.withOpacity(0.3),
                                    width: 0.5,
                                  ),
                                ),
                                color: index % 2 == 0
                                    ? Colors.white
                                    : Colors.grey.withOpacity(0.05),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 1.w),
                              child: Row(
                                children: [
                                  buildDataCell(billType.toTitleCase(), 1.1),
                                  buildDataCell(dueAmount, 1),
                                  buildDataCell(paidAmount, 1.1),

                                  Expanded(
                                    flex: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.5.w,
                                        vertical: 0.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          text: status.toTitleCase(),
                                          style: basicColorBold(12.5, statusColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  buildDataCell(dueDate, 1.2),
                                  Expanded(
                                    flex: 12,
                                    child: GestureDetector(
                                      onTap: status.toLowerCase() == "unpaid"
                                          ? () => _handlePaymentClick(bills, bill.id)
                                          : null,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                        child: Center(
                                          child: CustomText(
                                            text: status.toLowerCase() == "paid"
                                                ? "Paid"
                                                : "Pay Online",
                                            style: basicColorBold(
                                              12.5,
                                              status.toLowerCase() == "paid"
                                                  ? Colors.grey
                                                  : AppColors.greenColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            if(widget.role=="Owner")
              Consumer<BillsViewModel>(
                builder: (context, bills, child) {
                  var allBills = bills.ownerPaymentModel?.data?.payments ?? [];

                  // Filter bills based on isPaid toggle
                  var billsList = allBills.where((bill) {
                    String status = bill.status?.toLowerCase() ?? "";
                    if (isPaid) {
                      return status == "paid";
                    } else {
                      return status == "unpaid";
                    }
                  }).toList();

                  if (bills.loading) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                        ),
                      ),
                    );
                  }

                  if (billsList.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isPaid ? Icons.check_circle_outline : Icons.receipt_long_outlined,
                              size: 60,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              text: isPaid
                                  ? "No paid bills available"
                                  : "No unpaid bills available",
                              style: basicColorBold(16, Colors.grey),
                            ),
                            SizedBox(height: 1.h),
                            CustomText(
                              text: isPaid
                                  ? "You don't have any paid bills yet"
                                  : "Great! All your bills are paid",
                              style: basicColor(13, Colors.grey.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          color: AppColors.greenColor.withOpacity(0.1),
                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                          child: Row(
                            children: [
                              buildHeaderCell("Bill Type", 1.1),
                              buildHeaderCell("Due Amount", 1),
                              buildHeaderCell("Paid", 1.1),

                              buildHeaderCell("Status", 1),
                              buildHeaderCell("Due Date", 1.2),
                              buildHeaderCell("Actions", 1.2),
                            ],
                          ),
                        ),
                        // Divider
                        Container(height: 1, color: AppColors.cardBorderColor),
                        // Table Rows
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: billsList.length,
                            itemBuilder: (context, index) {
                              final bill = billsList[index];
                              String billType = bill.type ?? "N/A";
                              String dueAmount = bill.dueAmount?.toString() ?? "N/A";
                              String paidAmount = bill.paidAmount?.toString() ?? "N/A";

                              String dueDate = bill.dueDate?.toString().split(' ')[0] ?? "N/A";
                              String status = bill.status ?? "N/A";

                              Color statusColor = status.toLowerCase() == "paid"
                                  ? Colors.green
                                  : status.toLowerCase() == "unpaid"
                                  ? Colors.red
                                  : Colors.orange;


                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.cardBorderColor.withOpacity(0.3),
                                      width: 0.5,
                                    ),
                                  ),
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.grey.withOpacity(0.05),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 1.w),
                                child: Row(
                                  children: [
                                    buildDataCell(billType.toTitleCase(), 1.1),
                                    buildDataCell(dueAmount, 1),
                                    buildDataCell(paidAmount, 1.1),

                                    Expanded(
                                      flex: 10,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.5.w,
                                          vertical: 0.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: CustomText(
                                            text: status.toTitleCase(),
                                            style: basicColorBold(12.5, statusColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    buildDataCell(dueDate, 1.2),
                                    Expanded(
                                      flex: 12,
                                      child: GestureDetector(
                                        onTap: status.toLowerCase() == "unpaid"
                                            ? () => _handlePaymentClick(bills, bill.id)
                                            : null,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                          child: Center(
                                            child: CustomText(
                                              text: status.toLowerCase() == "paid"
                                                  ? "Paid"
                                                  : "Pay Online",
                                              style: basicColorBold(
                                                12.5,
                                                status.toLowerCase() == "paid"
                                                    ? Colors.grey
                                                    : AppColors.greenColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

          ],
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final String role;
  const WebViewScreen({required this.url,required this.role, super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;


  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (UrlChange change) {
            final url = change.url?.toLowerCase() ?? '';
            if (_isSuccessUrl(url)) {
              if (mounted) {
                Navigator.pop(context); // auto navigate back
                showToast("Payment Successful!");
                var provider=  Provider.of<BillsViewModel>(
                  context,
                  listen: false,
                );
                if(widget.role=="Tenant"){
                  provider.fetchBills(context);
                }
                else if(widget.role=="Owner"){
                  provider.fetchOwnerBills(context);
                }
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _isSuccessUrl(String url) {
    // Adjust these keywords to match your payment gateway's success redirect URL
    return url.contains('success') ||
        url.contains('payment-success') ||
        url.contains('payment_success') ||
        url.contains('complete') ||
        url.contains('thankyou') ||
        url.contains('thank-you') || url.contains('finish');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        title: CustomText(
          text: "Payment",
          style: basicColorBold(18, Colors.white),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}