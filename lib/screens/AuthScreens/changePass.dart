import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/Utils/Custom/customTextField.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/Utils/Custom/navigationbar.dart';
import 'package:savvyions/screens/AuthScreens/loginScreen.dart';
import 'package:savvyions/screens/mainLandingPage.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/images.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassword=TextEditingController();
  TextEditingController newPassword=TextEditingController();
  TextEditingController confirmPassword=TextEditingController();
  bool oldPass=true;
  bool newPass=true;
  bool confirmPass=true;



  @override
  void dispose() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
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

               /* /// GREEN BOTTOM AREA
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
                ),*/

                Positioned(
                  top: 4.h,
                  left: 0.w,
                  right: 82.w,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                      child: Icon(Icons.arrow_back_ios_new,color: AppColors.iconColor,))
                ),



                Positioned(
                    top: 10.h,
                    left: 0.w,
                    right: 0.w,
                    child:Center(child: Image.asset(AppImages.splashScreenLogo,fit: BoxFit.contain,height: 15.h))
                ),

              /*  Positioned(
                    top: 13.h,
                    left: 0.w,
                    right: 0.w,
                    child:Center(child: Image.asset(AppImages.splashimg,fit: BoxFit.cover,height: 21.h,))
                ),*/


                Positioned(
                  top: 30.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child:CustomText(
                        text: "Change Password",
                        style: basicColorBold(19.5, Colors.black)),
                  ),
                ),

                Positioned(
                  top: 36.h,
                  left: 10.w,
                  right: 10.w,
                  child: Center(
                    child:CustomText(
                        align: TextAlign.center,
                        text: "Enter your old password in order to change the password",
                        style: basicColor(16, AppColors.iconColor)),
                  ),
                ),

                Positioned(
                  top: 45.h,
                  left: 10.w,
                  right: 10.w,
                  child:
                  CustomTextfield(controller: oldPassword, obscureText: oldPass,keyboardType: TextInputType.text,hintText: "Enter your old password",iconName:Icons.lock_outline,size: 16.sp,isPasswordField: true,passwordIcon: oldPass?Icons.remove_red_eye_outlined:CupertinoIcons.eye_slash,onPressed: (){
                    setState(() {
                      oldPass=!oldPass;
                    });
                  },),

                ),


                Positioned(
                    top: 53.h,
                    left: 10.w,
                    right: 10.w,
                    child:
                    CustomTextfield(controller: newPassword, obscureText: newPass,keyboardType: TextInputType.text,hintText: "Enter your new password",iconName:Icons.lock_outline,size: 16.sp,isPasswordField: true,passwordIcon: newPass?Icons.remove_red_eye_outlined:CupertinoIcons.eye_slash,
                      onPressed: (){
                      setState(() {
                        newPass=!newPass;
                      });
                      },
                    ),

                ),

                Positioned(
                  top: 61.h,
                  left: 10.w,
                  right: 10.w,
                  child:
                  CustomTextfield(controller: confirmPassword, obscureText: confirmPass,keyboardType: TextInputType.text,hintText: "Confirm your new password",iconName:Icons.lock_outline,size: 16.sp,isPasswordField: true,passwordIcon: confirmPass?Icons.remove_red_eye_outlined:CupertinoIcons.eye_slash,onPressed: (){
                    setState(() {
                      confirmPass=!confirmPass;
                    });
                  },
                  ),

                ),

                Positioned(
                    top: 73.h,
                    left: 10.w,
                    right: 10.w,
                    child:
                    CustomButton(color: AppColors.buttonColor ,text: "Change Password", style: basicColorBold(18, Colors.white),borderRadius: 10,
                        onPressedCallback: (){
                          String oldText=oldPassword.text.trim();
                          String newText=newPassword.text.trim();
                          String confirmText=confirmPassword.text.trim();
                          if(oldText.isEmpty && newText.isEmpty && confirmText.isEmpty){
                            showToast("Please fill both fields");
                            return;
                          }
                        else  if (newText.characters.length < 8) {
                            showToast("The new password must be at least 8 characters.");
                            return;
                          }
                          else if(newText!=confirmText){
                            showToast("New password and new confirm password must be same.");
                            return;
                          }
                          else{
                            var data={
                              "current_password":oldText,
                              "new_password":newText,
                              "new_password_confirmation":confirmText
                            };
                            Provider.of<AuthViewModel>(context,listen: false).changePass(data, context);


                          }
                        })

                ),








              ],
            ),

          ),
        ),
      ),
    );

  }
}
