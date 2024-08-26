import 'package:app_kopabali/src/views/participant/pages/home/pages/Participant_Benefit/Participant_benefit_days/day_one_benefit.dart';
import 'package:flutter/services.dart';
import 'package:app_kopabali/src/core/base_import.dart';

import 'Participant_benefit_days/day_three_benefit.dart';
import 'Participant_benefit_days/day_two_benefit.dart';
import 'participant_Benefit_controller.dart';

class ParticipantBenefitView extends StatelessWidget {
  ParticipantBenefitView({Key? key}) : super(key: key);

  final ParticipantBenefitController controller =
      ParticipantBenefitController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              Colors.transparent, // Makes the status bar transparent
          statusBarIconBrightness:
              Brightness.dark, // Sets the icon brightness for better visibility
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
                  Icon(Icons.emoji_events,
                      color: HexColor("#01613B"), size: 48),
                  const SizedBox(height: 8),
                  Text("Participant Benefit",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: HexColor("#01613B"))),
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
              height: 1000,
              child: ValueListenableBuilder<int>(
                valueListenable: controller.selectedDay,
                builder: (context, value, child) {
                  switch (value) {
                    case 0:
                      return DayOneContentBenefit();
                    case 1:
                      return DayTwoContentBenefit();
                    case 2:
                      return DayThreeContentBenfit();
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
