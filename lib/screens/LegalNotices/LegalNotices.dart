import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/providers/legalNotice_provider.dart';
import 'package:savvyions/screens/LegalNotices/legalNoticeDetails.dart';
import 'package:savvyions/screens/UnitInspection/inspectionDetails.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/legalNotice.dart';



class LegalNotices extends StatefulWidget {
  const LegalNotices({super.key});

  @override
  State<LegalNotices> createState() => _LegalNoticesState();
}

class _LegalNoticesState extends State<LegalNotices> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchLegalNotices();
    });
  }

  Future<void> fetchLegalNotices() async {
    Provider.of<LegalNoticesViewModel>(
      context,
      listen: false,
    ).fetchLegalNotices(context);
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
                  text: "Legal Notices",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            customHeaderLine(context),


            SizedBox(height: 3.5.h),
            Consumer<LegalNoticesViewModel>(
              builder: (context, value, child) {
                var legalNoticeList=value.legalNoticeModel?.data?.legalNotices??[];
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(value.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (legalNoticeList.isEmpty) {
                  return const Center(child: Text("No legal notice available"));
                }


                return Expanded(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount:legalNoticeList.length,
                    itemBuilder: (context, index) {
                      final notice = legalNoticeList[index];
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: 0.5.h),
                        child: legalNoticeDetails(notice),
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
  Widget legalNoticeDetails(LegalNotice notice) {
    String refNo=notice.refNo??"N/A";
    String title=notice.title??"N/A";
    String issueDate=notice.issuedDate?.toString()??"N/A";
    issueDate=formatDateTime(issueDate);
    String status=notice.status??"N/A";
    String noticeType=notice.type?.name??"N/A";

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {

        case 'pending':
          return Colors.yellow;
        case 'resolved':
          return Colors.green;
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.black45;
      }
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LegalNoticeDetails(id:notice.id.toString(),type: noticeType,)));

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
                      Icon(Icons.note,color: AppColors.greenColor,size: 22,),
                      SizedBox(width: 2.w),
                      CustomText(
                        text: refNo,
                        style: basicColorBold(16, AppColors.greenColor),
                      ),
                    ],
                  ),
                  viewDetail(context, (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LegalNoticeDetails(id:notice.id.toString(),type: noticeType,)));

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
              unitDetailRow("Title:", title.toTitleCase(), null),
              unitDetailRow("Issued Date:", issueDate, null),
              unitDetailRow("Notice Type:", noticeType.toTitleCase(), null),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }




}
