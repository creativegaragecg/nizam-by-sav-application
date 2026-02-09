import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/providers/legalNotice_provider.dart';
import 'package:savvyions/providers/serviceSuspensionProvider.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';

class ServiceSuspensionDetails extends StatefulWidget {
  const ServiceSuspensionDetails({super.key, required this.id,});
  final String id;

  @override
  State<ServiceSuspensionDetails> createState() => _ServiceSuspensionDetailsState();
}

class _ServiceSuspensionDetailsState extends State<ServiceSuspensionDetails> {
  // Track which comment is being replied to
  int? replyingToCommentIndex;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isSubmittingComment = false;
  // Controllers for each comment reply
  Map<int, TextEditingController> replyControllers = {};
  Map<int, FocusNode> replyFocusNodes = {};

  // File upload variables for each comment
  Map<int, PlatformFile?> selectedFiles = {};
  Map<int, String?> fileNames = {};
  bool _isSubmittingReply = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchDetails();
    });
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes
    replyControllers.forEach((key, controller) => controller.dispose());
    replyFocusNodes.forEach((key, node) => node.dispose());
    super.dispose();
  }

  Future<void> fetchDetails() async {
    Provider.of<ServiceSuspensionViewModel>(
      context,
      listen: false,
    ).fetchDetails(context, widget.id);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {

      case 'submitted':
        return Colors.green;
      case 'under review':
        return Colors.blue;
      case 'inprogress':
        return Colors.brown;
      case 'suspended':
        return Colors.red;
      case 'restored':
        return Colors.blueAccent;
      default:
        return Colors.black45;
    }
  }

  String _stripHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  String _formatTimeAgo(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  TextEditingController _getReplyController(int index) {
    if (!replyControllers.containsKey(index)) {
      replyControllers[index] = TextEditingController();
    }
    return replyControllers[index]!;
  }

  FocusNode _getReplyFocusNode(int index) {
    if (!replyFocusNodes.containsKey(index)) {
      replyFocusNodes[index] = FocusNode();
    }
    return replyFocusNodes[index]!;
  }

  void _toggleReply(int index) {
    setState(() {
      if (replyingToCommentIndex == index) {
        replyingToCommentIndex = null;
      } else {
        replyingToCommentIndex = index;
        // Focus on the text field
        Future.delayed(Duration(milliseconds: 100), () {
          _getReplyFocusNode(index).requestFocus();
        });
      }
    });
  }

  Future<void> _submitComment() async {
    String commentText = _commentController.text.trim();

    if (commentText.isEmpty) {
      showToast("Write your comment");
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    var provider = Provider.of<ServiceSuspensionViewModel>(
      context,
      listen: false,
    );

    var data = {
      "message": "<div>$commentText</div>",
      "content": "<div>$commentText</div>",
      "parent_id": null,

    };

    try {
      await provider.addComment(data, context, widget.id);


      // Clear the reply field after successful submission
      _commentController.clear();
      setState(() {

      });
    } finally {
      setState(() {
        _isSubmittingComment = false;
      });
    }
  }



  Future<void> _submitReply(int commentIndex, String? parentId) async {
    final controller = _getReplyController(commentIndex);
    String commentText = controller.text.trim();

    if (commentText.isEmpty) {
      showToast("Write your comment");
      return;
    }

    setState(() {
      _isSubmittingReply = true;
    });

    var provider = Provider.of<ServiceSuspensionViewModel>(
      context,
      listen: false,
    );

    var data = {
      "message": "<div>$commentText</div>",
      "content": "<div>$commentText</div>",
      "parent_id": parentId,

    };

    try {
      if (selectedFiles[commentIndex] != null) {
      /*  await provider.addCommentWithFile(
            data,
            context,
            widget.id,
            file: selectedFiles[commentIndex]
        );*/
      } else {
        await provider.addComment(data, context, widget.id);
      }

      // Clear the reply field after successful submission
      controller.clear();
      setState(() {
        replyingToCommentIndex = null;
        selectedFiles[commentIndex] = null;
        fileNames[commentIndex] = null;
      });
    } finally {
      setState(() {
        _isSubmittingReply = false;
      });
    }
  }
  // Widget to build a single reply item
  Widget _buildReplyItem(dynamic reply) {
    final user = reply.user;
    final message = _stripHtmlTags(reply.message ?? "");
    final timeAgo = _formatTimeAgo(reply.createdAt.toString());

    return Container(
      margin: EdgeInsets.only(left: 1.w, top: 1.h),
      padding: EdgeInsets.all(2.5.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.greenColor.withOpacity(0.2),
                child: user?.profilePhotoPath != null
                    ? ClipOval(
                  child: Image.network(
                    user!.profilePhotoPath!,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return CustomText(
                        text: (user.name ?? "U")[0].toUpperCase(),
                        style: basicColorBold(14, AppColors.greenColor),
                      );
                    },
                  ),
                )
                    : CustomText(
                  text: (user?.name ?? "U")[0].toUpperCase(),
                  style: basicColorBold(14, AppColors.greenColor),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: user?.name ?? "Unknown User",
                      style: basicColorBold(14, Colors.black),
                    ),
                    if (timeAgo.isNotEmpty)
                      CustomText(
                        text: timeAgo,
                        style: basicColor(11, AppColors.hintText),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          CustomText(
            text: message,
            style: basicColor(13.5, Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBgScreen(
      child: Column(
        children: [
          SizedBox(height: 3.h,),
          // Header
          Padding(
            padding: EdgeInsets.symmetric( horizontal: 4.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                ),
                SizedBox(width: 3.w),
                CustomText(
                  text: "Service Suspension Details",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 4.w),
            child: customHeaderLine(context),
          ),
          SizedBox(height: 3.h,),

          // Content
          Expanded(
            child: Consumer<ServiceSuspensionViewModel>(
              builder: (context, value, child) {
                if (value.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }

                final suspension = value.detailModel?.data?.serviceSuspension;
                var allReplies = value.detailModel?.data?.serviceSuspension?.reply ?? [];
// Filter only top-level comments (where parent_id is null)
                var comments = allReplies.where((c) => c.parentId == null).toList();

                String suspensionNumber=suspension?.suspensionNumber?.toString()??"N/A";
                String subject=suspension?.subject??"N/A";
                String agent=suspension?.agent?.name??"N/A";
                String type=suspension?.suspensionType?.typeName??"N/A";
                String elapsedTime=suspension?.resolvedTime??"N/A";
                String status=suspension?.status??"N/A";
                status=status.replaceAll("_","");


                if (suspension == null) {
                  return Center(child: Text("No details found"));
                }


                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Status Card
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              unitDetailRow("Subject:", subject.toTitleCase(), null),
                              unitDetailRow("Agent:", agent, null),
                              unitDetailRow("Suspension Type:", type.toTitleCase(), null),
                              unitDetailRow("Elapsed Time:", elapsedTime!="N/A"?elapsedTime:"No Time Limit", null),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 1.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(status).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CustomText(
                                      text: status.toTitleCase(),
                                      style: basicColorBold(14, getStatusColor(status)),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Comments Section Header
                        CustomText(
                          text: "Comments (${comments.length})",
                          style: basicColorBold(16, Colors.black),
                        ),

                        SizedBox(height: 1.h),

                        // Comments List
                        if (comments.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: CustomText(
                                text: "No comments yet",
                                style: basicColorBold(14, AppColors.hintText),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              final user = comment.user;
                              final message = _stripHtmlTags(comment.message ?? "");
                              final timeAgo = _formatTimeAgo(comment.createdAt.toString());
                              final isReplying = replyingToCommentIndex == index;

// Get all replies for this comment by matching parent_id with comment.id
                              final replies = allReplies.where((c) =>
                              c.parentId?.toString() == comment.id?.toString()
                              ).toList();

                              return Padding(
                                padding: EdgeInsets.only(bottom: 1.5.h),
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(2.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // User Info Row
                                      Row(
                                        children: [
                                          // User Avatar
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: AppColors.greenColor.withOpacity(0.2),
                                            child: user?.profilePhotoPath != null
                                                ? ClipOval(
                                              child: Image.network(
                                                user!.profilePhotoPath!,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return CustomText(
                                                    text: (user.name ?? "U")[0].toUpperCase(),
                                                    style: basicColorBold(16, AppColors.greenColor),
                                                  );
                                                },
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                        AppColors.greenColor,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                                : CustomText(
                                              text: (user?.name ?? "U")[0].toUpperCase(),
                                              style: basicColorBold(16, AppColors.greenColor),
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: user?.name ?? "Unknown User",
                                                  style: basicColorBold(15, Colors.black),
                                                ),
                                                if (timeAgo.isNotEmpty)
                                                  CustomText(
                                                    text: timeAgo,
                                                    style: basicColorBold(12, AppColors.hintText),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 1.5.h),

                                      // Message
                                      CustomText(
                                        text: message,
                                        style: basicColorBold(14, Colors.black87),
                                      ),

                                      SizedBox(height: 1.h),

                                      // Reply Button
                                      GestureDetector(
                                        onTap: () => _toggleReply(index),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.reply,
                                              size: 16,
                                              color: AppColors.greenColor,
                                            ),
                                            SizedBox(width: 1.w),
                                            CustomText(
                                              text: isReplying ? "Cancel" : "Reply",
                                              style: basicColorBold(13, AppColors.greenColor),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Display existing replies
                                      if (replies.isNotEmpty) ...[
                                        SizedBox(height: 1.h),
                                        ...replies.map((reply) => _buildReplyItem(reply)).toList(),
                                      ],

                                      // Reply Section (Shows when replying)
                                      if (isReplying) ...[
                                        SizedBox(height: 1.5.h),
                                        Container(
                                          padding: EdgeInsets.all(3.w),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppColors.cardBorderColor),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: "Reply to ${user?.name ?? 'this comment'}",
                                                style: basicColorBold(13, AppColors.hintText),
                                              ),
                                              SizedBox(height: 1.h),
                                              TextField(
                                                controller: _getReplyController(index),
                                                focusNode: _getReplyFocusNode(index),
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  hintText: "Write your reply...",
                                                  hintStyle: TextStyle(
                                                    color: AppColors.hintText,
                                                    fontSize: 14,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide(color: AppColors.greenColor, width: 1.5),
                                                  ),
                                                  contentPadding: EdgeInsets.all(3.w),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 1.h),
                                              Row(
                                                children: [
                                                  // Upload File Button
                                                  GestureDetector(
                                                    onTap: () {
                                                      pickFile((file, name) {
                                                        setState(() {
                                                          selectedFiles[index] = file;
                                                          fileNames[index] = name;
                                                        });
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 3.w,
                                                        vertical: 1.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey.shade100,
                                                        borderRadius: BorderRadius.circular(6),
                                                        border: Border.all(color: AppColors.cardBorderColor),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.attach_file,
                                                              color: AppColors.greenColor, size: 16),
                                                          SizedBox(width: 1.w),
                                                          CustomText(
                                                            text: "File",
                                                            style: basicColorBold(12, AppColors.greenColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  if (fileNames[index] != null) ...[
                                                    SizedBox(width: 2.w),
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 2.w,
                                                          vertical: 0.8.h,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors.greenColor.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.description,
                                                                size: 14,
                                                                color: AppColors.greenColor
                                                            ),
                                                            SizedBox(width: 1.w),
                                                            Expanded(
                                                              child: CustomText(
                                                                text: fileNames[index]!,
                                                                style: basicColor(12, Colors.black87),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectedFiles[index] = null;
                                                                  fileNames[index] = null;
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors.red,
                                                                size: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],

                                                  Spacer(),

                                                  // Submit Button
                                                  GestureDetector(
                                                    onTap: () => _submitReply(index, comment.id?.toString()),
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 4.w,
                                                        vertical: 1.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.greenColor,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: CustomText(
                                                        text: "Submit",
                                                        style: basicColorBold(13, Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.cardBorderColor),
                      ),
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Write a comment...",
                          hintStyle: TextStyle(
                            color: AppColors.hintText,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: _isSubmittingComment ? null : (){
                      _submitComment();
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: _isSubmittingComment
                            ? Colors.grey
                            : AppColors.greenColor,
                        shape: BoxShape.circle,
                      ),
                      child: _isSubmittingComment
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}