import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/models/forums.dart' hide Icon;
import 'package:savvyions/providers/forums_provider.dart';
import 'package:savvyions/screens/LegalNotices/legalNoticeDetails.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';
import 'detail.dart';

class SocietyForums extends StatefulWidget {
  const SocietyForums({super.key});

  @override
  State<SocietyForums> createState() => _SocietyForumsState();
}

class _SocietyForumsState extends State<SocietyForums> {
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchForumCategories();
    });
  }

  Future<void> fetchForumCategories() async {
    await Provider.of<ForumsViewModel>(
      context,
      listen: false,
    ).fetchForumCategories(context);

    // After categories are loaded, select the first one by default
    final categories = Provider.of<ForumsViewModel>(context, listen: false)
        .forumsCategoriesModel
        ?.data;

    if (categories != null && categories.isNotEmpty) {
      setState(() {
        selectedCategoryId = categories[0].id;
      });
      fetchForums(categories[0].id??0);
    }
  }

  Future<void> fetchForums(int categoryId) async {
    await Provider.of<ForumsViewModel>(
      context,
      listen: false,
    ).fetchForums(context,categoryId.toString());
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
                  text: "Forums",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),

            customHeaderLine(context),
            SizedBox(height: 3.h),
            CustomText(
              text: "Categories",
              style: basicColorBold(16, Colors.black),
            ),
            SizedBox(height: 1.h),
            CustomText(
              text: "Browse forum discussions by category",
              style: TextStyle(
                fontFamily: "Ubuntu",
                fontSize: 15.sp,
                color: AppColors.greenColor,
              ),
            ),
            SizedBox(height: 2.h),

            Consumer<ForumsViewModel>(
              builder: (context, value, child) {
                var categories = value.forumsCategoriesModel?.data ?? [];

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
            // Categories Dropdown Section
/*
            Consumer<ForumsViewModel>(
              builder: (context, value, child) {
                var categories = value.forumsCategoriesModel?.data ?? [];

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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: AppColors.greenColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedCategoryId,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.greenColor,
                          ),
                          style: TextStyle(
                            fontFamily: "Ubuntu",
                            fontSize: 15.5.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          items: categories.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.category,
                                    color: AppColors.greenColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      category.name?.toTitleCase() ?? "N/A",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedCategoryId = newValue;
                              });
                              fetchForums(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                );
              },
            ),
*/


            // Forums List Section
            Consumer<ForumsViewModel>(
              builder: (context, value, child) {
                var forumsList = value.forumsModel?.data ?? [];

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

                if (forumsList.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: CustomText(
                        text: "No forums available in this category",
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
                    itemCount: forumsList.length,
                    itemBuilder: (context, index) {
                      final forum = forumsList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: forumDetails(forum),
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

  Widget forumDetails(Datum forum) {
    String title = forum.title ?? "N/A";
   // String date = forum.date.toString() ?? "N/A";
   // date=formatDateTime(date);
    String discussionType = forum.discussionType ?? "N/A";
    String createdBy = forum.createdBy?.name?? "N/A";
    String categoryName = forum.category?.name ?? "N/A";

    Color getDiscussionTypeColor(String type) {
      switch (type.toLowerCase().trim()) {
        case 'public':
          return Colors.green;
        case 'private':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ForumDetails(id:forum.id.toString())));

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
                /*  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.forum,
                          color: AppColors.greenColor,
                          size: 22,
                        ),
                        SizedBox(width: 2.w),
                        CustomText(
                          text: title.toTitleCase(),
                          style: basicColorBold(16, AppColors.greenColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),*/
                  viewDetail(context, (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForumDetails(id:forum.id.toString())));

                  })
                ],
              ),
              /*SizedBox(height: 0.5.h),
              Container(
                height: 0.2.h,
                width: 100.w,
                color: AppColors.cardBorderColor,
              ),*/
              SizedBox(height: 1.h),

              unitDetailRow("Forum Title:", title.toTitleCase(), null),
           //   unitDetailRow("Date:", date, null),
              unitDetailRow("Created By:", createdBy.toTitleCase(), null),
              unitDetailRow("Category:", categoryName.toTitleCase(), null),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IntrinsicWidth(
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                      decoration: BoxDecoration(
                        color: getDiscussionTypeColor(discussionType)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CustomText(
                          text: discussionType.toTitleCase(),
                          style: basicColorBold(
                              15, getDiscussionTypeColor(discussionType)),
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
                          hintText: 'Search categories...',
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
                          'No categories found',
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
                                formatTitle(category.name) ?? "N/A",
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
                                fetchForums(category.id);
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