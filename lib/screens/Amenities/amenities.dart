import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/providers/amenities_provider.dart';
import 'package:savvyions/screens/Amenities/bookAmenity.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/images.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import '../../models/amenities.dart';
import '../../models/mylease.dart';
import '../../providers/lease_provider.dart';

class Amenities extends StatefulWidget {
  const Amenities({super.key});

  @override
  State<Amenities> createState() => _AmenitiesState();
}

class _AmenitiesState extends State<Amenities> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchAmenities();
    });
  }

  Future<void> fetchAmenities() async {
    Provider.of<AmenitiesViewModel>(
      context,
      listen: false,
    ).fetchAmenities(context);
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
                  text: "Amenities",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),
            Consumer<AmenitiesViewModel>(
              builder: (context, value, child) {
                var list=value.amenitiesModel?.data??[];
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(value.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (list.isEmpty) {
                  return const Center(child: Text("No amenities available yet"));
                }


                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount:list.length,
                    itemBuilder: (context, index) {
                      final amenities = list[index];
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: 0.6.h),
                        child: amenitiesDetails(amenities),
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
  Widget amenitiesDetails(Datum data) {
    String amenityName=data.amenitiesName??"N/A";
    String amenityStatus=data.status??"N/A";
    amenityStatus=amenityStatus=="not_available"?"Not Available":"Available";
    bool bookingRequired=data.bookingStatus??true;
    String toBook=bookingRequired?"Yes":"No";
    String slotTiming=data.slotTime.toString();
    String startTime=data.startTime.toString();
    String endTime=data.endTime.toString();

    String formattedStart = startTime.to12HourFormat(); // "4:00 AM"
    String formattedEnd = endTime.to12HourFormat();     // "6:00 PM"

    String timeRange = '$formattedStart - $formattedEnd'; // "4:0
    bool multipleBooking=data.multipleBookingStatus??false;
    String multipleBookings=multipleBooking?"Available":"Not Available";
    String maxPersons=data.numberOfPerson.toString();

    Color getStatusColor(String status) {
      switch (status.toLowerCase().trim()) {

        case 'available':
          return Colors.green;
        case 'not available':
          return Colors.red;
        default:
          return Colors.grey;
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

            if(bookingRequired)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>BookAmenity(amenityId: data.id??0,maxPersons: maxPersons,)));
                    },
                    child: Padding(
                      padding:  EdgeInsets.only(right: 2.w),
                      child: CustomText(
                        text: "Book",
                        style: TextStyle(fontFamily: "Ubuntu",fontSize: 16.sp,color: AppColors.greenColor,decoration: TextDecoration.underline,decorationColor: AppColors.greenColor),
                      ),
                    ),
                  ),
                ],
              ),

            if(bookingRequired)

              SizedBox(height: 0.5.h),

            unitDetailRow("Amenity Name", amenityName.toTitleCase(), null),
            unitDetailRow("Booking Required", toBook, null),
            if(slotTiming!="null")
            unitDetailRow("Slot Timing:", "$timeRange\n Slot Time: $slotTiming", null),
            if(slotTiming=="null")
              unitDetailRow("Slot Timing:", "-", null),

            if(multipleBookings=="Not Available")
            unitDetailRow("Multiple Booking Allowed:", multipleBookings, null),

             if(multipleBookings!="Not Available")
            unitDetailRow("Multiple Booking Allowed:", "$multipleBookings\nMaximum Person: $maxPersons", null),





            SizedBox(height: 1.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                    decoration: BoxDecoration(
                      color: getStatusColor(amenityStatus).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomText(
                        text: amenityStatus.toTitleCase(),
                        style: basicColorBold(15, getStatusColor(amenityStatus)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }




}
