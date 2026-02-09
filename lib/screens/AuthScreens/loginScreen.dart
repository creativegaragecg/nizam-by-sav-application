import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/customTextField.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/providers/languagechangeController.dart';
import 'package:savvyions/screens/AuthScreens/forgotPassword.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/images.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key,  this.id,this.societyName,this.baseUrl});
  String? id;
  String? societyName;
  String? baseUrl;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  bool isPassword=true;



  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:true,
        backgroundColor: AppColors.white, // ← Add this too (double protection)
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),

          child: Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              image: DecorationImage(
                image: AssetImage(AppImages.newBg), // Your image path
                fit: BoxFit.cover, // or BoxFit.fill, BoxFit.contain based on your need
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),  // Dark soft shadow
                  blurRadius: 10,                         // Soft blur (like Figma)
                  offset: const Offset(10, 10),            // Shadow drops down
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [

                /*/// GREEN BOTTOM AREA
                Positioned(
                  left: 0.w,
                  right: 0.w,
                  top: 0.h,
                  child: Image.asset(
                    AppImages.topGreenCurve,
                    fit: BoxFit.fill,
                    height:40.h,   // This is the magic number — matches Figma perfectly
                  ),

                ),

                /// green area curve line
                Positioned(
                  top: 0.h,
                  left: 0.w,
                  right: 0.w,
                  child: Transform.rotate(
                    angle: 3,
                    child: Image.asset(AppImages.bottomcurve, fit: BoxFit.fill,
                      height: 59.h,
                    ),
                  ),
                ),
*/


                Positioned(
                    top: 7.h,
                    left: 0.w,
                    right: 0.w,
                    child:Image.asset(AppImages.splashScreenLogo,fit: BoxFit.contain,height: 15.h,)
                ),



                Positioned(
                  top: 24.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child:CustomText(
                        text: "Welcome By Nizaam of",

                        //     text:"${AppLocalizations.of(context)!.login} ${AppLocalizations.of(context)!.to} ${AppLocalizations.of(context)!.continueButton}",
                        style: basicColorBold(18, AppColors.iconColor)),
                  ),
                ),

                Positioned(
                  top: 27.5.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child:CustomText(
                        text: "${widget.societyName}",

                        //     text:"${AppLocalizations.of(context)!.login} ${AppLocalizations.of(context)!.to} ${AppLocalizations.of(context)!.continueButton}",
                        style: basicColorBold(18, AppColors.iconColor)),
                  ),
                ),


                Positioned(
                  top: 39.5.h,
                  left: 25.w,
                  right: 25.w,

                  child:
                  Center(
                    child: CustomText(
                        text:"${AppLocalizations.of(context)!.login} ${AppLocalizations.of(context)!.to} ${AppLocalizations.of(context)!.continueButton}",

                        //    text:"Welcome To ${widget.societyName}",
                        style: basicColorBold(17, AppColors.greenColor)),
                  ),
                ),


                Positioned(
                  top: 48.h,
                  left: 17.w,
                  right: 17.w,
                  child:
                  CustomTextfield(controller: email, obscureText: false,keyboardType: TextInputType.text,hintText:AppLocalizations.of(context)!.email,iconName:Icons.person,size: 16.sp,),

                ),

                Positioned(
                  top: 57.h,
                  left: 17.w,
                  right: 17.w,
                  child:
                  CustomTextfield(controller: password, obscureText: isPassword,keyboardType: TextInputType.text,hintText: AppLocalizations.of(context)!.password,iconName:Icons.lock_outline,size: 16.sp,isPasswordField: true,passwordIcon:isPassword? Icons.remove_red_eye_outlined:CupertinoIcons.eye_slash,onPressed: (){
                    setState(() {
                      isPassword=!isPassword;
                    });
                  },),

                ),


                Positioned(
                    top: 68.h,
                    left: 17.w,
                    right: 17.w,
                    child:
                    CustomButton(
                      color:
                      authViewModel.loading // ✅ Disable button when loading
                          ? AppColors.hintText.withOpacity(0.5)
                          : AppColors.buttonColor,
                      text: authViewModel.loading?"${AppLocalizations.of(context)!.loggingIn}...":AppLocalizations.of(context)!.login, style: basicColor(18, Colors.white),
                      onPressedCallback:  authViewModel.loading // ✅ Disable button when loading
                          ? null
                          : () async {
                        String emailText=email.text.trim();
                        String pass=password.text.trim();
                        if (emailText.isEmpty || pass.isEmpty) {
                          showToast("Please enter both email and password");
                          return;
                        }

                        if (!isValidEmail(emailText)) {
                          showToast("Please enter a valid email address");
                          return;
                        }

                        else {
                          AppEndPoints.baseUrl = widget.baseUrl!;
                          setState(() {

                          });
                          String deviceName = await getDeviceName();
                          Map<String, dynamic> data = {
                            "email": emailText,
                            "password": pass,
                            "device_name": deviceName,
                            "society_id":widget.id,
                          };

                          if (!mounted) return;
                          await authViewModel.loginApi(data, context, societyName: widget.societyName??'', baseUrl: widget.baseUrl??"");

                        }


                      },)

                ),

                /* Positioned(
                    top: 80.h,
                    left: 17.w,
                    right: 17.w,

                    child:
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Container(),
                           GestureDetector(
                             onTap: (){
                               Navigator.of(context).pushReplacement(
                                 MaterialPageRoute(builder: (_) => const ForgotPassword()), // ← Change to your next screen
                               );                             },
                               child: CustomText(text: AppLocalizations.of(context)!.forgotpass, style: basicColor(15.5, Colors.black))),
                         ],
                       )
                ),*/

                Positioned(
                  top: 81.h,
                  left: 0,
                  right: 0,
                  child: Consumer<LanguageChangeController>(builder: (BuildContext context, LanguageChangeController languageController, Widget? child) {
                    return   Center(
                      child: PopupMenuButton<String>(
                        offset: Offset(0, 50), // Dropdown appears just below
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        elevation: 8,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Icon(CupertinoIcons.globe, color: AppColors.greenColor, size: 20.sp),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "ar",
                            child: Row(children: [
                              SizedBox(
                                  width: 5.w,
                                  height: 2.5.h,
                                  child: CountryFlag.fromCountryCode(languageController.appLocale?.languageCode == 'ar'?"US":"SA")),
                              SizedBox(width: 3.w,),
                              CustomText(text:languageController.appLocale?.languageCode == 'ar'? "English":"عربي", style: basicColor(16, Colors.black))]),
                          ),

                        ],
                        onSelected: (value) {


                          if(languageController.appLocale?.languageCode=='ar'){
                            languageController.changeToEnglish();
                          }
                          else{
                            languageController.changeToArabic();

                          }

                          // Add your localization logic here
                        },
                      ),
                    );
                  },


                  ),
                ),


                // ✅ Loading Overlay
                if (authViewModel.loading)
                  Container(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent background
                    child: Center(
                      child:
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.greenColor),
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