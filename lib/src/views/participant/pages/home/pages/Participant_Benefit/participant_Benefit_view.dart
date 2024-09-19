import 'package:app_kopabali/src/core/base_import.dart';
import 'participant_Benefit_controller.dart';

class ParticipantBenefitView extends StatelessWidget {
  ParticipantBenefitView({Key? key}) : super(key: key);

  final ParticipantBenefitController controller =
      ParticipantBenefitController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Participant Benefit",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('#727578'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: HexColor("#F2F2F2"),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Participant Benefit",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Friday, 20th September",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "On day 1, participants can received different vouchers for different occasions.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double imageWidth = constraints.maxWidth *
                          0.91; // Adjust the width as needed
                      return Column(
                        children: [
                          Image.asset(
                            'assets/images/participant_benefit/Benefit1.png',
                            width: imageWidth,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/images/participant_benefit/Benefit2.png',
                            width: imageWidth,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/images/participant_benefit/Benefit3.png',
                            width: imageWidth,
                            fit: BoxFit.cover,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
