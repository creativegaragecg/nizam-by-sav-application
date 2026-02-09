import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/customTextField.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/Utils/Custom/navigationbar.dart';
import 'package:savvyions/screens/AuthScreens/loginScreen.dart';
import 'package:savvyions/screens/mainLandingPage.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/images.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email=TextEditingController();



  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

                /// GREEN BOTTOM AREA
                Positioned(
                  left: 0.w,
                  right: 0.w,
                  top: 0.h,
                  child: Image.asset(
                    AppImages.topGreenCurve,
                    fit: BoxFit.fill,
                    height: 46.h,   // This is the magic number — matches Figma perfectly
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
                      height: 63.h,
                    ),
                  ),
                ),



                Positioned(
                    top: 10.h,
                    left: 0.w,
                    right: 0.w,
                    child:Center(child: Image.asset(AppImages.rectangle,height: 21.h,fit: BoxFit.cover,))
                ),

                Positioned(
                    top: 13.h,
                    left: 0.w,
                    right: 0.w,
                    child:Center(child: Image.asset(AppImages.splashimg,fit: BoxFit.cover,height: 21.h,))
                ),


                Positioned(
                  top: 44.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child:CustomText(
                        text: AppLocalizations.of(context)!.forgotYourPassword,
                        style: basicColorBold(19.5, Colors.black)),
                  ),
                ),

                Positioned(
                  top: 48.h,
                  left: 10.w,
                  right: 10.w,
                  child: Center(
                    child:CustomText(
                      align: TextAlign.center,
                        text: AppLocalizations.of(context)!.forgotPasswordSubtitle,
                        style: basicColor(16, AppColors.hintText)),
                  ),
                ),

                Positioned(
                  top: 60.h,
                  left: 10.w,
                  right: 10.w,
                  child:
                  CustomTextfield(controller: email, obscureText: false,keyboardType: TextInputType.text,hintText: AppLocalizations.of(context)!.exampleEmail,size: 16.5.sp,bgcolor: AppColors.yellowColor,cornerColor: AppColors.cornerGreyColor,
                  borderRadius:BorderRadius.circular(10),hintColor: Colors.black,iconName: Icons.alternate_email_rounded,iconSize: 20,),

                ),


                Positioned(
                    top: 68.h,
                    left: 10.w,
                    right: 10.w,
                    child:
                    CustomButton(color: AppColors.buttonColor ,text: AppLocalizations.of(context)!.sendResetLink, style: basicColorBold(18, Colors.white),borderRadius: 10,
                        onPressedCallback: (){
                          String emailText=email.text.trim();

                          if(emailText.isEmpty ){
                            showToast("Please enter your email");
                            return;
                          }
                          else{
                            var data={
                              "email":emailText
                            };
                            Provider.of<AuthViewModel>(context, listen: false).forgotPass(data);
                          }
                        })

                ),

                Positioned(
                    top: 76.5.h,
                    left: 10.w,
                    right: 10.w,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomText(
                            text: "........",
                            style: basicColor(16.5, AppColors.hintText)),

                        CustomText(
                            text: AppLocalizations.of(context)!.needHelp,
                            style: basicColor(16.5, AppColors.hintText)),

                        CustomText(
                            text: "........",
                            style: basicColor(16.5, AppColors.hintText)),
                      ],
                    )

                ),

                Positioned(
                    top: 81.5.h,
                    left: 10.w,
                    right: 10.w,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                            text: AppLocalizations.of(context)!.rememberPassword,
                            style: basicColor(16.5, AppColors.hintText)),
                            SizedBox(width: 3.w,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

                          },
                          child: CustomText(
                              text: AppLocalizations.of(context)!.signIn,
                              style: basicColorBold(16.5, AppColors.buttonColor)),
                        ),

                      ],
                    )

                ),

              /*  Positioned(
                    top: 86.5.h,
                    left: 10.w,
                    right: 10.w,
                    child:
                    CustomButton(color: Colors.white ,text: AppLocalizations.of(context)!.goToHome, style: basicColor(17.5, Colors.black),borderRadius: 10,borderColor: AppColors.cornerGreyColor,
                    onPressedCallback: (){
                    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationBarScreen()));
                    },)
                ),*/






              ],
            ),

          ),
        ),
      ),
    );

  }
}
