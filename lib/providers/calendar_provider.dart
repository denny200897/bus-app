import 'package:flutter/foundation.dart';
import 'package:notes_app/models/event_model.dart';
import 'package:notes_app/utils/database_helper.dart';

class CalendarProvider extends ChangeNotifier {
  Map<DateTime, List<Event>> _events = {};

  Map<DateTime, List<Event>> get events => _events;

  CalendarProvider() {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final eventsList = await DatabaseHelper.instance.getEvents();
    _events = {};

    for (var event in eventsList) {
      final date = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );

      if (_events[date] == null) {
        _events[date] = [];
      }

      _events[date]!.add(event);
    }
    notifyListeners();
  }

  List<Event> getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  Future<Event> addEvent(Event event) async {
    final id = await DatabaseHelper.instance.insertEvent(event);
    final newEvent = event.copy(id: id);

    final date = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
    );

    if (_events[date] == null) {
      _events[date] = [];
    }

    _events[date]!.add(newEvent);
    notifyListeners();
    return newEvent;
  }

  Future<void> updateEvent(Event event) async {
    await DatabaseHelper.instance.updateEvent(event);
    await fetchEvents(); // 重新載入所有事件來更新狀態
  }

  Future<void> deleteEvent(int id) async {
    await DatabaseHelper.instance.deleteEvent(id);
    await fetchEvents(); // 重新載入所有事件來更新狀態
  }
}