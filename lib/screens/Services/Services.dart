import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/services.dart';
import 'package:savvyions/providers/services_provider.dart';
import 'package:savvyions/screens/Services/serviceDetails.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchServiceTypes();
    });
  }

  Future<void> fetchServiceTypes() async {
    await Provider.of<ServicesViewModel>(
      context,
      listen: false,
    ).fetchServiceTypes(context);

    // After categories are loaded, select the first one by default
    final categories = Provider.of<ServicesViewModel>(context, listen: false)
        .serviceTypesModel
        ?.data;

    if (categories != null && categories.isNotEmpty) {
      setState(() {
        selectedCategoryId = categories[0].id;
      });
      fetchServices(categories[0].id??0);
    }
  }

  Future<void> fetchServices(int categoryId) async {
    await Provider.of<ServicesViewModel>(
      context,
      listen: false,
    ).fetchServices(context,categoryId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                CustomText(
                  text: "Services",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),

            customHeaderLine(context),
            SizedBox(height: 3.h),
            CustomText(
              text: "Types",
              style: basicColorBold(16, Colors.black),
            ),

            SizedBox(height: 2.h),

            // Categories Dropdown Section
            Consumer<ServicesViewModel>(
              builder: (context, value, child) {
                var categories = value.serviceTypesModel?.data ?? [];

                if (categories.isEmpty) {
                  return const SizedBox.shrink();
                }

                // Find selected category name
                String selectedCategoryName = categories
                    .firstWhere(
                      (cat) => cat.id == selectedCategoryId,
                  orElse: () => categories[0],
                )
                    .name ?? "Select Category";

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showSearchableDropdown(context, categories);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: AppColors.greenColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  color: AppColors.greenColor,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  formatTitle(selectedCategoryName),
                                  style: TextStyle(
                                    fontFamily: "Ubuntu",
                                    fontSize: 15.5.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.greenColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                );
              },
            ),


            // Forums List Section
            Consumer<ServicesViewModel>(
              builder: (context, value, child) {
                var serviceList = value.servicesModel?.data ?? [];

                if (value.loading) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.greenColor),
                      ),
                    ),
                  );
                }

                if (serviceList.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: CustomText(
                        text: "No service available in this category",
                        style: TextStyle(
                          fontFamily: "Ubuntu",
                          fontSize: 15.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: serviceList.length,
                    itemBuilder: (context, index) {
                      final service = serviceList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: serviceDetails(service),
                      );
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

  Widget serviceDetails(Service data) {
    String serviceType = data.serviceTypeName ?? "N/A";
    String contactPerson = data.contactPersonName ?? "N/A";
    String contactNo = data.phoneNumber ?? "N/A";
    String status = data.status ?? "N/A";
    bool dailyHelp = data.dailyHelp?? false;
    String dailyAvailibility=dailyHelp?"Yes":"No";
    String price = data.price.toString();
    String frequency = data.paymentFrequency??"";
    frequency = frequency.replaceAll('_', ' ');
    print("freqqq:$frequency");



    Color getDiscussionTypeColor(String type) {
      switch (type.toLowerCase().trim()) {
        case 'available':
          return Colors.green;
        case 'not available':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceDetails(service: data,)));

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  viewDetail(context, (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceDetails(service: data,)));

                  }),
                ],
              ),

              unitDetailRow("Contact Person:", contactPerson.toTitleCase(), null),
              unitDetailRow("Contact No", contactNo, null),
              unitDetailRow("Service", serviceType, null),
              unitDetailRow("Daily Help Availability", dailyAvailibility, null),
              if(price!="0")
                unitDetailRow("Price", "€$price ${frequency.toTitleCase()}", null),
              if(price=="0")
                unitDetailRow("Price", "Not Disclosed", null),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IntrinsicWidth(
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                      decoration: BoxDecoration(
                        color: getDiscussionTypeColor(status)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CustomText(
                          text: status.toTitleCase(),
                          style: basicColorBold(
                              15, getDiscussionTypeColor(status)),
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

  void _showSearchableDropdown(BuildContext context, List<dynamic> categories) {
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            var filteredCategories = categories.where((category) {
              return (category.name ?? '')
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Search field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search service types...',
                          prefixIcon: Icon(Icons.search, color: AppColors.greenColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.greenColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.greenColor, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),

                    // Categories list
                    Expanded(
                      child: filteredCategories.isEmpty
                          ? Center(
                        child: Text(
                          'No service types found',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      )
                          : ListView.builder(
                        controller: scrollController,
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          var category = filteredCategories[index];
                          bool isSelected = category.id == selectedCategoryId;

                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.greenColor.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.greenColor
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.category,
                                color: isSelected
                                    ? AppColors.greenColor
                                    : Colors.grey[600],
                                size: 20,
                              ),
                              title: Text(
                                formatTitle(category.name) ,
                                style: TextStyle(
                                  fontFamily: "Ubuntu",
                                  fontSize: 15.sp,
                                  color: isSelected
                                      ? AppColors.greenColor
                                      : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                Icons.check_circle,
                                color: AppColors.greenColor,
                              )
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedCategoryId = category.id;
                                });
                                fetchServices(category.id);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}