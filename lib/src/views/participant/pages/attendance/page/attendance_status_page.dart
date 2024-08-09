import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/attedance_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AttendanceStatusPage extends StatefulWidget {
  final int day;
  final String event;

  AttendanceStatusPage({required this.day, required this.event});

  @override
  _AttendanceStatusPageState createState() => _AttendanceStatusPageState();
}

class _AttendanceStatusPageState extends State<AttendanceStatusPage> {
  final AttendanceController controller = Get.find();
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Status",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 250,
                      height: 60,
                      child: DropdownButtonFormField2(
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
                                  child: Center(
                                      child: Text(
                                    status,
                                    style: TextStyle(color: Colors.grey[700]),
                                  )), // Center the hintText
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value as String?;
                          });
                        },
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          width: 140,
                          offset: Offset(109, 60),
                          elevation: 5,
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (selectedStatus == 'Sick / Izin') ...[
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
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 20),
                ],
                Text(
                  "Attachment",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: Get.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200], // Background color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Take a picture and submit',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 450, left: 108, right: 108),
            child: Container(
              width: 177,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  controller.markEventAsAttended(widget.day, widget.event);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Submit Attendance',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
