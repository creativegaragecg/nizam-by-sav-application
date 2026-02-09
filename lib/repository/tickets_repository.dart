import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:savvyions/models/agents.dart';
import 'package:savvyions/models/ticketDetails.dart';
import 'package:savvyions/models/ticketOwnerList.dart';
import 'package:savvyions/models/ticketTenants.dart';
import 'package:savvyions/models/ticketTypes.dart';
import 'package:savvyions/models/tickets.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';


class TicketsRepository {
  final BaseApiService _apiService = NetworkApiService();


  Future<TicketsModel> getTickets() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.tickets}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.tickets);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Ticket response: $response");
        return TicketsModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return TicketsModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting tickets: $e");
      rethrow;
    }
  }

  Future<TicketDetails> getTicketDetails(String ticketId) async {
    try {
      debugPrint("APP URL: ${AppEndPoints.tickets}/$ticketId");
      final response =
      await _apiService.getGetApiResponse("${AppEndPoints.tickets}/$ticketId");

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Ticket Details response: $response");
        return TicketDetails.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return TicketDetails.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting ticket details: $e");
      rethrow;
    }
  }



  Future<TicketTypesModel> getTicketTypes() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.ticketTypes}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.ticketTypes);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Ticket Type response: $response");
        return TicketTypesModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return TicketTypesModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting ticket types: $e");
      rethrow;
    }
  }

  Future<AgentsModel> getAgents() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.agents}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.agents);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Get Agent response: $response");
        return AgentsModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return AgentsModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting agents: $e");
      rethrow;
    }
  }

  Future<TicketTenantModel> getTenants() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.getTenants}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.getTenants);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Get Ticket Tenants response: $response");
        return TicketTenantModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return TicketTenantModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting ticket tenants: $e");
      rethrow;
    }
  }


  Future<TicketOwnerModel> getOwners() async {
    try {
      debugPrint("APP URL: ${AppEndPoints.getOwner}");
      final response =
      await _apiService.getGetApiResponse(AppEndPoints.getOwner);

      // Handle direct user object response
      if (response is Map<String, dynamic>) {
        debugPrint("Get Ticket Owners response: $response");
        return TicketOwnerModel.fromJson(response);
      } else if (response is String) {
        // If it's a JSON string, decode it
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) {
          return TicketOwnerModel.fromJson(decoded);
        }
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error in getting ticket owners: $e");
      rethrow;
    }
  }


  /// Create Ticket (Original - without file)
  Future<dynamic> createTicketApi(dynamic data) async {
    try {
      debugPrint('Create Ticket Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse(AppEndPoints.createTicket, data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to create ticket");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }

  /// Create Ticket with File Upload (NEW METHOD)
  Future<dynamic> createTicketWithFileApi(Map<String, dynamic> data, {PlatformFile? file}) async {
    try {
      debugPrint('Create Ticket Data (with file): $data');
      if (file != null) {
        debugPrint('File to upload: ${file.name}, Size: ${file.size} bytes');
      }

      dynamic response = await _apiService.postMultipartApiResponse(
          AppEndPoints.createTicket,
          data,
          file: file
      );

      debugPrint('Create Ticket Response: $response');
      return response;

    } catch (e) {
      showToast("Failed to create ticket");
      debugPrint("Exception in createTicketWithFileApi: ${e.toString()}");
      rethrow;
    }
  }

/// https://web.creativegarage.org/api/tickets/163/reply
  Future<dynamic> createComment(dynamic data,String id) async {
    try {
      debugPrint('Create Comment Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse("${AppEndPoints.tickets}/$id/reply", data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to create comment");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }


}