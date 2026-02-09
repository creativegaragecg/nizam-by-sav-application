import 'package:file_picker/file_picker.dart';

abstract class BaseApiService {
  final String baseUrl = "";
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getGetBodyApiResponse(String url, Map<String, dynamic> data); // Changed Map to Map<String, dynamic>
  Future<dynamic> postPostApiResponse(String url, Map data,{bool? isAuth});
  Future<dynamic> postApiWithOutBody(String url,{bool? isAuth});
  Future<dynamic> patchPatchApiResponse(String url, Map data,);
  Future<dynamic> deleteDeleteApiResponse(String url);

  // Add this new method signature
  Future<dynamic> postMultipartApiResponse(String url, Map<String, dynamic> data, {PlatformFile? file,String? path});

}