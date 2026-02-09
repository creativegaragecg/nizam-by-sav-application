import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/Utils/Constants/icons.dart';
import 'package:savvyions/Utils/Constants/images.dart';
import 'package:savvyions/Utils/Constants/styles.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/Utils/Custom/customCards.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/Utils/Custom/custom_text.dart';
import 'package:savvyions/providers/auth_provider.dart';
import 'package:savvyions/providers/events_provider.dart';
import 'package:savvyions/providers/legalNotice_provider.dart';
import 'package:savvyions/screens/Amenities/amenities.dart';
import 'package:savvyions/screens/Amenities/bookings.dart';
import 'package:savvyions/screens/LegalNotices/LegalNotices.dart';
import 'package:savvyions/screens/ServiceSuspension/serviceSuspension.dart';
import 'package:savvyions/screens/Services/Services.dart';
import 'package:savvyions/screens/UnitInspection/unitInspections.dart';
import 'package:savvyions/screens/Violations/violations.dart';
import 'package:savvyions/screens/Visitor/visitor.dart';
import 'package:savvyions/screens/bills.dart';
import 'package:savvyions/screens/GatePassRequests/gatePass.dart';
import 'package:savvyions/screens/events.dart';
import 'package:savvyions/screens/Lease/lease.dart';
import 'package:savvyions/screens/Units/myUnits.dart';
import 'package:savvyions/screens/noticeBoard.dart';
import 'package:savvyions/screens/Tickets/tickets.dart';
import 'package:savvyions/screens/notifications.dart';
import '../Utils/Custom/customGreenBg.dart';
import '../l10n/app_localizations.dart';
import '../providers/bills_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/user_provider.dart';
import 'SocietyForums/forums.dart';
import 'emergencyScreen.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class MainLandingPage extends StatefulWidget {
  const MainLandingPage({super.key});

  @override
  State<MainLandingPage> createState() => _MainLandingPageState();
}

