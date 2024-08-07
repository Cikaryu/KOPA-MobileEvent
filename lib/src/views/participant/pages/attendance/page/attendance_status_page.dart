import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/attedance_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AttendanceStatusPage extends StatelessWidget {
  final int day;
  final String event;

  AttendanceStatusPage({required this.day, required this.event});

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Status'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            DropdownButtonFormField2(
              decoration: InputDecoration(
                hintText: 'Status',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Attending', 'Sick / Izin']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {},
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                width: 140,
                offset: Offset(218, 55),
                elevation: 5,
                padding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Write your attendance description',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            Text(
              "Attachment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OutlinedButton(
              onPressed: () {
                // fungsi disini yak
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                side: BorderSide(color: Colors.grey),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Take a picture and submit'),
                  SizedBox(width: 8.0),
                  Icon(Icons.add),
                ],
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.markEventAsAttended(day, event);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ParticipantView()),
                  // );
                  controller.tapBack();
                },
                child: Text('Submit Attendance'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
