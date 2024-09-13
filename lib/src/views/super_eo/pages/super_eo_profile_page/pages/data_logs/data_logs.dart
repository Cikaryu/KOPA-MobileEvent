import 'package:app_kopabali/src/core/base_import.dart'; // Assuming this imports your core packages.
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/data_logs/data_logs_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hexcolor/hexcolor.dart';

class DataLogsPageView extends StatelessWidget {
  const DataLogsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final DataLogsController controller =
        Get.put(DataLogsController()); // Controller instance
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#727578"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(), // Go back functionality
        ),
        title: const Text(
          'Data Logs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  filled: true,
                  fillColor: HexColor('F3F3F3'),
                  hintText: 'Search Logs',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: HexColor("E97717")),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "Filter by:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 310,
                    child: Obx(() => DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Choose Filter',
                            fillColor: HexColor("#F2F2F2"),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          value:
                              controller.filter.value, // Dropdown filter value
                          items: const [
                            DropdownMenuItem(
                                value: 'newest', child: Text('Newest')),
                            DropdownMenuItem(
                                value: 'oldest', child: Text('Oldest')),
                          ],
                          onChanged: controller
                              .changeFilter, // Update filter on selection
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor("#F3F3F3"),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: Get.height / 1.6,
                width: Get.width / 1.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Change Logs',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        width: Get.width / 1,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Obx(() => ListView.builder(
                              itemCount:
                                  controller.logs.length, // Logs list count
                              itemBuilder: (context, index) {
                                final log = controller.logs[index]; // Log item
                                return _buildLogItem(
                                    action: log.action); // Build log item UI
                              },
                            )),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem({required String action}) {
    // Function to get the status and format the log text accordingly
    TextSpan getFormattedAction(String action) {
      String status = "";
      String beforeStatus = "";
      String afterStatus = "";
      String date = "";

      // Split the action to extract the date (assuming the date is followed by a newline)
      if (action.contains('\n')) {
        date = action.split('\n')[0]; // Date part
        action = action.split('\n')[1]; // Remaining part of the action
      }

      // Check if the action contains specific status keywords
      if (action.contains('Pending')) {
        status = 'Pending';
        beforeStatus = action.split('Pending')[0];
        afterStatus = action.split('Pending')[1];
      } else if (action.contains('Not Received')) {
        status = 'Not Received';
        beforeStatus = action.split('Not Received')[0];
        afterStatus = action.split('Not Received')[1];
      } else if (action.contains('Received')) {
        status = 'Received';
        beforeStatus = action.split('Received')[0];
        afterStatus = action.split('Received')[1];
      }

      // If no status found, return the full action text with formatted date
      if (status.isEmpty) {
        return TextSpan(
          children: [
            TextSpan(
              text: "$date\n",
              style: const TextStyle(
                  height: 1.5,
                  fontSize: 16,
                  color: Colors.black), // Updated font size to 16
            ),
            TextSpan(
              text: action,
              style: const TextStyle(
                  fontSize: 16, color: Colors.black), // Default text style
            ),
          ],
        );
      }

      // Assign colors based on status
      Color statusColor;
      if (status == 'Pending') {
        statusColor = HexColor("F0B811");
      } else if (status == 'Not Received') {
        statusColor = Colors.red;
      } else if (status == 'Received') {
        statusColor = Colors.green;
      } else {
        statusColor = Colors.black; // Default color if no status is found
      }

      // Return the formatted TextSpan with colored status and formatted date
      return TextSpan(
        children: [
          TextSpan(
              text: "$date\n",
              style: const TextStyle(
                  height: 1.5,
                  fontSize: 16,
                  color: Colors.black)), // Updated font size to 16
          TextSpan(
              text: beforeStatus,
              style: const TextStyle(fontSize: 16, color: Colors.black)),
          TextSpan(
              text: status,
              style: TextStyle(
                  color: statusColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          TextSpan(
              text: afterStatus,
              style: const TextStyle(fontSize: 16, color: Colors.black)),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            margin: const EdgeInsets.only(top: 5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: getFormattedAction(action),
            ),
          ),
        ],
      ),
    );
  }
}
