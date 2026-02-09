import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/customWhiteBg.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/providers/amenities_provider.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';

import '../../Utils/Custom/custom_text.dart';

class BookAmenity extends StatefulWidget {
  final int amenityId;
  final String maxPersons;// Pass this from previous screen
  const BookAmenity({super.key, required this.amenityId, required this.maxPersons,});

  @override
  State<BookAmenity> createState() => _BookAmenityState();
}

class _BookAmenityState extends State<BookAmenity> {
  DateTime? selectedDate;
  String? selectedTimeSlot;
  String? selectedBookingType;
  TextEditingController personsController = TextEditingController();
  bool isLoadingSlots = false;

  List<String> bookingTypes = ["Single", "Multiple"];
  late int maxPersonsInt; // To store parsed max persons


  @override
  void initState() {
    super.initState();
    // Parse maxPersons safely
    maxPersonsInt = int.tryParse(widget.maxPersons) ?? 1; // default to 1 if parsing fails
  }


  @override
  void dispose() {
    personsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomWhiteBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                ),
                SizedBox(width: 3.w),
                CustomText(
                  text: "Book Amenity",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),

            customHeaderLine(context),
            SizedBox(height: 3.h),

            // Booking Date Field
            Row(
              children: [
                CustomText(
                  text: "Booking Date",
                  style: basicColorBold(15, Colors.black87),
                ),
                CustomText(
                  text: "*",
                  style: basicColor(15, Colors.red),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300,width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: selectedDate != null
                          ? '${selectedDate!.day} ${_getMonthName(selectedDate!.month)} ${selectedDate!.year}'
                          : 'Booking Date',
                      style: basicColor(14.5, selectedDate != null ? Colors.black : Colors.grey),
                    ),

                    Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Number of Persons TextField
            Row(
              children: [
                CustomText(
                  text: "Number of Persons",
                  style: basicColorBold(15, Colors.black87),
                ), CustomText(
                  text: "*",
                  style: basicColor(15, Colors.red),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            TextField(
              controller: personsController,
              keyboardType: TextInputType.number,
              style: basicColor(14.5, Colors.black),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: "Enter number of persons",
                hintStyle: basicColor(14.5, Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey.shade300,width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey.shade300,width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            SizedBox(height: 2.h),


            buildLabelWithDropDown(context, "Booking Type", "Select booking type", bookingTypes, selectedBookingType,  (String? newValue) {
              setState(() {
                selectedBookingType = newValue;
              });
              print('Selected Status: $newValue');
            },),


            SizedBox(height: 2.h),


            // Booking Time Section
            if (selectedDate != null) ...[
              CustomText(
                text: "Booking Time",
                style: basicColor(15, Colors.black87),
              ),


              SizedBox(height: 1.h),



              Expanded(
                child: Consumer<AmenitiesViewModel>(
                  builder: (BuildContext context, AmenitiesViewModel value, Widget? child) {
                    var slotsData = value.availableSlots?.data ?? [];

                    if (value.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.greenColor,
                        ),
                      );
                    } else if (slotsData.isEmpty) {
                      return Center(
                        child: CustomText(
                          text: "No available slots for this date",
                          style: basicColor(14, Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 1.h,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: slotsData.length,
                      itemBuilder: (context, index) {
                        final slotItem = slotsData[index];
                        final formattedTime = slotItem.formattedTime ?? slotItem.time ?? "";
                        final isDisabled = slotItem.isDisabled ?? false;
                        final isSelected = selectedTimeSlot == slotItem.time;

                        return GestureDetector(
                          onTap: isDisabled ? null : () {
                            setState(() {
                              selectedTimeSlot = slotItem.time;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDisabled
                                  ? Colors.grey.shade200
                                  : (isSelected ? Colors.blue : Colors.white),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isDisabled
                                    ? Colors.grey.shade300
                                    : (isSelected ? Colors.blue : Colors.grey.shade300),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: formattedTime,
                                  style: basicColor(
                                      14,
                                      isDisabled
                                          ? Colors.grey
                                          : (isSelected ? Colors.white : Colors.black87)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],



            SizedBox(height: 2.h),

            // Save and Cancel Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  width: 20.w,
                  color: AppColors.greenColor,
                  text: "Book",
                  style: basicColorBold(15, Colors.white),
                  onPressedCallback: () {
                    // Validation
                    if (selectedDate == null) {
                      showToast("Please select a booking date");
                      return;
                    }
                    if (selectedTimeSlot == null) {
                      showToast("Please select a time slot");
                      return;
                    }
                    if (selectedBookingType == null) {
                      showToast("Please select a booking type");
                      return;
                    }
                    if (personsController.text.trim().isEmpty) {
                      showToast("Please enter number of persons");
                      return;
                    }

                    int enteredPersons = int.tryParse(personsController.text.trim()) ?? 0;

                    if (enteredPersons <= 0) {
                      showToast("Number of persons must be greater than 0");
                      return;
                    }

                    if (enteredPersons > maxPersonsInt) {
                      showToast("Maximum allowed persons: $maxPersonsInt");
                      return;
                    }

                    // All validations passed
                    _bookAmenity();
                  },
                ),
                SizedBox(width: 4.w),
                CustomButton(
                  width: 20.w,
                  color: AppColors.white,
                  text: "Cancel",
                  style: basicColorBold(15, Colors.black),
                  onPressedCallback: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTimeSlot = null;
      });
      _fetchAvailableSlots();
    }
  }

  Future<void> _fetchAvailableSlots() async {
    setState(() {
      isLoadingSlots = true;
    });

    try {
      if(selectedDate!=null){
        String formattedDate = '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
        var data= {
          "amenity_id": widget.amenityId,
          "booking_date":formattedDate
        };
        Provider.of<AmenitiesViewModel>(context, listen: false).fetchSlots(context,widget.amenityId.toString(),data);
      }
      else{
        showToast("Select Date");
      }

      await Future.delayed(Duration(seconds: 1));
      setState(() {
        isLoadingSlots = false;
      });
    } catch (e) {
      setState(() {
        isLoadingSlots = false;
      });
      showToast("Failed to fetch available slots");
    }
  }

  Future<void> _bookAmenity() async {
    String formattedDate = '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';

    var list=[];
    list.add(selectedTimeSlot);
    var data = {
      "amenity_id": widget.amenityId,
      "booking_date": formattedDate,
      "booking_time": list,
      "persons": int.parse(personsController.text.trim()),
      "booking_type": selectedBookingType?.toLowerCase(), // "single" or "multiple"
    };

    debugPrint('Booking amenity with data: $data');

    // Call your booking API
     await Provider.of<AmenitiesViewModel>(context, listen: false).bookAmenity(data, context);
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}