import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/models/gatepassrequests.dart';
import 'package:savvyions/providers/unit_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart'; // Add this to pubspec.yaml

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../providers/gatePass_provider.dart';

class GatePassDetails extends StatefulWidget {
  const GatePassDetails({super.key, required this.gatePassRequest, required this.tenant});
  final GatePassRequest gatePassRequest;
  final String tenant;

  @override
  State<GatePassDetails> createState() => _GatePassDetailsState();
}

class _GatePassDetailsState extends State<GatePassDetails> {
  bool isBasicInfo = false;
  bool isTimeInfo = false;
  bool isStatusApproval = false;
  bool isNotes = false;
  bool isDownloadingQR = false;
  bool isSharing = false;
  final GlobalKey _qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchGatePassDetails();
      requestPermission();
    });
  }

  Future<void> fetchGatePassDetails() async {
    Provider.of<GatePassViewModel>(
      context,
      listen: false,
    ).fetchGatePassDetails(context,widget.gatePassRequest.id.toString());
  }


  Future<Uint8List?> _captureQrCode() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final boundary = _qrKey.currentContext?.findRenderObject();
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
        isDownloadingQR = true;
      });

      final hasPermission = await requestPermission();

      if (!hasPermission) {
        showToast('Storage Permission Denied');
        setState(() {
          isDownloadingQR = false;
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
        isDownloadingQR = false;
      });
    }
  }

  Future<void> _shareQrCode(String passNumber) async {
    try {
      setState(() {
        isSharing = true;
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
        isSharing = false;
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
                  text: "Gate Pass Request Details",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
                    CustomCards(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isBasicInfo = !isBasicInfo;
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
                                      Icon(Icons.error, color: Colors.white, size: 21),
                                      SizedBox(width: 2.w),
                                      CustomText(
                                        text: "Basic Information",
                                        style: basicColorBold(16, Colors.white),
                                      ),
                                    ],
                                  ),
                                  AnimatedRotation(
                                    turns: isBasicInfo ? 0.5 : 0,
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

                          if (isBasicInfo)
                            Container(
                              height: 0.2.h,
                              width: 100.w,
                              color: AppColors.cardBorderColor,
                            ),

                          AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: isBasicInfo
                                ? Container(
                              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                              child: Column(
                                children: [
                                  buildDetailRow("Pass No", widget.gatePassRequest.passNumber ?? "-"),
                                  buildDetailRow("Tenant", widget.tenant),
                                  buildDetailRow("Pass Type", widget.gatePassRequest.passType.toString().toTitleCase() ?? "-"),
                                  buildDetailRow("Purpose", widget.gatePassRequest.passPurpose ?? "-"),
                                ],
                              ),
                            )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Time Information Section
                    CustomCards(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isTimeInfo = !isTimeInfo;
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
                                      Icon(Icons.calendar_today, color: Colors.white, size: 20),
                                      SizedBox(width: 2.w),
                                      CustomText(
                                        text: "Time Information",
                                        style: basicColorBold(16, Colors.white),
                                      ),
                                    ],
                                  ),
                                  AnimatedRotation(
                                    turns: isTimeInfo ? 0.5 : 0,
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

                          if (isTimeInfo)
                            Container(
                              height: 0.2.h,
                              width: 100.w,
                              color: AppColors.cardBorderColor,
                            ),

                          AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: isTimeInfo
                                ? Container(
                              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                              child: Column(
                                children: [
                                  buildDetailRow("Expected Out Time", formatDateTime(widget.gatePassRequest.expectedOutTime?.toString())),
                                  buildDetailRow("Actual Out Time", formatDateTime(widget.gatePassRequest.actualOutTime?.toString()) ),
                                  buildDetailRow("Actual Return Time", formatDateTime(widget.gatePassRequest.returnedOn?.toString()) ),
                                ],
                              ),
                            )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Status & Approval Section
                    CustomCards(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isStatusApproval = !isStatusApproval;
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
                                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                                      SizedBox(width: 2.w),
                                      CustomText(
                                        text: "Status & Approval",
                                        style: basicColorBold(16, Colors.white),
                                      ),
                                    ],
                                  ),
                                  AnimatedRotation(
                                    turns: isStatusApproval ? 0.5 : 0,
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

                          if (isStatusApproval)
                            Container(
                              height: 0.2.h,
                              width: 100.w,
                              color: AppColors.cardBorderColor,
                            ),

                          AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: isStatusApproval
                                ? Container(
                              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                              child: Column(
                                children: [
                                  buildDetailRow(
                                    "Return Status",
                                    widget.gatePassRequest.returnStatus.toString().toTitleCase() ?? "-",
                                  ),
                                  buildDetailRow(
                                    "Approved By",
                                    widget.gatePassRequest.approvedBy?.toString() ?? '-',
                                  ),
                                ],
                              ),
                            )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Notes Section
                    CustomCards(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isNotes = !isNotes;
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
                                      Icon(Icons.comment, color: Colors.white, size: 20),
                                      SizedBox(width: 2.w),
                                      CustomText(
                                        text: "Notes",
                                        style: basicColorBold(16, Colors.white),
                                      ),
                                    ],
                                  ),
                                  AnimatedRotation(
                                    turns: isNotes ? 0.5 : 0,
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

                          if (isNotes)
                            Container(
                              height: 0.2.h,
                              width: 100.w,
                              color: AppColors.cardBorderColor,
                            ),

                          AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: isNotes
                                ? Container(
                              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: widget.gatePassRequest.remarks?.toTitleCase() ?? "-",
                                    style: basicColor(14.5, Colors.black87),
                                  ),
                                ],
                              ),
                            )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Consumer<GatePassViewModel>(
                      builder: (BuildContext context, GatePassViewModel value, Widget? child) {
                        String qrImageUrl = value.detailModel?.data?.qrCode?.urls?.png ?? "";
                        String passNumber = value.detailModel?.data?.gatePassRequest?.passNumber ?? "gate_pass";
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "QR Code",
                                    style: basicColorBold(16, Colors.black87),
                                  ),
                                  GestureDetector(
                                    onTap: !isDownloadingQR && !isSharing
                                        ? () => _showShareOptions(passNumber)
                                        : null,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                                      decoration: BoxDecoration(
                                        color: !isDownloadingQR && !isSharing
                                            ? AppColors.greenColor
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.share,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 1.w),
                                          CustomText(
                                            text: isSharing ? "Sharing..." : "Share",
                                            style: basicColorBold(13, Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),

                            if (qrImageUrl.isNotEmpty)
                              RepaintBoundary(
                                key: _qrKey,
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.cardBorderColor),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.network(
                                          qrImageUrl,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                    : null,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  AppColors.greenColor,
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.qr_code_2,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  CustomText(
                                                    text: "Failed to load QR code",
                                                    style: basicColor(12, Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      CustomText(
                                        text: passNumber,
                                        style: basicColorBold(14, Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.qr_code_2,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: "No QR code available",
                                      style: basicColor(14, Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
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