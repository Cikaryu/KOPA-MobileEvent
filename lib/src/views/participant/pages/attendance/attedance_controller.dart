// ignore_for_file: unnecessary_overrides

import 'package:app_kopabali/src/core/base_import.dart';

class AttendanceController extends GetxController {
  var isDay1Expanded = false.obs;
  var isDay2Expanded = false.obs;
  var isDay3Expanded = false.obs;


  tapBack(){
    Get.back();
    update();
  }


  var attendanceStatus = {
    1: {'Departure': 'Pending', 'Arrival': 'Pending', 'CSR': 'Pending', 'Lunch': 'Pending', 'Check In Hotel': 'Pending', 'Welcome Dinner': 'Pending', 'Arrived Hotel': 'Pending'},
    2: {'Event1': 'Pending', 'Event2': 'Pending'},
    3: {'Event1': 'Pending', 'Event2': 'Pending'},
  }.obs;

  var events = {
    1: ['Departure', 'Arrival', 'CSR', 'Lunch', 'Check In Hotel', 'Welcome Dinner', 'Arrived Hotel'],
    2: ['Event1', 'Event2'],
    3: ['Event1', 'Event2'],
  };

  var currentEvent = '';

  void toggleDayExpanded(int day) {
    if (day == 1) {
      isDay1Expanded.value = !isDay1Expanded.value;
    } else if (day == 2) {
      isDay2Expanded.value = !isDay2Expanded.value;
    } else if (day == 3) {
      isDay3Expanded.value = !isDay3Expanded.value;
    }
  }

  bool isDayExpanded(int day) {
    if (day == 1) {
      return isDay1Expanded.value;
    } else if (day == 2) {
      return isDay2Expanded.value;
    } else if (day == 3) {
      return isDay3Expanded.value;
    }
    return false;
  }

  bool isPreviousEventAttended(int day, String event) {
    var eventIndex = events[day]!.indexOf(event);
    if (eventIndex == 0) return true;

    var previousEvent = events[day]![eventIndex - 1];
    return attendanceStatus[day]![previousEvent] == 'Attended';
  }

  void markEventAsAttended(int day, String event) {
    attendanceStatus[day]![event] = 'Attended';
  }
}