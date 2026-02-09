import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/events.dart';
import 'package:savvyions/providers/events_provider.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';



class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchEvents();
    });
  }

  Future<void> fetchEvents() async {
    Provider.of<EventsViewModel>(
      context,
      listen: false,
    ).fetchEvents(context);
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
                  text: "Events",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),
            Consumer<EventsViewModel>(
              builder: (context, eventsViewModel, child) {
                var eventsList=eventsViewModel.eventsModel?.data?.events??[];
                if(eventsViewModel.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (eventsList.isEmpty) {
                  return const Center(child: Text("No events available"));
                }


                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount:eventsList.length,
                    itemBuilder: (context, index) {
                      final event = eventsList[index];
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: 0.5.h),
                        child: eventDetails(event),
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
  Widget eventDetails(Event event) {
    String eventName=event.eventName??"N/A";
    String eventLocation=event.where??"N/A";
    String desc=event.description??"N/A";
    String startDate=event.startDateTime?.toString()??"N/A";
    startDate=formatDateTime(startDate);
    String endDate=event.endDateTime?.toString()??"N/A";
    endDate=formatDateTime(endDate);
    String status=event.status??"N/A";

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {

        case 'pending':
          return Colors.orange;
        case 'completed':
          return Colors.green;
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.black45;
      }
    }


    return CustomCards(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),

        child: Column(
          mainAxisSize:
          MainAxisSize.min, // ADD THIS - makes column shrink to content

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event,color: AppColors.greenColor,size: 22,),
                SizedBox(width: 2.w),
                CustomText(
                  text: eventName.toTitleCase(),
                  style: basicColorBold(16, AppColors.greenColor),
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
            unitDetailRow("Event Location:", eventLocation.toTitleCase(), null),
            unitDetailRow("Start Date:", startDate, null),
            unitDetailRow("End Date:", endDate, null),
            unitDetailRow("Description:", desc.toTitleCase(), null),
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

          ],
        ),
      ),
    );
  }




}
