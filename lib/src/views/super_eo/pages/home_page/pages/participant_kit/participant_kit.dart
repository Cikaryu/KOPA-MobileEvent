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
                  Text(
                    "Polo Shirt",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Friday, 20 September 2024",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam at ipsum at nulla ultrices gravida. Integer nec viverra magna. Etiam euismod lacus eu dui vestibulum, eget luctus sem aliquet.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  _buildImageItem(
                      'assets/images/participant_kit/poloshirt1.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/poloshirt2.png'),
                  const SizedBox(height: 44),
                  Text(
                    "T-Shirt",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Saturday, 21 September 2024",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam at ipsum at nulla ultrices gravida. Integer nec viverra magna. Etiam euismod lacus eu dui vestibulum, eget luctus sem aliquet.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  _buildImageItem(
                      'assets/images/participant_kit/poloshirt1.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/poloshirt2.png'),
                  const SizedBox(height: 44),
                  Text(
                    "Name Tag",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sunday, 22 September 2024",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam at ipsum at nulla ultrices gravida. Integer nec viverra magna. Etiam euismod lacus eu dui vestibulum, eget luctus sem aliquet.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  _buildImageItem(
                      'assets/images/participant_kit/poloshirt1.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/poloshirt2.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan gambar item
  Widget _buildImageItem(String imagePath) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            alignment: Alignment.center,
            height: 200,
            width: Get.width / 1.9,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
