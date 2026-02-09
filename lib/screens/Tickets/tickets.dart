import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/models/tickets.dart';
import 'package:savvyions/providers/ticket_provider.dart';
import 'package:savvyions/screens/Tickets/addTickets.dart';
import 'package:savvyions/screens/Tickets/ticketDetails.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';


class Tickets extends StatefulWidget {
  const Tickets({super.key, required this.role});
  final String role;

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  final Map<int, bool> _expandedStates = {};
  bool _showResolvedOnly = false; // Add filter state

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await fetchTickets();
      _expandIfSingleTicket(); // Auto-expand if only one ticket
    });
  }

  // Auto-expand the only ticket if list has exactly one item
  void _expandIfSingleTicket() {
    final tickets = Provider.of<TicketsViewModel>(context, listen: false)
        .ticketsModel
        ?.data
        ?.tickets;

    if (tickets != null && tickets.length == 1) {
      final ticketId = tickets.first.id;
      if (ticketId != null) {
        setState(() {
          _expandedStates[ticketId] = true;
        });
      }
    }
  }

  // Helper to get expand/collapse a specific ticket
  void _toggleExpand(int ticketId) {
    setState(() {
      _expandedStates[ticketId] = !(_expandedStates[ticketId] ?? false);
    });
  }

  bool _isExpanded(int ticketId) => _expandedStates[ticketId] ?? false;

  Future<void> fetchTickets() async {
    Provider.of<TicketsViewModel>(
      context,
      listen: false,
    ).fetchTickets(context);
  }


  // Filter tickets based on resolved status
  List<Ticket> _getFilteredTickets(List<Ticket> tickets) {
    if (_showResolvedOnly) {
      return tickets.where((ticket) =>
      ticket.status?.toLowerCase().trim() == 'resolved'
      ).toList();
    }
    return tickets;
  }


  Map<String, int> getStatistics(Statistics? statistics) {
    if (statistics == null) {
      return {
        'total': 0,
        'open': 0,
        'pending': 0,
        'resolved': 0,
        'closed': 0
      };
    }

    return {
      'total': statistics.total ?? 0,
      'open': statistics.open ?? 0,
      'pending': statistics.pending ?? 0,
      'resolved': statistics.resolved ?? 0,
      'closed': statistics.closed ?? 0
    };
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
                      text: "Tickets",
                      style: basicColorBold(18, Colors.black),
                    ),

                  ],
                ),

                Row(
                  //  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTicket(role: widget.role,)));

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
                    SizedBox(width: 2.w,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _showResolvedOnly = !_showResolvedOnly;
                        });
                      },
                      child: Container(
                        height: 4.h,
                        width:26.w,
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
                        decoration: BoxDecoration(
                          color: _showResolvedOnly
                              ? AppColors.greenColor
                              : AppColors.greenColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              color: _showResolvedOnly
                                  ? Colors.white
                                  : AppColors.greenColor,
                              size: 18,
                            ),
                            SizedBox(width: 1.w,),
                            CustomText(
                              text: "Resolved",
                              style: basicColorBold(
                                  15,
                                  _showResolvedOnly
                                      ? Colors.white
                                      : AppColors.greenColor
                              ),
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
            Consumer<TicketsViewModel>(
              builder: (context, ticketModel, child) {
                var tickets=ticketModel.ticketsModel?.data?.tickets??[];
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(ticketModel.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }


                // Apply filter
                var filteredTickets = _getFilteredTickets(tickets);

                if (filteredTickets.isEmpty) {
                  return Center(
                      child: Text(
                          _showResolvedOnly
                              ? "No resolved tickets found"
                              : "No tickets created yet"
                      )
                  );
                }
                Map<String, int> stats = getStatistics(ticketModel.ticketsModel?.data?.statistics);

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
                              label: "Total Tickets",
                              count: stats['total']!,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 2.w),
                            buildStatCard(
                              icon: Icons.upload_file,
                              label: "Closed Tickets",
                              count: stats['closed']!,
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
                              label: "Open Tickets",
                              count: stats['open']!,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 2.w),
                            buildStatCard(
                              icon: Icons.restore,
                              label: "Pending Tickets",
                              count: stats['pending']!,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),

                      buildStatCard(
                        icon: Icons.done_all,
                        label: "Resolved Tickets",
                        count: stats['resolved']!,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 2.h),


                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                          itemCount: filteredTickets.length,
                          itemBuilder: (context, index) {
                            final ticket = filteredTickets[index];
                            return Padding(
                              padding: EdgeInsetsGeometry.symmetric(vertical: 0.5.h),
                                child: ticketDetails(ticket)); // Pass data to your widget
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
  Widget ticketDetails(Ticket ticket) {
    String ticketNo = ticket.id.toString();
    String ticketNumber = ticket.ticketNumber.toString();
    String status = ticket.status ?? "N/A";
    String agent = ticket.agent?.name ?? "N/A";
  //  String detail = ticket.d ?? "N/A";
    String subject = ticket.subject ?? "N/A";
    String ticketType = ticket.ticketType?.typeName ?? "N/A";
    bool isExpanded = _isExpanded(ticket.id ?? 0);

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {
        case 'open':
          return Colors.blue;
        case 'pending':
          return Colors.orange;
        case 'resolved':
          return Colors.green;
        case 'closed':
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
            builder: (context) => TicketDetails(ticketId: ticketNo),
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
              onTap: () => _toggleExpand(ticket.id ?? 0),
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.greenColor,
                      AppColors.greenColor.withOpacity(0.6),
                      Colors.white],


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
                          text: ticketNumber,
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
                                ///   border: Border.all(color: Colors.white.withOpacity(0.5)),
                                border: Border.all(color: AppColors.white),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: status.toTitleCase(),
                                  style: basicColorBold(15, AppColors.white),
                                  //   style: basicColorBold(15, Colors.white),
                                ),
                              ),
                            ),
                          ),
                        if (isExpanded)
                          viewDetail(context, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TicketDetails(ticketId: ticketNo),
                              ),
                            );
                          }),
                          SizedBox(width: 3.w),


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
                    unitDetailRow("Subject:", subject.toTitleCase(), null),
                    unitDetailRow("Ticket Type:", ticketType, null),
                    unitDetailRow("Agent Name:", agent, null),
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
}
