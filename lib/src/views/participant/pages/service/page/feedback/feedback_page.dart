import 'package:app_kopabali/src/views/participant/pages/service/page/feedback/feedback_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
        title: Text('Feedback',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: HexColor('01613B'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Obx(() => Column(
                        children: [
                          RatingBar.builder(
                            initialRating: feedbackController.rating.value,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 40,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              feedbackController.setRating(rating);
                            },
                          ),
                          SizedBox(height: 16),
                          Text(
                            feedbackController.getRatingLabel(
                                feedbackController.rating.value),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 24),
                Text('Tell us Your Suggestions!',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: feedbackController.suggestionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'What can we improve for you?',
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your suggestion';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        feedbackController.submitFeedback(
                          feedbackController.suggestionController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Submit Feedback',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
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
