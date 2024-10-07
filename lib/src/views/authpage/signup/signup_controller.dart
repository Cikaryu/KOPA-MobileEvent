import 'dart:convert';

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signup/page/signup_Slide2_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/page/signup_slide1_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/page/signup_slide3_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/page/signup_slide4_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart' as sheets;

class SignupController extends GetxController {
  PageController pageController = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController whatsappNumberController = TextEditingController();
  TextEditingController ktpNumberController = TextEditingController();
  TextEditingController tshirtSizeController = TextEditingController();
  TextEditingController poloShirtSizeController = TextEditingController();
  TextEditingController eWalletTypeController = TextEditingController();
  TextEditingController eWalletNumberController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  var showPassword = false.obs;

  var selfieImage = ValueNotifier<File?>(null);
  var ktpImage = ValueNotifier<File?>(null);
  String? _qrCodePath;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with empty strings to avoid null issues
    emailController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    nameController = TextEditingController(text: '');
    areaController = TextEditingController(text: '');
    divisionController = TextEditingController(text: '');
    departmentController = TextEditingController(text: '');
    addressController = TextEditingController(text: '');
    whatsappNumberController = TextEditingController(text: '');
    ktpNumberController = TextEditingController(text: '');
    tshirtSizeController = TextEditingController(text: '');
    poloShirtSizeController = TextEditingController(text: '');
    eWalletTypeController = TextEditingController(text: '');
    eWalletNumberController = TextEditingController(text: '');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    areaController.dispose();
    divisionController.dispose();
    departmentController.dispose();
    addressController.dispose();
    whatsappNumberController.dispose();
    ktpNumberController.dispose();
    tshirtSizeController.dispose();
    poloShirtSizeController.dispose();
    eWalletTypeController.dispose();
    eWalletNumberController.dispose();
    super.onClose();
  }

  void setSelfieImage(File? image) {
    selfieImage.value = image;
    update();
  }

  void nextPage() {
    pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void backPage() {
    pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void setKtpImage(File? image) {
    ktpImage.value = image;
    update();
  }

  void setLoading(bool value) {
    _isLoading = value;
    update();
  }

  Widget pageItemBuilder(context, position) {
    switch (position) {
      case 0:
        return SignupSlide1View();
      case 1:
        return SignupSlide2View();
      case 2:
        return SignupSlide3View();
      case 3:
        return SignupSlide4View();
      default:
        return Container();
    }
  }

  Future<String> loadCredentials() async {
    return await rootBundle.loadString('assets/credentials/credentials.json');
  }

  Future<AuthClient> getAuthClient() async {
    String credentials = await loadCredentials();
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      json.decode(credentials),
    );

    final scopes = [
      drive.DriveApi.driveFileScope,
      sheets.SheetsApi.spreadsheetsScope,
    ];

    final authClient =
        await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return authClient;
  }

  Future<void> uploadImageToDrive(File imageFile, String folderId,
      String departement, String area, String divisi, String user) async {
    final authClient = await getAuthClient();

    var driveApi = drive.DriveApi(authClient);

    var fileToUpload = drive.File();
    fileToUpload.name = '${user}_${area}_${departement}_$divisi.png';
    fileToUpload.parents = [folderId];
    var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());

    final response =
        await driveApi.files.create(fileToUpload, uploadMedia: media);
    print('Uploaded File Profile ID: ${response.id} with name: $departement');
  }

  Future<void> uploadImagektpToDrive(
      File imageFile, String folderId, String user) async {
    final authClient = await getAuthClient();

    var driveApi = drive.DriveApi(authClient);

    var fileToUpload = drive.File();
    fileToUpload.name = 'KTP_$user.png';
    fileToUpload.parents = [folderId];
    var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());

    final response =
        await driveApi.files.create(fileToUpload, uploadMedia: media);
    print('Uploaded File KTP ID: ${response.id} with name: $user');
  }

  Future<void> uploadQrCodeToDrive(String qrCodePath, String folderId,
      String username, String departement, String division) async {
    final authClient = await getAuthClient();
    var driveApi = drive.DriveApi(authClient);

    var fileToUpload = drive.File();
    fileToUpload.name =
        '${division}_${departement}_QR_$username.png'; // Name of the file in Drive
    fileToUpload.parents = [
      folderId
    ]; // Folder ID where the file will be uploaded

    var media =
        drive.Media(File(qrCodePath).openRead(), File(qrCodePath).lengthSync());

    final response =
        await driveApi.files.create(fileToUpload, uploadMedia: media);
    print(
        'Uploaded QR Code File ID: ${response.id} with name: QR_$username.png');
  }

  Future<void> submitToDrive(
      String username, String area, String department, String division) async {
    String folderIdktp = '1JcyaT5xNKP4iela099E7RnefFhITKTKj';
    String folderIdprofile = '1ct2JFxdNvEjWUb0slhBROiPGvy5v5Ode';
    String folderIdqr = '15ggM93uLiT7DORNDTeEOdiSDvlRltqWa';
    await Future.wait([
      uploadImagektpToDrive(ktpImage.value!, folderIdktp, username),
      uploadImageToDrive(selfieImage.value!, folderIdprofile, department, area,
          division, username),
      uploadQrCodeToDrive(
          _qrCodePath!, folderIdqr, username, department, division),
    ]);
  }

  Future<void> updateSpreadsheet(
      String spreadsheetId, String range, List<Object> newRow) async {
    try {
      final authClient = await getAuthClient();
      var sheetsApi = sheets.SheetsApi(authClient);

      // Get existing values
      var response =
          await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
      var existingValues = response.values ?? [];
      print('Existing values: $existingValues'); // Debug log

      // Find the row with the matching UserId
      int rowIndex = -1;
      for (int i = 1; i < existingValues.length; i++) {
        if (existingValues[i].length > 1 && existingValues[i][1] == newRow[1]) {
          rowIndex = i;
          break;
        }
      }
      print('Row index for UserId ${newRow[1]}: $rowIndex'); // Debug log

      if (rowIndex != -1) {
        // Update existing row
        existingValues[rowIndex] = newRow;
        print('Updated existing row: ${existingValues[rowIndex]}'); // Debug log
      } else {
        // Add new row
        existingValues.add(newRow);
        print('Added new row: $newRow'); // Debug log
      }

      var valueRange = sheets.ValueRange(values: existingValues);

      // Update the entire range
      var updateResponse = await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId,
        range,
        valueInputOption: 'USER_ENTERED',
      );
      print('Spreadsheet update response: $updateResponse'); // Debug log

      print('Spreadsheet updated successfully');
    } catch (e) {
      print('Error updating spreadsheet: $e');
      // Handle the error appropriately, e.g., by showing an error message to the user
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String area,
    required String division,
    required String department,
    required String address,
    required String whatsappNumber,
    required String ktpNumber,
    required String tShirtSize,
    required String poloShirtSize,
    required String eWalletType,
    required String eWalletNumber,
    required BuildContext context,
    required String role,
    required String status,
  }) async {
    OverlayEntry? loadingOverlay;
    try {
      setLoading(true);
      loadingOverlay = OverlayEntry(
        builder: (context) => Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
      Overlay.of(context).insert(loadingOverlay);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Prepare all futures
      List<Future> futures = [
        _uploadImages(uid),
        _saveUserData(
            uid,
            email,
            name,
            area,
            division,
            department,
            address,
            whatsappNumber,
            ktpNumber,
            tShirtSize,
            poloShirtSize,
            eWalletType,
            eWalletNumber,
            role,
            status),
        _saveParticipantKit(uid, status),
        _submitToDrive(name, area, department, division),
        _updateSpreadsheet(
            uid,
            email,
            name,
            area,
            division,
            department,
            address,
            whatsappNumber,
            ktpNumber,
            tShirtSize,
            poloShirtSize,
            eWalletType,
            eWalletNumber,
            status),
        userCredential.user!.sendEmailVerification(),
      ];

      // Execute all futures concurrently
      await Future.wait(futures);

      // Reset form and show success dialog
      await logout();
      resetForm();
      
      loadingOverlay.remove();
      setLoading(false);
      // Show success dialog and navigate to login
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Registration Successful',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Please check your email for verification !',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: Center(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor("E97717"),
                          border: Border(
                            top: BorderSide(color: Colors.orange[400]!),
                          ),
                        ),
                        child:
                            Text('OK', style: TextStyle(color: Colors.white)))),
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.offAllNamed('/signin');
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

      if (loadingOverlay != null) {
        loadingOverlay.remove();
      }
      setLoading(false);
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Registration Failed',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 70),
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
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Remove loading indicator
      if (loadingOverlay != null) {
        loadingOverlay.remove();
      }
      setLoading(false);

      // Show general error dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text(
              '$e',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 70),
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
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _uploadImages(String uid) async {
    String selfieUrl = await _uploadImageToStorage(
        selfieImage.value!, '/users/participant/$uid/selfie/selfie.jpg');
    String ktpUrl = await _uploadImageToStorage(
        ktpImage.value!, '/users/participant/$uid/ktp/ktp.jpg');
    String uniqueId = Uuid().v4();
    await _generateQRCode(uniqueId, uid);
    String qrCodeUrl = await _uploadImageToStorage(
        File(_qrCodePath!), '/users/participant/$uid/qr/qr.jpg');

    await _firestore.collection('users').doc(uid).update({
      'selfieUrl': selfieUrl,
      'ktpUrl': ktpUrl,
      'qrCodeUrl': qrCodeUrl,
    });
  }

  Future<void> _saveUserData(
      String uid,
      String email,
      String name,
      String area,
      String division,
      String department,
      String address,
      String whatsappNumber,
      String ktpNumber,
      String tShirtSize,
      String poloShirtSize,
      String eWalletType,
      String eWalletNumber,
      String role,
      String status) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'area': area,
      'division': division,
      'department': department,
      'address': address,
      'whatsappNumber': whatsappNumber,
      'NIK': ktpNumber,
      'tShirtSize': tShirtSize,
      'poloShirtSize': poloShirtSize,
      'eWalletType': eWalletType,
      'eWalletNumber': eWalletNumber,
      'emailVerified': false,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _saveParticipantKit(String uid, String status) async {
    await _firestore.collection('participantKit').doc(uid).set({
      'merchandise': {
        'poloShirt': {
          'status': status,
          'updatedAt': FieldValue.serverTimestamp()
        },
        'tShirt': {'status': status, 'updatedAt': FieldValue.serverTimestamp()},
        'luggageTag': {
          'status': status,
          'updatedAt': FieldValue.serverTimestamp()
        },
        'jasHujan': {
          'status': status,
          'updatedAt': FieldValue.serverTimestamp()
        },
      },
      'souvenir': {
        'gelangTridatu': {
          'status': status,
          'updatedAt': FieldValue.serverTimestamp()
        },
        'selendangUdeng': {
          'status': status,
          'updatedAt': FieldValue.serverTimestamp()
        },
      },
      'benefit': {
        'voucherBelanja': {
          'status': status,
          'updatedAt': FieldValue.serverTimestamp()
        },
        'voucherEwallet': {
          'status': status,
          'updatedAt': FieldValue.serverTimestamp()
        },
      },
    });
  }

  Future<void> _submitToDrive(
      String username, String area, String department, String division) async {
    String folderIdktp = '1JcyaT5xNKP4iela099E7RnefFhITKTKj';
    String folderIdprofile = '1ct2JFxdNvEjWUb0slhBROiPGvy5v5Ode';
    String folderIdqr = '15ggM93uLiT7DORNDTeEOdiSDvlRltqWa';

    await Future.wait([
      uploadImagektpToDrive(ktpImage.value!, folderIdktp, username),
      uploadImageToDrive(selfieImage.value!, folderIdprofile, department, area,
          division, username),
      uploadQrCodeToDrive(
          _qrCodePath!, folderIdqr, username, department, division),
    ]);
  }

  Future<void> _updateSpreadsheet(
      String uid,
      String email,
      String name,
      String area,
      String division,
      String department,
      String address,
      String whatsappNumber,
      String ktpNumber,
      String tShirtSize,
      String poloShirtSize,
      String eWalletType,
      String eWalletNumber,
      String status) async {
    final timestamp = DateTime.now().toIso8601String();
    List<Object> newRow = [
      timestamp,
      uid,
      email,
      name,
      area,
      division,
      department,
      address,
      whatsappNumber,
      ktpNumber,
      tShirtSize,
      poloShirtSize,
      eWalletType,
      eWalletNumber,
      status,
      status,
      status,
      status,
      status,
      status,
      status,
      status,
    ];
    await updateSpreadsheet(
        '1zOgCl7ngSUkTJTI9NortPjgfZeKrUA4YRsj0xNSbsVY', 'Sheet1!A:V', newRow);
  }

  // Future<void> _showSuccessDialog(BuildContext context) async {
  //   await showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Registration Successful',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //         content: Text('Please check your email for verification !',
  //             textAlign: TextAlign.center),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Center(
  //                 child: Container(
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: 70, vertical: 10),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(Radius.circular(20)),
  //                       color: HexColor("E97717"),
  //                       border:
  //                           Border(top: BorderSide(color: Colors.orange[400]!)),
  //                     ),
  //                     child:
  //                         Text('OK', style: TextStyle(color: Colors.white)))),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Get.offAllNamed('/signin');
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showErrorDialog(BuildContext context, String errorMessage) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Registration Failed',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //         content: Text(errorMessage, textAlign: TextAlign.center),
  //         actions: <Widget>[
  //           Center(
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 70),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(20)),
  //                 color: HexColor("E97717"),
  //                 border: Border(top: BorderSide(color: Colors.orange[400]!)),
  //               ),
  //               child: TextButton(
  //                 child: Text('OK', style: TextStyle(color: Colors.white)),
  //                 onPressed: () => Navigator.of(context).pop(),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
          title: Text(
            'Choose Image Source',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor("E97717"),
                          border: Border(
                            top: BorderSide(color: Colors.orange[400]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text('Camera',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      onTap: () {
                        _pickImage(ImageSource.camera, type, signupController);
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor("E97717"),
                          border: Border(
                            top: BorderSide(color: Colors.orange[400]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text('Gallery',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      onTap: () {
                        _pickImage(ImageSource.gallery, type, signupController);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
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
    final pickedFile = await picker.pickImage(source: source, imageQuality: 20);

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
    divisionController.clear();
    departmentController.clear();
    addressController.clear();
    whatsappNumberController.clear();
    ktpNumberController.clear();
    tshirtSizeController.clear();
    poloShirtSizeController.clear();
    eWalletTypeController.clear();
    eWalletNumberController.clear();
    selfieImage.value = null;
    ktpImage.value = null;
  }

  void showImagePreview(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
          child: AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: GestureDetector(
              onTap: () {},
              child: Container(
                width: double.maxFinite,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    } else if (value.endsWith('@yourcustomdomain.com')) {
      return null; // valid
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Please enter a valid email.';
    }
    return null; // valid
  }
}
