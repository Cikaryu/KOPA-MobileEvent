import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RegisterController with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _selfieImage;
  File? _ktpImage;
  String? _qrCodePath;

  File? get selfieImage => _selfieImage;
  File? get ktpImage => _ktpImage;

  void setSelfieImage(File? image) {
    _selfieImage = image;
    notifyListeners();
  }

  void setKtpImage(File? image) {
    _ktpImage = image;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String area,
    required String divisi,
    required String department,
    required String alamat,
    required String nomorWhatsapp,
    required String nomorKtp,
    required String ukuranTShirt,
    required String ukuranPoloShirt,
    required String tipeEWallet,
    required String nomorEWallet,
    required BuildContext context,
    required String participant,
  }) async {
    try {
      setLoading(true);

      // Register user with Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload images to Firebase Storage
      String selfieUrl = await _uploadImageToStorage(_selfieImage!,
          '/users/participant/${userCredential.user!.uid}/selfie/selfie.jpg');
      String ktpUrl = await _uploadImageToStorage(_ktpImage!,
          '/users/participant/${userCredential.user!.uid}/ktp/ktp.jpg');

      // Generate unique QR code
      String uniqueId = Uuid().v4();
      await _generateQRCode(
          uniqueId, userCredential.user!.uid); 

      // Upload QR code image to Firebase Storage
      String qrCodeUrl = await _uploadImageToStorage(File(_qrCodePath!),
          '/users/participant/${userCredential.user!.uid}/qr/qr.jpg');

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'area': area,
        'divisi': divisi,
        'department': department,
        'alamat': alamat,
        'nomorWhatsapp': nomorWhatsapp,
        'nomorKtp': nomorKtp,
        'ukuranTShirt': ukuranTShirt,
        'ukuranPoloShirt': ukuranPoloShirt,
        'tipeEWallet': tipeEWallet,
        'nomorEWallet': nomorEWallet,
        'selfieUrl': selfieUrl,
        'ktpUrl': ktpUrl,
        'qrCodeUrl': qrCodeUrl,
        'emailVerified': false,
        'role': participant,
      });

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      await logout();

      // Show success dialog and navigate to login
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text('Please check your email for verification.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      setLoading(false);
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text(e.toString()),
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
    } finally {
      setLoading(false);
    }
  }
  Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear preferences
  await FirebaseAuth.instance.signOut(); // Sign out from Firebase
  }

  Future<void> _generateQRCode(String uniqueId, String userId) async {
    // Generate the QR code image
    final qrCode = QrPainter(
      data: userId,
      version: QrVersions.auto,
      color: const Color(0xFF000000),
      gapless: false,
    );

    // Create a directory for the QR code image
    final directory = await Directory.systemTemp.createTemp();
    _qrCodePath = '${directory.path}/$userId.png';

    // Save the QR code image as a PNG file
    final byteData = await qrCode.toImageData(2048);
    final buffer = byteData!.buffer.asUint8List();
    final file = File(_qrCodePath!);
    await file.writeAsBytes(buffer);
  }

  Future<String> _uploadImageToStorage(File image, String path) async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(path).putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
