import 'package:app_kopabali/src/core/base_import.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    if (role == 'participant') {
      Navigator.of(context).pushReplacementNamed('/participant');
    } else if (role == 'committee') {
      Navigator.of(context).pushReplacementNamed('/committee');
    } else if (role == 'admin') {
      Navigator.of(context).pushReplacementNamed('/admin_view');
    }
  }

  void _showVerificationDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Not Verified'),
          content: Text(
              'Your email is not verified. Please check your email for verification link.'),
          actions: <Widget>[
            TextButton(
              child: Text('Resend Verification Email'),
              onPressed: () async {
                await sendVerificationEmail(user);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
      String role = prefs.getString('role') ?? 'participant';
      if (role == 'participant') {
        Navigator.of(context).pushReplacementNamed('/participant');
      } else if (role == 'committee') {
        Navigator.of(context).pushReplacementNamed('/committee');
      } else if (role == 'admin') {
        Navigator.of(context).pushReplacementNamed('/admin_view');
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
        // Reload user untuk memastikan status terkini
        await user.reload();
        user = FirebaseAuth
            .instance.currentUser; // Ambil user yang sudah diperbarui

        // Cek jika email sudah diverifikasi
        if (user!.emailVerified) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'emailVerified': true});

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userId', user.uid);

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          String role = userDoc['role'];
          await prefs.setString('role', role);
        }
      }
    });
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
