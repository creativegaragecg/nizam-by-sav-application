import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:savvyions/models/amenities.dart';
import 'package:savvyions/models/availableSlots.dart';
import 'package:savvyions/models/events.dart';
import 'package:savvyions/repository/amenities_repo.dart';
import 'package:savvyions/repository/events_repository.dart';

import '../Data/app_exceptions.dart';
import '../Utils/Constants/utils.dart';
import '../models/myBookings.dart';



class AmenitiesViewModel extends ChangeNotifier {
  final _myRepo = AmenitiesRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  AmenitiesModel? _amenitiesModel;
  AmenitiesModel? get amenitiesModel => _amenitiesModel;

  MyBookings? _bookings;
  MyBookings? get bookings => _bookings;

 AvailableSlots? _availableSlots;
  AvailableSlots? get availableSlots => _availableSlots;


  Future<void> fetchAmenities(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getAmenities();
      _amenitiesModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load amenities: ${e.toString()}");
      setLoading(false);
      _amenitiesModel = null;
    }
  }

  Future<void> fetchAmenitiesBookings(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getAmenitiesBookings();
      _bookings = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load amenities bookings: ${e.toString()}");
      setLoading(false);
      _bookings = null;
    }
  }


  Future<void> fetchSlots(BuildContext context,String id,var data) async {
    try {
      setLoading(true);
      final response = await _myRepo.getAvailableSlots(id,data);
      _availableSlots = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load slots: ${e.toString()}");
      setLoading(false);
      _availableSlots = null;
    }
  }



  Future<void> bookAmenity(dynamic data, BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.postBookings(data);

      debugPrint('Create Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'] ?? 'Booked successfully';
        Navigator.pop(context);
        showToast(msg);
      } else {
        String errorMsg = decoded['message'] ?? 'Failed to book amenity';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }
    } on BadRequestException catch (e) {
      // Handle 422 and 400 errors - THIS WILL NOW SHOW THE CORRECT MESSAGE
      debugPrint("Booking validation error: ${e.toString()}");
      showToast(e.toString());
    } on UnauthorisedException catch (e) {
      debugPrint("Authorization error: ${e}");
      showToast(e.toString() ?? "Session expired. Please login again.");
    } on FetchDataException catch (e) {
      debugPrint("Network error: ${e}");
      showToast(e.toString() ?? "Network error occurred");
    } catch (e) {
      debugPrint("Unexpected error: ${e.toString()}");
      showToast("An error occurred. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateAmenity(dynamic data, BuildContext context,String id) async {
    try {
      final response = await _myRepo.putBookings(data,id);

      debugPrint('Update Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // FIXED: Check for success field and data field (not comment field)
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'] ?? 'Updated successfully';

        // Refresh the details to show the new comment
             fetchAmenitiesBookings(context);
        Navigator.pop(context);
        showToast(msg);
      } else {
        String errorMsg = decoded['message'] ?? 'Failed to update amenity';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      showToast("An error occurred: ${e.toString()}");
    }
  }


}