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
        centerTitle: true,
        automaticallyImplyLeading:
            false, 
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              buildDayContainer(attendanceController, 1),
              buildDayContainer(attendanceController, 2),
              buildDayContainer(attendanceController, 3),
            ]),
          ),
        );
      }),
    );
  }
  //contai
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
            child: Container(
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
                  if (controller.isDayExpanded(day))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your Attendance"),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: controller.events[day]!.map((event) {
                              return buildEventRow(controller, day, event);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //isi dalam container
  Widget buildEventRow(AttendanceController controller, int day, String event) {
    bool isPreviousAttended = controller.isPreviousEventAttended(day, event);

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
            onPressed: isPreviousAttended
                ? () {
                    controller.currentEvent = event;
                    Get.to(() => AttendanceStatusPage(day: day, event: event));
                  }
                : null,
            child: Text(
              'Attend',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
      ],
    );
  }
}
