import 'package:calender_app/model/event.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier{
  final List<Event> _events = [];
  List<Event> get events => _events;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;
  List<Event> get eventOfSelectedDate => _events;

  void addEvent(Event event){
    _events.add(event);

    notifyListeners();
  }

  void deleteEvent(Event event){
    _events.remove(event);
    notifyListeners();
  }
  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;

    notifyListeners();
  }
}