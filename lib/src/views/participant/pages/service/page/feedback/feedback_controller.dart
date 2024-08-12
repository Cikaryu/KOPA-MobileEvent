import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        // Log the current user ID
        print('Current User ID: ${user.uid}');

        // Fetch the user's document
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        print('User Document Data: ${userDoc.data()}'); // Debugging line

        if (userDoc.exists) {
          final String userName =
              userDoc['name'] ?? 'No Name'; // Use a default value
          print('User Name: $userName'); // Debugging line

          // Create a reference to the feedback document
          DocumentReference feedbackDoc =
              _firestore.collection('feedback').doc('general_feedback');

          // Fetch the current feedback document
          DocumentSnapshot feedbackSnapshot = await feedbackDoc.get();

          if (feedbackSnapshot.exists) {
            // If the document exists, update the user's feedback
            await feedbackDoc.update({
              'userFeedback.${user.uid}': {
                'name': userName,
                'critique': critique,
                'advice': advice,
                'updatedAt': FieldValue.serverTimestamp(),
              },
            });
          } else {
            // If the document does not exist, create it with the user's feedback
            await feedbackDoc.set({
              'userFeedback.${user.uid}': {
                'name': userName,
                'critique': critique,
                'advice': advice,
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              },
            });
          }
          showSuccessDialog(Get.context!);
          // CustomSnackbar.show(
          //   Get.context!,
          //   title: 'Success',
          //   message: 'Feedback submitted successfully',
          //   position: SnackPosition.TOP,
          // );
        } else {
          CustomSnackbar.show(Get.context!,
              title: 'Failed', message: 'User document does not exist');
        }
      } else {
        CustomSnackbar.show(Get.context!,
            title: 'Failed', message: 'User not logged in');
      }
    } catch (e) {
      CustomSnackbar.show(Get.context!,
          title: 'Failed', message: 'User not logged in');
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
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
