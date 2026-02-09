import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/unitInspection.dart';
import 'package:savvyions/models/violationRecords.dart';
import 'package:savvyions/providers/unitInspection_provider.dart';
import 'package:savvyions/providers/violationRecord_provider.dart';
import 'package:savvyions/screens/UnitInspection/inspectionDetails.dart';
import 'package:savvyions/screens/Violations/violationDetails.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/mylease.dart';
import '../../providers/lease_provider.dart';


class ViolationRecords extends StatefulWidget {
  const ViolationRecords({super.key});

  @override
  State<ViolationRecords> createState() => _ViolationRecordsState();
}

class _ViolationRecordsState extends State<ViolationRecords> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchRecords();
    });
  }

  Future<void> fetchRecords() async {
    Provider.of<ViolationRecordsViewModel>(
      context,
      listen: false,
    ).fetchRecords(context);
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
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 20,)),
                SizedBox(width: 3.w,),
                CustomText(
                  text: "Violation Records",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),
            Consumer<ViolationRecordsViewModel>(
              builder: (context, value, child) {
                var list=value.recordsModel?.data?.violations??[];
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(value.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (list.isEmpty) {
                  return const Center(child: Text("No violation records yet"));
                }


                return Expanded(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount:list.length,
                    itemBuilder: (context, index) {
                      final record = list[index];
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical:0.6.h),
                        child: violationDetails(record),
                      ); // Pass data to your widget
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
  Widget violationDetails(Violation record) {
    String refNo=record.refNo??"N/A";
    String type=record.violationType??"N/A";
    String unitNo=record.apartment?.apartmentNumber??"N/A";
    String reportedDate=record.dateReported.toString()??"N/A";
    reportedDate=formatDateTime(reportedDate);
    String status=record.resolvedStatus??"N/A";

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {

        case 'pending':
          return Colors.orange;
        case 'resolved':
          return Colors.green;
        default:
          return Colors.black45;
      }
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViolationDetails(id:record.id.toString())));

      },
      child: CustomCards(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),

          child: Column(
            mainAxisSize:
            MainAxisSize.min, // ADD THIS - makes column shrink to content

            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber,color: AppColors.greenColor,size: 22,),
                      SizedBox(width: 2.w),
                      CustomText(
                        text: refNo,
                        style: basicColorBold(16, AppColors.greenColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                          decoration: BoxDecoration(
                            color: getStatusColor(status).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CustomText(
                              text: status.toTitleCase(),
                              style: basicColorBold(15, getStatusColor(status)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w,),
                      viewDetail(context, (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViolationDetails(id:record.id.toString())));
                      },)
                    ],
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
              unitDetailRow("Unit:", unitNo, null),
             unitDetailRow("Violation Type:", type, null),
              unitDetailRow("Reported Date:", reportedDate, null),


            ],
          ),
        ),
      ),
    );
  }




}
