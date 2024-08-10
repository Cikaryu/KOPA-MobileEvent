import 'package:app_kopabali/src/views/participant/pages/service/service_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:get/get.dart'; // Ensure GetX package is imported

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController = Get.put(ServiceController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Frequently Asked Questions',
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.search),
                hintText: 'Search FAQ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {},
            ),
            SizedBox(height: 20),
            Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: HexColor('F3F3F3'),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      serviceController.isFaq1Expanded.toggle();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Merch',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              serviceController.isFaq1Expanded.value
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_right_rounded,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        AnimatedContainer(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(),
                          width: double.infinity,
                          duration: Duration(milliseconds: 300),
                          height:
                              serviceController.isFaq1Expanded.value ? 240 : 0,
                          curve: Curves.easeInOut,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Answer 1',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Text('Answer 2',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                // Add more FAQ answers here
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
