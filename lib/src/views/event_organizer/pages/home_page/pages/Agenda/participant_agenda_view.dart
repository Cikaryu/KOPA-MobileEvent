import 'package:flutter/services.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'agenda_days/day_one_agenda.dart';
import 'agenda_days/day_three_agenda.dart';
import 'agenda_days/day_two_agenda.dart';
import 'participant_agenda_controller.dart';

class ParticipantAgendaView extends StatelessWidget {
  ParticipantAgendaView({Key? key}) : super(key: key);

  final ParticipantAgendaController controller = ParticipantAgendaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agenda Kegiatan",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('01613B'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Tab bar hari
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildDayTab(0, 'Day 1'),
                  _buildDayTab(1, 'Day 2'),
                  _buildDayTab(2, 'Day 3'),
                ],
              ),
            ),
            // Konten hari berdasarkan tab yang dipilih
            SizedBox(
              height: 1150,
              child: ValueListenableBuilder<int>(
                valueListenable: controller.selectedDay,
                builder: (context, value, child) {
                  switch (value) {
                    case 0:
                      return DayOneContentAgenda();
                    case 1:
                      return DayTwoContentAgenda();
                    case 2:
                      return DayThreeContentAgenda();
                    default:
                      return Center(child: Text('Invalid Day'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTab(int day, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeDay(day),
        child: ValueListenableBuilder<int>(
          valueListenable: controller.selectedDay,
          builder: (context, value, child) {
            final isSelected = value == day;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? HexColor("#01613B") : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            );
          },
        ),
      ),
    );
  }
}
