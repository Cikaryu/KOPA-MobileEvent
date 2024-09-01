import 'package:app_kopabali/src/core/base_import.dart';

// Controller
class ParticipantKitController {
  // Menggunakan ValueNotifier untuk menggantikan Rx
  final ValueNotifier<int> selectedDay = ValueNotifier<int>(0);

  void changeDay(int day) {
    selectedDay.value = day;
  }
}
