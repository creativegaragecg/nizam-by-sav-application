import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/models/visitor.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/custom_text.dart';

class VisitorDetails extends StatefulWidget {
  const VisitorDetails({super.key, required this.visitorName, required this.ref, required this.unitNo, required this.inTime, required this.outTime, required this.visitDate, required this.exitDate, required this.visitPurpose, required this.visitType, required this.visitAddress, required this.contactNumber, required this.status, required this.towerName, required this.floorName, required this.cnic, required this.data});
  final String visitorName;
  final String ref;
  final String unitNo;
  final String inTime;
  final String outTime;
  final String visitDate;
  final String exitDate;
  final String visitPurpose;
  final String visitType;
  final String visitAddress;
  final String contactNumber;
  final String status;
  final String towerName;
  final String floorName;
  final String cnic;
  final List<List<String>> data;


  @override
  State<VisitorDetails> createState() => _VisitorDetailsState();
}

class _VisitorDetailsState extends State<VisitorDetails> {
  late String qrData;
  final GlobalKey qrKey = GlobalKey();
// To store the generated QR string
  @override
  void initState() {
    super.initState();
    requestPermission();
    qrData = generateQRData();
  }

  String generateQRData() {
    // Convert the entire data map to a JSON-encoded string
    return jsonEncode(widget.data);
  }


  Future<Uint8List?> _captureQrCode() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final boundary = qrKey.currentContext?.findRenderObject();
      if (boundary == null || boundary is! RenderRepaintBoundary) {
        debugPrint('Error: RepaintBoundary not found or invalid');
        return null;
      }
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        debugPrint('Error: Failed to convert image to byte data');
        return null;
      }
      final imageBytes = byteData.buffer.asUint8List();
      debugPrint('Captured image bytes length: ${imageBytes.length}');
      return imageBytes;
    } catch (e) {
      debugPrint('Error capturing QR code: $e');
      return null;
    }
  }

  Future<void> _saveQrToGallery(String passNumber) async {
    try {
      setState(() {
      //  isDownloadingQR = true;
      });

      final hasPermission = await requestPermission();

      if (!hasPermission) {
        showToast('Storage Permission Denied');
        setState(() {
        //  isDownloadingQR = false;
        });
        return;
      }

      final imageBytes = await _captureQrCode();

      if (imageBytes != null && imageBytes.isNotEmpty) {
        final result = await ImageGallerySaverPlus.saveImage(
          imageBytes,
          quality: 100,
          name: 'GatePassQR${passNumber}_${DateTime.now().millisecondsSinceEpoch}',
        );

        debugPrint('Save result: $result');

        if (result != null && result['isSuccess'] == true) {
          showToast('QR Code saved to gallery successfully!');
        } else {
          showToast('Failed to save QR code');
        }
      } else {
        showToast('Failed to capture QR code image');
      }
    } catch (e) {
      debugPrint("Exception in saving QR: $e");
      showToast("Error in saving QR code: ${e.toString()}");
    } finally {
      setState(() {
     //   isDownloadingQR = false;
      });
    }
  }

  Future<void> _shareQrCode(String passNumber) async {
    try {
      setState(() {
     //   isSharing = true;
      });

      final imageBytes = await _captureQrCode();

      if (imageBytes != null && imageBytes.isNotEmpty) {
        // Save to temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/GatePassQR_${passNumber}_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(imageBytes);

        // Share the file
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Gate Pass QR Code - Pass Number: $passNumber',
          subject: 'Gate Pass QR Code',
        );
      } else {
        showToast('Failed to capture QR code image');
      }
    } catch (e) {
      debugPrint("Exception in sharing QR: $e");
      showToast("Error in sharing QR code: ${e.toString()}");
    } finally {
      setState(() {
      //  isSharing = false;
      });
    }
  }

  void _showShareOptions(String passNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.h),
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomText(
                text: "Share QR Code",
                style: basicColorBold(18, Colors.black),
              ),
            ),
            SizedBox(height: 2.h),
            Divider(height: 1, color: AppColors.cardBorderColor),
            ListTile(
              leading: Icon(Icons.download, color: AppColors.greenColor),
              title: CustomText(
                text: "Download to Gallery",
                style: basicColorBold(16, Colors.black87),
              ),
              onTap: () {
                Navigator.pop(context);
                _saveQrToGallery(passNumber);
              },
            ),
            Divider(height: 1, color: AppColors.cardBorderColor),
            ListTile(
              leading: Icon(Icons.share, color: AppColors.greenColor),
              title: CustomText(
                text: "Share via Apps",
                style: basicColorBold(16, Colors.black87),
              ),
              subtitle: CustomText(
                text: "WhatsApp, Email, Messages, etc.",
                style: basicColor(14, Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                _shareQrCode(passNumber);
              },
            ),
            SizedBox(height: 2.h),
          ],
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
            /// Welcome area
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                CustomText(
                  text: "Visitor Details",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
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
                          buildDetailRow("Tower Name",   widget.towerName),
                          buildDetailRow("Floor name",widget.floorName),
                          buildDetailRow("Visitor Name",widget.visitorName.toTitleCase()),
                          buildDetailRow("Ref No",widget.ref),
                          buildDetailRow("Unit Number",widget.unitNo),
                          buildDetailRow("In Time / Date Of Visit","${widget.inTime}, ${widget.visitDate}"),
                          buildDetailRow("Out Time / Date Of Exit","${widget.outTime}, ${widget.exitDate}"),
                          buildDetailRow("Purpose of Visit",widget.visitPurpose.toTitleCase()),
                          buildDetailRow("Visitor Type",widget.visitType.toTitleCase()),
                          buildDetailRow("Visitor Address",widget.visitAddress.toTitleCase()),
                          buildDetailRow("Contact No",widget.contactNumber),
                          buildDetailRow("CNIC",widget.cnic),
                          buildDetailRow("Status",widget.status.toTitleCase()),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "QR", style: basicColorBold(16, Colors.black87)),
                          GestureDetector(
                            onTap: () {
                              _showShareOptions(widget.ref);
                            },
                            child: Icon(
                              Icons.download,
                              color: Colors.black,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    RepaintBoundary(
                      key: qrKey,
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
                    )



                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}