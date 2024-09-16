import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final suggestionController = TextEditingController();
  final rating = 0.0.obs;

  @override
  void onClose() {
    suggestionController.dispose();
    super.onClose();
  }

  void setRating(double value) {
    rating.value = value;
  }

  String getRatingLabel(double rating) {
    switch (rating.toInt()) {
      case 1:
        return 'Need Improvement';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Excellent';
      case 5:
        return 'Perfect';
      default:
        return '';
    }
  }

  Future<void> submitFeedback(String suggestion) async {
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
          'rating': rating.value,
          'suggestion': suggestion,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        Get.snackbar('Success', 'Feedback submitted successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        suggestionController.clear();
        rating.value = 0.0;
      } else {
        Get.snackbar('Error', 'User not logged in',
        backgroundColor: Colors.red,
          colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit feedback: $e',
      backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }
}
