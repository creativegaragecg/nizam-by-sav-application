import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/models/tickets.dart';
import 'package:savvyions/providers/gatePass_provider.dart';
import 'package:savvyions/providers/ticket_provider.dart';
import 'package:savvyions/providers/visitor_provider.dart';
import 'package:savvyions/screens/GatePassRequests/addGatePass.dart';
import 'package:savvyions/screens/GatePassRequests/gatePassDetails.dart';
import 'package:savvyions/screens/Visitor/addVisitor.dart';
import 'package:savvyions/screens/Visitor/visitorDetail.dart';
import 'package:savvyions/screens/Tickets/ticketDetails.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/gatepassrequests.dart';
import '../../models/visitor.dart';


class Visitors extends StatefulWidget {
  const Visitors({super.key});

  @override
  State<Visitors> createState() => _VisitorsState();
}

class _VisitorsState extends State<Visitors> {
  final Map<int, bool> _expandedStates = {};
  bool _showAll = false; // Track whether to show all visitors or only recent ones

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchVisitors();
      _expandIfSingleTicket(); // Auto-expand if only one ticket
    });
  }

  // Auto-expand the only ticket if list has exactly one item
  void _expandIfSingleTicket() {
    final visitorList = Provider.of<VisitorViewModel>(context, listen: false)
        .visitorModel
        ?.data
        ?.visitors;

    if (visitorList != null && visitorList.length == 1) {
      final visitorId = visitorList.first.id;
      if (visitorId != null) {
        setState(() {
          _expandedStates[visitorId] = true;
        });
      }
    }
  }

  // Filter visitors based on _showAll flag
  List<Visitor> _getFilteredVisitors(List<Visitor> allVisitors) {
    if (_showAll) {
      return allVisitors; // Show all visitors
    }

    // Only show visitors from the last 24 hours
    DateTime now = DateTime.now();
    DateTime oneDayAgo = now.subtract(Duration(days: 1));

    return allVisitors.where((visitor) {
      try {
        // Parse the date of visit
        if (visitor.dateOfVisit != null) {
          DateTime visitDate = DateTime.parse(visitor.dateOfVisit.toString());
          return visitDate.isAfter(oneDayAgo);
        }
        // If no date, include it to be safe
        return true;
      } catch (e) {
        print('Error parsing date for visitor ${visitor.id}: $e');
        return true; // Include if parsing fails
      }
    }).toList();
  }

  // Helper to get expand/collapse a specific ticket
  void _toggleExpand(int id) {
    setState(() {
      _expandedStates[id] = !(_expandedStates[id] ?? false);
    });
  }

  bool _isExpanded(int id) => _expandedStates[id] ?? false;

  Future<void> fetchVisitors() async {
    Provider.of<VisitorViewModel>(
      context,
      listen: false,
    ).fetchVisitors(context);
  }




  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      text: "Visitors",
                      style: basicColorBold(18, Colors.black),
                    ),

                  ],
                ),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVisitor()));

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
              ],
            ),
            SizedBox(height: 1.5.h,),
            Container(
              height: 0.1.h,
              width: 100.w,
              color: AppColors.greenColor,
            ),
            SizedBox(height:3.h),
            Consumer<VisitorViewModel>(
              builder: (context,value, child) {
                var allVisitors = value.visitorModel?.data?.visitors ?? [];
                var data = value.visitorModel?.data?.qrData ?? [];
                var visitorList = _getFilteredVisitors(allVisitors);
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(value.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }

                if (visitorList.isEmpty) {
                  return Center(
                      child: Text(
                        _showAll
                            ? "No visitors yet"
                            : "No recent visitors (last 24 hours)",
                        style: basicColor(16, Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount: visitorList.length,
                    itemBuilder: (context, index) {
                      final visitor = visitorList[index];
                      return Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 0.5.h),
                          child: visitorDetails(visitor,data)); // Pass data to your widget
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


  Widget visitorDetails(Visitor visitor,var data) {
    int id = visitor.id ?? 0;
    String refNo = visitor.refNo ?? "N/A";
    String cnic = visitor.cnic?.toString() ?? "N/A";
    String visitorName = visitor.visitorName ?? "N/A";
    String mobileNo = visitor.phoneNumber ?? "N/A";
    String unitNo = visitor.apartment?.apartmentNumber ?? "N/A";

    String dateOfVisit = visitor.dateOfVisit?.toString() ?? "N/A";
    dateOfVisit=formatDateTime(dateOfVisit);
    String dateOfExist = visitor.dateOfExit?.toString() ?? "N/A";
    dateOfExist=formatDateTime(dateOfExist);
    String inTime = visitor.inTime ?? "N/A";
    inTime=inTime.to12HourFormat();
    String outTime = visitor.outTime ?? "N/A";
    outTime=outTime.to12HourFormat();
    String status = visitor.status ?? "N/A";
    String floorName = visitor.apartment?.floors?.floorName ?? "N/A";
    String towerName = visitor.apartment?.towers?.towerName ?? "N/A";
    bool isExpanded = _isExpanded(id);

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {
        case 'allow':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        case 'deny':
          return Colors.red;
        default:
          return Colors.black45;
      }
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitorDetails(
              visitorName: visitorName,
              ref: refNo,
              unitNo: unitNo,
              inTime: inTime,
              outTime: outTime,
              visitDate: dateOfVisit,
              exitDate: dateOfExist,
              visitPurpose: visitor.purposeOfVisit ?? "N/A",
              visitType: visitor.visitorType?.name ?? "N/A",
              visitAddress: visitor.address ?? "N/A",
              contactNumber: mobileNo,
              status: status,
              floorName: floorName,
              towerName: towerName,
              cnic: cnic,
              data: data,
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
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sticky_note_2, color: Colors.white, size: 22),
                        SizedBox(width: 2.w),
                        CustomText(
                          text: refNo,
                          style: basicColorBold(16, Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        /// status
                        if (!isExpanded)
                          IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.4.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.white),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: status.toTitleCase(),
                                  style: basicColorBold(15, AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        if (isExpanded)
                          viewDetail(context, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VisitorDetails(
                                  visitorName: visitorName,
                                  ref: refNo,
                                  unitNo: unitNo,
                                  inTime: inTime,
                                  outTime: outTime,
                                  visitDate: dateOfVisit,
                                  exitDate: dateOfExist,
                                  visitPurpose: visitor.purposeOfVisit ?? "N/A",
                                  visitType: visitor.visitorType?.name ?? "N/A",
                                  visitAddress: visitor.address ?? "N/A",
                                  contactNumber: mobileNo,
                                  status: status,
                                  floorName: floorName,
                                  towerName: towerName,
                                  cnic: cnic,
                                  data: data,
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
                    unitDetailRow("Visitor Name:", visitorName.toTitleCase(), null),
                    unitDetailRow("Mobile No:", mobileNo, null),
                    unitDetailRow("CNIC:", cnic, null),
                    unitDetailRow("Unit No:", unitNo, null),
                    unitDetailRow("Date of Visit:", dateOfVisit, null),
                    unitDetailRow("Date of Exist:", dateOfExist, null),
                    unitDetailRow("In Time:", inTime, null),
                    unitDetailRow("Out Time:", outTime, null),
                    SizedBox(height: 1.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IntrinsicWidth(
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
  Widget visitorDetails(Visitor visitor) {
    int id =visitor.id??0;
    String refNo =visitor.refNo??"N/A";
    String visitorName = visitor.visitorName?? "N/A";
    String mobileNo = visitor.phoneNumber?? "N/A";
    String unitNo = visitor.apartment?.apartmentNumber ?? "N/A";

    String dateOfVisit = visitor.dateOfVisit?.toString() ?? "N/A";
    String dateOfExist = visitor.dateOfExit?.toString() ?? "N/A";
    String inTime = visitor.inTime ?? "N/A";
    String outTime = visitor.outTime ?? "N/A";
    String status = visitor.status ?? "N/A";
    bool isExpanded = _isExpanded(id);

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {
        case 'allow':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        case 'deny':
          return Colors.red;
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
                  Row(
                    children: [
                      Icon(Icons.sticky_note_2, color: AppColors.greenColor, size: 22),
                      SizedBox(width: 2.w),
                      CustomText(
                        text: refNo,
                        style: basicColorBold(16, AppColors.greenColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if(!isExpanded)
                        SizedBox(width: 5.w,),
                      /// status
                      if(!isExpanded)
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

                    unitDetailRow("Visitor Name:",visitorName, null),
                    unitDetailRow("Mobile No:", mobileNo, null),
                    unitDetailRow("Unit No:",unitNo, null),
                    unitDetailRow("Date of Visit:", dateOfVisit, null),
                    unitDetailRow("Date of Exist:", dateOfExist, null),
                    unitDetailRow("In Time:", inTime, null),
                    unitDetailRow("Out Time:", outTime, null),
                    SizedBox(height: 1.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:
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
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>VisitorDetails(visitorName: visitorName, ref: refNo, unitNo: unitNo, inTime: inTime, outTime: outTime, visitDate: dateOfVisit, exitDate: dateOfExist, visitPurpose: visitor.purposeOfVisit??"N/A", visitType: visitor.visitorType?.name??"N/A", visitAddress:visitor.address??"N/A", contactNumber: mobileNo, status: status,)));
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
