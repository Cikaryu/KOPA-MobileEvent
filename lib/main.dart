import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/routes/app_pages.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_controller.dart';
import 'package:app_kopabali/src/views/landingpage/landingpage_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initNotifications();

  // Check if landing page has been shown before
  final bool isLandingPageShown = await _isLandingPageShown();

  if (!isLandingPageShown) {
    await _setLandingPageShown(); // Mark landing page as shown

    // Always request permissions when the app starts
    final bool permissionsGranted = await requestPermissions();

    if (permissionsGranted) {
      runApp(
        GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          home: LandingPageView(),
          getPages: AppPages.routes,
        ),
      );
    } else {
      // Show a message and exit the app
      runApp(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(
                "The app requires location and notification permissions to continue..",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

      // Delay before exiting the app to allow the message to be displayed
      Future.delayed(const Duration(seconds: 2), () {
        SystemNavigator.pop(); // Close the app
      });
    }
  } else {
    // If landing page has been shown, directly check login status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(SigninController()).checkLoginStatus(Get.context!);
    });

    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // Show a loading indicator
          ),
        ),
        getPages: AppPages.routes,
      ),
    );
  }
}

Future<bool> requestPermissions() async {
  // Request location permission
  final locationStatus = await Permission.location.request();

  // Request notification permission
  final notificationStatus = await Permission.notification.request();

  // Check if both permissions are granted
  if (locationStatus.isGranted && notificationStatus.isGranted) {
    return true;
  } else {
    return false;
  }
}

// Helper functions to check and set landing page shown status
Future<void> _setLandingPageShown() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLandingPageShown', true);
}

Future<bool> _isLandingPageShown() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLandingPageShown') ?? false;
}

// Initialize notifications firebase messaging
Future<void> _initNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  final token = await messaging.getToken();
  print('Token: $token');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  Get.snackbar(
    message.notification!.title!,
    message.notification!.body!,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 5),
  );
}
