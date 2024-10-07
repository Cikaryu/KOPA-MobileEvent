import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/routes/app_pages.dart';
import 'package:app_kopabali/src/views/landingpage/landingpage_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await _initNotifications();

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

// Initialize notifications and Firebase Messaging
Future<void> _initNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  await analytics.setAnalyticsCollectionEnabled(true);

  // Request permission for notifications
  await messaging.requestPermission();
  await messaging.subscribeToTopic('kopaevent-testing');
  await messaging.setAutoInitEnabled(true);

  // Get the FCM token
  final String token = await messaging.getToken() ?? '';
  print('Initial FCM Token: $token');
  await updateFCMToken(token);

  // Listen for token refresh and update Firestore
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    updateFCMToken(newToken);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

// Update FCM token to Firestore
Future<void> updateFCMToken(String token) async {
  try {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users') // Sesuaikan dengan koleksi Firestore
          .doc(userId)
          .update({'fcmToken': token}); // Update token FCM ke Firestore
      print('FCM token updated: $token');
    }
  } catch (e) {
    print('Error updating FCM token: $e');
  }
}

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}
