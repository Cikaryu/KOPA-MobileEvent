import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackController extends GetxController {
  bool canPop = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final critiqueController = TextEditingController();
  final adviceController = TextEditingController();

  @override
  onInit() {
    super.onInit();
  }

  @override
  onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    critiqueController.dispose();
    adviceController.dispose();
    super.onClose();
  }

  onGoBack() {
    Get.back();
  }

  Future<void> submitFeedback(String critique, String advice) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        final String name = userDoc['name'] ?? '';

        final String feedbackId = _firestore.collection('feedback').doc().id;

        await _firestore.collection('feedback').doc(feedbackId).set({
          'userId': user.uid,
          'name': name,
          'critique': critique,
          'advice': advice,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        showSuccessDialog(Get.context!);
      } else {
        Get.snackbar('Error', 'User not logged in',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit feedback: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Success',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text('Feedback submitted successfully',
              textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () {
                critiqueController.clear();
                adviceController.clear();
                Navigator.of(context).pop();
                Get.back();
              },
              child: Center(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: HexColor("E97717"),
                        border: Border(
                          top: BorderSide(color: Colors.orange[400]!),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ))),
            ),
          ],
        );
      },
    );
  }
}
