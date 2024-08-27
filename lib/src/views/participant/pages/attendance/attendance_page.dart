import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/attedance_controller.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/page/attendance_status_page.dart';

//TODO: Attend must by GPS location

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
        if (attendanceController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(children: [
                  buildDayContainer(attendanceController, 1),
                  buildDayContainer(attendanceController, 2),
                  buildDayContainer(attendanceController, 3),
                ]),
              ),
            ),
          );
        }
      }),
    );
  }

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
          InkWell(
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

  Widget buildEventRow(AttendanceController controller, int day, String event) {
    bool canAttend = controller.canAttendEvent(day, event);
    String status = controller.attendanceStatus[day]![event] ?? 'Pending';
    String displayName = controller.eventDisplayNames[event] ?? event;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(displayName),
        if (status == 'Attending')
          buildStatusContainer('Attended', Colors.green, Icons.check_circle)
        else if (status == 'Sick' || status == 'Permit')
          buildStatusContainer(status, Colors.yellow, Icons.warning)
        else if (status == 'Not Participating' || status == 'Left Early')
          buildStatusContainer(status, Colors.red, Icons.cancel)
        else
          ElevatedButton(
            onPressed: canAttend
                ? () async {
                    controller.currentEvent = event;
                    await Get.to(
                        () => AttendanceStatusPage(day: day, event: event));
                    // Refresh data when coming back from the status page
                    await controller.refreshAttendanceData();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canAttend ? Colors.green : Colors.grey,
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

  Widget buildStatusContainer(String status, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Row(
          children: [
            Text(
              status,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Icon(icon, color: color, size: 16)
          ],
        ),
      ),
    );
  }
}
