import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/data_logs/data_logs_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataLogsPageView extends StatelessWidget {
  const DataLogsPageView({super.key});
  @override
  Widget build(BuildContext context) {
    final DataLogsController controller = Get.put(DataLogsController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#727578"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Data Logs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: ElevatedButton(
                onPressed: () {
                  controller.logs.removeWhere((log) => log.action == 'Super EO');
                  controller.logs.refresh();
                },
                child: Text('Reset logs')),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    hintText: 'Choose Filter',
                    border: OutlineInputBorder(),
                  ),
                  value: controller.filter.value,
                  items: [
                    DropdownMenuItem(value: 'newest', child: Text('Newest')),
                    DropdownMenuItem(value: 'oldest', child: Text('Oldest')),
                  ],
                  onChanged: controller.changeFilter,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Change Logs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: Get.width / 1.1,
              padding: EdgeInsets.symmetric(horizontal: 18),
              color: HexColor("#F3F3F3"),
              child: Obx(() => ListView.builder(
                    itemCount: controller.logs.length,
                    itemBuilder: (context, index) {
                      final log = controller.logs[index];
                      return _buildLogItem(date: log.date, action: log.action);
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem({required DateTime date, required String action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            margin: EdgeInsets.only(top: 5),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('E, d MMMM yyyy, HH:mm').format(date),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(action),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
