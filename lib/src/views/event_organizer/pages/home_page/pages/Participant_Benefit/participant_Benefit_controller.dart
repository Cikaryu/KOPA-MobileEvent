import 'dart:ui';

import 'package:app_kopabali/src/core/base_import.dart';

// Controller
class ParticipantBenefitController {
  // Menggunakan ValueNotifier untuk menggantikan Rx
  final ValueNotifier<int> selectedDay = ValueNotifier<int>(0);

  void changeDay(int day) {
    selectedDay.value = day;
  }
  void showImagePreview(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            // Image preview
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}
