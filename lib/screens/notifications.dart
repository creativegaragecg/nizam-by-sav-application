import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/notifications.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../providers/notification_provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchNotifications();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    Provider.of<NotificationsViewModel>(
      context,
      listen: false,
    ).fetchNotifications(context);
  }

  Future<void> markAsRead(String notificationId) async {
    var list=[];
    list.add(notificationId);
    var data={
      "notification_ids": list

    };
    Provider.of<NotificationsViewModel>(
      context,
      listen: false,
    ).markAsRead(data,context);


  }

  Future<void> markAllAsRead() async {
    // Get the current unread notifications from the provider
    final unreadList = Provider.of<NotificationsViewModel>(context, listen: false)
        .notificationsModel
        ?.data
        ?.unreadNotifications ?? [];

    if (unreadList.isEmpty) {
      showToast("No unread notifications to mark");
      return;
    }

    // Collect all notification IDs
    final List<String> notificationIds = unreadList
        .map((notification) => notification.id ?? "")
        .where((id) => id.isNotEmpty)
        .toList();

    if (notificationIds.isEmpty) {
      showToast("No valid notification IDs found");
      return;
    }

    final data = {
      "notification_ids": notificationIds,
    };

    await Provider.of<NotificationsViewModel>(context, listen: false)
        .markAsRead(data, context);

  }


  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          children: [
            // Header
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
                  text: "Notifications",
                  style: basicColorBold(18, Colors.black),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    markAllAsRead();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      color: AppColors.greenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.greenColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.done_all,
                          color: AppColors.greenColor,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        CustomText(
                          text: "Mark All",
                          style: basicColorBold(12, AppColors.greenColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                labelStyle: basicColorBold(14, Colors.white),
                unselectedLabelStyle: basicColorBold(14, Colors.black54),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: "Unread"),
                  Tab(text: "Read"),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Tab Bar View
            Expanded(
              child: Consumer<NotificationsViewModel>(
                builder: (context, notificationsViewModel, child) {
                  if (notificationsViewModel.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                      ),
                    );
                  }

                  var unreadList = notificationsViewModel.notificationsModel?.data?.unreadNotifications ?? [];
                  var readList = notificationsViewModel.notificationsModel?.data?.readNotifications ?? [];

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // Unread Notifications
                      unreadList.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              text: "No unread notifications",
                              style: basicColorBold(16, Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: unreadList.length,
                        itemBuilder: (context, index) {
                          final notification = unreadList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.5.h),
                            child: notificationCard(notification, true),
                          );
                        },
                      ),

                      // Read Notifications
                      readList.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mark_email_read_outlined,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              text: "No read notifications",
                              style: basicColorBold(16, Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: readList.length,
                        itemBuilder: (context, index) {
                          final notification = readList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.5.h),
                            child: notificationCard(notification, false),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationCard(ReadNotification notification, bool isUnread) {
    String message = notification.data?.message ?? "N/A";
    String userName = notification.data?.userName ?? "System";
    String tenantName = notification.data?.tenantName ?? "";
    String type = notification.type ?? "notification";
    DateTime? createdAt = notification.createdAt;
    String timeAgo = createdAt != null ? _getTimeAgo(createdAt) : "Unknown";

    IconData getNotificationIcon(String type) {
      if (type.toLowerCase().contains('payment')) {
        return Icons.payment;
      } else if (type.toLowerCase().contains('maintenance')) {
        return Icons.build;
      } else if (type.toLowerCase().contains('event')) {
        return Icons.event;
      } else if (type.toLowerCase().contains('message')) {
        return Icons.message;
      } else {
        return Icons.notifications;
      }
    }

    return CustomCards(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: isUnread ? AppColors.greenColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    getNotificationIcon(type),
                    color: AppColors.greenColor,
                    size: 22,
                  ),
                ),
                SizedBox(width: 3.w),
                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              text: userName.toTitleCase(),
                              style: basicColorBold(15, Colors.black87),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.greenColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      CustomText(
                        text: message,
                        style: basicColor(14.5, Colors.black),
                      ),
                     /* if (tenantName.isNotEmpty) ...[
                        SizedBox(height: 0.5.h),
                        CustomText(
                          text: "Tenant: ${tenantName.toTitleCase()}",
                          style: basicColor(13, Colors.black45),
                        ),
                      ],*/
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.black,
                          ),
                          SizedBox(width: 1.w),
                          CustomText(
                            text: timeAgo,
                            style: basicColor(14, Colors.black),
                          ),
                          Spacer(),
                          if (isUnread)
                            GestureDetector(
                              onTap: () {
                                markAsRead(notification.id ?? "");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 1.w),
                                    CustomText(
                                      text: "Mark as Read",
                                      style: basicColorBold(14, Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}