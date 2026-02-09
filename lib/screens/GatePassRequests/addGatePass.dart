import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/providers/gatePass_provider.dart';
import 'package:savvyions/providers/ticket_provider.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/custom_text.dart';

class AddGatePass extends StatefulWidget {
  const AddGatePass({super.key});

  @override
  State<AddGatePass> createState() => _AddGatePassState();
}

class _AddGatePassState extends State<AddGatePass> {
  bool isVisible = false;
  String? selectedTenant;
  String? selectedPassType;
  TextEditingController item=TextEditingController();
  TextEditingController purpose=TextEditingController();
  TextEditingController time=TextEditingController();
  TextEditingController notes=TextEditingController();
  int  selectedTenantId=0;
  DateTime? selectedDateTime;


  @override
  void initState() {
    super.initState();
    // Set default date time to current
    selectedDateTime = DateTime.now();
    time.text = DateFormat('dd/MM/yyyy hh:mm a').format(selectedDateTime!);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchAllList();
    });
  }

  Future<void> fetchAllList() async {
    Provider.of<TicketsViewModel>(context, listen: false).fetchTenants(context);
    Provider.of<GatePassViewModel>(context, listen: false).fetchGetPassTypes(context);
  }



  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
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
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
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
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          time.text = DateFormat('dd/MM/yyyy hh:mm a').format(selectedDateTime!);
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
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
                    text: "Add Gate Pass Request",
                    style: basicColorBold(18, Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              Consumer2<TicketsViewModel,GatePassViewModel>(
                builder: (BuildContext context, TicketsViewModel value,GatePassViewModel gatePass, Widget? child) {
                  var tenantList = value.tenantModel?.data?.tenants ?? [];
                  var type=gatePass.gatePassTypesModel?.data?.passTypes??[];
                  List<String> typeNames = type
                      .where((item) => item.name != null)
                      .map((item) => item.name!)
                      .toList();



                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabelWithDropDownForTenant(
                          context,
                          'Tenant',
                          'Select tenant',
                          tenantList,
                          selectedTenant,
                              (String? newValue) {
                            setState(() {
                              selectedTenant = newValue;
                              print('Selected Tenant: $newValue');
                              String ref=getTenantId(newValue)??'';
                              selectedTenantId=getTenantID(ref)??0;

                              print("tenant id=$selectedTenantId");
                            });
                          },
                        ),
                        SizedBox(height:1.5.h ,),
                        labelText(context, "Item"),
                        SizedBox(height: 0.5.h,),

                        TextField(
                          controller: item,
                          keyboardType: TextInputType.text,
                          style: basicColor(14.5, Colors.black), // Add this line for text style

                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Enter item name or description",
                            contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),

                        ),
                        SizedBox(height:1.5.h ,),


                        buildLabelWithDropDown(context, "Pass Type", "Select Pass Type", typeNames, selectedPassType,  (String? newValue) {
                          setState(() {
                            selectedPassType = newValue;
                          });
                          print('Selected Pass Type: $newValue');
                        },),

                        SizedBox(height:1.5.h ,),
                        CustomText(
                          text: "Purpose",
                          style: basicColor(15, Colors.black87),
                          align: TextAlign.center,
                        ),
                        SizedBox(height: 0.5.h,),

                        TextField(
                          controller: purpose,
                          keyboardType: TextInputType.text,
                          style: basicColor(14.5, Colors.black), // Add this line for text style

                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Enter purpose of the gate pass",
                            contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),

                        ),

                        SizedBox(height:1.5.h),

                        labelText(context, "Expected Out Time"),
                        SizedBox(height: 0.5.h,),

                        SizedBox(height: 0.5.h),
                        GestureDetector(
                          onTap: () => _selectDateTime(context),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: time,
                              style: basicColor(14.5, Colors.black),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "Select date and time",
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: AppColors.greenColor,
                                  size: 20,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 1.h),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height:1.5.h ,),

                        CustomText(
                          text: "Notes",
                          style: basicColor(15, Colors.black87),
                          align: TextAlign.center,
                        ),

                        SizedBox(height: 0.5.h,),

                        TextField(
                          controller: notes,
                          maxLines: 5,
                          keyboardType: TextInputType.text,
                          style: basicColor(14.5, Colors.black), // Add this line for text style
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Notes...",
                            contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),

                        ),


                        SizedBox(height:3.h ,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(width: 20.w,color: AppColors.greenColor, text: "Save", style: basicColorBold(15, Colors.white),onPressedCallback: (){
                              String passTypeFormatted = selectedPassType!
                                  .replaceAll(' ', '')  // Remove all spaces// Replace / with _ (optional, for "IT / Electronics" -> "it_electronics")
                                  .toLowerCase();
                              print("Pass type: $passTypeFormatted");
                              String itemText=item.text.trim();
                              String purposeText=purpose.text.trim();
                              String timeText=time.text.trim();
                              String notesText=notes.text.trim();
                              String onlyDate = "${selectedDateTime!.year}-${selectedDateTime?.month.toString().padLeft(2, '0')}-${selectedDateTime?.day.toString().padLeft(2, '0')}";
                              if(selectedTenant!=null && selectedPassType!=null &&itemText.isNotEmpty &&selectedDateTime!=null ){
                                var data={
                                  "tenant_id":selectedTenantId,
                                  "item":itemText,
                                  "pass_type": passTypeFormatted.toString().toLowerCase(),
                                  "pass_purpose": purposeText,
                                  "expected_out_time": onlyDate,
                                  "remarks": notesText,
                                };




                                gatePass.addGatePass(data, context);


                              }
                              else{
                                showToast("Please fill all required fields");
                              }
                            },),
                            SizedBox(width: 4.w,),
                            CustomButton(width: 20.w,color: AppColors.white, text: "Cancel", style: basicColorBold(15, Colors.black),onPressedCallback: (){
                              Navigator.pop(context);
                            },)
                          ],
                        ),
                        SizedBox(height:1.5.h ,),


                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modified dropdown specifically for tenants
  Widget buildLabelWithDropDownForTenant(
      BuildContext context,
      String text,
      String hintText,
      List<dynamic> tenantList,
      String? selectedValue,
      Function(String?) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: text,
              style: basicColor(15, Colors.black87),
              align: TextAlign.center,
            ),
            CustomText(
              text: " *",
              style: basicColor(15, Colors.red),
              align: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Container(
          height: 6.h,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              hint: CustomText(
                text: hintText,
                style: basicColor(14.5, Colors.black),
              ),
              // OR if you want even more control:
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 15.5),
              /* hintText: hintText,
              contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),*/
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            isExpanded: true,
            items: tenantList.map((tenant) {
              String displayText = '${tenant.refNo} - ${tenant.user?.name ?? "N/A"}';

              return DropdownMenuItem<String>(
                value: displayText,
                child: CustomText(text: displayText,style: basicColor(14.5,Colors.black ),),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  int? getTenantID(String? name) {
    if (name == null) return null;
    final types = Provider.of<TicketsViewModel>(context, listen: false)
        .tenantModel
        ?.data
        ?.tenants ?? [];
    final matched = types.firstWhereOrNull((t) => t.refNo == name);
    return matched?.id;
  }



  String? getTenantId(value) {
    if (value != null) {
      return value!.split(' - ')[0]; // Returns "TN-00012"
    }
    return null;
  }
}