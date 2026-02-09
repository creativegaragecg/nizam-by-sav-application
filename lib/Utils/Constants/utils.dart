import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Custom/custom_text.dart';
import 'colors.dart';
import 'styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

void close(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop('dialog');
}

ColorFilter getSvgColor(Color color) {
  return ColorFilter.mode(color, BlendMode.srcIn);
}

void showToast(String str) {
  Fluttertoast.showToast(
    msg: str,
    fontSize: 15.sp,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor:Colors.grey,
    // fontAsset: "assets/fonts/PS-R.ttf"
  );
}


/// Returns true if the given email is in a valid format.
bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$', caseSensitive: false);
  return emailRegex.hasMatch(email);
}


 Future<String> getDeviceName() async {
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
String deviceName = '';

try {
if (Platform.isAndroid) {
AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
/*
deviceName = '${androidInfo.brand} ${androidInfo.model}';
*/
deviceName = '${androidInfo.model}';
// Example: "Samsung SM-G960F" or "Google Pixel 5"
} else if (Platform.isIOS) {
IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
deviceName = iosInfo.name ?? iosInfo.model;
// Example: "John's iPhone" or "iPhone 14 Pro"
}
} catch (e) {
debugPrint('Error getting device name: $e');
deviceName = 'Unknown Device';
}

return deviceName;
}

// Helper method to extract message
String extractErrorMessage(String exceptionString) {
try {
// Check if it contains JSON
if (exceptionString.contains('{') && exceptionString.contains('}')) {
// Extract JSON part
int startIndex = exceptionString.indexOf('{');
int endIndex = exceptionString.lastIndexOf('}') + 1;
String jsonString = exceptionString.substring(startIndex, endIndex);

// Parse JSON
Map<String, dynamic> errorJson = jsonDecode(jsonString);

// Return message
return errorJson['message'] ?? 'An error occurred';
}

// If no JSON, return original
return exceptionString;
} catch (e) {
return 'An error occurred';
}
}

Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 0.35.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 35.w,
          child: CustomText(
            text: "$label",
            style: basicColor(14.5, Colors.black),
          ),
        ),
        Expanded(
          child: CustomText(
            text: value,
            style: basicColor(14.5, Colors.black87),
          ),
        ),
      ],
    ),
  );
}

Widget buildSectionTitle(String title, IconData icon,{bool? isDownload}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: Colors.black87),
              SizedBox(width: 2.w),
              CustomText(text: title, style: basicColorBold(15, Colors.black87)),
            ],
          ),

          if(isDownload==true)
          GestureDetector(
            onTap: (){

            },
            child: Padding(
              padding:  EdgeInsets.only(right: 1.w),
              child: Icon(Icons.download,color: Colors.black,size: 20,),
            ),
          )
        ],
      ),
      SizedBox(height: 0.3.h),
      Divider(color: Colors.grey.withOpacity(0.5)),
      SizedBox(height: 0.3.h),
    ],
  );
}


// Helper methods (add these to your State class)
Widget buildHeaderCell(String text, double flex,{Color? textColor,VoidCallback? onPressed}) {
  return Expanded(
    flex: (flex * 10).toInt(),
    child: GestureDetector(
      onTap:onPressed ,
      child: CustomText(
        text: text,
        style: basicColorBold(13.5, textColor??Colors.black),
        align: TextAlign.center,
      ),
    ),
  );
}

Widget buildDataCell(String text, double flex,{Color? textColor}) {
  return Expanded(
    flex: (flex * 10).toInt(),
    child: CustomText(
      text: text,
      style: basicColor(12.5, textColor??Colors.black87),
      align: TextAlign.center,
    ),
  );
}

Widget unitDetailRow(String label, String value, TextStyle? style,{Color? color}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 0.6.h),
    child:
    Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to top for multi-line
      children: [
        SizedBox(
          width: 28.w, // Fixed width for labels
          child: CustomText(
            text: "$label",
            style: basicColor(14.5 ,color??Colors.black),
          ),
        ),
        SizedBox(width: 2.w), // Add some spacing
        Expanded( // This allows the value to take remaining space and wrap
          child: CustomText(
            align: TextAlign.left,
            text: value,
            style: style ?? basicColor(14.5, Colors.black87),
            overflow: TextOverflow.visible, // Show all text
          ),
        ),
      ],
    ),
  );
}

