import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/customWhiteBg.dart';
import 'package:savvyions/providers/unit_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';

class UnitDetails extends StatefulWidget {
  const UnitDetails({super.key, required this.unitId});
  final String unitId;

  @override
  State<UnitDetails> createState() => _UnitDetailsState();
}

class _UnitDetailsState extends State<UnitDetails> {

  bool isInfo = false;
  bool isContract = false;
  bool isFinancial = false;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchMyUnitDetail();
    });
  }

  Future<void> fetchMyUnitDetail() async {
    Provider.of<UnitViewModel>(
      context,
      listen: false,
    ).fetchUnitDetails(context, widget.unitId);
  }




// Add this helper method in your _UnitDetailsState class
  Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final androidVersion = await _getAndroidVersion();

    // Android 13+ (API 33+) - No permission needed for app-specific directories
    if (androidVersion >= 33) {
      return true;
    }

    // Android 11-12 (API 30-32) - Request MANAGE_EXTERNAL_STORAGE
    if (androidVersion >= 30) {
      var status = await Permission.manageExternalStorage.status;
      if (status.isGranted) {
        return true;
      }

      status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      }

      // If denied, try storage permission as fallback
      status = await Permission.storage.request();
      return status.isGranted;
    }

    // Android 10 (API 29) and below - Request WRITE_EXTERNAL_STORAGE
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<String> _getSavePath(String fileName) async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      // For Android 10+ (API 29+), use app-specific external directory
      // This doesn't require permissions and is more reliable
      if (androidVersion >= 29) {
        // Use getExternalStorageDirectory which gives us app-specific storage
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          // Create a "Downloads" folder in app-specific storage
          final downloadsDir = Directory('${directory.path}/Downloads');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          return '${downloadsDir.path}/$fileName';
        }
      } else {
        // For Android 9 and below, use public Downloads directory
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          return '${directory.path}/$fileName';
        }
      }

      // Fallback to external storage directory
      final directory = await getExternalStorageDirectory();
      return '${directory!.path}/$fileName';

    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/$fileName';
    }

    // Default fallback
    final directory = await getTemporaryDirectory();
    return '${directory.path}/$fileName';
  }

  Future<void> downloadInstallmentPlanPDF(BuildContext context) async {
    setState(() {
      isDownloading = true;
    });

    try {
      // Request storage permission
      final hasPermission = await _requestStoragePermission();

      if (!hasPermission) {
        setState(() {
          isDownloading = false;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Storage permission is required to download PDF'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () => openAppSettings(),
            ),
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      final unitViewModel = Provider.of<UnitViewModel>(context, listen: false);
      var installmentPaymentsList =
          unitViewModel.unitDetailModel?.data?.paymentProfile?.installmentPayments ?? [];

      if (installmentPaymentsList.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No installment data available')),
        );
        setState(() {
          isDownloading = false;
        });
        return;
      }

      // Get unit details for PDF header
      String unitNumber = unitViewModel.unitDetailModel?.data?.unit?.apartment?.apartmentNumber ?? "N/A";
      String tower = unitViewModel.unitDetailModel?.data?.unit?.apartment?.towers?.towerName ?? "N/A";
      String fileName = "installment_plan_${unitNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // Create PDF
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              pw.Container(
                padding: pw.EdgeInsets.only(bottom: 20),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(width: 2, color: PdfColors.green),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Installment Payment Plan',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Unit: $unitNumber', style: pw.TextStyle(fontSize: 14)),
                        pw.Text('Tower: ${tower.toTitleCase()}', style: pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Generated: ${DateTime.now().toString().substring(0, 16)}',
                      style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                columnWidths: {
                  0: pw.FlexColumnWidth(1.2),
                  1: pw.FlexColumnWidth(1.2),
                  2: pw.FlexColumnWidth(1.2),
                  3: pw.FlexColumnWidth(1.3),
                  4: pw.FlexColumnWidth(1.3),
                  5: pw.FlexColumnWidth(1),
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green100,
                    ),
                    children: [
                      _buildPDFHeaderCell('Due Amount'),
                      _buildPDFHeaderCell('Paid Amount'),
                      _buildPDFHeaderCell('Advance Amount'),
                      _buildPDFHeaderCell('Due Date'),
                      _buildPDFHeaderCell('Payment Date'),
                      _buildPDFHeaderCell('Status'),
                    ],
                  ),
                  // Data Rows
                  ...List.generate(installmentPaymentsList.length, (index) {
                    final plan = installmentPaymentsList[index];
                    String dueAmount = plan.dueAmount?.toString() ?? "N/A";
                    String paidAmount = plan.paidAmount?.toString() ?? "N/A";
                    String advanceAmount = plan.advanceAmount?.toString() ?? "N/A";
                    String dueDate = plan.dueDate?.toString().split(' ')[0] ?? "N/A";
                    String paymentDate = plan.paymentDate?.toString() ?? "N/A";
                    String status = plan.status ?? "N/A";

                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: index % 2 == 0 ? PdfColors.white : PdfColors.grey50,
                      ),
                      children: [
                        _buildPDFDataCell(dueAmount),
                        _buildPDFDataCell(paidAmount),
                        _buildPDFDataCell(advanceAmount),
                        _buildPDFDataCell(dueDate),
                        _buildPDFDataCell(paymentDate),
                        _buildPDFStatusCell(status),
                      ],
                    );
                  }),
                ],
              ),

              pw.SizedBox(height: 20),

              // Footer
              pw.Container(
                padding: pw.EdgeInsets.only(top: 20),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(width: 1, color: PdfColors.grey300),
                  ),
                ),
                child: pw.Text(
                  'Total Installments: ${installmentPaymentsList.length}',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ];
          },
        ),
      );

      // Get the appropriate save path
      final filePath = await _getSavePath(fileName);
      print('Saving PDF to: $filePath'); // Debug print

      // Save PDF
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      setState(() {
        isDownloading = false;
      });

      if (!mounted) return;

      // Get Android version for better message
      final androidVersion = await _getAndroidVersion();
      String locationMessage = androidVersion >= 29
          ? 'PDF saved in app storage/Downloads'
          : 'PDF downloaded to Downloads folder';

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$locationMessage!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Open',
            textColor: Colors.white,
            onPressed: () {
              OpenFile.open(file.path);
            },
          ),
          duration: Duration(seconds: 4),
        ),
      );

      // Automatically open the PDF
      await OpenFile.open(file.path);

    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      print('Error generating PDF: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
  pw.Widget _buildPDFHeaderCell(String text) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 11,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildPDFDataCell(String text) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildPDFStatusCell(String status) {
    PdfColor statusColor = status.toLowerCase() == "paid"
        ? PdfColors.green
        : status.toLowerCase() == "unpaid"
        ? PdfColors.red
        : PdfColors.orange;

    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      child: pw.Container(
        padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: pw.BoxDecoration(
          color: statusColor.shade(0.3),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Center(
          child: pw.Text(
            status.toTitleCase(),
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomWhiteBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          children: [
            /// Welcome area
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)),
                SizedBox(width: 3.w),
                CustomText(
                  text: "Unit Details",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),
            Consumer<UnitViewModel>(
              builder: (context, unitViewModel, child) {
                String? unitNumber = unitViewModel.unitDetailModel?.data?.unit?.apartment?.apartmentNumber ?? "N/A";
                String? status = unitViewModel.unitDetailModel?.data?.unit?.apartment?.status ?? "N/A";
                String? floor = unitViewModel.unitDetailModel?.data?.unit?.apartment?.floors?.floorName ?? "N/A";
                String? tower = unitViewModel.unitDetailModel?.data?.unit?.apartment?.towers?.towerName ?? "N/A";

              //  String contractDate = unitViewModel.unitDetailModel?.data?.unit?.contractDate.toString().substring(0, 10).split('-').reversed.join('/') ?? "N/A";

                String contractDate = unitViewModel.unitDetailModel?.data?.unit?.contractDate != null
                    ? unitViewModel.unitDetailModel!.data!.unit!.contractDate!
                    .toString()
                    .substring(0, 10)
                    .split('-')
                    .reversed
                    .join('/')
                    : "N/A";

                String? contractType = unitViewModel.unitDetailModel?.data?.unit?.contractType?.name.toString() ?? "N/A";
                String? companyCommission = unitViewModel.unitDetailModel?.data?.unit?.companyCommission ?? "N/A";
                String? agentCommission = unitViewModel.unitDetailModel?.data?.unit?.agentCommission ?? "N/A";
                String? advanceAmount = unitViewModel.unitDetailModel?.data?.unit?.advanceAmount.toString() ?? "N/A";
                String? totalAmount = unitViewModel.unitDetailModel?.data?.unit?.totalPrice.toString() ?? "N/A";

                /// payment profile
                String? totalPaymentAmount = unitViewModel.unitDetailModel?.data?.paymentProfile?.paymentSummary?.totalAmount ?? "N/A";
                String? totalDueAmount = unitViewModel.unitDetailModel?.data?.paymentProfile?.paymentSummary?.totalDueAmount ?? "N/A";
                String? totalPaidAmount = unitViewModel.unitDetailModel?.data?.paymentProfile?.paymentSummary?.totalPaidAmount ?? "N/A";
                String? lastPaymentDate = unitViewModel.unitDetailModel?.data?.paymentProfile?.paymentSummary?.lastPaymentDate.toString() ?? "N/A";
                String? lastPaymentAmount = unitViewModel.unitDetailModel?.data?.paymentProfile?.paymentSummary?.lastPaidAmount.toString() ?? "N/A";

                var installmentPaymentsList = unitViewModel.unitDetailModel?.data?.paymentProfile?.installmentPayments ?? [];

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scrollable Content
                      Flexible(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Unit Information Card (Expandable)
                                CustomCards(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Header
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isInfo = !isInfo;
                                          });
                                        },
                                        child: Container(
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.greenColor,
                                                AppColors.greenColor.withOpacity(0.6),
                                                Colors.white
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.home, color: Colors.white, size: 22),
                                                  SizedBox(width: 2.w),
                                                  CustomText(
                                                    text: "Unit Information",
                                                    style: basicColorBold(16, Colors.white),
                                                  ),
                                                ],
                                              ),
                                              AnimatedRotation(
                                                turns: isInfo ? 0.5 : 0,
                                                duration: Duration(milliseconds: 300),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down_sharp,
                                                  color: AppColors.greenColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Divider
                                      if (isInfo)
                                        Container(
                                          height: 0.2.h,
                                          width: 100.w,
                                          color: AppColors.cardBorderColor,
                                        ),

                                      // Expandable Content
                                      AnimatedSize(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        child: isInfo
                                            ? Container(
                                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                                          child: Column(
                                            children: [
                                              buildDetailRow("Unit Number", unitNumber),
                                              buildDetailRow("Tower", tower.toTitleCase()),
                                              buildDetailRow("Floor", floor),
                                              buildDetailRow("Status", status.toTitleCase()),
                                            ],
                                          ),
                                        )
                                            : SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 1.h),

                                // Contract Information Card (Expandable)
                                CustomCards(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Header
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isContract = !isContract;
                                          });
                                        },
                                        child: Container(
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.greenColor,
                                                AppColors.greenColor.withOpacity(0.6),
                                                Colors.white
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.panorama_rounded, color: Colors.white, size: 22),
                                                  SizedBox(width: 2.w),
                                                  CustomText(
                                                    text: "Contract Information",
                                                    style: basicColorBold(16, Colors.white),
                                                  ),
                                                ],
                                              ),
                                              AnimatedRotation(
                                                turns: isContract ? 0.5 : 0,
                                                duration: Duration(milliseconds: 300),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down_sharp,
                                                  color: AppColors.greenColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Divider
                                      if (isContract)
                                        Container(
                                          height: 0.2.h,
                                          width: 100.w,
                                          color: AppColors.cardBorderColor,
                                        ),

                                      // Expandable Content
                                      AnimatedSize(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        child: isContract
                                            ? Container(
                                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                                          child: Column(
                                            children: [
                                              buildDetailRow("Contract Date", contractDate),
                                              buildDetailRow("Total Amount", totalAmount),
                                              buildDetailRow("Advance Amount", advanceAmount),
                                              buildDetailRow("Company Commission", companyCommission),
                                              buildDetailRow("Agent Commission", agentCommission),
                                            ],
                                          ),
                                        )
                                            : SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 1.h),

                                // Financial Information Card (Expandable)
                                CustomCards(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Header
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isFinancial = !isFinancial;
                                          });
                                        },
                                        child: Container(
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.greenColor,
                                                AppColors.greenColor.withOpacity(0.6),
                                                Colors.white
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.currency_exchange, color: Colors.white, size: 22),
                                                  SizedBox(width: 2.w),
                                                  CustomText(
                                                    text: "Financial Information",
                                                    style: basicColorBold(16, Colors.white),
                                                  ),
                                                ],
                                              ),
                                              AnimatedRotation(
                                                turns: isFinancial ? 0.5 : 0,
                                                duration: Duration(milliseconds: 300),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down_sharp,
                                                  color: AppColors.greenColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Divider
                                      if (isFinancial)
                                        Container(
                                          height: 0.2.h,
                                          width: 100.w,
                                          color: AppColors.cardBorderColor,
                                        ),

                                      // Expandable Content
                                      AnimatedSize(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        child: isFinancial
                                            ? Container(
                                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                                          child: Column(
                                            children: [
                                              buildDetailRow("Total Amount", totalPaymentAmount),
                                              buildDetailRow("Total Due Amount", totalDueAmount),
                                              buildDetailRow("Total Paid Amount", totalPaidAmount),
                                              buildDetailRow("Last Paid Amount", lastPaymentAmount == "null" ? "N/A" : lastPaymentAmount),
                                              buildDetailRow("Last Payment Date", lastPaymentDate == 'null' ? "N/A" : lastPaymentDate),
                                            ],
                                          ),
                                        )
                                            : SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 1.h),

                                // Installment Plans (Always Open)
                                if (installmentPaymentsList.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.5.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.cornerGreyColor.withOpacity(0.2),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.payments, color: AppColors.greenColor, size: 22),
                                                SizedBox(width: 2.w),
                                                CustomText(
                                                  text: "Installment Plans",
                                                  style: basicColorBold(16, AppColors.greenColor),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: isDownloading ? null : () => downloadInstallmentPlanPDF(context),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.7.h),
                                                decoration: BoxDecoration(
                                                  color: isDownloading
                                                      ? Colors.grey
                                                      : AppColors.greenColor,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (isDownloading)
                                                      SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                        ),
                                                      )
                                                    else
                                                      Icon(Icons.download, color: Colors.white, size: 18),
                                                    SizedBox(width: 1.w),
                                                    CustomText(
                                                      text: isDownloading ? "Generating..." : "Download PDF",
                                                      style: basicColorBold(13, Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),

                                        // Table Header
                                        Container(
                                          color: AppColors.greenColor.withOpacity(0.1),
                                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                                          child: Row(
                                            children: [
                                              buildHeaderCell("Due Amount", 1),
                                              buildHeaderCell("Paid Amount", 1),
                                              buildHeaderCell("Advance Amount", 1),
                                              buildHeaderCell("Due Date", 1.2),
                                              buildHeaderCell("Payment Date", 1.2),
                                              buildHeaderCell("Status", 1),
                                            ],
                                          ),
                                        ),

                                        // Divider
                                        Container(height: 1, color: AppColors.cardBorderColor),

                                        // Table Rows
                                        Column(
                                          children: List.generate(
                                            installmentPaymentsList.length,
                                                (index) {
                                              final plan = installmentPaymentsList[index];
                                              String dueAmount = plan.dueAmount?.toString() ?? "N/A";
                                              String paidAmount = plan.paidAmount?.toString() ?? "N/A";
                                              String advanceAmount = plan.advanceAmount?.toString() ?? "N/A";
                                              String dueDate = plan.dueDate?.toString().split(' ')[0] ?? "N/A";
                                              String paymentDate = plan.paymentDate?.toString() ?? "N/A";
                                              String status = plan.status ?? "N/A";

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
                                                        width: 0.5),
                                                  ),
                                                  color: index % 2 == 0 ? Colors.white : Colors.grey.withOpacity(0.05),
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 2.w),
                                                child: Row(
                                                  children: [
                                                    buildDataCell(dueAmount, 1),
                                                    buildDataCell(paidAmount, 1),
                                                    buildDataCell(advanceAmount, 1),
                                                    buildDataCell(dueDate, 1.2),
                                                    buildDataCell(paymentDate, 1.2),
                                                    Expanded(
                                                      flex: 10,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
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
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}