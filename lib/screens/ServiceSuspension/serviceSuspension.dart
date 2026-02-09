import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/serviceSuspension.dart';
import 'package:savvyions/providers/legalNotice_provider.dart';
import 'package:savvyions/providers/serviceSuspensionProvider.dart';
import 'package:savvyions/screens/LegalNotices/legalNoticeDetails.dart';
import 'package:savvyions/screens/ServiceSuspension/details.dart';
import 'package:savvyions/screens/UnitInspection/inspectionDetails.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/legalNotice.dart';



class ServicesSuspension extends StatefulWidget {
  const ServicesSuspension({super.key});

  @override
  State<ServicesSuspension> createState() => _ServicesSuspensionState();
}

class _ServicesSuspensionState extends State<ServicesSuspension> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchSuspensions();
    });
  }

  Future<void> fetchSuspensions() async {
    Provider.of<ServiceSuspensionViewModel>(
      context,
      listen: false,
    ).fetchSuspensions(context);
  }

  Map<String, int> getStatistics(List<Suspension> suspensions) {
    Map<String, int> stats = {
      'total': suspensions.length,
      'submitted': 0,
      'under_review': 0,
      'in_progress': 0,
      'suspended': 0,
      'restored': 0,
    };

    for (var suspension in suspensions) {
      String status = (suspension.status ?? '').toLowerCase().replaceAll('_', '').trim();

      switch (status) {
        case 'submitted':
          stats['submitted'] = (stats['submitted'] ?? 0) + 1;
          break;
        case 'under review':
        case 'underreview':
          stats['under_review'] = (stats['under_review'] ?? 0) + 1;
          break;
        case 'inprogress':
        case 'in progress':
          stats['in_progress'] = (stats['in_progress'] ?? 0) + 1;
          break;
        case 'suspended':
          stats['suspended'] = (stats['suspended'] ?? 0) + 1;
          break;
        case 'restored':
          stats['restored'] = (stats['restored'] ?? 0) + 1;
          break;
      }
    }

    return stats;
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
                  text: "Service Suspension",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.h),

            Consumer<ServiceSuspensionViewModel>(
              builder: (context, value, child) {
                var suspensionList=value.serviceSuspensionModel?.data?.suspensions??[];

                if(value.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }

                if (suspensionList.isEmpty) {
                  return const Center(child: Text("No service suspension available"));
                }

                Map<String, int> stats = getStatistics(suspensionList);

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Statistics Section
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                        Row(
                          children: [
                            buildStatCard(
                              icon: Icons.list_alt,
                              label: "Suspensions",
                              count: stats['total']!,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 2.w),
                            buildStatCard(
                              icon: Icons.upload_file,
                              label: "Submitted",
                              count: stats['submitted']!,
                              color: Colors.green,
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: 1.h,),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                        Row(
                          children: [

                            buildStatCard(
                              icon: Icons.rate_review,
                              label: "Under Review",
                              count: stats['under_review']!,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 2.w),
                            buildStatCard(
                              icon: Icons.autorenew,
                              label: "In Progress",
                              count: stats['in_progress']!,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                        Row(
                          children: [

                            buildStatCard(
                              icon: Icons.warning,
                              label: "Suspended",
                              count: stats['suspended']!,
                              color: Colors.red.shade700,
                            ),
                            SizedBox(width: 2.w),
                            buildStatCard(
                              icon: Icons.check_circle,
                              label: "Restored",
                              count: stats['restored']!,
                              color: Colors.teal,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // List of suspensions
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: suspensionList.length,
                          itemBuilder: (context, index) {
                            final suspension = suspensionList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: serviceSuspension(suspension),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }



  Widget serviceSuspension(Suspension suspension) {
    String suspensionNumber=suspension.suspensionNumber?.toString()??"N/A";
    String subject=suspension.subject??"N/A";
    String agent=suspension.agent?.name??"N/A";
    String type=suspension.suspensionType?.typeName??"N/A";
    String elapsedTime=suspension.resolvedTime??"N/A";
    String status=suspension.status??"N/A";
    status=status.replaceAll("_","");

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {
        case 'submitted':
          return Colors.green;
        case 'under review':
          return Colors.blue;
        case 'inprogress':
          return Colors.brown;
        case 'suspended':
          return Colors.red;
        case 'restored':
          return Colors.blueAccent;
        default:
          return Colors.black45;
      }
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceSuspensionDetails(id:suspension.id.toString())));
      },
      child: CustomCards(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home_repair_service,color: AppColors.greenColor,size: 22,),
                      SizedBox(width: 2.w),
                      CustomText(
                        text: suspensionNumber,
                        style: basicColorBold(16, AppColors.greenColor),
                      ),
                    ],
                  ),
                  viewDetail(context, (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceSuspensionDetails(id:suspension.id.toString())));
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
              unitDetailRow("Subject:", subject.toTitleCase(), null),
              unitDetailRow("Agent:", agent, null),
              unitDetailRow("Suspension Type:", type.toTitleCase(), null),
              unitDetailRow("Elapsed Time:", elapsedTime!="N/A"?elapsedTime:"No Time Limit", null),
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