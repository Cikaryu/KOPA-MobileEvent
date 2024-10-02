import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/committee/committee_view.dart';
import 'package:app_kopabali/src/views/committee/pages/home_page/home_page.dart';
import 'package:app_kopabali/src/views/event_organizer/event_organizer_view.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/home_page/home_page.dart';
import 'package:app_kopabali/src/views/participant/pages/home/home_page.dart';
import 'package:app_kopabali/src/views/participant/participant_view.dart';
import 'package:app_kopabali/src/views/super_eo/pages/home_page/home_page.dart';
import 'package:app_kopabali/src/views/super_eo/super_eo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SigninController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool showPassword = false;

  siginController() {
    _checkEmailVerificationStatus();
  }

  togglePasswordVisibility() {
    showPassword = !showPassword;
    update();
  }

  void setLoading(bool value) {
    _isLoading = value;
    update();
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      setLoading(true);

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        await user.reload(); // Reload user to get the latest information
        user = FirebaseAuth.instance.currentUser; // Get updated user

        if (user!.emailVerified) {
          await _handleVerifiedUser(user, context);
          _checkEmailVerificationStatus();
        } else {
          _showVerificationDialog(context, user);
        }
      }
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      String errorMessage;
      print(
          'FirebaseAuthException code: ${e.code}, message: ${e.message}'); // Debug log
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage =
              'The user corresponding to the given email has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'There is no user corresponding to the given email.';
          break;
        case 'wrong-password':
          errorMessage = 'The password is invalid for the given email.';
          break;
        case 'invalid-credential':
          errorMessage = 'Please check your email and password.';
          break;
        case 'channel-rejected':
          errorMessage = 'Please check your internet connection.';
          break;
        case 'channel-error':
          errorMessage = 'Please check your email and password.';
          break;
        default:
          errorMessage =
              'An unknown error occurred: ${e.code}'; // Include error code in message
      }
      _showErrorDialog(context, errorMessage);
    } catch (e) {
      setLoading(false);
      print('General exception: ${e.toString()}'); // Debug log
      _showErrorDialog(context, e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> _handleVerifiedUser(User user, BuildContext context) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    String role = userDoc['role'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', user.uid);
    await prefs.setString('role', role);

    await _storeFCMToken(user.uid);

    if (role == 'Participant') {
      Navigator.of(context).pushReplacementNamed('/participant');
    } else if (role == 'Committee') {
      Navigator.of(context).pushReplacementNamed('/committee');
    } else if (role == 'Event Organizer') {
      Navigator.of(context).pushReplacementNamed('/eventorganizer');
    } else if (role == 'Super Event Organizer') {
      Navigator.of(context).pushReplacementNamed('/supereo');
    }
  }

  Future<void> _storeFCMToken(String userId) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'fcmToken': token});
        print('FCM Token stored successfully');
      }
    } catch (e) {
      print('Error storing FCM token: $e');
    }
  }

  void _showVerificationDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Not Verified',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Text(
            'Your email is not verified. Please check your email for verification link',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: HexColor("E97717"),
                    border: Border(
                      top: BorderSide(color: Colors.orange[400]!),
                    ),
                  ),
                  child: TextButton(
                    child: Text(
                      'Resend Verification Email',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () async {
                      await sendVerificationEmail(user);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: HexColor("E97717"),
                    border: Border(
                      top: BorderSide(color: Colors.orange[400]!),
                    ),
                  ),
                  child: TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white,fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> sendVerificationEmail(User? user) async {
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String role = prefs.getString('role') ?? '';
      if (role == 'Participant') {
        Get.offAll(() => ParticipantView());
      } else if (role == 'Committee') {
        Get.offAll(() => CommitteeView());
      } else if (role == 'Event Organizer') {
        Get.offAll(() => EventOrganizerView());
      } else if (role == 'Super Event Organizer') {
        Get.offAll(() => SuperEOView());
      } else {
        Get.offAll(() => SigninView());
      }
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    FirebaseAuth.instance.signOut();
  }

  void _checkEmailVerificationStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await Future.delayed(Duration(seconds: 2)); // Beri sedikit waktu
        await user.reload(); // Memuat ulang untuk memastikan status terbaru
        User? updatedUser = FirebaseAuth.instance.currentUser;
        if (updatedUser!.emailVerified) {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(updatedUser.uid)
                .update({'emailVerified': true});

            // Simpan status ke SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('userId', updatedUser.uid);

            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(updatedUser.uid)
                .get();
            String role = userDoc['role'];
            await prefs.setString('role', role);
          } catch (e) {
            print("Firestore update error: $e");
          }
        }
      }
    });
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                'Login Failed',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
            ],
          ),
          content: Text(message, textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: Center(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
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
                    )),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
