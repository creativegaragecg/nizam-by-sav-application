import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/models/tickets.dart';
import 'package:savvyions/providers/gatePass_provider.dart';
import 'package:savvyions/providers/ticket_provider.dart';
import 'package:savvyions/screens/GatePassRequests/addGatePass.dart';
import 'package:savvyions/screens/GatePassRequests/gatePassDetails.dart';
import 'package:savvyions/screens/Tickets/ticketDetails.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/gatepassrequests.dart';


class GatePassRequests extends StatefulWidget {
  const GatePassRequests({super.key});

  @override
  State<GatePassRequests> createState() => _GatePassRequestsState();
}

class _GatePassRequestsState extends State<GatePassRequests> {
  final Map<int, bool> _expandedStates = {};
  bool _showAll = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchGatePass();
      _expandIfSingleTicket(); // Auto-expand if only one ticket
    });
  }

  // Auto-expand the only ticket if list has exactly one item
  void _expandIfSingleTicket() {
    final gatepass = Provider.of<GatePassViewModel>(context, listen: false)
        .gatePassRequestModel
        ?.data
        ?.gatePassRequests;

    if (gatepass != null && gatepass.length == 1) {
      final gatePassId = gatepass.first.id;
      if (gatePassId != null) {
        setState(() {
          _expandedStates[gatePassId] = true;
        });
      }
    }
  }

  // Helper to get expand/collapse a specific ticket
  void _toggleExpand(int id) {
    setState(() {
      _expandedStates[id] = !(_expandedStates[id] ?? false);
    });
  }

  bool _isExpanded(int id) => _expandedStates[id] ?? false;

  Future<void> fetchGatePass() async {
    Provider.of<GatePassViewModel>(
      context,
      listen: false,
    ).fetchGatePass(context);
  }

  List<GatePassRequest> _getFilteredGatePass(List<GatePassRequest> allGatePasses) {
    if (_showAll) {
      return allGatePasses;
    }

    DateTime now = DateTime.now();
    DateTime oneDayAgo = now.subtract(Duration(days: 1));

    return allGatePasses.where((gatePass) {
      try {
        // Parse the date of visit
        if (gatePass.expectedOutTime != null) {
          DateTime visitDate = DateTime.parse(gatePass.expectedOutTime.toString());
          return visitDate.isAfter(oneDayAgo);
        }
        // If no date, include it to be safe
        return true;
      } catch (e) {
        print('Error parsing date for gatePass ${gatePass.id}: $e');
        return true; // Include if parsing fails
      }
    }).toList();
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
                  text: "Gate Pass Request",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _showAll = !_showAll; // Toggle between all and recent
                        });
                      },
                      child: IntrinsicWidth(
                        child: Container(
                          height: 4.h,
                          padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
                          decoration: BoxDecoration(
                            color: _showAll
                                ? AppColors.greenColor
                                : AppColors.greenColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _showAll ? Icons.visibility_off : Icons.remove_red_eye_outlined,
                                color: _showAll ? Colors.white : AppColors.greenColor,
                                size: 16,
                              ),
                              SizedBox(width: 1.w,),
                              CustomText(
                                text: _showAll ? "Recent only" : "View all",
                                style: basicColorBold(
                                  15,
                                  _showAll ? Colors.white : AppColors.greenColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 3.w,),


                    GestureDetector(
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>AddGatePass()));

                      },
                      child: Container(
                        height: 4.h,
                        width:17.w,
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
                        decoration: BoxDecoration(
                          color: AppColors.greenColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,color: AppColors.greenColor,size: 20,),

                            CustomText(
                              text: "Add",
                              style: basicColorBold(15,AppColors.greenColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 1.5.h,),


            Container(
              height: 0.1.h,
              width: 100.w,
              color: AppColors.greenColor,
            ),
            SizedBox(height:3.h),
            Consumer<GatePassViewModel>(
              builder: (context,gatePassModel, child) {
                var allGatePassList=gatePassModel.gatePassRequestModel?.data?.gatePassRequests??[];
                var gatePassList = _getFilteredGatePass(allGatePassList);

                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(gatePassModel.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }

                if (gatePassList.isEmpty) {
                  return Center(
                      child:Text(
                        _showAll
                            ? "No gate pass request created yet"
                            : "No recent gate pass request (last 24 hours)",
                        style: basicColor(16, Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount: gatePassList.length,
                    itemBuilder: (context, index) {
                      final gatePass = gatePassList[index];
                      return Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 0.5.h),
                          child: gatePassDetails(gatePass)); // Pass data to your widget
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
  Widget gatePassDetails(GatePassRequest gatePass) {
    int id = gatePass.id ?? 0;
    String passNo = gatePass.passNumber ?? "N/A";
    String refNo = gatePass.tenant?.refNo ?? "N/A";
    String name = gatePass.tenant?.user?.name ?? "N/A";
    String item = gatePass.item ?? "N/A";
    String passType = gatePass.passType ?? "N/A";
    String returnStatus = gatePass.returnStatus ?? "N/A";
    String expectedTime = gatePass.expectedOutTime.toString() ?? "N/A";
    expectedTime=formatDateTime(expectedTime);
    print("date :$expectedTime");
    bool isExpanded = _isExpanded(id);

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {
        case 'returned':
          return Colors.blue;
        case 'not returned':
          return Colors.orange;
        case 'expired':
          return Colors.red;
        case 'outgoing':
          return Colors.grey;
        default:
          return Colors.black45;
      }
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GatePassDetails(
              gatePassRequest: gatePass,
              tenant: "$refNo-$name",
            ),
          ),
        );
      },
      child: CustomCards(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Gradient Background (Green to White)
            GestureDetector(
              onTap: () => _toggleExpand(id),
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.greenColor,
                      AppColors.greenColor.withOpacity(0.6),
                      Colors.white
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sticky_note_2, color: Colors.white, size: 20),
                        SizedBox(width: 1.w),
                        CustomText(
                          text: passNo,
                          style: basicColorBold(15, Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        /// status badge when collapsed
                        if (!isExpanded)
                          IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.3.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.white),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: returnStatus.toTitleCase(),
                                  style: basicColorBold(14.5, AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        if (isExpanded)
                          viewDetail(context, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GatePassDetails(
                                  gatePassRequest: gatePass,
                                  tenant: "$refNo-$name",
                                ),
                              ),
                            );
                          }),
                          SizedBox(width: 2.w),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            if (isExpanded)
              Container(
                height: 0.2.h,
                width: 100.w,
                color: AppColors.cardBorderColor,
              ),

            // Expandable Details Section
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    unitDetailRow("Tenant:", "$refNo-$name", null),
                    unitDetailRow("Item:", item, null),
                    unitDetailRow("Pass Type:", passType.toTitleCase(), null),
                    unitDetailRow("Expected Out Time:", expectedTime, null),
                    SizedBox(height: 1.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                          decoration: BoxDecoration(
                            color: getStatusColor(returnStatus).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CustomText(
                              text: returnStatus.toTitleCase(),
                              style: basicColorBold(15, getStatusColor(returnStatus)),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
/*
  Widget gatePassDetails(GatePassRequest gatePass) {
    int id =gatePass.id??0;
    String passNo =gatePass.passNumber??"N/A";
    String refNo = gatePass.tenant?.refNo?? "N/A";
    String name = gatePass.tenant?.user?.name?? "N/A";
    String item = gatePass.item ?? "N/A";
    String passType = gatePass.passType ?? "N/A";
    String returnStatus = gatePass.returnStatus ?? "N/A";

    String expectedTime = gatePass.expectedOutTime.toString() ?? "N/A";
    bool isExpanded = _isExpanded(id);

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {
        case 'returned':
          return Colors.blue;
        case 'not returned':
          return Colors.orange;
        case 'expired':
          return Colors.red;
        case 'outgoing':
          return Colors.grey;
        default:
          return Colors.black45;
      }
    }

    return CustomCards(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Ticket ID and Expandable Arrow
            GestureDetector(
              onTap: () => _toggleExpand(id),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sticky_note_2, color: AppColors.greenColor, size: 22),
                          SizedBox(width: 2.w),
                          CustomText(
                            text: passNo,
                            style: basicColorBold(16, AppColors.greenColor),
                          ),
                        ],
                      ),

                      if(!isExpanded)
                        SizedBox(height: 1.h,),
                      /// status
                      if(!isExpanded)
                        IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                            decoration: BoxDecoration(
                              color: getStatusColor(returnStatus).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: CustomText(
                                text: returnStatus.toTitleCase(),
                                style: basicColorBold(15, getStatusColor(returnStatus)),
                              ),
                            ),
                          ),
                        ),


                    ],
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0, // 180° when expanded
                    duration: Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: AppColors.hintText,
                    ),
                  ),
                ],
              ),
            ),



            // Expandable Details Section
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: (isExpanded ?? false)
                  ? Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    // Divider
                    Container(
                      height: 0.2.h,
                      width: 100.w,
                      color: AppColors.cardBorderColor,
                    ),
                    SizedBox(height: 0.5.h),

                    unitDetailRow("Tenant:", "${refNo}-$name", null),
                    unitDetailRow("Item:", item, null),
                    unitDetailRow("Pass Type:", passType.toTitleCase(), null),
                    unitDetailRow("Expected Out Time:", expectedTime, null),
                    SizedBox(height: 1.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:
                      IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                          decoration: BoxDecoration(
                            color: getStatusColor(returnStatus).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CustomText(
                              text: returnStatus.toTitleCase(),
                              style: basicColorBold(15, getStatusColor(returnStatus)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>GatePassDetails(gatePassRequest: gatePass,tenant: "$refNo-$name",)));
                      },
                      child: Align(
                        alignment: AlignmentGeometry.bottomRight,
                        child: CustomText(
                          text: "Detail",
                          style: TextStyle(fontFamily: "Ubuntu",fontSize: 15.5.sp,color: AppColors.greenColor,decoration: TextDecoration.underline,decorationColor: AppColors.greenColor),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : SizedBox.shrink(), // Hide completely when collapsed
            ),
          ],
        ),
      ),
    );
  }
*/

}
