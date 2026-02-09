import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/providers/bills_provider.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/styles.dart';
import '../Utils/Constants/utils.dart';
import '../Utils/Custom/customBgScreen.dart';
import '../Utils/Custom/custom_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                            String dueAmount = bill.dueAmount ?? "N/A";
                            String paidAmount = bill.paidAmount ?? "N/A";
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
                                          ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WebViewScreen(url: dummyPaymentUrl),
                                          ),
                                        );
                                      }
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
                                            ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WebViewScreen(url: dummyPaymentUrl),
                                            ),
                                          );
                                        }
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

class WebViewScreen extends StatelessWidget {
  final String url;
  const WebViewScreen({required this.url, super.key});

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
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}