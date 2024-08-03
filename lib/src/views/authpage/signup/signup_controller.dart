import 'package:app_kopabali/src/core/base_import.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SignupController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController divisiController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController nomorWhatsappController = TextEditingController();
  TextEditingController nomorKtpController = TextEditingController();
  TextEditingController ukuranTShirtController = TextEditingController();
  TextEditingController ukuranPoloShirtController = TextEditingController();
  TextEditingController tipeEWalletController = TextEditingController();
  TextEditingController nomorEWalletController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  var selfieImage = ValueNotifier<File?>(null);
  var ktpImage = ValueNotifier<File?>(null);
  String? _qrCodePath;

  void setSelfieImage(File? image) {
    selfieImage.value = image;
    update();
  }

  void setKtpImage(File? image) {
    ktpImage.value = image;
    update();
  }

  void setLoading(bool value) {
    _isLoading = value;
    update();
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
    required String role,
    required String poloShirt,
    required String tShirt,
    required String nameTag,
    required String luggageTag,
    required String jasHujan,
  }) async {
    try {
      setLoading(true);
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Upload images to Firebase Storage
      String selfieUrl = await _uploadImageToStorage(selfieImage.value!,
          '/users/participant/${userCredential.user!.uid}/selfie/selfie.jpg');
      String ktpUrl = await _uploadImageToStorage(ktpImage.value!,
          '/users/participant/${userCredential.user!.uid}/ktp/ktp.jpg');

      // Generate unique QR code
      String uniqueId = Uuid().v4();
      await _generateQRCode(uniqueId, userCredential.user!.uid);

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
        'role': role,
      });

      await FirebaseFirestore.instance
          .collection('merchandise')
          .doc(userCredential.user!.uid)
          .set({
        'participantKit': {
          'poloShirt': poloShirt,
          'tShirt': tShirt,
          'nameTag': nameTag,
          'luggageTag': luggageTag,
          'jasHujan': jasHujan,
        },
      });

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      await logout();
      resetForm();
      Navigator.of(context).pop();

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
                  Navigator.of(context).pushReplacementNamed('/signin');
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use by another account.';
      } else {
        errorMessage = e.message ?? 'An unknown error occurred.';
      }
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text(errorMessage),
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

  void showImageSourceDialog(
      BuildContext context, String type, SignupController signupController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(width: 10),
                      Text('Camera'),
                    ],
                  ),
                  onTap: () {
                    _pickImage(ImageSource.camera, type, signupController);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      SizedBox(width: 10),
                      Text('Gallery'),
                    ],
                  ),
                  onTap: () {
                    _pickImage(ImageSource.gallery, type, signupController);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source, String type,
      SignupController signupController) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (type == 'selfie') {
        signupController.setSelfieImage(File(pickedFile.path));
      } else {
        signupController.setKtpImage(File(pickedFile.path));
      }
    }
  }

  void resetForm() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    areaController.clear();
    divisiController.clear();
    departmentController.clear();
    alamatController.clear();
    nomorWhatsappController.clear();
    nomorKtpController.clear();
    ukuranTShirtController.clear();
    ukuranPoloShirtController.clear();
    tipeEWalletController.clear();
    nomorEWalletController.clear();
    selfieImage.value = null;
    ktpImage.value = null;
  }
}
