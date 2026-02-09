import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import 'package:savvyions/providers/forums_provider.dart';
import 'package:savvyions/providers/unitInspection_provider.dart';
import 'package:savvyions/providers/violationRecord_provider.dart';
import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/customBgScreen.dart';
import '../../Utils/Custom/customCards.dart';
import '../../Utils/Custom/custom_text.dart';

class ForumDetails extends StatefulWidget {
  const ForumDetails({super.key, required this.id});
  final String id;

  @override
  State<ForumDetails> createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails> {
  // Track which comment is being replied to
  int? replyingToCommentIndex;

  // Controllers for each comment reply
  Map<int, TextEditingController> replyControllers = {};
  Map<int, FocusNode> replyFocusNodes = {};

  // Main comment controller (for bottom section)
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  // File upload variables for each comment
  Map<int, PlatformFile?> selectedFiles = {};
  Map<int, String?> fileNames = {};
  bool _isSubmittingReply = false;
  bool _isSubmittingComment = false;

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
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchDetails() async {
    Provider.of<ForumsViewModel>(
      context,
      listen: false,
    ).fetchForumDetails(context, widget.id);
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

  // Submit main comment (from bottom section)
  Future<void> _submitComment() async {
    String commentText = _commentController.text.trim();

    if (commentText.isEmpty) {
      showToast("Write your comment");
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    var provider = Provider.of<ForumsViewModel>(
      context,
      listen: false,
    );

    var data = {
      "reply": "<div>$commentText</div>",
      "parent_reply_id": null,  // This might be the issue


    };

    try {
      await provider.addComment(data, context, widget.id);

      // Clear the comment field after successful submission
      _commentController.clear();
      showToast("Comment added successfully");
    } finally {
      setState(() {
        _isSubmittingComment = false;
      });
    }
  }

  // Submit reply to a specific comment
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

    var provider = Provider.of<ForumsViewModel>(
      context,
      listen: false,
    );

    var data = {
      "reply": "<div>$commentText</div>",
      "parent_reply_id": parentId,
    };

    try {
      await provider.addComment(data, context, widget.id);

      // Clear the reply field after successful submission
      controller.clear();
      setState(() {
        replyingToCommentIndex = null;
        selectedFiles[commentIndex] = null;
        fileNames[commentIndex] = null;
      });
      showToast("Reply added successfully");
    } finally {
      setState(() {
        _isSubmittingReply = false;
      });
    }
  }

  // Widget to build a single reply item
  Widget _buildReplyItem(dynamic reply) {
    final user = reply.user;
    final message = _stripHtmlTags(reply.reply ?? "");
    final timeAgo = _formatTimeAgo(reply.createdAt.toString());

    return Container(
      margin: EdgeInsets.only(left: 1.w, top: 1.h),
      padding: EdgeInsets.all(2.w),
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
                child: user?.profileImage != null
                    ? ClipOval(
                  child: Image.network(
                    user!.profileImage!,
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
                      style: basicColorBold(13, Colors.black),
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
            style: basicColor(13, Colors.black87),
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
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.w),
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
                  text: "Forum Details",
                  style: basicColorBold(18, Colors.black),
                ),
              ],
            ),
          ),


          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.w),
            child: customHeaderLine(context),
          ),

          SizedBox(height: 3.h,),
          // Content
          Expanded(
            child: Consumer<ForumsViewModel>(
              builder: (context, value, child) {
                if (value.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  );
                }

                Color getStatusColor(String status) {
                  switch (status.toLowerCase().trim()) {
                    case 'public':
                      return Colors.blue;
                    case 'private':
                      return Colors.red;
                    default:
                      return Colors.black45;
                  }
                }

                var forum = value.detailModel?.data;
                String title = forum?.title ?? "N/A";
             //   String date = forum?.date.toString() ?? "N/A";
             //   date=formatDateTime(date);
                String discussionType = forum?.discussionType ?? "N/A";
                String createdBy = forum?.createdBy?.name ?? "N/A";
                String categoryName = forum?.category?.name ?? "N/A";
                var fileList = forum?.files ?? [];

                final comments = value.detailModel?.data?.replies ?? [];

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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(
                                        text: "Category",
                                        style: basicColorBold(15, Colors.black),
                                      ),
                                      SizedBox(width: 3.w),
                                      CustomText(
                                        text: categoryName,
                                        style: basicColorBold(16, AppColors.greenColor),
                                      ),
                                    ],
                                  ),
                                  IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.w, vertical: 0.6.h),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(discussionType)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          text: discussionType.toTitleCase(),
                                          style: basicColorBold(
                                              15, getStatusColor(discussionType)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              buildDetailRow("Author", createdBy),
                           //   buildDetailRow("Created", date),
                              buildDetailRow("Replies", comments.length.toString()),
                              SizedBox(height: 1.h),
                              ForumAttachmentsWidget(
                                files: fileList,
                              )
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
                                text: "No comments yet. Be the first to comment!",
                                style: basicColor(14, AppColors.hintText),
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
                              final message = _stripHtmlTags(comment.reply ?? "");
                              final timeAgo =
                              _formatTimeAgo(comment.createdAt.toString());
                              final isReplying = replyingToCommentIndex == index;
                              final replies = comment.childReply ?? [];

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
                                            backgroundColor: AppColors.greenColor
                                                .withOpacity(0.2),
                                            child: user?.profileImage != null
                                                ? ClipOval(
                                              child: Image.network(
                                                user!.profileImage!,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return CustomText(
                                                    text: (user.name ?? "U")[0]
                                                        .toUpperCase(),
                                                    style: basicColorBold(16,
                                                        AppColors.greenColor),
                                                  );
                                                },
                                              ),
                                            )
                                                : CustomText(
                                              text: (user?.name ?? "U")[0]
                                                  .toUpperCase(),
                                              style: basicColorBold(
                                                  16, AppColors.greenColor),
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text:
                                                  user?.name ?? "Unknown User",
                                                  style: basicColorBold(
                                                      15, Colors.black),
                                                ),
                                                if (timeAgo.isNotEmpty)
                                                  CustomText(
                                                    text: timeAgo,
                                                    style: basicColor(
                                                        14, Colors.black),
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
                                        style: basicColor(14.5, Colors.black87),
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
                                              text: isReplying
                                                  ? "Cancel"
                                                  : "Reply",
                                              style: basicColorBold(
                                                  13, AppColors.greenColor),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Display existing replies
                                      if (replies.isNotEmpty) ...[
                                        SizedBox(height: 1.h),
                                        ...replies
                                            .map((reply) => _buildReplyItem(reply))
                                            .toList(),
                                      ],

                                      // Reply Section (Shows when replying)
                                      if (isReplying) ...[
                                        SizedBox(height: 1.5.h),
                                        Container(
                                          padding: EdgeInsets.all(3.w),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            border: Border.all(
                                                color:
                                                AppColors.cardBorderColor),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text:
                                                "Reply to ${user?.name ?? 'this comment'}",
                                                style: basicColorBold(
                                                    13, AppColors.hintText),
                                              ),
                                              SizedBox(height: 1.h),
                                              TextField(
                                                controller:
                                                _getReplyController(index),
                                                focusNode:
                                                _getReplyFocusNode(index),
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  hintText:
                                                  "Write your reply...",
                                                  hintStyle: TextStyle(
                                                    color: AppColors.hintText,
                                                    fontSize: 14,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  enabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                    borderSide: BorderSide(
                                                        color: AppColors
                                                            .greenColor,
                                                        width: 1.5),
                                                  ),
                                                  contentPadding:
                                                  EdgeInsets.all(3.w),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 1.h),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  // Submit Button
                                                  GestureDetector(
                                                    onTap: _isSubmittingReply
                                                        ? null
                                                        : () => _submitReply(
                                                        index,
                                                        comment.id
                                                            ?.toString()),
                                                    child: Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                        horizontal: 5.w,
                                                        vertical: 1.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: _isSubmittingReply
                                                            ? Colors.grey
                                                            : AppColors
                                                            .greenColor,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(8),
                                                      ),
                                                      child: _isSubmittingReply
                                                          ? SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                              Colors
                                                                  .white),
                                                        ),
                                                      )
                                                          : CustomText(
                                                        text: "Submit",
                                                        style:
                                                        basicColorBold(
                                                            13,
                                                            Colors
                                                                .white),
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

                        // Extra padding at bottom for fixed comment section
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Fixed Bottom Comment Section
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


class ForumAttachmentsWidget extends StatefulWidget {
  final List<dynamic> files;

  const ForumAttachmentsWidget({
    Key? key,
    required this.files,
  }) : super(key: key);

  @override
  State<ForumAttachmentsWidget> createState() => _ForumAttachmentsWidgetState();
}

class _ForumAttachmentsWidgetState extends State<ForumAttachmentsWidget> {
  bool isExpanded = false;
  Map<int, double> downloadProgress = {};

  // Get file extension from URL
  String getFileExtension(String url) {
    try {
      Uri uri = Uri.parse(url);
      String path = uri.path;
      return path.split('.').last.toLowerCase();
    } catch (e) {
      return '';
    }
  }

  // Get file name from URL
  String getFileName(String url) {
    try {
      Uri uri = Uri.parse(url);
      return uri.pathSegments.last;
    } catch (e) {
      return 'Unknown file';
    }
  }

  // Determine file type
  String getFileType(String extension) {
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      return 'image';
    } else if (['pdf'].contains(extension)) {
      return 'pdf';
    } else if (['doc', 'docx'].contains(extension)) {
      return 'document';
    } else if (['xls', 'xlsx'].contains(extension)) {
      return 'excel';
    } else if (['zip', 'rar'].contains(extension)) {
      return 'archive';
    } else {
      return 'file';
    }
  }

  // Get icon for file type
  IconData getFileIcon(String fileType) {
    switch (fileType) {
      case 'image':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'document':
        return Icons.description;
      case 'excel':
        return Icons.table_chart;
      case 'archive':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Get color for file type
  Color getFileColor(String fileType) {
    switch (fileType) {
      case 'image':
        return Colors.blue;
      case 'pdf':
        return Colors.red;
      case 'document':
        return Colors.blue.shade700;
      case 'excel':
        return Colors.green;
      case 'archive':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Download file
  Future<void> downloadFile(String url, String fileName, int index) async {
    try {
      // Request permissions based on Android version
      bool hasPermission = false;

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;

        if (androidInfo.version.sdkInt >= 33) {
          // Android 13+ (API 33+)
          // No special storage permissions needed for app-specific directory
          hasPermission = true;
        } else if (androidInfo.version.sdkInt >= 30) {
          // Android 11-12 (API 30-32)
          var status = await Permission.manageExternalStorage.request();
          hasPermission = status.isGranted;

          if (!hasPermission) {
            status = await Permission.storage.request();
            hasPermission = status.isGranted;
          }
        } else {
          // Android 10 and below
          var status = await Permission.storage.request();
          hasPermission = status.isGranted;
        }
      } else {
        hasPermission = true;
      }

      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Storage permission is required to download files'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get download directory
      Directory? directory;
      String savePath;

      if (Platform.isAndroid) {
        // Use app-specific external storage (no permission needed on Android 13+)
        directory = await getExternalStorageDirectory();

        // Create a Downloads folder within app directory
        if (directory != null) {
          final downloadDir = Directory('${directory.path}/Downloads');
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          savePath = '${downloadDir.path}/$fileName';
          print("Saved path:$savePath");
        } else {
          throw Exception('Could not get storage directory');
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
        savePath = '${directory.path}/$fileName';
      }

      // Download with progress
      Dio dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress[index] = received / total;
            });
          }
        },
      );

      setState(() {
        downloadProgress.remove(index);
      });

     showToast("Downloaded successfully!");
    } catch (e) {
      setState(() {
        downloadProgress.remove(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    color: AppColors.greenColor,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: CustomText(
                      text: "Attachments (${widget.files.length})",
                      style: basicColorBold(15, Colors.black87),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.greenColor,
                  ),
                ],
              ),
            ),
          ),

          // Expanded file list
          if (isExpanded)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.w,
                  childAspectRatio: 0.85,
                ),
                itemCount: widget.files.length,
                itemBuilder: (context, index) {
                  final file = widget.files[index];

                  // FIX: Extract the file URL from the object
                  final fileUrl = file.file;

                  final fileName = getFileName(fileUrl);
                  final extension = getFileExtension(fileUrl);
                  final fileType = getFileType(extension);
                  final fileColor = getFileColor(fileType);
                  final fileIcon = getFileIcon(fileType);
                  final isDownloading = downloadProgress.containsKey(index);

                  return GestureDetector(
                    onTap: isDownloading
                        ? null
                        : () => downloadFile(fileUrl, fileName, index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // File preview
                              Expanded(
                                child: Center(
                                  child: fileType == 'image'
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      fileUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          fileIcon,
                                          size: 40,
                                          color: fileColor,
                                        );
                                      },
                                    ),
                                  )
                                      : Icon(
                                    fileIcon,
                                    size: 40,
                                    color: fileColor,
                                  ),
                                ),
                              ),

                              // File name
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(1.5.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    CustomText(
                                      text: fileName.length > 15
                                          ? '${fileName.substring(0, 12)}...'
                                          : fileName,
                                      style: basicColor(11, Colors.black87),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (extension.isNotEmpty)
                                      CustomText(
                                        text: extension.toUpperCase(),
                                        style: basicColor(9, fileColor),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Download progress overlay
                          if (isDownloading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        value: downloadProgress[index],
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                        strokeWidth: 3,
                                      ),
                                      SizedBox(height: 1.h),
                                      CustomText(
                                        text: '${(downloadProgress[index]! * 100).toInt()}%',
                                        style: basicColorBold(12, Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Download icon
                          if (!isDownloading)
                            Positioned(
                              top: 1.w,
                              right: 1.w,
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}







