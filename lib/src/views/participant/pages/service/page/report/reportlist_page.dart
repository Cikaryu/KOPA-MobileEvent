import 'package:app_kopabali/src/views/participant/pages/service/page/report/report_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController reportController = Get.put(ReportController());

    return Scaffold(
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
