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
          title: Text('Success'),
          content: Text('Feedback submitted successfully'),
          actions: [
            TextButton(
              onPressed: () {
                critiqueController.clear();
                adviceController.clear();
                Navigator.of(context).pop();
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
