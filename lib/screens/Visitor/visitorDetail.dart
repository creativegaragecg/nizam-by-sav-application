import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/providers/visitor_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';

class VisitorDetails extends StatefulWidget {
  const VisitorDetails({super.key, required this.visitorId});
  final String visitorId;

  @override
  State<VisitorDetails> createState() => _VisitorDetailsState();
}

class _VisitorDetailsState extends State<VisitorDetails> {
  bool isBasicInfo = false;
  bool isTimeInfo = false;
  bool isActivityLogs = false;
  bool isDownloadingQR = false;
  bool isSharing = false;
  final GlobalKey _qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<VisitorViewModel>(context, listen: false)
          .fetchVisitorDetails(context, widget.visitorId);
      requestPermission();
    });
  }

  Future<Uint8List?> _captureQrCode() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final boundary = _qrKey.currentContext?.findRenderObject();
      if (boundary == null || boundary is! RenderRepaintBoundary) return null;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing QR code: $e');
      return null;
    }
  }

  Future<void> _saveQrToGallery(String refNo) async {
    try {
      setState(() => isDownloadingQR = true);
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        showToast('Storage Permission Denied');
        return;
      }
      final imageBytes = await _captureQrCode();
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final result = await ImageGallerySaverPlus.saveImage(
          imageBytes,
          quality: 100,
          name: 'VisitorQR_${refNo}_${DateTime.now().millisecondsSinceEpoch}',
        );
        if (result != null && result['isSuccess'] == true) {
          showToast('QR Code saved to gallery successfully!');
        } else {
          showToast('Failed to save QR code');
        }
      } else {
        showToast('Failed to capture QR code image');
      }
    } catch (e) {
      showToast("Error saving QR: ${e.toString()}");
    } finally {
      setState(() => isDownloadingQR = false);
    }
  }

  Future<void> _shareQrCode(String refNo) async {
    try {
      setState(() => isSharing = true);
      final imageBytes = await _captureQrCode();
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final tempDir = await getTemporaryDirectory();
        final file = File(
            '${tempDir.path}/VisitorQR_${refNo}_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(imageBytes);
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Visitor QR Code - Ref: $refNo',
          subject: 'Visitor QR Code',
        );
      } else {
        showToast('Failed to capture QR code image');
      }
    } catch (e) {
      showToast("Error sharing QR: ${e.toString()}");
    } finally {
      setState(() => isSharing = false);
    }
  }

  void _showShareOptions(String refNo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
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
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomText(
                  text: "Share QR Code",
                  style: basicColorBold(18, Colors.black)),
            ),
            SizedBox(height: 2.h),
            Divider(height: 1, color: AppColors.cardBorderColor),
            ListTile(
              leading: Icon(Icons.download, color: AppColors.greenColor),
              title: CustomText(
                  text: "Download to Gallery",
                  style: basicColorBold(16, Colors.black87)),
              onTap: () {
                Navigator.pop(context);
                _saveQrToGallery(refNo);
              },
            ),
            Divider(height: 1, color: AppColors.cardBorderColor),
            ListTile(
              leading: Icon(Icons.share, color: AppColors.greenColor),
              title: CustomText(
                  text: "Share via Apps",
                  style: basicColorBold(16, Colors.black87)),
              subtitle: CustomText(
                  text: "WhatsApp, Email, Messages, etc.",
                  style: basicColor(14, Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _shareQrCode(refNo);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  // ── Reusable expandable section header (same style as GatePassDetails) ──
  Widget _sectionHeader({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.greenColor,
              AppColors.greenColor.withOpacity(0.6),
              Colors.white,
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
                Icon(icon, color: Colors.white, size: 20),
                SizedBox(width: 2.w),
                CustomText(text: title, style: basicColorBold(16, Colors.white)),
              ],
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(Icons.keyboard_arrow_down_sharp,
                  color: AppColors.greenColor),
            ),
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
            // ── Header ──
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios,
                      color: Colors.black, size: 20),
                ),
                SizedBox(width: 3.w),
                CustomText(
                    text: "Visitor Details",
                    style: basicColorBold(18, Colors.black)),
              ],
            ),
            customHeaderLine(context),
            SizedBox(height: 3.5.h),

            Expanded(
              child: Consumer<VisitorViewModel>(
                builder: (context, vm, child) {
                  if (vm.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: AppColors.greenColor),
                    );
                  }

                  final detail = vm.visitorDetailModel;
                  if (detail == null || detail.data == null) {
                    return Center(
                      child: CustomText(
                          text: "No details available",
                          style: basicColor(14, Colors.grey)),
                    );
                  }

                  final visitor  = detail.data!.visitor;
                  final qrCode   = detail.data!.qrCode;
                  final logs     = detail.data!.activityLog?.logs ?? [];
                  final summary  = detail.data!.activityLog?.summary;
                  final refNo    = visitor?.refNo ?? '-';
                  final qrImageUrl = qrCode?.urls?.png ?? '';

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Basic Information ──
                        CustomCards(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _sectionHeader(
                                title: "Basic Information",
                                icon: Icons.info_outline,
                                isExpanded: isBasicInfo,
                                onTap: () =>
                                    setState(() => isBasicInfo = !isBasicInfo),
                              ),
                              if (isBasicInfo)
                                Container(
                                    height: 0.2.h,
                                    width: 100.w,
                                    color: AppColors.cardBorderColor),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: isBasicInfo
                                    ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 3.w),
                                  child: Column(
                                    children: [
                                      buildDetailRow("Ref No", refNo),
                                      buildDetailRow(
                                          "Visitor Name",
                                          (visitor?.visitorName ?? '-')
                                              .toTitleCase()),
                                      buildDetailRow("Phone",
                                          visitor?.phoneNumber ?? '-'),
                                      buildDetailRow(
                                          "CNIC",
                                          visitor?.cnic?.toString() ??
                                              '-'),
                                      buildDetailRow(
                                          "Address",
                                          (visitor?.address ?? '-')
                                              .toTitleCase()),
                                      buildDetailRow(
                                          "Visitor Type",
                                          (visitor?.visitorType?.name ??
                                              '-')
                                              .toTitleCase()),
                                      buildDetailRow(
                                          "Purpose",
                                          (visitor?.purposeOfVisit
                                              ?.toString() ??
                                              '-')
                                              .toTitleCase()),
                                     /* buildDetailRow(
                                          "Status",
                                          (visitor?.status ?? '-')
                                              .toTitleCase()),*/
                                      buildDetailRow(
                                          "Added By",
                                          visitor?.user?.name
                                              ?.toTitleCase() ??
                                              '-'),
                                    ],
                                  ),
                                )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 1.h),

                        // ── Apartment / Time Info ──
                        CustomCards(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _sectionHeader(
                                title: "Visit & Apartment Info",
                                icon: Icons.apartment,
                                isExpanded: isTimeInfo,
                                onTap: () =>
                                    setState(() => isTimeInfo = !isTimeInfo),
                              ),
                              if (isTimeInfo)
                                Container(
                                    height: 0.2.h,
                                    width: 100.w,
                                    color: AppColors.cardBorderColor),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: isTimeInfo
                                    ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 3.w),
                                  child: Column(
                                    children: [
                                      buildDetailRow(
                                          "Unit No",
                                          visitor?.apartment
                                              ?.apartmentNumber ??
                                              '-'),
                                      buildDetailRow(
                                          "Tower",
                                          visitor?.apartment?.towers
                                              ?.towerName ??
                                              '-'),
                                      buildDetailRow(
                                          "Floor",
                                          visitor?.apartment?.floors
                                              ?.floorName ??
                                              '-'),
                                      buildDetailRow(
                                          "Date of Visit",
                                          formatDateTime(visitor
                                              ?.dateOfVisit
                                              ?.toString())),
                                      buildDetailRow(
                                          "Date of Exit",
                                          formatDateTime(visitor
                                              ?.dateOfExit
                                              ?.toString())),
                                      buildDetailRow(
                                          "In Time", visitor?.inTime ?? '-'),
                                      buildDetailRow(
                                          "Out Time",
                                          visitor?.outTime ?? '-'),
                                    ],
                                  ),
                                )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 1.h),

                        // ── Activity Logs ──
                        CustomCards(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _sectionHeader(
                                title: "Activity Logs",
                                icon: Icons.history,
                                isExpanded: isActivityLogs,
                                onTap: () => setState(
                                        () => isActivityLogs = !isActivityLogs),
                              ),
                              if (isActivityLogs)
                                Container(
                                    height: 0.2.h,
                                    width: 100.w,
                                    color: AppColors.cardBorderColor),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: isActivityLogs
                                    ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 3.w),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // Summary row
                                      if (summary != null) ...[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h,
                                              horizontal: 3.w),
                                          margin: EdgeInsets.only(
                                              bottom: 1.5.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.greenColor
                                                .withOpacity(0.08),
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceAround,
                                            children: [
                                              _summaryChip(
                                                  "Total Scans",
                                                  summary.totalScans
                                                      ?.toString() ??
                                                      '0'),
                                              _summaryChip(
                                                  "In",
                                                  summary.totalIn
                                                      ?.toString() ??
                                                      '0'),
                                              _summaryChip(
                                                  "Out",
                                                  summary.totalOut
                                                      ?.toString() ??
                                                      '0'),
                                            ],
                                          ),
                                        ),
                                      ],

                                      // Log entries
                                      if (logs.isEmpty)
                                        Padding(
                                          padding:
                                          EdgeInsets.all(2.h),
                                          child: Center(
                                            child: CustomText(
                                                text: "No activity logs",
                                                style: basicColor(
                                                    14, Colors.grey)),
                                          ),
                                        )
                                      else
                                        ...logs.map((log) =>
                                            _buildLogCard(log)),
                                    ],
                                  ),
                                )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // ── QR Code (from API URL) ──
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                  text: "QR Code",
                                  style: basicColorBold(16, Colors.black87)),
                              GestureDetector(
                                onTap: !isDownloadingQR && !isSharing
                                    ? () => _showShareOptions(refNo)
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 0.8.h),
                                  decoration: BoxDecoration(
                                    color: !isDownloadingQR && !isSharing
                                        ? AppColors.greenColor
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.share,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 1.w),
                                      CustomText(
                                          text: isSharing
                                              ? "Sharing..."
                                              : "Share",
                                          style: basicColorBold(
                                              13, Colors.white)),
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
                                border: Border.all(
                                    color: AppColors.cardBorderColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
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
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: progress.expectedTotalBytes !=
                                                null
                                                ? progress
                                                .cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                                : null,
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.greenColor),
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.qr_code_2,
                                                size: 50, color: Colors.grey),
                                            SizedBox(height: 1.h),
                                            CustomText(
                                                text: "Failed to load QR",
                                                style: basicColor(
                                                    12, Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  CustomText(
                                      text: refNo,
                                      style:
                                      basicColorBold(14, Colors.black87)),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.all(8.w),
                            child: Column(
                              children: [
                                const Icon(Icons.qr_code_2,
                                    size: 60, color: Colors.grey),
                                SizedBox(height: 2.h),
                                CustomText(
                                    text: "No QR code available",
                                    style: basicColor(14, Colors.grey)),
                              ],
                            ),
                          ),

                        SizedBox(height: 3.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Summary chip ──
  Widget _summaryChip(String label, String value) {
    return Column(
      children: [
        CustomText(text: value, style: basicColorBold(18, AppColors.greenColor)),
        SizedBox(height: 0.3.h),
        CustomText(text: label, style: basicColor(14, Colors.black54)),
      ],
    );
  }

  // ── Single log entry card ──
  Widget _buildLogCard(log) {
    final bool isIn = (log.direction ?? '').toLowerCase() == 'in';
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isIn
            ? AppColors.greenColor.withOpacity(0.06)
            : Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isIn
              ? AppColors.greenColor.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Direction icon
          Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: isIn
                  ? AppColors.greenColor.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIn ? Icons.login : Icons.logout,
              color: isIn ? AppColors.greenColor : Colors.red,
              size: 16,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: (log.direction ?? '-').toUpperCase(),
                      style: basicColorBold(
                          14, isIn ? AppColors.greenColor : Colors.red),
                    ),
                    CustomText(
                      text: formatDateTime(log.activityTime?.toString()),
                      style: basicColor(14, Colors.black54),
                    ),
                  ],
                ),
                if (log.scannedBy != null) ...[
                  SizedBox(height: 0.3.h),
                  CustomText(
                    text: "Scanned by: ${log.scannedBy}",
                    style: basicColor(14, Colors.black54),
                  ),
                ],
                if (log.remarks != null &&
                    log.remarks!.isNotEmpty) ...[
                  SizedBox(height: 0.3.h),
                  CustomText(
                    text: "Remarks: ${log.remarks}",
                    style: basicColor(14, Colors.black54),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}