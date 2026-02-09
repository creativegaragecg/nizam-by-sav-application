import 'package:flutter/material.dart';
import 'package:savvyions/repository/noticeBoard_repository.dart';
import '../models/noticeBoard.dart';



class NoticeBoardViewModel extends ChangeNotifier {
  final _myRepo = NoticeRepo();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  NoticeBoardModel? _noticeBoardModel;
  NoticeBoardModel? get noticeBoardModel => _noticeBoardModel;


  Future<void> fetchNotices(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getNotices();
      _noticeBoardModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load notices: ${e.toString()}");
      setLoading(false);
      _noticeBoardModel = null;
    }
  }

}