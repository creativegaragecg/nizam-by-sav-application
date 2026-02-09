import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/images.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/mylease.dart';
import '../../providers/lease_provider.dart';
import 'leaseStatement.dart';

class MyLease extends StatefulWidget {
  const MyLease({super.key});

  @override
  State<MyLease> createState() => _MyLeaseState();
}

class _MyLeaseState extends State<MyLease> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchLeases();
    });
  }

  Future<void> fetchLeases() async {
    Provider.of<LeaseViewModel>(
      context,
      listen: false,
    ).fetchLease(context);
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
                  text: "My Leases",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),
            Consumer<LeaseViewModel>(
              builder: (context, leaseViewModel, child) {
                var leaseList=leaseViewModel.leaseModel?.data?.leases??[];
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(leaseViewModel.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (leaseList.isEmpty) {
                  return const Center(child: Text("No lease details available"));
                }


                return Expanded(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount:leaseList.length,
                    itemBuilder: (context, index) {
                      final lease = leaseList[index];
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: 0.6.h),
                        child: leaseDetails(lease),
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
  Widget leaseDetails(Lease lease) {
    String refNo=lease.tenant?.refNo??"N/A";
    print("fregerg:${lease.id}");
    String unitNo=lease.apartment?.apartmentNumber??"N/A";
    String floor=lease.apartment?.floors?.floorName??"N/A";
    String tower=lease.apartment?.towers?.towerName??"N/A";
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLeaseStatement(leaseId: lease.id.toString(),)));

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
                      Icon(Icons.person,color: AppColors.greenColor,size: 22,),
                      SizedBox(width: 2.w),
                      CustomText(
                        text: refNo,
                        style: basicColorBold(16, AppColors.greenColor),
                      ),
                    ],
                  ),
                  viewDetail(context, (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLeaseStatement(leaseId: lease.id.toString(),)));

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
              unitDetailRow("Floor:", floor, null),
              unitDetailRow("Tower:", tower, null),


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
          child: Column(
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

}
