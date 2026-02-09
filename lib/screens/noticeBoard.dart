import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/noticeBoard.dart';
import 'package:savvyions/providers/noticeBoard_provider.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/custom_text.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({super.key});

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchNotices();
    });
  }

  Future<void> fetchNotices() async {
    Provider.of<NoticeBoardViewModel>(
      context,
      listen: false,
    ).fetchNotices(context);
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
                  text: "Notice Board",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),
            Consumer<NoticeBoardViewModel>(
              builder: (context, noticeViewModel, child) {
                var noticeList =
                    noticeViewModel.noticeBoardModel?.data?.notices ?? [];
                if (noticeViewModel.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (noticeList.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "No notices available",
                            style: basicColor(16, Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: noticeList.length,
                    itemBuilder: (context, index) {
                      final notice = noticeList[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: noticeCard(notice),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget noticeCard(Notice notice) {
    String noticeTitle = notice.title?.toTitleCase() ?? "Untitled Notice";
    String desc = notice.description?.toTitleCase() ?? "No description available";
    String? imageUrl = notice.imageUrl;
    print("Image UR::$imageUrl");
    bool hasImage = imageUrl != null && imageUrl.isNotEmpty && imageUrl != "N/A";


    return Container(
      padding: EdgeInsetsGeometry.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section (if image exists)
          if (hasImage)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 20.h,
                        color: Colors.grey.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "Image not available",
                              style: basicColor(12, Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 20.h,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.greenColor),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Download Icon Button
                Positioned(
                  top: 1.h,
                  right: 2.w,
                  child: GestureDetector(
                    onTap: () => downloadImage(imageUrl, noticeTitle),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.download,
                        color: AppColors.greenColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          SizedBox(height: 0.5.h,),
          // Content Section
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        color: AppColors.greenColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: noticeTitle,
                            style: basicColorBold(17, Colors.black87),
                          ),
                          SizedBox(height: 0.5.h),
                          Container(
                            height: 3,
                            width: 12.w,
                            decoration: BoxDecoration(
                              color: AppColors.greenColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Description
                CustomText(
                  text: desc,
                  style: basicColor(14.5, Colors.black87),
                  overflow: hasImage ? TextOverflow.ellipsis : null,
                ),

                // Date/Time if available
                if (notice.createdAt != null) ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.black,
                      ),
                      SizedBox(width: 1.w),
                      CustomText(
                        text: formatDate(notice.createdAt.toString()),
                        style: basicColor(14, Colors.black),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      DateTime now = DateTime.now();
      Duration difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return "${difference.inMinutes} minutes ago";
        }
        return "${difference.inHours} hours ago";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else {
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return dateStr;
    }
  }
}