import 'package:flutter/material.dart';
import 'package:savvyions/models/events.dart';
import 'package:savvyions/repository/events_repository.dart';



class EventsViewModel extends ChangeNotifier {
  final _myRepo = EventsRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  EventsModel? _eventsModel;
  EventsModel? get eventsModel => _eventsModel;


  Future<void> fetchEvents(BuildContext context) async {
    try {
      setLoading(true);
      final response = await _myRepo.getEvents();
      _eventsModel = response;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load events: ${e.toString()}");
      setLoading(false);
      _eventsModel = null;
    }
  }

}