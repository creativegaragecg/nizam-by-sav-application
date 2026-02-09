import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Custom/customWhiteBg.dart';
import 'package:savvyions/Utils/Custom/custom_button.dart';
import 'package:savvyions/models/tickets.dart';
import 'package:savvyions/providers/ticket_provider.dart';
import 'package:savvyions/providers/user_provider.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/customTextField.dart';
import '../../Utils/Custom/custom_text.dart';

class AddTicket extends StatefulWidget {
  const AddTicket({super.key,required this.role});
  final String role;

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  bool isVisible = false;
  String? selectedTenant;
  String? selectedType;
  String? selectedAgent;
  String? selectedStatus;
  TextEditingController subject=TextEditingController();
  TextEditingController description=TextEditingController();
  List<String>status=["Open","Pending","Resolved","Closed"];
  int  selectedTenantId=0;
  int  selectedTypeId=0;
  int  selectedAgentId=0;
  // File upload variables
  PlatformFile? selectedFile;
  String? fileName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchAllList();
    });
  }

  Future<void> fetchAllList() async {

    if(widget.role=="Tenant"){
      print("Role:${widget.role}");
      Provider.of<TicketsViewModel>(context, listen: false).fetchTenants(context);
    }
    else if(widget.role=="Owner"){
      print("Role:${widget.role}");
      Provider.of<TicketsViewModel>(context, listen: false).fetchOwners(context);
    }
    Provider.of<TicketsViewModel>(context, listen: false).fetchAgents(context);
    Provider.of<TicketsViewModel>(context, listen: false).fetchTicketTypes(context);
  }

  // Remove selected file
  void removeFile() {
    setState(() {
      selectedFile = null;
      fileName = null;
    });
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
                    text: "Add Tickets",
                    style: basicColorBold(18, Colors.black),
                  ),
                ],
              ),

              customHeaderLine(context),

              SizedBox(height: 3.h),
              Consumer2<TicketsViewModel,UserProfileViewModel>(
                builder: (BuildContext context, TicketsViewModel value,UserProfileViewModel user ,Widget? child) {
                  var tenantList = value.tenantModel?.data?.tenants ?? [];
                  var type=value.ticketTypesModel?.data?.ticketTypes??[];
                  var agents=value.agentsModel?.data?.agents??[];
                  List<String> typeNames = type
                      .where((item) => item.typeName != null)
                      .map((item) => item.typeName!)
                      .toList();
          
                  List<String> agentNames = agents
                      .where((item) => item.name != null)
                      .map((item) => item.name!)
                      .toList();

                  var ownerList = value.ownerModel?.data?.owners ?? [];




                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(widget.role=="Tenant")
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

                        if(widget.role=="Owner")
                          buildLabelWithDropDownForOwner(
                            context,
                            'Owner',
                            'Select owner',
                            ownerList,
                            selectedTenant,
                                (String? newValue) {
                              setState(() {
                                selectedTenant = newValue;
                                print('Selected Owner: $newValue');
                                String ref=getTenantId(newValue)??'';

                                selectedTenantId=getOwnerID(ref)??0;

                                print("Owner id=$selectedTenantId");
                              });
                            },
                          ),
                        SizedBox(height:1.5.h ,),
                        buildLabelWithDropDown(context, "Type", "Select Type", typeNames, selectedType,  (String? newValue) {
                          setState(() {
                            selectedType = newValue;
                            selectedTypeId = getTypeIdFromName(newValue)??0; // real ID
                          });
                          print('Selected Type: $newValue');
                          print('Selected Type ID: $selectedTypeId');
                        },),
          
                        /*SizedBox(height:1.5.h ,),
                        buildLabelWithDropDown(context, "Agent", "Select Agent", agentNames, selectedAgent,  (String? newValue) {
                          setState(() {
                            selectedAgent = newValue;
                            selectedAgentId = getAgentIdFromName(newValue)??0;
                          });
                          print('Selected Agent: $newValue');
                          print('Selected AgentId: $selectedAgentId');
                        },),
          */
                       /* SizedBox(height:1.5.h ,),
                        buildLabelWithDropDown(context, "Status", "Select Status", status, selectedStatus,  (String? newValue) {
                          setState(() {
                            selectedStatus = newValue;
                          });
                          print('Selected Status: $newValue');
                        },),
                      */
                        SizedBox(height:1.5.h ,),
                        labelText(context, "Subject"),
                        SizedBox(height: 0.5.h,),
          
                        TextField(
                          controller: subject,
                          keyboardType: TextInputType.text,
                          style: basicColor(14.5, Colors.black), // Add this line for text style

                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Enter Subject",
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
          
                        SizedBox(height:1.5.h ,),
                        labelText(context, "Description"),
                        SizedBox(height: 0.5.h,),
          
                        TextField(
                          controller: description,
                          maxLines: 5,
                          keyboardType: TextInputType.text,
                          style: basicColor(14.5, Colors.black), // Add this line for text style
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Enter Description...",
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
          
                        SizedBox(height:1.5.h ,),
          
                        CustomText(
                          text: "File Upload",
                          style: basicColorBold(15, Colors.black87),
                        ),
                        SizedBox(height: 0.5.h),
          
                        GestureDetector(
                          onTap: (){

                              pickFile((file, name) {
                                setState(() {
                                  selectedFile = file;
                                  fileName = name;
                                });
                              });

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300,width: 2),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2C3E50),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: CustomText(
                                    text: "Choose files",
                                    style: basicColor(14.5, Colors.white),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: CustomText(
                                    text: fileName ?? "No file chosen",
                                    style: basicColor(14.5, fileName != null ? Colors.black87 : Colors.grey),
                                  ),
                                ),
                                if (fileName != null)
                                  GestureDetector(
                                    onTap: removeFile,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height:1.5.h ,),
                        CustomText(
                          text: "Max File Size is 1 MB.",
                          style: basicColor(15, Colors.black),
                        ),
                        SizedBox(height:1.5.h ,),

                        CustomText(
                          text: "Note: Tickets cannot be deleted once created. To request deletion, leave a comment.",
                          style: basicColor(15, Colors.red),
                        ),

                        SizedBox(height:3.h ,),
          
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end
                          ,
                          children: [
                            CustomButton(width: 20.w,color: AppColors.greenColor, text: "Save", style: basicColorBold(15, Colors.white),onPressedCallback: (){
                           String subjectText=subject.text.trim();
                           String descText=description.text.trim();

                             if(selectedTenant!=null && selectedType!=null&&subjectText.isNotEmpty &&descText.isNotEmpty){
                           String roleName=user.userProfile?.data?.user?.role?.name??"";

                               var data={
                              "party_type":roleName.toLowerCase(),
                                 "party_id":selectedTenantId,
                                 "type_id": selectedTypeId,
                                 "subject": subjectText,
                                 "description":descText,
                                 "files": []
                               };

                               debugPrint('Submitting ticket data: $data');
                               if (selectedFile != null) {
                                 debugPrint('With file: ${selectedFile!.name}');
                                 // Call the NEW method with file parameter
                             value.addTicketWithFile(data, context, file: selectedFile);
                               }



                               value.addTickets(data, context);


                             }
                             else{
                               showToast("Please fill all required fills");
                             }
                              /*{
                                "tenant_id":3,
                                "type_id": 2,
                                "agent_id": 5,
                                "status": "open",
                                "subject": "Water Issue",
                                "description": "There's a water leak in my bathroom",
                                "files": []
                              }*/
                            },),
                            SizedBox(width: 4.w,),
                            CustomButton(width: 20.w,color: AppColors.white, text: "Cancel", style: basicColorBold(15, Colors.black),
                            onPressedCallback: (){
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
              style: basicColorBold(15, Colors.black87),
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
            menuMaxHeight: 200, // This limits the dropdown height and forces it below

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
            isExpanded: true,
            items: tenantList.map((tenant) {
              String displayText = '${tenant.refNo} - ${tenant.user?.name ?? "N/A"}';
              print("dscdscvs:$displayText");

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


  Widget buildLabelWithDropDownForOwner(
      BuildContext context,
      String text,
      String hintText,
      List<dynamic> ownerList,
      String? selectedValue,
      Function(String?) onChanged,
      ) {
    print("owner lsit:$ownerList");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: text,
              style: basicColorBold(15, Colors.black87),
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
            menuMaxHeight: 200, // This limits the dropdown height and forces it below

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
            isExpanded: true,
            items: ownerList.map((owner) {
              String displayText = '${owner.refNo} - ${owner.user?.name ?? "N/A"}';
              print("displayText:$displayText");
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

  int? getOwnerID(String? name) {
    if (name == null) return null;
    final types = Provider.of<TicketsViewModel>(context, listen: false)
        .ownerModel
        ?.data
        ?.owners ?? [];
    final matched = types.firstWhereOrNull((t) => t.refNo == name);
    return matched?.id;
  }

  int? getTypeIdFromName(String? name) {
    if (name == null) return null;
    final types = Provider.of<TicketsViewModel>(context, listen: false)
        .ticketTypesModel
        ?.data
        ?.ticketTypes ?? [];
    final matched = types.firstWhereOrNull((t) => t.typeName == name);
    return matched?.id;
  }

  int? getAgentIdFromName(String? name) {
    if (name == null) return null;
    final agents = Provider.of<TicketsViewModel>(context, listen: false)
        .agentsModel
        ?.data
        ?.agents ?? [];
    final matched = agents.firstWhereOrNull((a) => a.name == name);
    return matched?.id;
  }


  String? getTenantId(value) {
    if (value != null) {
      return value!.split(' - ')[0]; // Returns "TN-00012"
    }
    return null;
  }
}