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
                    "Name Tag",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Friday, 20 September 2024",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "One of the main items to be received on the first day is a name tag. This name tag is specially designed for the event and will provide identification as well as a uniform appearance for all participants.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  _buildImageItem(
                      'assets/images/participant_kit/nametag1.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/nametag2.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/nametag3.png'),
                  const SizedBox(height: 24),
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
                    "On the second day, participants will receive a t-shirt. This t-shirt is designed to provide comfort during the activities and also serves as a souvenir from the event.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  _buildImageItem(
                      'assets/images/participant_kit/tshirt1.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/tshirt2.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/tshirt3.png'),
                  const SizedBox(height: 44),
                  Text(
                    "Polo Shirt",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sunday, 22 September 2024",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "On the third day, participants will receive a polo shirt. This polo shirt is specially designed for the event and will provide comfort as well as a uniform appearance for all participants.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 24),
                  _buildImageItem(
                      'assets/images/participant_kit/poloshirt1.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/poloshirt2.png'),
                  const SizedBox(height: 18),
                  _buildImageItem(
                      'assets/images/participant_kit/polo_shirt.png'),
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
            color: HexColor('#F2F2F2'),
            width: 2,
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
    );
  }
}
