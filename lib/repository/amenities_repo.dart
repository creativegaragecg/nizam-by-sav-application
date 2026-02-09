import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/amenities.dart';
import 'package:savvyions/models/availableSlots.dart';
import 'package:savvyions/models/events.dart';
import 'package:savvyions/models/myBookings.dart';
import 'package:savvyions/models/tickets.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class AmenitiesRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<AmenitiesModel> getAmenities() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.amenities}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.amenities);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Amenities response: $response");
        return AmenitiesModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return AmenitiesModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting amenities: $e");
      rethrow;
    }
  }


  Future<MyBookings> getAmenitiesBookings() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.amenities}/my-bookings");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.amenities}/my-bookings");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Amenities Booking response: $response");
        return MyBookings.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return MyBookings.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting amenities bookings: $e");
      rethrow;
    }
  }


  Future<AvailableSlots> getAvailableSlots(String id,var data) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.availableSlots}/$id");
      final response =
      await _apiService.getGetBodyApiResponse("${AppEndPoints.availableSlots}/$id",data);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Available slots response: $response");
        return AvailableSlots.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return AvailableSlots.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting slots: $e");
      rethrow;
    }

  }

  Future<dynamic> postBookings(dynamic data) async {
    try {
      debugPrint('Book Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse(AppEndPoints.book, data);
      return response;
    } catch (e) {
      showToast("Failed to book amenity");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }

  Future<dynamic> putBookings(dynamic data,String id) async {
    try {
      debugPrint('Update Amenity Data: $data');
      dynamic response = await _apiService
          .patchPatchApiResponse("${AppEndPoints.amenities}/booking/$id", data);
      return response;
    } catch (e) {
      showToast("Failed to update amenity");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }

}