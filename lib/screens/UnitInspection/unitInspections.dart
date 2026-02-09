import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/unitInspection.dart';
import 'package:savvyions/providers/unitInspection_provider.dart';
import 'package:savvyions/screens/UnitInspection/inspectionDetails.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/mylease.dart';
import '../../providers/lease_provider.dart';


class UnitInspections extends StatefulWidget {
  const UnitInspections({super.key});

  @override
  State<UnitInspections> createState() => _UnitInspectionsState();
}

class _UnitInspectionsState extends State<UnitInspections> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchInspections();
    });
  }

  Future<void> fetchInspections() async {
    Provider.of<UnitInspectionViewModel>(
      context,
      listen: false,
    ).fetchInspections(context);
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
                  text: "Unit Inspection",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),
          customHeaderLine(context),
            SizedBox(height: 3.5.h),
            Consumer<UnitInspectionViewModel>(
              builder: (context, value, child) {
                var inspectionList=value.inspectionModel?.data?.inspections??[];
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(value.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (inspectionList.isEmpty) {
                  return const Center(child: Text("No inspections yet"));
                }


                return Expanded(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount:inspectionList.length,
                    itemBuilder: (context, index) {
                      final inspection = inspectionList[index];
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical:0.6.h),
                        child: inspectionDetail(inspection),
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
  Widget inspectionDetail(Inspection inspection) {
    String refNo=inspection.refNo??"N/A";

    String unitNo=inspection.apartment?.apartmentNumber??"N/A";
    String inspectionDate=inspection.inspectionDate?.toString()??"N/A";
    String rating=inspection.cleanlinessRating.toString()??"N/A";
    String damageFound=inspection.damageFound.toString()??"N/A";
    damageFound=damageFound=="0"?"No":"Yes";
    String duration=inspection.inspectionDuration.toString()??"N/A";
    String inspectedBy=inspection.inspectedBy?.name??"N/A";
    String inspectionType=inspection.inspectionType?.name??"N/A";
    String inspectionSeverity=inspection.damageSeverity??"N/A";
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>InspectionDetails(id:inspection.id.toString())));

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
                  viewDetail(context, (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>InspectionDetails(id:inspection.id.toString())));

                  })
                ],
              ),
              SizedBox(height: 0.5.h),
              Container(
                height: 0.2.h,
                width: 100.w,
                color: AppColors.cardBorderColor,
              ),
              SizedBox(height: 1.h),
              unitDetailRow("Unit Number:", unitNo, null),
              unitDetailRow("Inspection Type:", inspectionType, null),
              unitDetailRow("Inspection Date:", inspectionDate, null),
              unitDetailRow("Inspected By:", inspectedBy, null),
              unitDetailRow("Inspection Duration:", duration=="null"?"N/A":duration, null),
              unitDetailRow("Inspection Severity:", inspectionSeverity, null),
              unitDetailRow("Damage Found:", damageFound, null),
              unitDetailRow("Rating:", "$rating/5", null),


            ],
          ),
        ),
      ),
    );
  }




}
