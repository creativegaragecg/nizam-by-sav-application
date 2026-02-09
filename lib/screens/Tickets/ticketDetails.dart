import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/models/tickets.dart';
import 'package:savvyions/providers/ticket_provider.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Constants/utils.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';

class TicketDetails extends StatefulWidget {
  TicketDetails({super.key, required this.ticketId});
  final String ticketId;

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isSubmittingComment = false;

  // Track which comment is being replied to
  int? replyingToCommentIndex;
// Controllers for each comment reply
  Map<int, TextEditingController> replyControllers = {};
  Map<int, FocusNode> replyFocusNodes = {};
  bool _isSubmittingReply = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchTickets();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    // Dispose all reply controllers and focus nodes
    replyControllers.forEach((key, controller) => controller.dispose());
    replyFocusNodes.forEach((key, node) => node.dispose());
    super.dispose();
  }

  Future<void> fetchTickets() async {
    Provider.of<TicketsViewModel>(
      context,
      listen: false,
    ).fetchTicketDetails(context, widget.ticketId);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'open':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
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

  Future<void> _submitComment() async {
    String commentText = _commentController.text.trim();

    if (commentText.isEmpty) {
      showToast("Write your comment");
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    var provider = Provider.of<TicketsViewModel>(
      context,
      listen: false,
    );

    var data = {
      "message": "<div>$commentText</div>",
      "parent_id": null,  // This might be the issue


    };


    await provider.addComment(data, context, widget.ticketId);


    _commentController.clear();
    _commentFocusNode.unfocus();
    setState(() {
      _isSubmittingComment = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment submitted successfully'),
        backgroundColor: AppColors.greenColor,
      ),
    );
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

  Future<void> _submitReply(int commentIndex, String? parentId) async {
    final controller = _getReplyController(commentIndex);
    String commentText = controller.text.trim();

    if (commentText.isEmpty) {
      showToast("Write your reply");
      return;
    }

    setState(() {
      _isSubmittingReply = true;
    });

    var provider = Provider.of<TicketsViewModel>(
      context,
      listen: false,
    );

    var data = {
      "message": "<div>$commentText</div>",
      "parent_id": parentId,
    };

    try {
      await provider.addComment(data, context, widget.ticketId);

      // Clear the reply field after successful submission
      controller.clear();
      setState(() {
        replyingToCommentIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reply submitted successfully'),
          backgroundColor: AppColors.greenColor,
        ),
      );
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
                child: user?.profilePhotoUrl != null
                    ? ClipOval(
                  child: Image.network(
                    user!.profilePhotoUrl!,
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
          // Header
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
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
                  text: "Ticket Details",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Consumer<TicketsViewModel>(
              builder: (context, ticketModel, child) {
                if (ticketModel.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }

                final ticketData = ticketModel.ticketDetails?.data?.ticket;

                if (ticketData == null) {
                  return Center(child: Text("No ticket details found"));
                }

                final allReplies = ticketData.reply ?? [];
// Filter only top-level comments (where parent_id is null)
                final comments = allReplies.where((c) => c.parentId == null).toList();
                final status = ticketData.status ?? "N/A";
                final ticketNumber = ticketData.ticketNumber?.toString() ?? ticketData.id?.toString() ?? "N/A";
                String agent = ticketData.agent?.name ?? "N/A";
                String agentEmail = ticketData.agent?.email ?? "N/A";
                String agentPhone = ticketData.agent?.phoneNumber ?? "N/A";
                //  String detail = ticket.d ?? "N/A";
                String subject = ticketData.subject ?? "N/A";
                String ticketType = ticketData.ticketType?.typeName ?? "N/A";
                String resolvedTime = ticketData.resolvedTime ?? "N/A";
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ticket ID and Status Card
                        Container(
                          width: 100.w,
                          decoration: BoxDecoration(
                              color: Colors.white,

                              border: Border.all(color:AppColors.cardBorderColor,width: 1 )
                          ),
                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.confirmation_number,
                                          color: AppColors.greenColor, size: 18),
                                      SizedBox(width: 2.w),
                                      CustomText(
                                        text: "Ticket #$ticketNumber",
                                        style: basicColorBold(16, Colors.black),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 1.h
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
                              SizedBox(height: 1.h,),
                              buildDetailRow("Ticket Type", ticketType),
                              buildDetailRow("Subject", subject),
                              buildDetailRow("Resolved Time", resolvedTime),
                              buildDetailRow("Agent Name", agent),
                              buildDetailRow("Agent Email", agentEmail),
                              buildDetailRow("Agent Phone", agentPhone),

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
                              final timeAgo = _formatTimeAgo(comment.createdAt.toString() ?? "");
                              final hasFiles = comment.files != null && comment.files!.isNotEmpty;
                              final isReplying = replyingToCommentIndex == index;

                              // Get all replies for this comment
                              final replies = allReplies.where((c) =>
                              c.parentId?.toString() == comment.id?.toString()
                              ).toList();
                              return Padding(
                                padding: EdgeInsets.only(bottom: 2.h),
                                child: Container(
                                                                decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              border: Border.all(color:AppColors.cardBorderColor,
                                                                ),
                                                                ),
                                  padding: EdgeInsets.all(2.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // User Info Row
                                      Row(
                                        children: [
                                          // User Avatar
                                          // User Avatar
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: AppColors.greenColor.withOpacity(0.2),
                                            child: user?.profilePhotoUrl != null
                                                ? ClipOval(
                                              child: Image.network(
                                                user!.profilePhotoUrl!,
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

                                      // Attachments Section
                                      if (hasFiles) ...[
                                        SizedBox(height: 1.5.h),
                                        Container(
                                          padding: EdgeInsets.all(2.w),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.attach_file,
                                                  color: AppColors.greenColor, size: 18),
                                              SizedBox(width: 2.w),
                                              CustomText(
                                                text: "${comment.files!.length} ${comment.files!.length == 1 ? 'Attachment' : 'Attachments'}",
                                                style: basicColorBold(13, AppColors.greenColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                              // Submit Button
                              GestureDetector(
                              onTap: _isSubmittingReply ? null : () => _submitReply(index, comment.id?.toString()),
                              child: Container(
                              padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                              color: _isSubmittingReply
                              ? Colors.grey
                                  : AppColors.greenColor,
                              borderRadius: BorderRadius.circular(6),
                              ),
                              child: _isSubmittingReply
                              ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              )
                                  : CustomText(
                              text: "Submit",
                              style: basicColorBold(13, Colors.white),
                              ),
                              ),
                              ),
                              ],),
                              ],),
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

          // Add Comment Section (Fixed at bottom)
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
                    onTap: _isSubmittingComment ? null : _submitComment,
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