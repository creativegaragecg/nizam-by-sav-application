import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/screens/AuthScreens/changePass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Constants/colors.dart';
import '../Utils/Constants/images.dart';
import '../Utils/Constants/styles.dart';
import '../Utils/Constants/utils.dart';
import '../Utils/Custom/customBgScreen.dart';
import '../Utils/Custom/custom_text.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import 'AuthScreens/loginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Fetch advertisements when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchUserData();
    });
  }

  Future<void> fetchUserData() async {
    Provider.of<UserProfileViewModel>(
      context,
      listen: false,
    ).fetchUserProfile(context);
  }


  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            Consumer<UserProfileViewModel>(
              builder: (BuildContext context, UserProfileViewModel value, Widget? child) {
                if (value.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }

                else if (value.userProfile == null) {
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

                final profile = value.userProfile!; // Safe because we checked for null above
                String name= profile.data?.user?.info?.name ?? "N/A";
                String email= profile.data?.user?.info?.email ?? "N/A";
                String roleName= profile.data?.user?.role?.name ?? "N/A";
                String phoneNo= profile.data?.user?.info?.phoneNumber ?? "N/A";
                String nationalId= profile.data?.user?.meta?.nationalIdNumber ?? "N/A";
                String companyName= profile.data?.user?.meta?.companyName ?? "N/A";
                String companyRegistrationNo= profile.data?.user?.meta?.companyRegistrationNumber ?? "N/A";
                String address= profile.data?.user?.meta?.address ?? "N/A";
                String alternatePhone= profile.data?.user?.meta?.alternatePhone ?? "N/A";
                String whatsappNo= profile.data?.user?.meta?.whatsappNumber ?? "N/A";
                String emergencyContactName= profile.data?.user?.meta?.emergencyContactName ?? "N/A";
                String emergencyContact= profile.data?.user?.meta?.emergencyContactNo ?? "N/A";
                String dob= profile.data?.user?.meta?.dob?.toString() ?? "N/A";
                dob = dob.split(' ').first;
                print("dateee:$dob");
                String bloodGroup= profile.data?.user?.meta?.bloodGroup?? "N/A";
                String country= profile.data?.user?.meta?.country?? "N/A";
                String passport= profile.data?.user?.meta?.passport?? "N/A";
                String userPic= profile.data?.user?.info?.profilePhotoUrl ?? "N/A";

                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Profile",
                            style: basicColorBold(18, Colors.black),
                          ),
                          Row(
                            children: [

                              CircleAvatar(
                                backgroundColor: Colors.lightBlueAccent,
                                radius: 20,
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
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                )
                                    : Image.asset(
                                  AppImages.dummyImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              /*   SizedBox(width: 4.w,),
                    GestureDetector(
                        onTap: () async {
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setBool('isLoggedIn', false);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        child: Icon(Icons.logout)),*/
                              SizedBox(width: 1.w,),
                            ],
                          ),
                        ],
                      ),


                      SizedBox(height: 1.h),
                      Expanded(
                        child: Container(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 3.w,vertical: 1.5.h),
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
                                      CustomText(
                                        text: name,
                                        style: basicColorBold(16, AppColors.greenColor),
                                      ),
                                      CustomText(
                                        text: " ($roleName)",
                                        style: basicColor(15, AppColors.hintText),
                                      ),
                                    ],
                                  ),
                                  Align(
                                      alignment: AlignmentGeometry.bottomRight,
                                      child: CustomButton(height: 5.h,width: 33.w,color: AppColors.greenColor, text: "Change Password", style: basicColor(15, Colors.white),borderRadius: 12,onPressedCallback: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePassword()));
                                      },)),
                        
                                ],
                              ),
                        
                              // Scrollable Content
                              Flexible(
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              buildSectionTitle(
                                                AppLocalizations.of(context)!.basicInformation,
                                                Icons.person,
                                              ),
                                              buildDetailRow(AppLocalizations.of(context)!.fullName,name),
                                              buildDetailRow(AppLocalizations.of(context)!.email, email),
                                              buildDetailRow(AppLocalizations.of(context)!.phoneNumber, phoneNo),
                                              buildDetailRow(AppLocalizations.of(context)!.nationalId, nationalId),
                                              buildDetailRow(
                                                  AppLocalizations.of(context)!.address, address
                                              ),
                                            ],
                                          ),
                                        ),
                        
                                        SizedBox(height: 2.5.h),
                                        Container(
                        
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          //  color: AppColors.cornerGreyColor.withOpacity(0.2),
                                          ),
                                          child: Column(
                                            children: [
                                              buildSectionTitle(
                                                AppLocalizations.of(context)!.companyInformation,
                                                Icons.home,
                                              ),
                                              buildDetailRow(
                                                AppLocalizations.of(context)!.companyName,
                                                companyName,
                                              ),
                                              buildDetailRow(
                                                AppLocalizations.of(context)!.companyRegistrationNumber,
                                                companyRegistrationNo,
                                              ),
                                            ],
                                          ),
                                        ),
                        
                                        SizedBox(height: 2.5.h),
                                        Container(
                        
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                         //   color: AppColors.cornerGreyColor.withOpacity(0.2),
                                          ),
                                          child: Column(
                                            children: [
                                              buildSectionTitle(
                                                AppLocalizations.of(context)!.contactInformation,
                                                Icons.call,
                                              ),
                                              buildDetailRow(AppLocalizations.of(context)!.alternatePhone, alternatePhone),
                                              buildDetailRow(AppLocalizations.of(context)!.whatsappNumber,whatsappNo),
                                              buildDetailRow(
                                                AppLocalizations.of(context)!.emergencyContactName,
                                                emergencyContactName,
                                              ),
                                              buildDetailRow(
                                                AppLocalizations.of(context)!.emergencyContact,
                                                emergencyContact,
                                              ),
                                            ],
                                          ),
                                        ),
                        
                                        SizedBox(height: 2.5.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          //  color: AppColors.cornerGreyColor.withOpacity(0.2),
                                          ),
                                          child: Column(
                                            children: [
                                              buildSectionTitle(
                                                AppLocalizations.of(context)!.additionalInformation,
                                                Icons.electric_bolt,
                                              ),
                                              buildDetailRow(AppLocalizations.of(context)!.dateOfBirth, dob),
                                              buildDetailRow(AppLocalizations.of(context)!.bloodGroup, bloodGroup),
                                              buildDetailRow(AppLocalizations.of(context)!.country, country),
                                              buildDetailRow(AppLocalizations.of(context)!.passport, passport),
                        
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
                    ],
                  ),
                );
              },
            ),



          ],
        ),
      ),
    );
  }
}
