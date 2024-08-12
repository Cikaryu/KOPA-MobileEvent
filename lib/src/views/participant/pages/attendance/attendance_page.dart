// attendance_page.dart

//TODO: Button berubah warna sesuai dropdownlist di page attendance_status_page.dart
//TODO: Function untuk validasi jika memilih tidak hadir atau early leave


import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/attedance_controller.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/page/attendance_status_page.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendanceController attendanceController =
        Get.put(AttendanceController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                buildDayContainer(attendanceController, 1),
                buildDayContainer(attendanceController, 2),
                buildDayContainer(attendanceController, 3),
              ]),
            ),
          ),
        );
      }),
    );
  }

  // Membuat container untuk setiap hari
  Widget buildDayContainer(AttendanceController controller, int day) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Color(0xFFF3F3F3),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              controller.toggleDayExpanded(day);
            },
            child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Day - $day',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        controller.isDayExpanded(day)
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: controller.isDayExpanded(day)
                        ? (day == 1
                            ? 390
                            : (day == 2 ? 220 : (day == 3 ? 250 : 0)))
                        : 0,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Attendance"),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              // Menggunakan map untuk membuat event row
                              children: controller.events[day]!.map((event) {
                                return buildEventRow(controller, day, event);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Membuat row untuk setiap event dalam container
  Widget buildEventRow(AttendanceController controller, int day, String event) {
    // Cek apakah semua event di hari sebelumnya sudah attended
    bool isPreviousDayAttended = day == 1 || controller.areAllEventsAttended(day - 1);

    // Cek apakah event sebelumnya di hari yang sama sudah attended
    bool isPreviousAttended = controller.isPreviousEventAttended(day, event);

    // Button Attend hanya bisa ditekan jika event sebelumnya dan hari sebelumnya sudah attended
    bool canAttend = isPreviousDayAttended && isPreviousAttended;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(event),
        if (controller.attendanceStatus[day]![event] == 'Attended')
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  Text(
                    'Attended',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.check_circle, color: Colors.green, size: 16)
                ],
              ),
            ),
          )
        else
          ElevatedButton(
            // Tombol Attend hanya aktif jika canAttend bernilai true
            onPressed: canAttend
                ? () {
                    controller.currentEvent = event;
                    Get.to(() => AttendanceStatusPage(day: day, event: event));
                  }
                : null, // Tombol dinonaktifkan jika canAttend bernilai false
            style: ElevatedButton.styleFrom(
              backgroundColor: canAttend ? Colors.green : Colors.grey, // Ubah warna tombol saat tidak aktif
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Attend',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
