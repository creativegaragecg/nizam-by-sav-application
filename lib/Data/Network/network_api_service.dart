import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../token.dart';
import '../app_exceptions.dart';
import 'base_api_service.dart';

class NetworkApiService extends BaseApiService {
  Dio dio = Dio();
  UserToken userToken = UserToken();

  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      await userToken.loadUserToken();
      Map<String, String> headers = {
        'Authorization': 'Bearer ${UserToken.token}',
        'Content-Type': 'application/json'
      };
      final response = await dio.get(
        url,
        options: Options(headers: headers),

      );
      responseJson = returnResponse(response);
      debugPrint("Response JSON: $responseJson");
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        throw FetchDataException('No Internet Connection');
      }
    }
    return responseJson;
  }

@override
  Future getGetBodyApiResponse(String url, Map<String, dynamic>  data) async {
    dynamic responseJson;
    try {
      debugPrint('Data: $data');

      await userToken.loadUserToken();
      Map<String, String> headers = {
        'Authorization': 'Bearer ${UserToken.token}',
        'Content-Type': 'application/json'
      };
      final response = await dio.get(
        url,
        data: jsonEncode(data),
        options: Options(headers: headers),

      );
      responseJson = returnResponse(response);
      debugPrint("Response JSON: $responseJson");
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        throw FetchDataException('No Internet Connection');
      }
    }
    return responseJson;
  }

  // NEW METHOD FOR MULTIPART FILE UPLOAD
  @override
  Future postMultipartApiResponse(String url, Map<String, dynamic> data, {PlatformFile? file,String? path}) async {
    debugPrint('===== MULTIPART REQUEST START =====');
    debugPrint('URL: $url');
    debugPrint('Data: $data');
    dynamic responseJson;

    try {
      await userToken.loadUserToken();

      // Create FormData
      FormData formData = FormData();

      // Add all text fields to FormData
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
        debugPrint('✓ Field added: $key = $value');
      });

      // IMPORTANT: Add empty files array if no file is provided
      // This matches your Postman request structure
      if (file != null && file.path != null) {
        try {
          String fileName = file.name;
          String filePath = file.path!;

          debugPrint('📎 Adding file:');
          debugPrint('  - Name: $fileName');
          debugPrint('  - Path: $filePath');
          debugPrint('  - Size: ${file.size} bytes');

          // Create MultipartFile from path
          MultipartFile multipartFile = await MultipartFile.fromFile(
            filePath,
            filename: fileName,
          );

          // Use 'files[]' notation for Laravel array
          formData.files.add(MapEntry(path??'files[]', multipartFile));
          debugPrint('✓ File successfully added to FormData as files[]');

        } catch (e) {
          debugPrint('❌ Error adding file to FormData: $e');
          throw Exception('Failed to add file: $e');
        }
      } else {
        debugPrint('ℹ️ No file to upload - sending empty files array');
        // Don't add anything for files if empty - Laravel will handle it
      }

      // Set headers - Don't set Content-Type, let Dio handle it
      Map<String, String> headers = {
        'Authorization': 'Bearer ${UserToken.token}',
        'Accept': 'application/json',
      };

      debugPrint('📤 Headers: $headers');
      debugPrint('📤 Sending multipart request...');

      final startTime = DateTime.now();

      // Send the request
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      ).timeout(const Duration(seconds: 60));

      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inSeconds;

      debugPrint('📥 Response received:');
      debugPrint('  - Status Code: ${response.statusCode}');
      debugPrint('  - Response Time: $responseTime s');
      debugPrint('  - Response Data: ${response.data}');
      debugPrint('===== MULTIPART REQUEST END =====');

      responseJson = returnResponse(response);

      String responseString;
      if (responseJson is Map<String, dynamic>) {
        responseString = jsonEncode(responseJson);
      } else {
        responseString = responseJson.toString();
      }

      return responseString;

    } on TimeoutException catch (_) {
      debugPrint('❌ Request timed out');
      Fluttertoast.showToast(msg: 'Request timed out');
      throw FetchDataException('Request timed out');
    } on DioException catch (e) {
      debugPrint('❌ DioException occurred:');
      debugPrint('  - Type: ${e.type}');
      debugPrint('  - Message: ${e.message}');
      debugPrint('  - Status Code: ${e.response?.statusCode}');
      debugPrint('  - Response Data: ${e.response?.data}');

      if (e.response != null) {
        if (e.response?.statusCode == 422) {
          debugPrint('⚠️ 422 Validation Error');
          debugPrint('  Server validation failed. Check response for details:');
          debugPrint('  ${e.response?.data}');

          // Try to extract validation errors
          if (e.response?.data is Map) {
            var errors = e.response?.data['errors'] ?? e.response?.data['message'];
            debugPrint('  Validation errors: $errors');
            Fluttertoast.showToast(msg: 'Validation failed: $errors');
          }
        }
        responseJson = returnResponse(e.response!);
      } else {
        Fluttertoast.showToast(msg: 'No Internet Connection');
        throw FetchDataException('No Internet Connection');
      }
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      Fluttertoast.showToast(msg: 'Failed to upload: $e');
      rethrow;
    }
  }

  @override
  Future postPostApiResponse(String url, Map data, {bool? isAuth}) async {
    debugPrint('URL: $url');
    debugPrint('Network Data: $data');
    dynamic responseJson;

    try {
      await userToken.loadUserToken();
      Map<String, String> headers = {
        'Authorization': 'Bearer ${UserToken.token}',
        'Content-Type': 'application/json'
      };

      Map<String, String> headers2 = {'Content-Type': 'application/json'};

      debugPrint('Network Headers: $headers');
      debugPrint('Network Headers2: $headers2');

      final startTime = DateTime.now();

      final response = await dio
          .post(
            url,
            data: jsonEncode(data),
            options: Options(headers: isAuth == true ? headers2 : headers),
          )
          .timeout(const Duration(seconds: 30));

      print("Post response:$response");
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inSeconds;
      debugPrint('Response Time: $responseTime s');
      responseJson = returnResponse(response);

      String responseString;
      if (responseJson is Map<String, dynamic>) {
        responseString = jsonEncode(responseJson);
        print("Post response:$responseString");
      } else {
        responseString = responseJson.toString();
        print("Post response:$responseString");
      }

      debugPrint(
          'Returning Raw Response JSON as String (Local): $responseString');
      return responseString;
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'Request timed out');
      throw FetchDataException('Request timed out');
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        Fluttertoast.showToast(msg: 'No Internet Connection');
        throw FetchDataException('No Internet Connection');
      }
    }
  }


  @override
  Future postApiWithOutBody(String url, {bool? isAuth}) async {
    debugPrint('URL: $url');
    dynamic responseJson;

    try {
      await userToken.loadUserToken();
      Map<String, String> headers = {
        'Authorization': 'Bearer ${UserToken.token}',
        'Content-Type': 'application/json'
      };

      Map<String, String> headers2 = {'Content-Type': 'application/json'};

      debugPrint('Network Headers: $headers');
      debugPrint('Network Headers2: $headers2');

      final startTime = DateTime.now();

      final response = await dio
          .post(
        url,
        options: Options(headers: isAuth == true ? headers2 : headers),
      )
          .timeout(const Duration(seconds: 30));

      print("Post response:$response");
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inSeconds;
      debugPrint('Response Time: $responseTime s');
      responseJson = returnResponse(response);

      String responseString;
      if (responseJson is Map<String, dynamic>) {
        responseString = jsonEncode(responseJson);
        print("Post response:$responseString");
      } else {
        responseString = responseJson.toString();
        print("Post response:$responseString");
      }

      debugPrint(
          'Returning Raw Response JSON as String (Local): $responseString');
      return responseString;
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'Request timed out');
      throw FetchDataException('Request timed out');
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        Fluttertoast.showToast(msg: 'No Internet Connection');
        throw FetchDataException('No Internet Connection');
      }
    }
  }


  @override
  Future patchPatchApiResponse(
    String url,
    Map data,
  ) async {
    Map<String, String>? headers;
    await userToken.loadUserToken();
    headers = {
      'Authorization': 'Bearer ${UserToken.token}',
      'Content-Type': 'application/json'
    };
    debugPrint('URL: $url');
    debugPrint('Network Headers: $headers');
    debugPrint('Network Data: $data');
    dynamic responseJson;

    try {
      final startTime = DateTime.now();

      final response = await dio
          .patch(
            url,
            data: jsonEncode(data),
            options: Options(headers: headers),
          )
          .timeout(const Duration(seconds: 30));
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inSeconds;
      debugPrint('Response Time: $responseTime s');
      responseJson = returnResponse(response);

      String responseString;
      if (responseJson is Map<String, dynamic>) {
        responseString = jsonEncode(responseJson);
      } else {
        responseString = responseJson.toString();
      }

      debugPrint(
          'Returning Raw Response JSON as String (Local): $responseString');
      return responseString;
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'Request timed out');
      throw FetchDataException('Request timed out');
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        Fluttertoast.showToast(msg: 'No Internet Connection');
        throw FetchDataException('No Internet Connection');
      }
    }
  }

  Future deleteDeleteApiResponse(String url) async {
    Map<String, String>? headers;
    await userToken.loadUserToken();
    headers = {
      'Authorization': 'Bearer ${UserToken.token}',
      'Content-Type': 'application/json'
    };
    debugPrint('URL: $url');
    debugPrint('Network Headers: $headers');
    dynamic responseJson;

    try {
      final startTime = DateTime.now();

      final response = await dio
          .delete(
            url,
            options: Options(headers: headers),
          )
          .timeout(const Duration(seconds: 30));
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inSeconds;
      debugPrint('Response Time: $responseTime s');
      responseJson = returnResponse(response);

      String responseString;
      if (responseJson is Map<String, dynamic>) {
        responseString = jsonEncode(responseJson);
      } else {
        responseString = responseJson.toString();
      }

      debugPrint(
          'Returning Raw Response JSON as String (Local): $responseString');
      return responseString;
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'Request timed out');
      throw FetchDataException('Request timed out');
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        Fluttertoast.showToast(msg: 'No Internet Connection');
        throw FetchDataException('No Internet Connection');
      }
    }
  }

  dynamic returnResponse(dynamic response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = response.data;
        return responseJson;
      case 204:
        dynamic responseJson = response.data;
        return responseJson;
      case 302: // Add this case
        debugPrint('⚠️ Received 302 Redirect');
        debugPrint('Redirect Location: ${response.headers['location']}');
        throw FetchDataException('Server redirected the request. Check API endpoint.');
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 404:
        throw UnauthorisedException(response.data.toString());

      case 422: // Validation error
        throw BadRequestException(
            response.data['message'] ?? 'Validation failed'
        );
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server with status code : ${response.statusCode}');
    }
  }
}
