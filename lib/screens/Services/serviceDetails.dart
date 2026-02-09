import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/services.dart';
import 'package:savvyions/providers/forums_provider.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key, required this.service});
  final Service service;

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
String contactPerson="";
String contactNo="";
String status="";
String dailyAvailibility="";
String price="";
String frequency="";

  @override
  void initState() {
    super.initState();
     contactPerson = widget.service.contactPersonName ?? "N/A";
     contactNo = widget.service.phoneNumber ?? "N/A";
     status = widget.service.status ?? "N/A";
    bool dailyHelp = widget.service.dailyHelp?? false;
     dailyAvailibility=dailyHelp?"Yes":"No";
     price = widget.service.price.toString();
     frequency = widget.service.paymentFrequency??"";
    frequency = frequency.replaceAll('_', ' ');
    print("freqqq:$frequency");

  }

  @override
  void dispose() {

    super.dispose();
  }

Color getStatusColor(String type) {
  switch (type.toLowerCase().trim()) {
    case 'available':
      return Colors.green;
    case 'not available':
      return Colors.red;
    default:
      return Colors.grey;
  }
}


@override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: Column(
        children: [
          // Header
          SizedBox(height: 3.h,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                ),
                SizedBox(width: 3.w),
                CustomText(
                  text: "Service Details",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.w),
            child: customHeaderLine(context),
          ),
          SizedBox(height: 3.h,),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.w),
            child: CustomCards(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [

                            CustomText(
                              text: widget.service.serviceTypeName?.toTitleCase()??"",
                              style: basicColorBold(16, AppColors.greenColor),
                            ),
                          ],
                        ),
                        IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 0.6.h),
                            decoration: BoxDecoration(
                              color: getStatusColor(status)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: CustomText(
                                text: status.toTitleCase(),
                                style: basicColorBold(
                                    15, getStatusColor(status)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    buildDetailRow("Contact Person Name", contactPerson.toTitleCase()),
                    buildDetailRow("Contact Number", contactNo),
                    if(price!="0")
                    buildDetailRow("Price", "€$price $frequency"),
                    if(price=="0")
                      buildDetailRow("Price", "Not Disclosed"),
                      buildDetailRow("Is he/she will be a daily help?", dailyAvailibility),
                      buildDetailRow("Website Link", widget.service.websiteLink??"--"),
                      buildDetailRow("Company Name", widget.service.companyName??"--"),
                      buildDetailRow("Description", widget.service.description??"--"),


                  ],
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}





