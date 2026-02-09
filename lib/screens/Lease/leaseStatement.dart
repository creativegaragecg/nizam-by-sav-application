import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/leaseDetail.dart';
import '../../models/mylease.dart';
import '../../providers/lease_provider.dart';

class MyLeaseStatement extends StatefulWidget {
  const MyLeaseStatement({super.key, required this.leaseId});
  final String leaseId;

  @override
  State<MyLeaseStatement> createState() => _MyLeaseStatementState();
}

class _MyLeaseStatementState extends State<MyLeaseStatement> {
  bool isDownloading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchLeaseDetails();
    });
  }

  Future<void> fetchLeaseDetails() async {
    Provider.of<LeaseViewModel>(
      context,
      listen: false,
    ).fetchLeaseDetails(context,widget.leaseId);
  }


  // Helper method to get Android version
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
      if (androidVersion >= 29) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
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

  Future<void> downloadLeaseStatementPDF(BuildContext context) async {
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

      final leaseViewModel = Provider.of<LeaseViewModel>(context, listen: false);
      var rents = leaseViewModel.leaseDetailModel?.data?.paymentProfile?.paymentHistory?.rents ?? [];
      var utilities = leaseViewModel.leaseDetailModel?.data?.paymentProfile?.paymentHistory?.utilities ?? [];
      var leaseStatementList = [...rents, ...utilities];

      if (leaseStatementList.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No lease statement data available')),
        );
        setState(() {
          isDownloading = false;
        });
        return;
      }

      // Get lease details for PDF header
      String leaseRef = leaseViewModel.leaseDetailModel?.data?.lease?.apartment?.apartmentNumber ?? "N/A";
      String fileName = "lease_statement_${leaseRef}_${DateTime.now().millisecondsSinceEpoch}.pdf";

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
                      'Lease Statement',
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
                        pw.Text('Lease Ref: $leaseRef', style: pw.TextStyle(fontSize: 14)),
                       // pw.Text('Tenant: $tenantName', style: pw.TextStyle(fontSize: 14)),
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
                  0: pw.FlexColumnWidth(1.3),
                  1: pw.FlexColumnWidth(1.2),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
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
                      _buildPDFHeaderCell('Bill Date'),
                      _buildPDFHeaderCell('Bill Type'),
                      _buildPDFHeaderCell('Amount'),
                      _buildPDFHeaderCell('Paid'),
                      _buildPDFHeaderCell('Paid Date'),
                      _buildPDFHeaderCell('Status'),
                    ],
                  ),
                  // Data Rows
                  ...List.generate(leaseStatementList.length, (index) {
                    final statement = leaseStatementList[index];
                    String billDate = statement.billDate?.toString().split(' ')[0] ?? "N/A";
                    String billType = statement.type ?? "N/A";
                    String rentAmount = statement.rentAmount?.toString() ?? "N/A";
                    String paidAmount = statement.paidAmount?.toString() ?? "N/A";
                    String paymentDate = statement.paymentDate?.toString().split(' ')[0] ?? "N/A";
                    String status = statement.status ?? "N/A";

                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: index % 2 == 0 ? PdfColors.white : PdfColors.grey50,
                      ),
                      children: [
                        _buildPDFDataCell(billDate),
                        _buildPDFDataCell(billType),
                        _buildPDFDataCell(rentAmount),
                        _buildPDFDataCell(paidAmount),
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
                  'Total Statements: ${leaseStatementList.length}',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ];
          },
        ),
      );

      // Get the appropriate save path
      final filePath = await _getSavePath(fileName);
      print('Saving PDF to: $filePath');

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
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 20,)),
                    SizedBox(width: 3.w,),
                    CustomText(
                      text: "Lease Statement",
                      style: basicColorBold(18, Colors.black),
                    ),

                  ],
                ),
                GestureDetector(
                  onTap: isDownloading ? null : () => downloadLeaseStatementPDF(context),
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

            customHeaderLine(context),

            SizedBox(height: 2.5.h),

            Consumer<LeaseViewModel>(
              builder: (context, leaseViewModel, child) {
                var rents = leaseViewModel.leaseDetailModel?.data?.paymentProfile?.paymentHistory?.rents ?? [];
                var utilities = leaseViewModel.leaseDetailModel?.data?.paymentProfile?.paymentHistory?.utilities ?? [];
                var leaseStatementList = [...rents, ...utilities];
                if (leaseViewModel.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }

                if (leaseStatementList.isEmpty) {
                  return const Center(child: Text("No lease statements available"));
                }

                return Expanded(
                  child:
                  Column(
                    children: [
                      // Table Header
                      Container(
                        color: AppColors.greenColor.withOpacity(0.1),
                        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                        child:
                        Row(
                          children: [
                            buildHeaderCell("Bill Date", 1.5),
                            buildHeaderCell("Bill Type", 1.5),
                            buildHeaderCell("Amount", 1),
                            buildHeaderCell("Paid", 1),
                            buildHeaderCell("Paid Date", 1.2),
                            buildHeaderCell("Status", 1),
                          ],
                        ),
                      ),

                      // Divider
                      Container(height: 1, color: AppColors.cardBorderColor),

                      // Table Rows
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: leaseStatementList.length,
                          itemBuilder: (context, index) {
                            final history = leaseStatementList[index];
                            String id = history.id?.toString() ?? "N/A";
                            String billDate = history.billDate?.toString().split(' ')[0] ?? "N/A";

                            String billType = history.type ?? "N/A";
                            String rentAmount = history.rentAmount .toString()?? "N/A";
                            String paidAmount = history.paidAmount.toString() ?? "N/A";
                            String dueDate = history.billDueDate?.toString().split(' ')[0] ?? "N/A";
                            String paymentDate = history.paymentDate?.toString().split(' ')[0] ?? "N/A";
                            String status = history.status ?? "N/A";

                            Color statusColor = status.toLowerCase() == "paid"
                                ? Colors.green
                                : status.toLowerCase() == "unpaid"
                                ? Colors.red
                                : Colors.orange;

                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.cardBorderColor.withOpacity(0.3), width: 0.5),
                                ),
                                color: index % 2 == 0 ? Colors.white : Colors.grey.withOpacity(0.05),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 2.w),
                              child: Row(
                                children: [
                                  buildDataCell(dueDate, 1.5),
                                  buildDataCell(billType, 1.5),
                                  buildDataCell(rentAmount, 1),
                                  buildDataCell(paidAmount, 1),
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
                                          text: status,
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
                );
              },
            )

          ],
        ),
      ),
    );
  }







}
