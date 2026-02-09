import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/providers/unit_provider.dart';
import 'package:savvyions/screens/Units/unitDetails.dart';

import '../../Data/token.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/icons.dart';
import '../../Utils/Constants/images.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/myunits.dart';

class MyUnits extends StatefulWidget {
  const MyUnits({super.key});

  @override
  State<MyUnits> createState() => _MyUnitsState();
}

class _MyUnitsState extends State<MyUnits> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchMyUnits();
    });
  }

  Future<void> fetchMyUnits() async {
    Provider.of<UnitViewModel>(
      context,
      listen: false,
    ).fetchUnits(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          children: [
            /// Welcome area
            Row(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 20,)),                  SizedBox(width: 3.w,),
                CustomText(
                  text: "My Units",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),
            Consumer<UnitViewModel>(
              builder: (context, unitViewModel, child) {
                var myUnitsList=unitViewModel.myUnits?.data?.units??[];
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(unitViewModel.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (myUnitsList.isEmpty) {
                  return  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 68.h,),
                      CustomText(text: "No units available",style: basicColor(16.5, AppColors.greenColor),),
                    ],
                  );
                }


                return Expanded(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount:myUnitsList.length,
                    itemBuilder: (context, index) {
                      final unit = myUnitsList[index];
                      return unitDetails(unit); // Pass data to your widget
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
  Widget unitDetails(Unit unit) {
    String unitNumber=unit.apartment?.apartmentNumber.toString()??"N?A";
    String unitArea=unit.apartment?.apartmentArea.toString()??"N?A";
    String unitAreaUnit=unit.apartment?.apartmentAreaUnit.toString()??"N?A";
    String unitType=unit.apartment?.apartments?.apartmentType.toString()??"N?A";
    String floor=unit.apartment?.floors?.floorName??"N?A";
    String tower=unit.apartment?.towers?.towerName??"N/A";
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UnitDetails(unitId: unit.id.toString(),)));
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
                      Image.asset(AppImages.home,color: AppColors.greenColor,),
                      SizedBox(width: 2.w),
                      CustomText(
                        text: unit.refNo??"N/A",
                        style: basicColorBold(15, AppColors.greenColor),
                      ),
                    ],
                  ),
                  viewDetail(context, (){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UnitDetails(unitId: unit.id.toString(),)));

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
              _unitDetailRow("Unit Number:", unitNumber, null),
              _unitDetailRow("Unit Area:", "${unitArea} ${unitAreaUnit}", null),
              _unitDetailRow("Unit Type:", unitType, null),
              _unitDetailRow("Floor:",floor, null),
              _unitDetailRow("Tower:", tower.toTitleCase(), null),

            ],
          ),
        ),
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
              style: basicColor(15, AppColors.hintText),
            ),
          ),
          CustomText(
            align: TextAlign.left,
            text: value,
            style: style ?? basicColor(15, Colors.black87),
          ),
        ],
      ),
    );
  }


/*
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
          child:
          Column(
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
                              buildSectionTitle(
                                "Unit Information",
                                Icons.home,
                              ),
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
                              buildDetailRow(
                                "Contract End Date",
                                "2025-10-26",
                              ),
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
*/

}
