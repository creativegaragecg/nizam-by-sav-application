import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/models/myBookings.dart';
import 'package:savvyions/providers/amenities_provider.dart';
import 'package:savvyions/screens/Amenities/updateAmenity.dart';
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

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchBookings();
    });
  }

  Future<void> fetchBookings() async {
    Provider.of<AmenitiesViewModel>(
      context,
      listen: false,
    ).fetchAmenitiesBookings(context);
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
                  text: "Bookings",
                  style: basicColorBold(18, Colors.black),
                ),

              ],
            ),

            customHeaderLine(context),

            SizedBox(height: 3.5.h),
            Consumer<AmenitiesViewModel>(
              builder: (context, value, child) {
                var list=value.bookings?.data??[];
                // Assuming your LeaseViewModel has a list like: List<Lease> leases
                if(value.loading){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }
                if (list.isEmpty) {
                  return const Center(child: Text("No bookings available yet"));
                }


                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // or EdgeInsets.all(16) as needed
                    itemCount:list.length,
                    itemBuilder: (context, index) {
                      final booking = list[index];
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: 0.6.h),
                        child: bookingDetails(booking),
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
  Widget bookingDetails(Booking data) {
    String amenityName=data.amenityName??"N/A";
    String bookingDate=data.bookingDate.toString()??"N/A";

    bookingDate=dateConverted(bookingDate);
    String bookingTime=data.bookingTime.toString()??"N/A";
    bookingTime=bookingTime.to12HourFormat();
    String persons=data.persons.toString()??"";
    String bookingType=data.bookingType??"";



    return CustomCards(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),

        child: Column(
          mainAxisSize:
          MainAxisSize.min, // ADD THIS - makes column shrink to content

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [



            unitDetailRow("Amenity Name", amenityName.toTitleCase(), null),
            unitDetailRow("Booking Date", bookingDate, null),
            unitDetailRow("Booking Time", bookingTime, null),
            unitDetailRow("Persons", persons, null),
            unitDetailRow("Booking Type", bookingType.toTitleCase(), null),

           /* GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateAmenity(booking: data,)));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(text: "Update", style: basicColor(16, AppColors.greenColor))
                ],
              ),
            )*/



          ],
        ),
      ),
    );
  }




}
