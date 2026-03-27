import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/payment methods.dart';


class PaymentMethodsDialog extends StatelessWidget {
  final PaymentMethodsModel paymentMethodsData;
  final Function(PaymentMethod) onMethodSelected;

  const PaymentMethodsDialog({
    Key? key,
    required this.paymentMethodsData,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = paymentMethodsData.data;
    final paymentMethods = data?.paymentMethods ?? [];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 90.w,
        padding: EdgeInsets.all(3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Choose Payment Method",
                  style: basicColorBold(17, Colors.black),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Payment Details (if needed)
            if (data?.rentDetails != null) ...[
              Container(
                padding: EdgeInsets.all(2.h),
                decoration: BoxDecoration(
                  color: AppColors.greenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Tenant:", data?.rentDetails?.tenantName ?? "N/A"),
                    SizedBox(height: 0.5.h),
                    _buildInfoRow("Apartment:", data?.rentDetails?.apartment ?? "N/A"),
                    SizedBox(height: 0.5.h),
                    _buildInfoRow(
                      "Month:",
                      "${data?.rentDetails?.forMonth ?? "N/A"} ${data?.rentDetails?.forYear ?? ""}",
                    ),
                    SizedBox(height: 0.5.h),
                    _buildInfoRow(
                      "Amount:",
                      "${data?.currencySymbol ?? ""}${data?.amount ?? "N/A"}",
                      isAmount: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Payment Methods Grid
            if (paymentMethods.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: CustomText(
                    text: "No payment methods available",
                    style: basicColor(15, Colors.grey),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 1.3,
                ),
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  return _buildPaymentMethodCard(context, method);
                },
              ),

            SizedBox(height: 2.h),

            // Close Button
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: CustomText(
                  text: "Close",
                  style: basicColorBold(16, Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          style: basicColor(15, Colors.black87),
        ),
        CustomText(
          text: value,
          style: isAmount
              ? basicColorBold(15, AppColors.greenColor)
              : basicColorBold(15, Colors.black),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(BuildContext context, PaymentMethod method) {
    return GestureDetector(
      onTap: () {
        onMethodSelected(method);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.greenColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            if (method.iconUrl != null && method.iconUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  method.iconUrl!,
                  height: 5.h,
                  width: 5.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultIcon();
                  },
                ),
              )
            else
              _buildDefaultIcon(),

            SizedBox(height: 1.h),

            // Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Center(
                child: CustomText(
                  text: method.name ?? "Payment Method",
                  style: basicColorBold(14.5, Colors.black87),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Container(
      height: 5.h,
      width: 5.h,
      decoration: BoxDecoration(
        color: AppColors.greenColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.payment,
        color: AppColors.greenColor,
        size: 3.h,
      ),
    );
  }
}