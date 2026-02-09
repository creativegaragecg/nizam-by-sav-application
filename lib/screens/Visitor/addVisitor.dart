import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/customWhiteBg.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/providers/visitor_provider.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/custom_text.dart';

class AddVisitor extends StatefulWidget {
  const AddVisitor({super.key});

  @override
  State<AddVisitor> createState() => _AddVisitorState();
}

class _AddVisitorState extends State<AddVisitor> {
  String? selectedApartment;
  String? selectedType;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController purpose = TextEditingController();
  TextEditingController dateOfVisit = TextEditingController();
  TextEditingController inTime = TextEditingController();
  TextEditingController dateOfExit = TextEditingController();
  TextEditingController outTime = TextEditingController();

  int selectedAppId = 0;
  DateTime? selectedVisitDateTime;
  DateTime? selectedInDateTime;
  DateTime? selectedExitDate;
  DateTime? selectedOutDateTime;

  File? visitorPhoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Set default date time to current for visit date and in time
    selectedVisitDateTime = DateTime.now();
    selectedInDateTime = DateTime.now();

    dateOfVisit.text = DateFormat('dd/MM/yyyy').format(selectedVisitDateTime!);
    inTime.text = DateFormat('hh:mm a').format(selectedInDateTime!);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchAllList();
    });
  }

  Future<void> fetchAllList() async {
    Provider.of<VisitorViewModel>(context, listen: false).fetchVisitorAppartments(context);
    Provider.of<VisitorViewModel>(context, listen: false).fetchVisitorTypes(context);
  }

  Future<void> _selectVisitDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedVisitDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.greenColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedVisitDateTime = pickedDate;
        dateOfVisit.text = DateFormat('dd/MM/yyyy').format(selectedVisitDateTime!);
      });
    }
  }

  Future<void> _selectInTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedInDateTime ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.greenColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedInDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        inTime.text = DateFormat('hh:mm a').format(selectedInDateTime!);
      });
    }
  }

  Future<void> _selectExitDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedExitDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.greenColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedExitDate = pickedDate;
        dateOfExit.text = DateFormat('dd/MM/yyyy').format(selectedExitDate!);
      });
    }
  }

  Future<void> _selectOutTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.greenColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedOutDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        outTime.text = DateFormat('hh:mm a').format(selectedOutDateTime!);
      });
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (photo != null) {
                    setState(() {
                      visitorPhoto = File(photo.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (photo != null) {
                    setState(() {
                      visitorPhoto = File(photo.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return CustomWhiteBgScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        child: SingleChildScrollView(
          child: Column(
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
                    text: "Add Visitor",
                    style: basicColorBold(18, Colors.black),
                  ),
                ],
              ),

              customHeaderLine(context),
              SizedBox(height: 3.h),

              Consumer<VisitorViewModel>(
                builder: (BuildContext context, VisitorViewModel value, Widget? child) {
                  var apartmentList = value.visitorAppartmentModel?.data?.apartments ?? [];
                  var typeList = value.visitorTypesModel?.data?.visitorTypes ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Apartment Dropdown
                      buildLabelWithDropDown(
                        context,
                        'Apartment',
                        'Select Apartment',
                        apartmentList.map((e) => e.apartmentNumber ?? '').toList(),
                        selectedApartment,
                            (String? newValue) {
                          setState(() {
                            selectedApartment = newValue;
                            selectedAppId = apartmentList
                                .firstWhere((apt) => apt.apartmentNumber == newValue)
                                .id ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 1.5.h),

                      // Visitor Type Dropdown
                      buildLabelWithDropDown(
                        context,
                        'Visitor Type',
                        'Select Visitor Type',
                        typeList.map((e) => e.name ?? '').toList(),
                        selectedType,
                            (String? newValue) {
                          setState(() {
                            selectedType = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 1.5.h),

                      // Visitor Name
                      buildTextField(context, 'Visitor Name', name, 'Enter Visitor Name', isRequired: true),
                      SizedBox(height: 1.5.h),

                      // Phone Number
                      buildTextField(context, 'Mobile Number', phone, 'Enter Mobile Number',
                          keyboardType: TextInputType.phone, isRequired: true),
                      SizedBox(height: 1.5.h),

                      // Address
                      buildTextField(context, 'Visitor Address', address, 'Enter Visitor Address',
                          maxLines: 3, isRequired: true),
                      SizedBox(height: 1.5.h),

                      // Purpose
                      buildTextField(context, 'Purpose Of Visit', purpose, 'Enter Purpose Of Visit'),
                      SizedBox(height: 1.5.h),

                      // Date of Visit and In Time Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText(context, "Date Of Visit", isRequired: true),
                                SizedBox(height: 0.5.h),
                                GestureDetector(
                                  onTap: () => _selectVisitDate(context),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: dateOfVisit,
                                      style: basicColor(14.5, Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "Select Date",
                                        suffixIcon: Icon(
                                          Icons.calendar_today,
                                          color: AppColors.greenColor,
                                          size: 20,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 1.h),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText(context, "In Time", isRequired: true),
                                SizedBox(height: 0.5.h),
                                GestureDetector(
                                  onTap: () => _selectInTime(context),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: inTime,
                                      style: basicColor(14.5, Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "Select Time",
                                        suffixIcon: Icon(
                                          Icons.access_time,
                                          color: AppColors.greenColor,
                                          size: 20,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 1.h),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),

                      // Date of Exit and Out Time Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText(context, "Date Of Exit"),
                                SizedBox(height: 0.5.h),
                                GestureDetector(
                                  onTap: () => _selectExitDate(context),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: dateOfExit,
                                      style: basicColor(14.5, Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "Select Date",
                                        suffixIcon: Icon(
                                          Icons.calendar_today,
                                          color: AppColors.greenColor,
                                          size: 20,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 1.h),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText(context, "Out Time"),
                                SizedBox(height: 0.5.h),
                                GestureDetector(
                                  onTap: () => _selectOutTime(context),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: outTime,
                                      style: basicColor(14.5, Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "Select Time",
                                        suffixIcon: Icon(
                                          Icons.access_time,
                                          color: AppColors.greenColor,
                                          size: 20,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 1.h),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),

                      // Upload Photo
                      labelText(context, "Visitor Photo"),
                      SizedBox(height: 0.5.h),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 12.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300,width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: visitorPhoto != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.file(
                              visitorPhoto!,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 0.5.h),
                              CustomText(
                                text: "Upload Photo",
                                style: basicColor(14, Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height:1.5.h ,),
                      CustomText(
                        text: "Max Image Upload Size Limit is 2 MB.",
                        style: basicColor(15, AppColors.greenColor),
                      ),
                      SizedBox(height: 3.h),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            width: 20.w,
                            color: AppColors.greenColor,
                            text: "Save",
                            style: basicColorBold(15, Colors.white),
                            onPressedCallback: () {
                              if (selectedApartment != null &&
                                  selectedType != null &&
                                  name.text.trim().isNotEmpty &&
                                  phone.text.trim().isNotEmpty &&
                                  address.text.trim().isNotEmpty) {



                                // Get visitor_type_id from the selected type
                                int visitorTypeId = typeList
                                    .firstWhere((type) => type.name == selectedType)
                                    .id ?? 0;

                                // Prepare data for API
                                var data = {
                                  "visitor_name": name.text.trim(),
                                  "phone_number": phone.text.trim(),
                                  "address": address.text.trim(),
                                  "apartment_id": selectedAppId,
                                  "visitor_type_id": visitorTypeId,
                                  "purpose_of_visit": purpose.text.trim(),
                                  "date_of_visit": DateFormat('yyyy-MM-dd').format(selectedVisitDateTime!),
                                  "date_of_exit": selectedExitDate != null
                                      ? DateFormat('yyyy-MM-dd').format(selectedExitDate!)
                                      : null,
                                  "in_time": DateFormat('HH:mm').format(selectedInDateTime!),
                                  "out_time": selectedOutDateTime != null
                                      ? DateFormat('HH:mm').format(selectedOutDateTime!)
                                      : null,
                                  "visitor_photo": null,
                                  "status": "pending",
                                };

                                // Call appropriate method based on whether photo exists
                                if (visitorPhoto != null) {
                                  // Convert File to PlatformFile
                                  PlatformFile platformFile = PlatformFile(
                                    name: visitorPhoto!.path.split('/').last,
                                    size: visitorPhoto!.lengthSync(),
                                    path: visitorPhoto!.path,
                                  );
                                  value.addVisitorWithFile(data, context, file: platformFile,path:'visitor_photo' );
                                } else {
                                  value.addVisitors(data, context);
                                }
                              } else {
                                showToast("Please fill all required fields");
                              }
                            },
                          ),
                          SizedBox(width: 4.w),
                          CustomButton(
                            width: 20.w,
                            color: AppColors.white,
                            text: "Cancel",
                            style: basicColorBold(15, Colors.black),
                            onPressedCallback: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget buildTextField(
      BuildContext context,
      String label,
      TextEditingController controller,
      String hint, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        bool isRequired = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText(context, label, isRequired: isRequired),
        SizedBox(height: 0.5.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: basicColor(14.5, Colors.black),
          decoration: InputDecoration(
            hintText: hint,
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
      ],
    );
  }

  Widget labelText(BuildContext context, String text, {bool isRequired = false}) {
    return Row(
      children: [
        CustomText(
          text: text,
          style: basicColorBold(15, Colors.black87),
        ),
        if (isRequired)
          CustomText(
            text: " *",
            style: basicColor(15, Colors.red),
          ),
      ],
    );
  }
}