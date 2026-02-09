import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/colors.dart';
import 'package:savvyions/Utils/Constants/styles.dart';
import 'package:savvyions/Utils/Custom/custom_text.dart';
import 'package:savvyions/providers/auth_provider.dart';
import 'package:savvyions/screens/AuthScreens/loginScreen.dart';
import 'package:savvyions/screens/qrScreen.dart';
import 'package:savvyions/swipeUpScreen.dart';

import '../Utils/Constants/utils.dart';
import '../providers/user_provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String societyName='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<UserProfileViewModel>(
        context,
        listen: false,
      ).fetchUserProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        body: Container(
          color: AppColors.bgColor,
          height: 100.h,
          width: 100.w,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 3.h,horizontal: 2.w),
            child: Consumer2<AuthViewModel,UserProfileViewModel>(builder: (BuildContext context, value, user,Widget? child) {
              final current = value.currentAccount;
              final allAccounts = value.accounts;
              societyName=user.userProfile?.data?.user?.society?.name??"";
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
         Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             CustomText(text: "Menu", style: basicColorBold(18, AppColors.greenColor)),
           ],
         ),

                  SizedBox(height: 3.h,),

                  // List of All Logged-in Companies
                  ...allAccounts.map((account) {
                    bool isCurrent = account.email == current?.email;

                    return ListTile(

                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: isCurrent ? AppColors.greenColor : Colors.grey,
                        child: Text(
                          account.userName.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      title: Text(
                        account.userName,
                        style: TextStyle(
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          fontFamily: "Ubuntu"
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(account.email,style: TextStyle(fontFamily: "Ubuntu"),),
                          SizedBox(height: 0.2.h,),
                          CustomText(text: account.societyName, style: basicColor(15.5, AppColors.greenColor)),
                          SizedBox(height: 1.h,),

                        ],
                      ),
                      trailing: isCurrent
                          ? Icon(Icons.check, color: AppColors.greenColor)
                          : null,
                      onTap: () async {
                        if (!isCurrent) {
                          await value.switchToAccount(account.email);
                          // Optional: Show toast
                          showToast("Switched to ${account.userName}");
                          // Refresh any data that depends on company (e.g., fetch profile, units, etc.)
                          // Example:
                          // Provider.of<UserProfileViewModel>(context, listen: false).fetchData();
                        }
                      },
                    );
                  }).toList(),

// Divider before Add button
                  if (allAccounts.isNotEmpty) Divider(),

                  // Add Another Company Button
                  ListTile(
                    leading: Icon(Icons.add_circle_outline, color: AppColors.greenColor),
                    title: Text("Add another company"),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) =>  Qrscreen(isLogin: true,)),
                      );
                    },
                  ),


                  // Logout Current Account
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text("Logout current company"),
                    onTap: () async {
                      await value.logoutCurrentAccount();
                      showToast("Logged out");

                      // If no accounts left → go to login
                      if (value.accounts.isEmpty) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) =>  SwipeUpScreen()),
                              (route) => false,
                        );
                      } else {
                        ///
                      }
                    },
                  ),

                ],
              );
            },
            ),

            ),
          ),
        ),
      );

  }
}
