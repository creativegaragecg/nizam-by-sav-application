import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:savvyions/models/agents.dart';
import 'package:savvyions/models/ticketTenants.dart';
import 'package:savvyions/models/ticketTypes.dart';
import 'package:savvyions/repository/tickets_repository.dart';
import '../Utils/Constants/utils.dart';
import '../models/ticketDetails.dart';
import '../models/ticketOwnerList.dart';
import '../models/tickets.dart';


class TicketsViewModel extends ChangeNotifier {
  final _myRepo = TicketsRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  TicketsModel? _ticketsModel;
  TicketsModel? get ticketsModel => _ticketsModel;

  TicketTypesModel? _ticketTypesModel;
  TicketTypesModel? get ticketTypesModel => _ticketTypesModel;

  AgentsModel? _agentsModel;
  AgentsModel? get agentsModel => _agentsModel;

  TicketTenantModel? _tenantModel;
  TicketTenantModel? get tenantModel => _tenantModel;


  TicketDetails? _ticketDetails;
  TicketDetails? get ticketDetails => _ticketDetails;

  TicketOwnerModel? _ownerModel;
  TicketOwnerModel? get ownerModel => _ownerModel;




  Future<void> fetchTickets(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getTickets();
      _ticketsModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load tickets: ${e.toString()}");
      setLoading(false);
      _ticketsModel = null;
    }
  }

  Future<void> fetchTicketDetails(BuildContext context,String ticketId) async {
    try {
      setLoading(true);
      final response = await _myRepo.getTicketDetails(ticketId);
      _ticketDetails = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load ticket details: ${e.toString()}");
      setLoading(false);
      _ticketDetails = null;
    }
  }


  Future<void> fetchTicketTypes(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getTicketTypes();
      _ticketTypesModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load ticket types: ${e.toString()}");
      setLoading(false);
      _ticketTypesModel = null;
    }
  }


  Future<void> fetchAgents(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getAgents();
      _agentsModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load agents: ${e.toString()}");
      setLoading(false);
      _agentsModel = null;
    }
  }


  Future<void> fetchTenants(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getTenants();
      _tenantModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load ticket tenants: ${e.toString()}");
      setLoading(false);
      _tenantModel = null;
    }
  }


  Future<void> fetchOwners(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getOwners();
      _ownerModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load ticket owners: ${e.toString()}");
      setLoading(false);
      _ownerModel = null;
    }
  }

// Original method (kept for backward compatibility)
  Future<void> addTickets(dynamic data, BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.createTicketApi(data);

      debugPrint('Create Ticket Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'];
        setLoading(false);
        Navigator.pop(context);
        fetchTickets(context);
        showToast(msg);
      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to create ticket';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);
     // showToast("An error occurred");
    }
  }

  // NEW METHOD: Add ticket with file upload
  Future<void> addTicketWithFile(Map<String, dynamic> data, BuildContext context, {PlatformFile? file}) async {
    try {
      setLoading(true);

      debugPrint('Adding ticket with file...');
      final response = await _myRepo.createTicketWithFileApi(data, file: file);

      debugPrint('Create Ticket Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'] ?? 'Ticket created successfully';
        setLoading(false);
        Navigator.pop(context);
        fetchTickets(context);
        showToast(msg);
      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to create ticket';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("error: ${e.toString()}");
      setLoading(false);
      showToast("An error occurred while creating ticket");
    }
  }



  /// add comments
  Future<void> addComment(dynamic data, BuildContext context, String id) async {
    try {
      final response = await _myRepo.createComment(data, id);

      debugPrint('Create Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // FIXED: Check for success field and data field (not comment field)
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'] ?? 'Comment added successfully';

        // Refresh the details to show the new comment
        await fetchTicketDetails(context, id);

        showToast(msg);
      } else {
        String errorMsg = decoded['message'] ?? 'Failed to add comment';
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      showToast("An error occurred: ${e.toString()}");
    }
  }

}