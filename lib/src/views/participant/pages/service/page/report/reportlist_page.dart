//TODO: reportlist belum selesai
import 'package:app_kopabali/src/views/participant/pages/service/page/report/report_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class ReportListPage extends StatelessWidget {
  const ReportListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController reportController = Get.put(ReportController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Report List', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
