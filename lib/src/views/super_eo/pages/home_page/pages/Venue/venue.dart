import 'package:app_kopabali/src/core/base_import.dart';

import 'pages/venue_days_one.dart';
import 'pages/venue_days_three.dart';
import 'pages/venue_days_two.dart';
import 'venue_controler.dart';

class VenueViewPage extends StatelessWidget {
  VenueViewPage({super.key});

  final VenueControler controller = VenueControler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Venue",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('727578'),
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
              height: MediaQuery.of(context).size.height * 0.98,
              child: ValueListenableBuilder<int>(
                valueListenable: controller.selectedDay,
                builder: (context, value, child) {
                  switch (value) {
                    case 0:
                      return VenuePagedayone();
                    case 1:
                      return VenuePagedaytwo();
                    case 2:
                      return VenuePagedaythree();
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
                color: isSelected ? HexColor("#727578") : Colors.transparent,
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
