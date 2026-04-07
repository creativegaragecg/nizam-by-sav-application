import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/payment methods.dart';

class OfflinePaymentDialog extends StatefulWidget {
  final PaymentMethod method;
  final int billId;
  final String amount;
  final Function(Map<String, dynamic>) onSubmit;

  const OfflinePaymentDialog({
    Key? key,
    required this.method,
    required this.billId,
    required this.amount,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<OfflinePaymentDialog> createState() => _OfflinePaymentDialogState();
}

class _OfflinePaymentDialogState extends State<OfflinePaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedPaymentMethod;
  PlatformFile? _receiptFile;
  String? _fileName;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.method.name;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _receiptFile = result.files.single;  // CHANGED: Store PlatformFile directly
          _fileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick file")),
      );
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_receiptFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload a receipt")),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final paymentData = {
        'rent_id': widget.billId,
        'description': _descriptionController.text.trim(),
        'receipt_file': _receiptFile,
        'offline_method_id': widget.method.offlineMethodId,
      };

      widget.onSubmit(paymentData);
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 90.w,
        constraints: BoxConstraints(maxHeight: 80.h),
        padding: EdgeInsets.all(3.h),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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

                // Payment Method Dropdown
                CustomText(
                  text: "Payment Method *",
                  style: basicColorBold(14, Colors.black87),
                ),
                SizedBox(height: 1.h),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: InputDecoration(
                    hintText: "Select Payment Method",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  ),
                  items: [widget.method.name ?? "Offline Payment"]
                      .map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a payment method";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                // Description
                CustomText(
                  text: "Description *",
                  style: basicColorBold(14, Colors.black87),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Payment Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                // Upload Receipt
                CustomText(
                  text: "Upload Receipt *",
                  style: basicColorBold(14, Colors.black87),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, color: Colors.white, size: 20),
                        SizedBox(width: 2.w),
                        CustomText(
                          text: "Choose file",
                          style: basicColorBold(14, Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                CustomText(
                  text: _fileName ?? "No file chosen",
                  style: basicColor(15, AppColors.greenColor),
                ),
                SizedBox(height: 1.h),
                CustomText(
                  text: "JPG, JPEG, PNG, PDF, DOC, DOCX (Max. 3MB per file)",
                  style: basicColor(14, Colors.grey.shade600),
                ),
                SizedBox(height: 3.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenColor,
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                        : CustomText(
                      text: "Submit Payment Request",
                      style: basicColorBold(15, Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 1.5.h),

                // Close Button
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: CustomText(
                      text: "Close",
                      style: basicColorBold(15, Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}