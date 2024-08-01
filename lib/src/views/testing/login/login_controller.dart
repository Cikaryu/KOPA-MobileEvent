import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginController() {
    _checkEmailVerificationStatus();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
  } catch (e) {
    setLoading(false);
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
    } else if (role == 'panitia') {
      Navigator.of(context).pushReplacementNamed('/panitia_view');
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
              _showSnackBar(context, 'Verification email sent!');
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

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
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
      } else if (role == 'panitia') {
        Navigator.of(context).pushReplacementNamed('/panitia_view');
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
      user = FirebaseAuth.instance.currentUser; // Ambil user yang sudah diperbarui

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
