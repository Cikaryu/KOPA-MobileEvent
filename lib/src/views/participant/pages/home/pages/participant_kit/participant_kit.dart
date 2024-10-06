import 'package:app_kopabali/src/core/base_import.dart';
import 'participant_kit_controller.dart';

class ParticipantKit extends StatelessWidget {
  ParticipantKit({Key? key}) : super(key: key);

  final ParticipantKitController controller = ParticipantKitController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Participant Kit",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('727578'),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: HexColor('F2F2F2'),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Participant Kit",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Friday, 20 September 2024",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "On day 1, participants can pick up their kit, which typically includes event materials like T-Shirts, Name Tag, etc.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildImageItem(
                      context, 'assets/images/participant_kit/item1.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      context, 'assets/images/participant_kit/item2.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      context, 'assets/images/participant_kit/item3.png'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(BuildContext context, String imagePath) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => controller.showImagePreview(context, imagePath),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: HexColor('#F2F2F2'),
              width: screenWidth * 0.01,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              alignment: Alignment.center,
              height: 200,
              width: Get.width / 1,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
