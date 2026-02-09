import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Data/token.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/Utils/Constants/images.dart';
import 'package:savvyions/Utils/Custom/navigationbar.dart';
import 'package:savvyions/providers/amenities_provider.dart';
import 'package:savvyions/providers/auth_provider.dart';
import 'package:savvyions/providers/bills_provider.dart';
import 'package:savvyions/providers/events_provider.dart';
import 'package:savvyions/providers/forums_provider.dart';
import 'package:savvyions/providers/gatePass_provider.dart';
import 'package:savvyions/providers/languagechangeController.dart';
import 'package:savvyions/providers/lease_provider.dart';
import 'package:savvyions/providers/legalNotice_provider.dart';
import 'package:savvyions/providers/noticeBoard_provider.dart';
import 'package:savvyions/providers/notification_provider.dart';
import 'package:savvyions/providers/serviceSuspensionProvider.dart';
import 'package:savvyions/providers/services_provider.dart';
import 'package:savvyions/providers/ticket_provider.dart';
import 'package:savvyions/providers/unitInspection_provider.dart';
import 'package:savvyions/providers/unit_provider.dart';
import 'package:savvyions/providers/user_provider.dart';
import 'package:savvyions/providers/violationRecord_provider.dart';
import 'package:savvyions/providers/visitor_provider.dart';
import 'package:savvyions/screens/onBoardingScreens.dart';
import 'package:savvyions/screens/qrScreen.dart';
import 'package:savvyions/swipeUpScreen.dart';
import 'package:savvyions/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Utils/Constants/styles.dart';
import 'Utils/Custom/custom_text.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ChangeNotifierProvider(create: (_) => UserProfileViewModel()),
      ChangeNotifierProvider(create: (_) => LeaseViewModel()),
      ChangeNotifierProvider(create: (_) => LanguageChangeController()),
      ChangeNotifierProvider(create: (_) => UnitViewModel()),
      ChangeNotifierProvider(create: (_) => BillsViewModel()),
      ChangeNotifierProvider(create: (_) => TicketsViewModel()),
      ChangeNotifierProvider(create: (_) => GatePassViewModel()),
      ChangeNotifierProvider(create: (_) => VisitorViewModel()),
      ChangeNotifierProvider(create: (_) => EventsViewModel()),
      ChangeNotifierProvider(create: (_) => NoticeBoardViewModel()),
      ChangeNotifierProvider(create: (_) => LegalNoticesViewModel()),
      ChangeNotifierProvider(create: (_) => UnitInspectionViewModel()),
      ChangeNotifierProvider(create: (_) => ViolationRecordsViewModel()),
      ChangeNotifierProvider(create: (_) => ForumsViewModel()),
      ChangeNotifierProvider(create: (_) => AmenitiesViewModel()),
      ChangeNotifierProvider(create: (_) => ServicesViewModel()),
      ChangeNotifierProvider(create: (_) => NotificationsViewModel()),
      ChangeNotifierProvider(create: (_) => ServiceSuspensionViewModel()),

    ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return   Consumer<LanguageChangeController>(builder: (BuildContext context, LanguageChangeController value, Widget? child) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: value.appLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),


          ],
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.bgColor,  // ← ADD THIS
            applyElevationOverlayColor: false,           // ← IMPORTANT
            canvasColor: AppColors.bgColor,
            useMaterial3: false, // Optional: disables new Material You tinting// ← ALSO ADD
          ),
          home: const SplashScreen(),
        );
      },


      );
    },


    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});



  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadLanguage(); // Move it here so the Provider is accessible
  }

  void loadLanguage(){
    final languageController = Provider.of<LanguageChangeController>(context);
    languageController.loadLanguage();
  }

  /*void checkLogin() async {
    var prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isQRScanned = prefs.getBool('qrScanned') ?? false;
    print("User Token: ${UserToken.token}");
    print("isLoggedIn: $isLoggedIn");
    print("isQRScanned: $isQRScanned");

    Timer(
       Duration(seconds: 2),
          () async {
        // Case 1: QR not scanned (regardless of login status)
        if (!isQRScanned) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Qrscreen(),
            ),
                (route) => false,
          );

        }
        // Case 2: QR scanned but not logged in
        else if (isQRScanned && !isLoggedIn) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
                (route) => false,
          );
        }
        // Case 3: Both QR scanned and logged in
        else if (isQRScanned && isLoggedIn) {
          UserToken().loadUserToken();
          UserToken().loadUserInfo();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const NavigationBarScreen(),
            ),
                (route) => false,
          );
        }

      },
    );
  }*/
  void checkLogin() async {
    // Get AuthViewModel
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // CRITICAL: Load all saved accounts and current session
    await authViewModel.loadAccounts();

    // Get SharedPreferences for QR check
    final prefs = await SharedPreferences.getInstance();
    bool isWelcomePages = prefs.getBool('welcomePages') ?? false;

    // Small delay for splash feel (2 seconds total)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    UserToken().loadUserToken();





    if (!isWelcomePages) {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  WelcomeScreen()),
            (route) => false,
      );
    }
    // QR scanned, but no accounts logged in
     if (isWelcomePages && authViewModel.accounts.isEmpty) {
       Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(builder: (context) =>  SwipeUpScreen ()),
             (route) => false,
       );
    }
    // At least one account exists → go to home (currentAccount is auto-set in loadAccounts)
    else if(authViewModel.accounts.isNotEmpty && isWelcomePages) {

       // Optional: Refresh any user-specific data here if needed
      // e.g., Provider.of<UserProfileViewModel>(context, listen: false).fetchProfile();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavigationBarScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bgColor, // ← Add this too (double protection)
      body: SafeArea(
          child:
          Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: AppColors.bgColor,


            ),
            child:
            Center(
            child: Image.asset(
    AppImages.splashScreenLogo,
    ),

          )
          /*Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: AppColors.bgColor,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),  // Dark soft shadow
                  blurRadius: 30,                         // Soft blur (like Figma)
                  offset: const Offset(0, 10),            // Shadow drops down
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                /// TOP LIGHT CURVE (background pattern)
                Positioned(
                  top: 1.h,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    AppImages.topCurve,
                    fit: BoxFit.cover,
                    height: 43.h, // Adjust this if needed (50-60.h works best)
                  ),
                ),

             /// LOGO
                Positioned(
                  top: 5.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      AppImages.logo,
                     ),
                  )
                  ),

                /// Welcome text
                Positioned(
                    top: 35.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child:CustomText(
                         *//* text: "WELCOME TO MEMBER APP", *//*
                          text: "${AppLocalizations.of(context)!.welcome} ${AppLocalizations.of(context)!.to} ${AppLocalizations.of(context)!.member}" ,
                          style: basicColorBold(19.5, AppColors.greenColor)),
                    ),
                    ),
                
                



                /// GREEN BOTTOM AREA
                Positioned(
                  bottom: 0.h,
                  left: 0.w,
                  right: 0.w,
                  child: Image.asset(
                    AppImages.greenRectangle,
                    fit: BoxFit.fill,
                    height: 46.h,   // This is the magic number — matches Figma perfectly
                  ),
                ),

                /// green area curve line
                 Positioned(
                  bottom: 0.h,
                 left: 0.w,
                 right: 0.w,
                 child: Image.asset(AppImages.bottomcurve, fit: BoxFit.fill,
                   height: 70.h,
                 ),
                 ),


                // 7. MAIN ILLUSTRATION — PERFECTLY CENTERED LIKE FIGMA
                Positioned(
                  bottom: 12.h,                    // Distance from bottom
                  left: 0.w,
                  right:0.w,// Center horizontally (38.w = image width approx)
                  child: Image.asset(
                    AppImages.rectangle,       // ← Your circled image (people + card)
                    height:18.h,

                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  bottom: 9.5.h,                    // Distance from bottom
                  left: 0.w,
                  right: 0.w,// Center horizontally (38.w = image width approx)
                  child: Image.asset(
                    AppImages.splashimg,       // ← Your circled image (people + card)
                    height: 19.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

          )*/
      ),
    )
    );
  }
}