String formatTitle(String? text) {
  if (text == null || text.isEmpty) return "N/A";
  return text.split(' ')
      .map((word) => word.isEmpty
      ? word
      : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}

Widget buildStatCard({
  required IconData icon,
  required String label,
  required int count,
  required Color color,
}) {
  return Container(
    width: 45.w,
    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: label,
              style: basicColor(14, Colors.black),
            ),
            CustomText(
              text: count.toString(),
              style: basicColorBold(18, Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}
buildLabelWithDropDown(
    BuildContext context,
    String text,
    String hintText,
    List<String> list,
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
          value: selectedValue,
          decoration: InputDecoration(
         hint: CustomText(
          text: hintText,
          style: basicColor(14.5, Colors.black),
          ),
        // OR if you want even more control:
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 15.5),
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
          items: list.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CustomText(
                text: value,
                style: basicColor(14.5, Colors.black),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

Widget customHeaderLine(BuildContext context){
  return  Column(
    children: [
      SizedBox(height: 1.5.h,),


      Container(
        height: 0.1.h,
        width: 100.w,
        color: AppColors.greenColor,
      ),
    ],
  );
}

Widget viewDetail(BuildContext context,VoidCallback onPressed){
  return  GestureDetector(
      onTap:onPressed,
      child: Icon(Icons.remove_red_eye_outlined,color: AppColors.greenColor,size: 19,));

}

Widget labelText(BuildContext context,String text){
  return  Column(
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
    ],
  );
}


extension IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (T element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}


Future<void> downloadImage(String imageUrl, String title) async {
  try {
    // Show loading indicator
    showToast("Downloading image...");

    // Request storage permission based on Android version
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+)
      if (await Permission.photos.isPermanentlyDenied ||
          await Permission.mediaLibrary.isPermanentlyDenied) {
        openAppSettings();
        return;
      }

      // Request appropriate permission
      PermissionStatus status;
      if (Platform.isAndroid) {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        if (deviceInfo.version.sdkInt >= 33) {
          status = await Permission.photos.request();
        } else if (deviceInfo.version.sdkInt >= 30) {
          status = await Permission.manageExternalStorage.request();
        } else {
          status = await Permission.storage.request();
        }

        if (!status.isGranted) {
          showToast("Storage permission denied");
          return;
        }
      }
    }

    // Get download directory
    Directory? directory;
    String savePath;

    if (Platform.isAndroid) {
      // Use app-specific directory that doesn't require permissions
      directory = await getExternalStorageDirectory();
      // Create a custom directory in app storage
      String customPath = '${directory!.path}/SavedImages';
      await Directory(customPath).create(recursive: true);

      // Create filename from title and timestamp
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = '${title.replaceAll(RegExp(r'[^\w\s]+'), '')}_$timestamp.jpg';
      savePath = '$customPath/$fileName';
    } else {
      directory = await getApplicationDocumentsDirectory();
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = '${title.replaceAll(RegExp(r'[^\w\s]+'), '')}_$timestamp.jpg';
      savePath = '${directory.path}/$fileName';
    }

    // Download the image
    Dio dio = Dio();
    await dio.download(
      imageUrl,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );

    showToast("Image saved successfully");
    print('Image downloaded to: $savePath');
  } catch (e) {
    print('Error downloading image: $e');
    showToast("Failed to download image");
  }
}


Future<void> downloadFile(String fileName, String fileUrl) async {
  try {
    // Request storage permission
    var status = await Permission.storage.request();

    if (status.isGranted) {
      showToast("Downloading...");

      // Get download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      String filePath = '${directory!.path}/$fileName';

      // Download file
      final response = await http.get(Uri.parse(fileUrl));
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      showToast("Downloaded to: ${directory.path}");
    } else {
      showToast("Storage permission denied");
    }
  } catch (e) {
    debugPrint("Download error: $e");
    showToast("Failed to download file");
  }
}


Future<void> pickFile(Function(PlatformFile?, String?) onFileSelected) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      PlatformFile selectedFile = result.files.first;
      String fileName = result.files.first.name;
      onFileSelected(selectedFile, fileName);
      print('File selected: $fileName');
    }
  } catch (e) {
    print('Error picking file: $e');
  }
}



extension TimeFormatter on String {
  /// Converts "04:00:00" or "18:00:00" to "4:00 AM" or "6:00 PM"
  String to12HourFormat() {
    try {
      // Parse the input time (assumes format HH:mm:ss)
      final DateFormat parser = DateFormat('HH:mm:ss');
      final DateTime dateTime = parser.parseStrict(this);

      // Format to 12-hour with AM/PM, no leading zero on hour
      final DateFormat formatter = DateFormat('h:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      // Fallback if parsing fails
      return this;
    }
  }

  /// Optional: If you want exactly "4:00 AM" even when minutes are 00
  /// (the above already does this correctly)
  String to12HourFormatClean() {
    try {
      final DateFormat parser = DateFormat('HH:mm:ss');
      final DateTime dateTime = parser.parseStrict(this);

      final int hour = dateTime.hour;
      final int displayHour = hour % 12 == 0 ? 12 : hour % 12;
      final String period = hour < 12 ? 'AM' : 'PM';
      final String minute = dateTime.minute.toString().padLeft(2, '0');

      if (minute == '00') {
        return '$displayHour:00 $period';
      } else {
        return '$displayHour:$minute $period';
      }
    } catch (e) {
      return this;
    }
  }
}


String dateConverted(String date) {
  // Default fallback
  if (date.isEmpty || date == "N/A") {
    return "N/A";
  }

  try {
    // Parse the date string like "2025-12-15 00:00:00.000"
    DateTime dateTime = DateTime.parse(date.trim());

    // Format as "15 December 2025"
    return DateFormat('d MMMM yyyy').format(dateTime);
  } catch (e) {
    // If parsing fails, return a safe fallback
    return "Invalid Date";
  }
}



// Add this function in your utils file or at the top of your widget class
String formatDateTime(dynamic dateTime) {
  if (dateTime == null) return "N/A";

  try {
    DateTime dt;

    // Handle if it's already a DateTime object
    if (dateTime is DateTime) {
      dt = dateTime;
    }
    // Handle if it's a String
    else if (dateTime is String) {
      dt = DateTime.parse(dateTime);
    }
    else {
      return "N/A";
    }

    // Format: "27 Dec 2025 00:00"
    String day = dt.day.toString().padLeft(2, '0');
    String month = _getMonthName(dt.month);
    String year = dt.year.toString();
    String hour = dt.hour.toString().padLeft(2, '0');
    String minute = dt.minute.toString().padLeft(2, '0');

    return "$day $month $year $hour:$minute";
  } catch (e) {
    print("Error formatting date: $e");
    return "N/A";
  }
}

String _getMonthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}

Future<bool> requestPermission() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      return true;
    } else {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
  }
  return true;
}
