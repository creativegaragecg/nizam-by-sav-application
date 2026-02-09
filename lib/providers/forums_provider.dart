
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:savvyions/models/forumCategories.dart';
import 'package:savvyions/models/forums.dart';
import 'package:savvyions/repository/forums_repo.dart';

import '../Utils/Constants/utils.dart';
import '../models/forumDetail.dart';

class ForumsViewModel extends ChangeNotifier {
  final _myRepo = ForumsRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ForumsModel? _forumsModel;

  ForumsModel? get forumsModel => _forumsModel;

  ForumsCategoriesModel? _forumsCategoriesModel;

  ForumsCategoriesModel? get forumsCategoriesModel => _forumsCategoriesModel;


  ForumDetailModel? _detailModel;

  ForumDetailModel? get detailModel => _detailModel;

  Future<void> fetchForums(BuildContext context,String categoryId) async {
    try {
      setLoading(true);
      final response = await _myRepo.getForums(categoryId);
      _forumsModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load forums: ${e.toString()}");
      setLoading(false);
      _forumsModel = null;
    }
  }

  Future<void> fetchForumCategories(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getForumCategories();
      _forumsCategoriesModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load forum categories: ${e.toString()}");
      setLoading(false);
      _forumsCategoriesModel = null;
    }
  }


  Future<void> fetchForumDetails(BuildContext context,String id) async {
    try {
      setLoading(true);
      final response = await _myRepo.getForumDetails(id);
      _detailModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load forum details: ${e.toString()}");
      setLoading(false);
      _detailModel = null;
    }
  }

  Future<void> addComment(dynamic data, BuildContext context, String id) async {
    try {
      final response = await _myRepo.createComment(data, id);

      debugPrint('Create Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // FIXED: Check for success field and data field (not comment field)
      if (decoded['success'] == true && decoded['data'] != null) {
        String msg = decoded['message'] ?? 'Comment added successfully';

        // Refresh the details to show the new comment
        await fetchForumDetails(context, id);

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