class _MainLandingPageState extends State<MainLandingPage> {
  int _currentIndex = 0; // Track current carousel page
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  String name = '';
  String role = '';
  static bool _hasShownUnpaidBillsPopup = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = true;
  bool _hasShownOfflineMessage = false;
  bool hasViewAll=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Initialize connectivity listener
    _initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );

    // Fetch advertisements when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchUserData();
    });
  }

  // Add this method to your MainLandingPage State class
  void showImportantNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return ImportantNotificationsDialog();
      },
    );
  }

  // Check initial connectivity status
  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print('Could not check connectivity: $e');
    }
  }

  // Update connection status and show snackbar
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    bool isOnline =
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);

    if (_isOnline != isOnline) {
      setState(() {
        _isOnline = isOnline;
      });

      // Show snackbar based on connection status
      if (mounted) {
        if (isOnline) {
          // Back online
          _showConnectivitySnackbar(
            message: "✓ Connected to Internet",
            backgroundColor: AppColors.greenColor,
            icon: Icons.wifi,
          );
          _hasShownOfflineMessage = false;
        } else {
          // Offline
          if (!_hasShownOfflineMessage) {
            _showConnectivitySnackbar(
              message: "✗ No Internet Connection",
              backgroundColor: Colors.red,
              icon: Icons.wifi_off,
            );
            _hasShownOfflineMessage = true;
          }
        }
      }
    }
  }

  // Show custom snackbar
  void _showConnectivitySnackbar({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 2.w),
            CustomText(text: message, style: basicColorBold(15, Colors.white)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 2.h, left: 4.w, right: 4.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    Provider.of<AuthViewModel>(context, listen: false).loadAccounts().then((
      v,
    ) async {
      final user = Provider.of<UserProfileViewModel>(context, listen: false);
      user.fetchUserProfile(context).then((v) async {
        // Get the role from the fetched profile
        final currentRole = user.userProfile?.data?.user?.role?.name ?? "";
        print("Roleeeee:$currentRole");

        // Now fetch bills with the correct role
        if (currentRole.isNotEmpty) {
          await fetchBills(currentRole).then((_) {
            // Only check and show popup if not already shown in this session
            if (!_hasShownUnpaidBillsPopup) {
              checkAndShowUnpaidBills(currentRole);
              _hasShownUnpaidBillsPopup = true; // Mark as shown
            }
          });
        }
      });
      user.fetchDueAmount(context);
      user.fetchHealth(context);
      Provider.of<NotificationsViewModel>(
        context,
        listen: false,
      ).fetchNotifications(context);
    });
  }

  Future<void> fetchBills(String userRole) async {
    var provider = Provider.of<BillsViewModel>(context, listen: false);
    if (userRole == "Tenant") {
      await provider.fetchBills(context);
    } else if (userRole == "Owner") {
      await provider.fetchOwnerBills(context);
    }
  }

  void checkAndShowUnpaidBills(String userRole) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventsViewModel>(context, listen: false).fetchEvents(context);
      Provider.of<LegalNoticesViewModel>(
        context,
        listen: false,
      ).fetchLegalNotices(context);

      final billsProvider = Provider.of<BillsViewModel>(context, listen: false);

      List<dynamic> unpaidBills = [];

      if (userRole == "Tenant" &&
          billsProvider.billsModel?.data?.bills != null) {
        unpaidBills = billsProvider.billsModel!.data!.bills!
            .where((bill) => bill.status?.toLowerCase() == "unpaid")
            .toList();
      } else if (userRole == "Owner" &&
          billsProvider.ownerPaymentModel?.data?.payments != null) {
        unpaidBills = billsProvider.ownerPaymentModel!.data!.payments!
            .where((payment) => payment.status?.toLowerCase() == "unpaid")
            .toList();
      }

      if (unpaidBills.isNotEmpty) {
        Future.delayed(Duration(milliseconds: 800), () {
          if (mounted) {
            showUnpaidBillsPopup(context, unpaidBills, userRole);
          }
        });
      }
    });
  }

  // Add this method to your MainLandingPage State class
  void showUnpaidBillsPopup(
    BuildContext context,
    List<dynamic> unpaidBills,
    String role,
  ) {
    if (unpaidBills.isEmpty) return;

    // Calculate total unpaid amount
    double totalUnpaid = 0;
    for (var bill in unpaidBills) {
      String dueAmount = bill.dueAmount?.toString() ?? "0";
      totalUnpaid += double.tryParse(dueAmount) ?? 0;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              constraints: BoxConstraints(maxHeight: 80.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with warning icon - Full coverage gradient
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 3.h,
                      horizontal: 4.w,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.red.shade400, Colors.orange.shade400],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                showImportantNotificationsDialog(context);
                              },
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 21.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: EdgeInsets.all(1.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                              size: 35.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.8.h),
                        CustomText(
                          text: "Pending Payments",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          align: TextAlign.center,
                        ),
                        SizedBox(height: 0.8.h),
                        CustomText(
                          text:
                              "You have ${unpaidBills.length} unpaid bill${unpaidBills.length > 1 ? 's' : ''}",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w400,
                          ),
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Total amount section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade200, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Total Outstanding",
                              style: basicColor(14, Colors.black54),
                            ),
                            SizedBox(height: 0.3.h),
                            CustomText(
                              text: "\$${totalUnpaid.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.red.shade700,
                          size: 25.sp,
                        ),
                      ],
                    ),
                  ),

                  // Bills list - Made scrollable with visible hint
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      constraints: BoxConstraints(maxHeight: 32.h),
                      child: Stack(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 1.h),
                            physics: BouncingScrollPhysics(),
                            itemCount: unpaidBills.length,
                            itemBuilder: (context, index) {
                              final bill = unpaidBills[index];
                              String billType = bill.type ?? "N/A";
                              String dueAmount =
                                  bill.dueAmount?.toString() ?? "0";
                              String dueDate = "";

                              if (role == "Tenant") {
                                dueDate =
                                    bill.billDueDate?.toString().split(
                                      ' ',
                                    )[0] ??
                                    "N/A";
                              } else if (role == "Owner") {
                                dueDate =
                                    bill.dueDate?.toString().split(' ')[0] ??
                                    "N/A";
                              }

                              return Container(
                                margin: EdgeInsets.only(bottom: 1.2.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.5.w,
                                  vertical: 1.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.cardBorderColor
                                        .withOpacity(0.3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(1.2.h),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.receipt_long_rounded,
                                        color: Colors.red.shade600,
                                        size: 20.sp,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: billType.toTitleCase(),
                                            style: basicColorBold(
                                              14.5,
                                              Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 0.4.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 15.sp,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 1.w),
                                              CustomText(
                                                text: "Due: $dueDate",
                                                style: basicColor(
                                                  15,
                                                  Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustomText(
                                      text: "\$$dueAmount",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // Scroll indicator at bottom
                          if (unpaidBills.length > 2)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0),
                                      Colors.white.withOpacity(0.9),
                                      Colors.white,
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 1.w),
                                      CustomText(
                                        text: "Scroll for more",
                                        style: basicColor(15, Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Action buttons
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: Column(
                      children: [
                        // View All Bills Button
                        SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Bills(role: role),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.payment_rounded,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 2.w),
                                CustomText(
                                  text: "View & Pay Bills",
                                  style: basicColorBold(16, Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 1.2.h),
                        // Remind Me Later Button
                        SizedBox(
                          width: double.infinity,
                          height: 5.h,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: CustomText(
                              text: "Remind Me Later",
                              style: basicColor(16, Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For dark icons
        statusBarBrightness: Brightness.light, // For iOS
      ),
      child: SafeArea(
        top: false,
        child: Scaffold(
         // backgroundColor: AppColors.newBg,
          body: Container(
            height: 100.h,
            width: 100.w,
      
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.newBg), // Your image path
                fit: BoxFit.cover, // or BoxFit.fill, BoxFit.contain based on your need
              ),
           /*   gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE6F4EC), Color(0xFFF3FAF6)],
              ),*/
            ),
            child: Padding(
              padding: EdgeInsets.only(top:7.h,right: 4.w,left: 4.w,),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Consumer<UserProfileViewModel>(
                      builder:
                          (
                            BuildContext context,
                            UserProfileViewModel value,
                            Widget? child,
                          ) {
// Single loading check at the top
                            if (value.loading) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 30.h),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                                  ),
                                ),
                              );
                            }

                            role = value.userProfile?.data?.user?.role?.name ?? "-";
                            name = value.userProfile?.data?.user?.info?.name ?? "-";
                            String dueAmount =
                                value.amountModel?.data?.dueAmount?.toString() ??
                                "-";
                            return Column(
                              children: [
                                /// Welcome area
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /* CustomText(
                              text: "${AppLocalizations.of(context)!.welcome} ${AppLocalizations.of(context)!.back}",
                              style: basicColor(15, Colors.white),
                            ),
                            SizedBox(height: 1.h)*/
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                    text: "Hi, $name",
                                                    style: basicColorBold(
                                                      18,
                                                      Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 0.5.h),
                                              CustomText(
                                                text: "$role",
                                                style: basicColor(15, Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EmergencySOSScreen(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 4.h,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 3.w,
                                            ),
                                            decoration: BoxDecoration(
                                              // Linear gradient matching Figma design
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                30,
                                              ),
                                              // Border if specified
                                            ),
                
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.notifications,
                                                  color: AppColors.redColor,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 1.w),
                                                Text(
                                                  "Emergency",
                                                  style: basicColor(15, AppColors.redColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                
                                        SizedBox(width: 4.w),
                
                                        // Replace your notification icon GestureDetector with this code:
                                        Consumer<NotificationsViewModel>(
                                          builder:
                                              (
                                                context,
                                                notificationsViewModel,
                                                child,
                                              ) {
                                                var unreadCount =
                                                    notificationsViewModel
                                                        .notificationsModel
                                                        ?.data
                                                        ?.unreadNotifications
                                                        ?.length ??
                                                    0;
                
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Notifications(),
                                                      ),
                                                    );
                                                  },
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      SvgPicture.asset(
                                                        AppIcons.notifications,
                                                        height: 3.5.h,
                                                        width: 7.w,
                                                        color: Colors.black,
                                                      ),
                
                                                      Positioned(
                                                        right: -2,
                                                        top: -3.5,
                                                        child: Container(
                                                          padding: EdgeInsets.all(
                                                            unreadCount > 99
                                                                ? 1.5
                                                                : 3,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          constraints:
                                                              BoxConstraints(
                                                                minWidth: 10,
                                                                minHeight: 10,
                                                              ),
                                                          child: Center(
                                                            child: Text(
                                                              unreadCount > 99
                                                                  ? '99+'
                                                                  : unreadCount
                                                                        .toString(),
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize:
                                                                    unreadCount > 99
                                                                    ? 10.sp
                                                                    : 12.sp,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                fontFamily:
                                                                    "Ubuntu",
                                                              ),
                                                              textAlign:
                                                                  TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                        ),
                                        SizedBox(width: 2.w),
                                      ],
                                    ),
                                  ],
                                ),
                
                                SizedBox(height: 2.5.h),
                                profileCard(value, dueAmount),
                              ],
                            );
                          },
                    ),
                
                   
                    SizedBox(height: 2.h),
                
                    Consumer<UserProfileViewModel>(
                      builder: (context, userModel, child) {
                        final currentRole =
                            userModel.userProfile?.data?.user?.role?.name ?? "";
                        /*// Show loading if still fetching
                        if (userModel.loading) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.greenColor,
                              ),
                            ),
                          );
                        }*/
                
                        return !userModel.loading?
                        Column(
                          children: [
                            Scrollbar(
                              child: GridView.count(
                                crossAxisCount: 4,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),  // Keep this as is
                                childAspectRatio:
                                1.1, // Changed from 1.0 - gives more height
                                // mainAxisSpacing: 0.h,
                                /* crossAxisSpacing: 2.w,*/
                                padding: EdgeInsets.zero,
                                children: [
                                  if (currentRole != "Tenant")
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyUnits(),
                                          ),
                                        );
                                      },
                                      child: _buildMenuSVGItem(
                                        icon: AppIcons.unit,
                                        title: "My Unit",
                                      ),
                                    ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyLease(),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.leased,
                                      title: "Leased",
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Bills(role: role),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.bills,
                                      title: "Bills",
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Tickets(role: role),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.tickets,
                                      title: "Tickets",
                                    ),
                                  ),

                                  if (currentRole != "Owner")
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GatePassRequests(),
                                          ),
                                        );
                                      },
                                      child: _buildMenuSVGItem(
                                        icon: AppIcons.gatePasses,
                                        title: "Gate Pass",
                                      ),
                                    ),

                                  if (currentRole != "Owner")
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Visitors(),
                                          ),
                                        );
                                      },
                                      child: _buildMenuSVGItem(
                                        icon: AppIcons.visitor,
                                        title: "Visitors",
                                      ),
                                    ),

                                  if (currentRole != "Owner")
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UnitInspections(),
                                          ),
                                        );
                                      },
                                      child: _buildMenuSVGItem(
                                        icon: AppIcons.inspections,
                                        title: "Inspections",
                                      ),
                                    ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Events(),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.function,
                                      title: "Events",
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NoticeBoard(),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.notice,
                                      title: "Notices",
                                    ),
                                  ),

                                  if(hasViewAll)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LegalNotices(),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.legalNotice,
                                      title: "Legal Notices",
                                    ),
                                  ),

                                  if(hasViewAll)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViolationRecords(),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.violationRecords,
                                      title: "Violations",
                                    ),
                                  ),

                                  if(hasViewAll)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SocietyForums(),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.forums,
                                      title: "Forums",
                                    ),
                                  ),

                                  if (currentRole != "Owner" &&  hasViewAll)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Amenities(),
                                          ),
                                        );
                                      },
                                      child: _buildMenuSVGItem(
                                        icon: AppIcons.amenities,
                                        title: "Amenities",
                                      ),
                                    ),

                                  if (currentRole != "Owner" && hasViewAll)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Services(),
                                          ),
                                        );
                                      },
                                      child: _buildMenuSVGItem(
                                        icon: AppIcons.services,
                                        title: "Services",
                                      ),
                                    ),

                                  if (currentRole != "Owner" && hasViewAll)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Bookings(),
                                          ),
                                        );
                                      },
                                      child: _buildMenuSVGItem(
                                        icon: AppIcons.booking,
                                        title: "Bookings",
                                      ),
                                    ),

                                  if(hasViewAll)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ServicesSuspension(),
                                        ),
                                      );
                                    },
                                    child: _buildMenuSVGItem(
                                      icon: AppIcons.services,
                                      title: "Suspensions",
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 1.5.h),


                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  hasViewAll = !hasViewAll;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      text: hasViewAll ? "View Less" : "View All",
                                      style: basicColorBold(14, AppColors.greenColor),
                                    ),
                                    SizedBox(width: 0.w),
                                    Icon(
                                      hasViewAll
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.greenColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ):Container();
                      },
                    ),

                    SizedBox(height: 1.5.h),


      
                    Consumer<UserProfileViewModel>(builder: (BuildContext context, UserProfileViewModel userModel, Widget? child) {
                    /*  if (userModel.loading) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                          ),
                        );
                      }*/
                       if (userModel.userProfile == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_off, size: 50, color: AppColors.hintText),
                              SizedBox(height: 2.h),
                              CustomText(
                                text: "No data available",
                                style: basicColor(16, AppColors.hintText),
                              ),
                            ],
                          ),
                        );
                      }
                      String healthPercent =
                          userModel.healthModel?.health?.percentage?.toString() ?? "-";
                      String healthStatus = userModel.healthModel?.health?.status ?? "-";

                      return !userModel.loading?_buildAccountHealthCard(healthPercent,healthStatus,userModel):Container();
                    },),
                
                
                    
                
                
                
                    SizedBox(height: 2.h),
                
                
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountHealthCard(String healthPercent, String healthStatus,UserProfileViewModel userModel ) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 6.w,vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.newColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
           text: 'Account Health',
            style: basicColorBold(17, Colors.black)

          ),
           SizedBox(height:2.h),
          Row(
            children: [
              _buildCircularProgress(healthPercent),
               SizedBox(width:3.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                decoration: BoxDecoration(
                  color:AppColors.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                           text: 'Health Status',
                            style: basicColor(15,Colors.black )

                          ),

                          Padding(
                            padding:  EdgeInsets.only(right: 3.w),
                            child: Row(
                              children: [
                                CustomText(
                                    text: healthStatus,
                                    style: basicColorBold(15,AppColors.iconColor )

                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  CupertinoIcons.heart_fill,
                                  size: 12,
                                  color: AppColors.iconColor,
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                       SizedBox(height: 1.5.h),
                      Container(
                        height: 0.1.h,
                        width: 100.w,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      SizedBox(height: 1.5.h),

                      GestureDetector(
                        onTap: () {
                          showHealthDialog(context, userModel);

                        },
                        child: Align(
                          alignment: AlignmentGeometry.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children:  [
                              CustomText(
                               text: 'View Details',
                                style: basicColor(14.5, Color(0xFF718096) )

                              ),
                              SizedBox(width: 3.w),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Color(0xFF718096),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(String percent) {
    return SizedBox(
      width: 25.w,
      height: 25.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: 0.85,
              strokeWidth: 8,
              backgroundColor:AppColors.iconGreyColor.withOpacity(0.2),
              valueColor:  AlwaysStoppedAnimation<Color>(
                AppColors.iconColor,
              ),
            ),
          ),
          CustomText(
           text: '$percent%',
            style:
                basicColorBold(20, Colors.black)

          ),
        ],
      ),
    );
  }



  Widget _buildMenuSVGItem({required String icon, required String title}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        IntrinsicHeight(
          child: Container(
            padding: EdgeInsetsGeometry.symmetric(vertical: 1.5.h),
            // height: 9.h,
            width: 20.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              color: AppColors.newColor,
              borderRadius: BorderRadius.circular(20),

              //  border: Border.all(color: AppColors.hintText,width: 2)
            ),
            child: Column(
              children: [
                Center(
                  child: SvgPicture.asset(
                    height: 3.h,
                    width: 6.5.w,
                    icon,
                    color: AppColors.iconColor,
                  ),
                ),
                SizedBox(height: 1.h),
                CustomText(
                  text: title,
                  style: basicColor(14, Colors.black),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        /*  SizedBox(height: 0.5.h),
        CustomText(
          text: title,
          style: basicColor(13.4, AppColors.menuTextColor),
          align: TextAlign.center,
          maxLines: 2,
        ),*/
      ],
    );
  }


  Widget profileCard(UserProfileViewModel userModel, String dueAmount) {

    // Show error/empty message if profile is null
     if (userModel.userProfile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 50, color: AppColors.hintText),
            SizedBox(height: 2.h),
            CustomText(
              text: "No profile data available",
              style: basicColor(16, AppColors.hintText),
            ),
          ],
        ),
      );
    }
    final profile =
        userModel.userProfile!; // Safe because we checked for null above
    String status = profile.data?.user?.info?.status ?? "N/A";
    String userPic = profile.data?.user?.info?.profilePhotoUrl ?? "N/A";
    print("profile pic:$userPic");
    /*
    String verified= profile.data?.user?..emailVerifiedAt==null?"Not Verified":"Verified";
*/
    String email = profile.data?.user?.info?.email ?? "N/A";
    String phoneNo = profile.data?.user?.info?.phoneNumber ?? "N/A";
    String nationalId = profile.data?.user?.meta?.nationalIdNumber ?? "N/A";
    //  String companyName= profile.data?.user?.info?.metas?.companyName ?? "N/A";
    String companyName = profile.data?.user?.society?.name ?? "N/A";
    String address = profile.data?.user?.meta?.address ?? "N/A";
    String healthPercent =
        userModel.healthModel?.health?.percentage?.toString() ?? "-";
    String healthStatus = userModel.healthModel?.health?.status ?? "-";

    return CustomCards(
      color:AppColors.newColor,
      radius: 25,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.lightBlueAccent,
                      radius: 30,
                      child: userPic.isNotEmpty && userPic != "N/A"
                          ? ClipOval(
                              child: Image.network(
                                userPic,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppImages.dummyImage,
                                    fit: BoxFit.cover,
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Image.asset(AppImages.dummyImage, fit: BoxFit.cover),
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: CustomText(
                            //  align: TextAlign.left,
                            text: companyName,
                            style: basicColorBold(15.5, Colors.black87),
                          ),
                        ),
                        SizedBox(height: 0.5.h),

                        //  SizedBox(height: 1.h,),
                        CustomText(
                          //  align: TextAlign.left,
                          text: email,
                          style: basicColor(14.5, Colors.black87),
                        ),
                        SizedBox(height: 0.5.h),
                        CustomText(
                          //  align: TextAlign.left,
                          text: phoneNo,
                          style: basicColor(14.5, Colors.black87),
                        ),
                        SizedBox(height: 0.5.h),
                        CustomText(
                          //  align: TextAlign.left,
                          text: nationalId,
                          style: basicColor(14.5, Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),


                Padding(
                  padding:  EdgeInsets.only(top: 1.h),
                  child: Container(
                      height: 7.h,
                      width: 27.w,
                      child: Image.asset(AppImages.splashScreenLogo,fit: BoxFit.cover,)),
                )

              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                statusContainer(
                  context,
                  AppColors.profileCardBoxColor,
                  AppImages.award,
                  status.toTitleCase(),
                  AppColors.iconColor,
                ),
                SizedBox(width: 2.w),
                GestureDetector(

                  child: Container(
                    height: 3.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.profileCardBoxColor,
                      // border: Border.all(color: AppColors.greenColor)
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                        child: Row(
                       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.money_dollar, size: 11,color: AppColors.iconColor,),
                                SizedBox(width: 0.5.w),

                                /* CustomText(
                                          text: "$healthPercent%",
                                          style: basicColorBold(
                                            13.5,
                                            AppColors.greenColor,
                                          ),
                                        ),
                                        SizedBox(width: 0.5.w),*/
                                CustomText(
                                  text: "OverDue Amount:",
                                  style: basicColorBold(13.5, AppColors.iconColor),
                                ),
                              ],
                            ),
                            SizedBox(width: 6.w,),
                            CustomText(
                              text:  "\$$dueAmount",
                              style: basicColorBold(14.5, AppColors.redColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Widget unitDetails() {
    return CustomCards(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),

        child: Column(
          mainAxisSize:
              MainAxisSize.min, // ADD THIS - makes column shrink to content

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(AppImages.home),
                SizedBox(width: 2.w),
                CustomText(
                  text: "Unit Details",
                  style: basicColorBold(15, Colors.black),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Container(
              height: 0.2.h,
              width: 100.w,
              color: AppColors.cardBorderColor,
            ),
            SizedBox(height: 1.h),
            _unitDetailRow("Unit Number:", "APSE01", null),
            _unitDetailRow("Floor:", "SE01", null),
            _unitDetailRow("Tower:", "Stock Exchange Tower", null),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () => _showUnitDetailsDialog(context),

              child: Row(
                children: [
                  CustomText(
                    text: "View Details",
                    style: basicColor(14.5, AppColors.greenColor),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.greenColor,
                    size: 17,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentSummary() {
    return CustomCards(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),

        child: Column(
          mainAxisSize:
              MainAxisSize.min, // ADD THIS - makes column shrink to content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(AppImages.payment),
                    SizedBox(width: 2.w),
                    CustomText(
                      text: "Payment Summary",
                      style: basicColorBold(15, Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Container(
                  height: 0.2.h,
                  width: 100.w,
                  color: AppColors.cardBorderColor,
                ),
                SizedBox(height: 1.h),
                _unitDetailRow(
                  "Total Amount::",
                  "\$69,785.80",
                  basicColorBold(14.5, Colors.black),
                ),
                _unitDetailRow(
                  "Remaining Unpaid:",
                  "\$59,785.80",
                  basicColorBold(14.5, Colors.red),
                ),
                _unitDetailRow(
                  "Total Paid:",
                  "\$10,000.00",
                  basicColorBold(14.5, AppColors.greenColor),
                ),
                _unitDetailRow(
                  "Last Payment:",
                  "20 Oct 2025(\$10,000.00)",
                  basicColor(14.5, AppColors.greenColor),
                ),
                _unitDetailRow(
                  "Next Due Date:",
                  "31 Oct 2021",
                  basicColorBold(14.5, Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget statusContainer(
    BuildContext context,
    Color bgColor,
    String iconPath,
    String text,
    Color textColor,
  ) {
    return Container(
      height: 3.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgColor,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath),
              SizedBox(width: 2.w),
              CustomText(text: text, style: basicColorBold(14, textColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 28.w, // Fixed width for labels → perfect alignment!
            child: CustomText(
              text: "$label",
              style: basicColor(14.5, AppColors.hintText),
            ),
          ),
          Expanded(
            child: CustomText(
              align: TextAlign.left,
              text: value,
              style: basicColor(14.5, Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitDetailRow(String label, String value, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 28.w, // Fixed width for labels → perfect alignment!
            child: CustomText(
              text: "$label",
              style: basicColor(14.5, AppColors.hintText),
            ),
          ),
          CustomText(
            align: TextAlign.left,
            text: value,
            style: style ?? basicColor(14.5, Colors.black87),
          ),
        ],
      ),
    );
  }

  void _showUnitDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        content: Container(
          width: 100.w,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(21),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.house, color: Colors.black, size: 18),
                      SizedBox(width: 2.w),
                      CustomText(
                        text: "Unit Details",
                        style: basicColorBold(16, Colors.black),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),

              // Scrollable Content
              Flexible(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              buildSectionTitle("Unit Information", Icons.home),
                              buildDetailRow("Unit Number", "APSE02"),
                              buildDetailRow("Tower", "Stock Exchange Tower"),
                              buildDetailRow("Floor", "SE01"),
                            ],
                          ),
                        ),

                        SizedBox(height: 1.h),
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
                              buildSectionTitle(
                                "Contract Information",
                                Icons.panorama_rounded,
                              ),
                              buildDetailRow(
                                "Contract Start Date",
                                "2025-10-20",
                              ),
                              buildDetailRow("Contract End Date", "2025-10-26"),
                              buildDetailRow("Rent Amount", "1,000.00"),
                              buildDetailRow("Security Deposit", "500.00"),
                              buildDetailRow("Advance Amount", "200.00"),
                            ],
                          ),
                        ),

                        SizedBox(height: 1.h),
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
                              buildSectionTitle(
                                "Financial Information",
                                Icons.currency_exchange,
                              ),
                              buildDetailRow("Renewal Fee", "50.00"),
                              buildDetailRow("Commission ", "50.00"),
                              buildDetailRow("Company Commission", "10.00"),
                              buildDetailRow("Agent Commission", "10.00"),
                              buildDetailRow("Rent Billing Cycle", "monthly"),
                            ],
                          ),
                        ),

                        SizedBox(height: 1.h),
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
                              buildSectionTitle(
                                "Additional Information",
                                Icons.electric_bolt,
                              ),
                              buildDetailRow(
                                "Contract Type",
                                "Protected Tenancy",
                              ),
                              buildDetailRow("Source Tenancy", "gulf news"),
                              buildDetailRow("Status", "current_resident"),
                              buildDetailRow("Move In Date", "2025-10-21"),
                              buildDetailRow("Move Out Date", "2025-10-21"),
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
        ),
      ),
    );
  }

  // Call this method when health container is tapped
  void showHealthDialog(BuildContext context, UserProfileViewModel userModel) {
    final health = userModel.healthModel?.health;
    final breakdown = userModel.healthModel?.breakdown;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 90.w,
            padding: EdgeInsets.all(3.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.heart_fill,
                          color: AppColors.greenColor,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        CustomText(
                          text: "Health Indicator",
                          style: basicColorBold(18, Colors.black),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.hintText),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Overall Health Section
                Container(
                  padding: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color: AppColors.iconGreyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Overall Health",
                            style: basicColor(14, Colors.black),
                          ),
                          CustomText(
                            text: "${health?.percentage ?? 0}%",
                            style: basicColorBold(20, AppColors.greenColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (health?.percentage ?? 0) / 100,
                          minHeight: 8,
                          backgroundColor: AppColors.cornerGreyColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.greenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                // Health Factors
                _buildHealthFactor(
                  icon: CupertinoIcons.checkmark_shield_fill,
                  title: "Verification",
                  totalWeight: breakdown?.verification?.weight ?? 20,
                  penalty: breakdown?.verification?.penalty ?? 0,
                  remaining:
                      breakdown?.verification?.remaining?.toDouble() ?? 20.0,
                  color: Colors.blue,
                ),
                SizedBox(height: 1.5.h),

                _buildHealthFactor(
                  icon: CupertinoIcons.exclamationmark_triangle_fill,
                  title: "Violations",
                  totalWeight: breakdown?.violations?.weight ?? 20,
                  penalty: breakdown?.violations?.penalty ?? 0,
                  remaining:
                      breakdown?.violations?.remaining?.toDouble() ?? 20.0,
                  color: Colors.deepOrange,
                ),
                SizedBox(height: 1.5.h),

                _buildHealthFactor(
                  icon: CupertinoIcons.doc_text_fill,
                  title: "Legal Notices",
                  totalWeight: breakdown?.legalNotices?.weight ?? 20,
                  penalty: breakdown?.legalNotices?.penalty ?? 0,
                  remaining:
                      breakdown?.legalNotices?.remaining?.toDouble() ?? 20.0,
                  color: Colors.orange,
                ),
                SizedBox(height: 1.5.h),

                _buildHealthFactor(
                  icon: CupertinoIcons.xmark_octagon_fill,
                  title: "Service Suspensions",
                  totalWeight: breakdown?.serviceSuspensions?.weight ?? 20,
                  penalty: breakdown?.serviceSuspensions?.penalty ?? 0,
                  remaining:
                      breakdown?.serviceSuspensions?.remaining?.toDouble() ??
                      20.0,
                  color: Colors.red,
                ),
                SizedBox(height: 1.5.h),

                _buildHealthFactor(
                  icon: CupertinoIcons.money_dollar_circle_fill,
                  title: "Unpaid Bills",
                  totalWeight: breakdown?.unpaidBills?.weight ?? 20,
                  penalty: breakdown?.unpaidBills?.penalty ?? 0,
                  remaining:
                      breakdown?.unpaidBills?.remaining?.toDouble() ?? 20.0,
                  color: Colors.teal,
                ),
                SizedBox(height: 2.h),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenColor,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CustomText(
                      text: "Close",
                      style: basicColorBold(15, Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthFactor({
    required IconData icon,
    required String title,
    required int totalWeight,
    required int penalty,
    required double remaining,
    required Color color,
  }) {
    // Calculate the penalty percentage to show as negative
    String penaltyText = penalty == 0
        ? "-0.0%"
        : "-${penalty.toStringAsFixed(1)}%";

    return Container(
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cornerGreyColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              SizedBox(width: 2.w),
              Expanded(
                child: CustomText(
                  text: title,
                  style: basicColorBold(14, Colors.black),
                ),
              ),
              CustomText(
                text: penaltyText,
                style: basicColor(
                  12,
                  penalty > 0 ? Colors.red : AppColors.hintText,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Total Weight: $totalWeight%",
                style: basicColor(12, AppColors.hintText),
              ),
              CustomText(
                text: "Remaining: ${remaining.toStringAsFixed(1)}%",
                style: basicColor(12, AppColors.hintText),
              ),
            ],
          ),
          SizedBox(height: 0.8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: totalWeight > 0 ? remaining / totalWeight : 0,
              minHeight: 6,
              backgroundColor: AppColors.cornerGreyColor.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class ImportantNotificationsDialog extends StatefulWidget {
  const ImportantNotificationsDialog({Key? key}) : super(key: key);

  @override
  State<ImportantNotificationsDialog> createState() =>
      _ImportantNotificationsDialogState();
}

class _ImportantNotificationsDialogState
    extends State<ImportantNotificationsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get data from providers
    final eventsProvider = Provider.of<EventsViewModel>(context);
    final legalNoticesProvider = Provider.of<LegalNoticesViewModel>(context);

    final eventsList = eventsProvider.eventsModel?.data?.events ?? [];
    final legalNoticesList =
        legalNoticesProvider.legalNoticeModel?.data?.legalNotices ?? [];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
      child: Container(
        constraints: BoxConstraints(maxHeight: 75.h),
        decoration: BoxDecoration(
          color: Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.notifications_active,
                      color: Colors.orange.shade700,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Notifications',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Stay updated with the latest alerts and reminders',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Tabs with badges
            Container(
              color: Colors.white.withOpacity(0.3),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
                tabs: [
                  _buildTab(
                    'Legal Notices',
                    legalNoticesList.length,
                    Colors.red,
                  ),
                  _buildTab('Events', eventsList.length, Colors.teal),
                ],
              ),
            ),

            // Tab content
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLegalNoticesTab(legalNoticesProvider, legalNoticesList),
                  _buildEventsTab(eventsProvider, eventsList),
                  //   _buildInspectionsTab(inspectionsProvider, inspectionsList),
                ],
              ),
            ),

            // Footer buttons
            Container(
              padding: EdgeInsets.all(2.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*   Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Mark all as seen functionality
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.check_circle_outline, size: 18.sp),
                      label: CustomText(text: 'Mark All as Seen',style: basicColor(17, AppColors.buttonColor),),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF4CAF50),
                        side: BorderSide(color: Color(0xFF4CAF50)),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),*/
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: CustomText(
                        text: 'Close',
                        style: basicColor(17, AppColors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int count, Color badgeColor) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (count > 0) ...[
              SizedBox(width: 1.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.5.w,
                  vertical: 0.3.h,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegalNoticesTab(
    LegalNoticesViewModel provider,
    List<dynamic> legalNoticesList,
  ) {
    if (provider.loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
        ),
      );
    }

    if (legalNoticesList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 60,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 2.h),
            CustomText(
              text: "No legal notices available",
              style: basicColor(16, Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(2.h),
      itemCount: legalNoticesList.length,
      itemBuilder: (context, index) {
        final notice = legalNoticesList[index];
        String refNo = notice.refNo ?? "N/A";
        String title = notice.title ?? "N/A";
        String issueDate = notice.issuedDate?.toString() ?? "N/A";
        issueDate = formatDateTime(issueDate);
        String status = notice.status ?? "N/A";
        String noticeType = notice.type?.name ?? "N/A";

        Color getStatusColor(String status) {
          switch (status.toLowerCase().trim()) {
            case 'pending':
              return Colors.orange;
            case 'resolved':
              return Colors.green;
            case 'cancelled':
              return Colors.red;
            default:
              return Colors.grey;
          }
        }

        return Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 20),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: CustomText(
                      text: refNo,
                      style: basicColorBold(16, Colors.black87),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomText(
                      text: status.toTitleCase(),
                      style: basicColorBold(14, getStatusColor(status)),
                    ),
                  ),
                ],
              ),
              Divider(height: 2.h),
              _buildInfoRow('Title:', title.toTitleCase()),
              _buildInfoRow('Notice Type:', noticeType.toTitleCase()),
              _buildInfoRow('Issued Date:', issueDate),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventsTab(EventsViewModel provider, List<dynamic> eventsList) {
    if (provider.loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
        ),
      );
    }

    if (eventsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 60, color: Colors.grey.shade400),
            SizedBox(height: 2.h),
            CustomText(
              text: "No events available",
              style: basicColor(16, Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(2.h),
      itemCount: eventsList.length,
      itemBuilder: (context, index) {
        final event = eventsList[index];
        String eventName = event.eventName ?? "N/A";
        String eventLocation = event.where ?? "N/A";
        String startDate = event.startDateTime?.toString() ?? "N/A";
        startDate = formatDateTime(startDate);
        String endDate = event.endDateTime?.toString() ?? "N/A";
        endDate = formatDateTime(endDate);
        String status = event.status ?? "N/A";

        Color getStatusColor(String status) {
          switch (status.toLowerCase().trim()) {
            case 'pending':
              return Colors.orange;
            case 'completed':
              return Colors.green;
            case 'cancelled':
              return Colors.red;
            default:
              return Colors.grey;
          }
        }

        return Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.event, color: Colors.teal, size: 20),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: CustomText(
                      text: eventName.toTitleCase(),
                      style: basicColorBold(16, Colors.black87),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomText(
                      text: status.toTitleCase(),
                      style: basicColorBold(14, getStatusColor(status)),
                    ),
                  ),
                ],
              ),
              Divider(height: 2.h),
              _buildInfoRow('Location:', eventLocation.toTitleCase()),
              _buildInfoRow('Start Date:', startDate),
              _buildInfoRow('End Date:', endDate),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: CustomText(
              text: label,
              style: basicColor(14, Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              style: basicColor(14, Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
