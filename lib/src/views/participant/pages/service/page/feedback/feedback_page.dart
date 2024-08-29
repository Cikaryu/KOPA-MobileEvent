import 'package:app_kopabali/src/views/participant/pages/service/page/feedback/feedback_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class FeedbackPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FeedbackController feedbackController = Get.put(FeedbackController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('01613B'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('Feedback', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text('Critique',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                TextFormField(
                  controller: feedbackController.critiqueController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Write your critique',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your critique';
                    }
                    return null; // Return null if valid
                  },
                ),
                SizedBox(height: 28),
                Text('Advice',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                TextFormField(
                  controller: feedbackController.adviceController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Write your advice',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your advice';
                    }
                    return null; // Return null if valid
                  },
                ),
                SizedBox(height: 40),
                Center(
                  child: Container(
                    width: Get.width * 0.5,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final critique =
                              feedbackController.critiqueController.text;
                          final advice =
                              feedbackController.adviceController.text;

                          feedbackController.submitFeedback(critique, advice);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#72BB65"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      child: Text('Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
